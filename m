Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab2IGMfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:35:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45222 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab2IGMfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:35:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] procfs: don't need a PATH_MAX allocation to hold a string representation of an int
Date: Fri,  7 Sep 2012 08:34:53 -0400
Message-Id: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/proc/base.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1b6c84c..58e801b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2758,7 +2758,8 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name = ERR_PTR(-ENOENT);
 	if (tgid) {
-		name = __getname();
+		/* 10 for max length of an int in decimal + NULL terminator */
+		name = kmalloc(11, GFP_KERNEL);
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

