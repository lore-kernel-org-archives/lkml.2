Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab1D1Uwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611Ab1D1Uwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:52:53 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] jump_label,x86: use text_poke_smp_batch for entries update
Date: Thu, 28 Apr 2011 22:52:41 +0200
Message-Id: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the jump label update code to use batch processing
for x86 architectures. 

Currently each jump label update calls text_poke_smp for each
jump label key entry. Thus one key update ends up calling stop
machine multiple times.

This patch is using text_poke_smp_batch, which is called for
all the key's entries.  Ensuring the stop machine is called
only once.

The highest entries count for a single key I found was 20,
thus I set MAX_POKE_PARAMS to 30.

I added arch_jump_label_transform_key function with weak definition
to update all the entries for single key.

Architectures, that will do the batch update in the future can
overload this function as x86 does in the patch. For now they
can stay in current state with no further changes.

I tested this on x86 and s390 archs.

wrb,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/jump_label.c |   69 ++++++++++++++++++++++++++++++++++--------
 include/linux/jump_label.h   |    2 +
 kernel/jump_label.c          |   16 ++++++++-
 3 files changed, 72 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..4024c67 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,22 +24,65 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+struct text_poke_buffer {
+	u8 buf[JUMP_LABEL_NOP_SIZE];
+};
+
+#define MAX_POKE_PARAMS 30
+static struct text_poke_param  poke_params[MAX_POKE_PARAMS];
+static struct text_poke_buffer poke_buffers[MAX_POKE_PARAMS];
+
+static void setup_poke_param(struct text_poke_param *param, u8 *buf,
+			     int enable,
+			     struct jump_entry *entry)
 {
-	union jump_code_union code;
+	union jump_code_union *code = (union jump_code_union *) buf;
 
-	if (type == JUMP_LABEL_ENABLE) {
-		code.jump = 0xe9;
-		code.offset = entry->target -
-				(entry->code + JUMP_LABEL_NOP_SIZE);
+	if (enable == JUMP_LABEL_ENABLE) {
+		code->jump = 0xe9;
+		code->offset = entry->target -
+			       (entry->code + JUMP_LABEL_NOP_SIZE);
 	} else
-		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
-	get_online_cpus();
-	mutex_lock(&text_mutex);
-	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
-	mutex_unlock(&text_mutex);
-	put_online_cpus();
+		memcpy(code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+	param->addr = (void *) entry->code;
+	param->opcode = code;
+	param->len = JUMP_LABEL_NOP_SIZE;
+}
+
+void arch_jump_label_transform_key(struct jump_label_key *key,
+				   struct jump_entry *entry, int enable)
+{
+	int count;
+
+	do {
+		for (count = 0;
+		     (entry->key == (jump_label_t)(unsigned long) key) &&
+		     (count < MAX_POKE_PARAMS);
+		     entry++) {
+
+			/*
+			 * The entry->code set to 0 invalidates module init text
+			 * sections (see jump_label_invalidate_module_init).
+			 */
+			if (!entry->code || !kernel_text_address(entry->code))
+				continue;
+
+			setup_poke_param(&poke_params[count],
+					 poke_buffers[count].buf,
+					 enable, entry);
+			count++;
+		}
+
+		if (count) {
+			get_online_cpus();
+			mutex_lock(&text_mutex);
+			text_poke_smp_batch(poke_params, count);
+			mutex_unlock(&text_mutex);
+			put_online_cpus();
+		}
+
+	} while (count == MAX_POKE_PARAMS);
 }
 
 void arch_jump_label_text_poke_early(jump_label_t addr)
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 83e745f..f8afc3e 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -43,6 +43,8 @@ extern struct jump_entry __stop___jump_table[];
 
 extern void jump_label_lock(void);
 extern void jump_label_unlock(void);
+extern void arch_jump_label_transform_key(struct jump_label_key *key,
+				 struct jump_entry *entry, int enable);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..e2a0a73 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -104,8 +104,14 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 	return 0;
 }
 
-static void __jump_label_update(struct jump_label_key *key,
-		struct jump_entry *entry, int enable)
+
+void __weak arch_jump_label_transform(struct jump_entry *entry,
+				      enum jump_label_type type)
+{
+}
+
+void __weak arch_jump_label_transform_key(struct jump_label_key *key,
+					  struct jump_entry *entry, int enable)
 {
 	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
 		/*
@@ -125,6 +131,12 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
 {
 }
 
+static void __jump_label_update(struct jump_label_key *key,
+		struct jump_entry *entry, int enable)
+{
+	arch_jump_label_transform_key(key, entry, enable);
+}
+
 static __init int jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
-- 
1.7.1

