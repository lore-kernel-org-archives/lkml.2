Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1EZPc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:32:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab1EZP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:29:58 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=WTA-_JLw6QEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=MrzxreWBbIlLGQBSyVkA:9 a=89mRCNkwxmUSt_BR_XEA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=zASoJWZpUSAb4RT5:21 a=WqXpYbBIR0NGjGNs:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152957.100391899@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 06/12] jump_label: Check entries limit in __jump_label_update
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0006-jump_label-Check-entries-limit-in-__jump_label_updat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

When iterating the jump_label entries array (core or modules),
the __jump_label_update function peeks over the last entry.

The reason is that the end of the for loop depends on the key
value of the processed entry. Thus when going through the
last array entry, we will touch the memory behind the array
limit.

This bug probably will never be triggered, since most likely the
memory behind the jump_label entries will be accesable and the
entry->key will be different than the expected value.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Link: http://lkml.kernel.org/r/20110510104346.GC1899@jolsa.brq.redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..fa27e75 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -105,9 +105,12 @@ static int __jump_label_text_reserved(struct jump_entry *iter_start,
 }
 
 static void __jump_label_update(struct jump_label_key *key,
-		struct jump_entry *entry, int enable)
+				struct jump_entry *entry,
+				struct jump_entry *stop, int enable)
 {
-	for (; entry->key == (jump_label_t)(unsigned long)key; entry++) {
+	for (; (entry < stop) &&
+	      (entry->key == (jump_label_t)(unsigned long)key);
+	      entry++) {
 		/*
 		 * entry->code set to 0 invalidates module init text sections
 		 * kernel_text_address() verifies we are not in core kernel
@@ -181,7 +184,11 @@ static void __jump_label_mod_update(struct jump_label_key *key, int enable)
 	struct jump_label_mod *mod = key->next;
 
 	while (mod) {
-		__jump_label_update(key, mod->entries, enable);
+		struct module *m = mod->mod;
+
+		__jump_label_update(key, mod->entries,
+				    m->jump_entries + m->num_jump_entries,
+				    enable);
 		mod = mod->next;
 	}
 }
@@ -245,7 +252,8 @@ static int jump_label_add_module(struct module *mod)
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop,
+					    JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
@@ -371,7 +379,7 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, enable);
+		__jump_label_update(key, entry, __stop___jump_table, enable);
 
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
-- 
1.7.4.4


