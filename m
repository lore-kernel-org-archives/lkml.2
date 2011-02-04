Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1BDEiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:38:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46255 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1BDEiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HCP4wnsuGb4zvSoC3j/AOqlRCWlZY/kSvAIXKcUitiM5Q/7ydWdNX5/Oi33o7AeEez
         9O+WlfSflbR6NrGqvJr8rZbzbZDjeyjq9tl+VWMixeZa0nRxVHcu7wIlhaDLgGiZJvUc
         KqY93XlVunH7cCSgPBdh3iMbQk87lNtPTMKMY=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 2/5] sysctl: remove useless ctl_table->parent field
Date: Fri,  4 Feb 2011 06:37:05 +0200
Message-Id: <9a1977a6526ca9e0b03ba1df767f842aea62b5f4.1296793770.git.lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
In-Reply-To: <cover.1296793770.git.lucian.grijincu@gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
In-Reply-To: <cover.1296793770.git.lucian.grijincu@gmail.com>
References: <cover.1296793770.git.lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'parent' field was added for selinux in:
    commit d912b0cc1a617d7c590d57b7ea971d50c7f02503
    [PATCH] sysctl: add a parent entry to ctl_table and set the parent entry

and then was used for sysctl_check_table.

Both of the users have found other implementations.

CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |   11 -----------
 kernel/sysctl_check.c  |    4 ++--
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 7bb5cb6..1f1da4b 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1018,7 +1018,6 @@ struct ctl_table
 	int maxlen;
 	mode_t mode;
 	struct ctl_table *child;
-	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	void *extra1;
 	void *extra2;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 56f6fc1..42025ec 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1695,18 +1695,8 @@ int sysctl_perm(struct ctl_table_root *root, struct ctl_table *table, int op)
 	return test_perm(mode, op);
 }
 
-static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
-{
-	for (; table->procname; table++) {
-		table->parent = parent;
-		if (table->child)
-			sysctl_set_parent(table, table->child);
-	}
-}
-
 static __init int sysctl_init(void)
 {
-	sysctl_set_parent(NULL, root_table);
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	sysctl_check_table(current->nsproxy, root_table);
 #endif
@@ -1864,7 +1854,6 @@ struct ctl_table_header *__register_sysctl_paths(
 	header->used = 0;
 	header->unregistering = NULL;
 	header->root = root;
-	sysctl_set_parent(NULL, header->ctl_table);
 	header->count = 1;
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
 	if (sysctl_check_table(namespaces, header->ctl_table)) {
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 9b4fecd..b7d9c66 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -95,8 +95,8 @@ static int __sysctl_check_table(struct nsproxy *namespaces,
 	for (; table->procname; table++) {
 		const char *fail = NULL;
 
-		if (table->parent) {
-			if (table->procname && !table->parent->procname)
+		if (depth != 0) { /* has parent */
+			if (table->procname && !parents[depth - 1]->procname)
 				SET_FAIL("Parent without procname");
 		}
 		if (!table->procname)
-- 
1.7.4.rc1.7.g2cf08.dirty

