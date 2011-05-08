Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1EHWve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:51:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab1EHWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RSiaiGxfv7eCBJSOmOcFGZPZ/5vM2Q8cH/uZQbQi7D9cgXedWtsNKJc18Pjq4nhhmL
         YFy8UZEy0yAhHdMMzcWxtEY4BUSfbxEaR0ta3SxiDshhFlh81asljuxJ2VMm4QTXAHe6
         Zc6B+ujy0Bp8vcrETj13zJAA0D8+F+9x3/Ge0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 065/115] sysctl: delete useless grab_header function
Date: Mon,  9 May 2011 00:39:17 +0200
Message-Id: <1304894407-32201-66-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of header grabbing/getting functions around. We'll
start changing them later on and this one will just make conversions
harder. It doesn't help much, so kill it!

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 93962b0..64665e0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -62,15 +62,10 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 	return NULL;
 }
 
-static struct ctl_table_header *grab_header(struct inode *inode)
-{
-	return sysctl_head_grab(PROC_I(inode)->sysctl);
-}
-
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 					struct nameidata *nd)
 {
-	struct ctl_table_header *head = grab_header(dir);
+	struct ctl_table_header *head = sysctl_head_grab(PROC_I(dir)->sysctl);
 	struct ctl_table *table = PROC_I(dir)->sysctl_entry;
 	struct ctl_table_header *h = NULL;
 	struct qstr *name = &dentry->d_name;
@@ -123,7 +118,7 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
 		size_t count, loff_t *ppos, int write)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
+	struct ctl_table_header *head = sysctl_head_grab(PROC_I(inode)->sysctl);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	ssize_t error;
 	size_t res;
@@ -234,7 +229,7 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
+	struct ctl_table_header *head = sysctl_head_grab(PROC_I(inode)->sysctl);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	struct ctl_table_header *h = NULL;
 	unsigned long pos;
@@ -302,7 +297,7 @@ static int proc_sys_permission(struct inode *inode, int mask,unsigned int flags)
 	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))
 		return -EACCES;
 
-	head = grab_header(inode);
+	head = sysctl_head_grab(PROC_I(inode)->sysctl);
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
@@ -343,7 +338,7 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 static int proc_sys_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
-	struct ctl_table_header *head = grab_header(inode);
+	struct ctl_table_header *head = sysctl_head_grab(PROC_I(inode)->sysctl);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 
 	if (IS_ERR(head))
-- 
1.7.5.134.g1c08b

