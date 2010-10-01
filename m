Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0JAQCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:02:07 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59512
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab0JAQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:02:03 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L9MCH5-02-D86-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/5] oprofile: Remove duplicate code around __oprofilefs_create_file()
Date: Fri, 1 Oct 2010 17:56:27 +0200
Message-ID: <1285948587-24521-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
References: <1285948587-24521-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing duplicate code by assigning the inodes private data pointer
in __oprofilefs_create_file(). Extending the function interface to
pass the pointer.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/oprofilefs.c |   46 ++++++++++++----------------------------
 1 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 2766a6d..789a1a8 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -126,50 +126,41 @@ static const struct file_operations ulong_ro_fops = {
 };
 
 
-static struct dentry *__oprofilefs_create_file(struct super_block *sb,
+static int __oprofilefs_create_file(struct super_block *sb,
 	struct dentry *root, char const *name, const struct file_operations *fops,
-	int perm)
+	int perm, void *priv)
 {
 	struct dentry *dentry;
 	struct inode *inode;
 
 	dentry = d_alloc_name(root, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 	inode = oprofilefs_get_inode(sb, S_IFREG | perm);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 	inode->i_fop = fops;
 	d_add(dentry, inode);
-	return dentry;
+	dentry->d_inode->i_private = priv;
+	return 0;
 }
 
 
 int oprofilefs_create_ulong(struct super_block *sb, struct dentry *root,
 	char const *name, unsigned long *val)
 {
-	struct dentry *d = __oprofilefs_create_file(sb, root, name,
-						     &ulong_fops, 0644);
-	if (!d)
-		return -EFAULT;
-
-	d->d_inode->i_private = val;
-	return 0;
+	return __oprofilefs_create_file(sb, root, name,
+					&ulong_fops, 0644, val);
 }
 
 
 int oprofilefs_create_ro_ulong(struct super_block *sb, struct dentry *root,
 	char const *name, unsigned long *val)
 {
-	struct dentry *d = __oprofilefs_create_file(sb, root, name,
-						     &ulong_ro_fops, 0444);
-	if (!d)
-		return -EFAULT;
-
-	d->d_inode->i_private = val;
-	return 0;
+	return __oprofilefs_create_file(sb, root, name,
+					&ulong_ro_fops, 0444, val);
 }
 
 
@@ -189,31 +180,22 @@ static const struct file_operations atomic_ro_fops = {
 int oprofilefs_create_ro_atomic(struct super_block *sb, struct dentry *root,
 	char const *name, atomic_t *val)
 {
-	struct dentry *d = __oprofilefs_create_file(sb, root, name,
-						     &atomic_ro_fops, 0444);
-	if (!d)
-		return -EFAULT;
-
-	d->d_inode->i_private = val;
-	return 0;
+	return __oprofilefs_create_file(sb, root, name,
+					&atomic_ro_fops, 0444, val);
 }
 
 
 int oprofilefs_create_file(struct super_block *sb, struct dentry *root,
 	char const *name, const struct file_operations *fops)
 {
-	if (!__oprofilefs_create_file(sb, root, name, fops, 0644))
-		return -EFAULT;
-	return 0;
+	return __oprofilefs_create_file(sb, root, name, fops, 0644, NULL);
 }
 
 
 int oprofilefs_create_file_perm(struct super_block *sb, struct dentry *root,
 	char const *name, const struct file_operations *fops, int perm)
 {
-	if (!__oprofilefs_create_file(sb, root, name, fops, perm))
-		return -EFAULT;
-	return 0;
+	return __oprofilefs_create_file(sb, root, name, fops, perm, NULL);
 }
 
 
-- 
1.7.2.2


