Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1E0Mqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:46:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:51957 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1E0Mqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:46:33 -0400
Date: Fri, 27 May 2011 12:46:26 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        jolsa@redhat.com
In-Reply-To: <20110510104346.GC1899@jolsa.brq.redhat.com>
References: <20110510104346.GC1899@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump_label: Check entries limit in __jump_label_update
Git-Commit-ID: 7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:46:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d
Gitweb:     http://git.kernel.org/tip/7cbc5b8d4a775a43875a09e29c49a2a8195b5b2d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 10 May 2011 12:43:46 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 19:56:36 -0400

jump_label: Check entries limit in __jump_label_update

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
