Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1EDJl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:41:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab1EDJly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:41:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/2] jump_label,x86: use text_poke_smp_batch for entries update
Date: Wed,  4 May 2011 11:41:42 +0200
Message-Id: <1304502103-3228-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304502103-3228-1-git-send-email-jolsa@redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
 <1304502103-3228-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the jump label update code to use batch processing
for x86 architectures. 

Currently each jump label update calls text_poke_smp for each
jump label key entry. Thus one key update ends up calling stop
machine multiple times.

This patch is using text_poke_smp_batch, which is called for
all the key's entries. Thus ensuring the stop machine is called
only once per jump_label key.

Added jump_label_update_end function which is paired with
the key's entries update.

The jump_label_update_end calls arch_jump_label_update_end
(with generic weak definition) which is overloaded by x86
arch and makes the batch update of all the entries queued
by arch_jump_label_transform function.

Added dynamic array/handling for queueing jump_label entries
with the same key.

Tested this on x86 and s390 archs.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/jump_label.c |  128 +++++++++++++++++++++++++++++++++++++++---
 include/linux/jump_label.h   |    1 +
 kernel/jump_label.c          |   16 +++++-
 3 files changed, 134 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..7a4dd32 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/jhash.h>
 #include <linux/cpu.h>
+#include <linux/slab.h>
 #include <asm/kprobes.h>
 #include <asm/alternative.h>
 
@@ -24,24 +25,133 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-void arch_jump_label_transform(struct jump_entry *entry,
-			       enum jump_label_type type)
+struct text_poke_buffer {
+	u8 code[JUMP_LABEL_NOP_SIZE];
+};
+
+#define POKE_ALLOC_CNT 30
+
+static struct text_poke_param  *poke_pars;
+static struct text_poke_buffer *poke_bufs;
+static int poke_cnt, poke_size;
+
+static void poke_setup(struct text_poke_param *param, u8 *buf,
+		       int enable,
+		       struct jump_entry *entry)
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
+		memcpy(code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+	param->addr = (void *) entry->code;
+	param->opcode = code;
+	param->len = JUMP_LABEL_NOP_SIZE;
+}
+
+static int poke_alloc(void)
+{
+	struct text_poke_param  *pars;
+	struct text_poke_buffer *bufs;
+
+	if (poke_cnt % POKE_ALLOC_CNT)
+		return 0;
+
+	poke_size += POKE_ALLOC_CNT;
+
+	pars = krealloc(poke_pars, poke_size * sizeof(*pars),
+			GFP_KERNEL);
+	if (!pars)
+		return -ENOMEM;
+
+	bufs = krealloc(poke_bufs, poke_size * sizeof(*bufs),
+			GFP_KERNEL);
+	if (!bufs) {
+		kfree(pars);
+		return -ENOMEM;
+	}
+
+	poke_pars = pars;
+	poke_bufs = bufs;
+	return 0;
+}
+
+static void poke_free(void)
+{
+	kfree(poke_pars);
+	kfree(poke_bufs);
+
+	poke_cnt = poke_size = 0;
+	poke_pars = NULL;
+	poke_bufs = NULL;
+}
+
+static void poke_process(struct text_poke_param *par, int cnt)
+{
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	text_poke_smp_batch(par, cnt);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
+static void poke_end(void)
+{
+	if (!poke_cnt)
+		return;
+
+	poke_process(poke_pars, poke_cnt);
+	poke_free();
+}
+
+static void process_entry(struct jump_entry *entry,
+			     enum jump_label_type enable)
+{
+	struct text_poke_param  par;
+	struct text_poke_buffer buf;
+
+	poke_setup(&par, buf.code, enable, entry);
+	poke_process(&par, 1);
+}
+
+void arch_jump_label_transform(struct jump_entry *entry,
+			       enum jump_label_type enable)
+{
+	struct text_poke_param  *par;
+	struct text_poke_buffer *buf;
+
+	if (poke_alloc()) {
+		/*
+		 * Allocation failed, let's finish what we
+		 * gather so far and process this entry
+		 * separatelly. Next call we try the allocation
+		 * again.
+		 */
+		poke_end();
+		process_entry(entry, enable);
+		return;
+	}
+
+	par = &poke_pars[poke_cnt];
+	buf = &poke_bufs[poke_cnt];
+
+	poke_setup(par, buf->code, enable, entry);
+	poke_cnt++;
+}
+
+/*
+ * Called after arch_jump_label_transform is called for
+ * all entries of a single key.
+ */
+void arch_jump_label_update_end(void)
+{
+	poke_end();
+}
+
 void arch_jump_label_text_poke_early(jump_label_t addr)
 {
 	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 83e745f..e7a8fa3 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -46,6 +46,7 @@ extern void jump_label_unlock(void);
 extern void arch_jump_label_transform(struct jump_entry *entry,
 				 enum jump_label_type type);
 extern void arch_jump_label_text_poke_early(jump_label_t addr);
+extern void arch_jump_label_update_end(void);
 extern int jump_label_text_reserved(void *start, void *end);
 extern void jump_label_inc(struct jump_label_key *key);
 extern void jump_label_dec(struct jump_label_key *key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..6657a37 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -125,6 +125,15 @@ void __weak arch_jump_label_text_poke_early(jump_label_t addr)
 {
 }
 
+void __weak arch_jump_label_update_end(void)
+{
+}
+
+void jump_label_update_end(void)
+{
+	arch_jump_label_update_end();
+}
+
 static __init int jump_label_init(void)
 {
 	struct jump_entry *iter_start = __start___jump_table;
@@ -244,10 +253,11 @@ static int jump_label_add_module(struct module *mod)
 		jlm->next = key->next;
 		key->next = jlm;
 
-		if (jump_label_enabled(key))
+		if (jump_label_enabled(key)) {
 			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
+			jump_label_update_end();
+		}
 	}
-
 	return 0;
 }
 
@@ -376,6 +386,8 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
 #endif
+
+	jump_label_update_end();
 }
 
 #endif
-- 
1.7.1

