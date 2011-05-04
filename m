Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1EDPan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab1EDPam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:30:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] jump_label: check entries limit in __jump_label_update
Date: Wed,  4 May 2011 17:30:23 +0200
Message-Id: <1304523023-7501-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/jump_label.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 74d1c09..b2ee97a 100644
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
@@ -158,6 +161,7 @@ early_initcall(jump_label_init);
 struct jump_label_mod {
 	struct jump_label_mod *next;
 	struct jump_entry *entries;
+	struct jump_entry *entries_stop;
 	struct module *mod;
 };
 
@@ -181,7 +185,8 @@ static void __jump_label_mod_update(struct jump_label_key *key, int enable)
 	struct jump_label_mod *mod = key->next;
 
 	while (mod) {
-		__jump_label_update(key, mod->entries, enable);
+		__jump_label_update(key, mod->entries, mod->entries_stop,
+				    enable);
 		mod = mod->next;
 	}
 }
@@ -241,11 +246,13 @@ static int jump_label_add_module(struct module *mod)
 
 		jlm->mod = mod;
 		jlm->entries = iter;
+		jlm->entries_stop = iter_stop;
 		jlm->next = key->next;
 		key->next = jlm;
 
 		if (jump_label_enabled(key))
-			__jump_label_update(key, iter, JUMP_LABEL_ENABLE);
+			__jump_label_update(key, iter, iter_stop,
+					    JUMP_LABEL_ENABLE);
 	}
 
 	return 0;
@@ -371,7 +378,7 @@ static void jump_label_update(struct jump_label_key *key, int enable)
 
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, enable);
+		__jump_label_update(key, entry, __stop___jump_table, enable);
 
 #ifdef CONFIG_MODULES
 	__jump_label_mod_update(key, enable);
-- 
1.7.1

