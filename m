Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2IGR11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:27:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45596 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2IGR1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:27:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] procfs: don't need a PATH_MAX allocation to hold a string representation of an int
Date: Fri,  7 Sep 2012 13:27:16 -0400
Message-Id: <1347038836-24806-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
References: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a minor respin that just increases the buffer size by 1
to account for a potential minus sign at the head.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/proc/base.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1b6c84c..3e6ce3f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2758,7 +2758,8 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name = ERR_PTR(-ENOENT);
 	if (tgid) {
-		name = __getname();
+		/* 11 for max length of signed int in decimal + NULL term */
+		name = kmalloc(12, GFP_KERNEL);
 		if (!name)
 			name = ERR_PTR(-ENOMEM);
 		else
@@ -2773,7 +2774,7 @@ static void proc_self_put_link(struct dentry *dentry, struct nameidata *nd,
 {
 	char *s = nd_get_link(nd);
 	if (!IS_ERR(s))
-		__putname(s);
+		kfree(s);
 }
 
 static const struct inode_operations proc_self_inode_operations = {
-- 
1.7.11.4

