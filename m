Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GAPMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:12:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1GAPMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:12:42 -0400
Date: Fri, 1 Jul 2011 15:12:21 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Message-ID: <tip-140fe3b1ab9c082182ef13359fab4ddba95c24c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        xiaoguangrong@cn.fujitsu.com, rostedt@goodmis.org,
        johannes@sipsolutions.net, tglx@linutronix.de, jbaron@redhat.com,
        mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        xiaoguangrong@cn.fujitsu.com, rostedt@goodmis.org,
        johannes@sipsolutions.net, tglx@linutronix.de, jbaron@redhat.com,
        avi@redhat.com, mingo@elte.hu
In-Reply-To: <4E00038B.2060404@cn.fujitsu.com>
References: <4E00038B.2060404@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] jump_label: Fix jump_label update for modules
Git-Commit-ID: 140fe3b1ab9c082182ef13359fab4ddba95c24c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:12:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  140fe3b1ab9c082182ef13359fab4ddba95c24c3
Gitweb:     http://git.kernel.org/tip/140fe3b1ab9c082182ef13359fab4ddba95c24c3
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 21 Jun 2011 10:35:55 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 29 Jun 2011 09:59:17 -0400

jump_label: Fix jump_label update for modules

The jump labels entries for modules do not stop at __stop__jump_table,
but after mod->jump_entries + mod_num_jump_entries.

By checking the wrong end point, module trace events never get enabled.

Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
Tested-by: Avi Kivity <avi@redhat.com>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/4E00038B.2060404@cn.fujitsu.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index fa27e75..a8ce450 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -375,15 +375,19 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries;
-
-	/* if there are no users, entry can be NULL */
-	if (entry)
-		__jump_label_update(key, entry, __stop___jump_table, enable);
+	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
 
 #ifdef CONFIG_MODULES
+	struct module *mod = __module_address((jump_label_t)key);
+
 	__jump_label_mod_update(key, enable);
+
+	if (mod)
+		stop = mod->jump_entries + mod->num_jump_entries;
 #endif
+	/* if there are no users, entry can be NULL */
+	if (entry)
+		__jump_label_update(key, entry, stop, enable);
 }
 
 #endif
