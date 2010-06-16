Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab0FPPdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:33:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44933 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab0FPPdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=e7tru3QCsVgce+LzFMnRuPo9/tN01HZDirHcuIYQfzTQ0Lc2jpZurecJVZcsMB+dDh
         PTqP2IW+oKJxgUSWIhbgIsllq+zrRr4ppzySSTc7IteDFsvLrd3TuFxEWrV0zhzAezE8
         7T5bxKMEsNuQ9wHMr4icgAlh1i1Db9MHRXAW4=
Date: Wed, 16 Jun 2010 19:33:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs, ext4: Fix potential memory leak in ext4_fill_super
Message-ID: <20100616153332.GA6751@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under heavy memory pressure we may hit out of memory
situation and as result kstrdup'ed options will not be
freed. Fix it.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/ext4/super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/ext4/super.c
=====================================================================
--- linux-2.6.git.orig/fs/ext4/super.c
+++ linux-2.6.git/fs/ext4/super.c
@@ -2448,7 +2448,7 @@ static int ext4_fill_super(struct super_
 	struct inode *root;
 	char *cp;
 	const char *descr;
-	int ret = -EINVAL;
+	int ret = -ENOMEM;
 	int blocksize;
 	unsigned int db_count;
 	unsigned int i;
@@ -2459,13 +2459,13 @@ static int ext4_fill_super(struct super_
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		return -ENOMEM;
+		goto out_free_orig;
 
 	sbi->s_blockgroup_lock =
 		kzalloc(sizeof(struct blockgroup_lock), GFP_KERNEL);
 	if (!sbi->s_blockgroup_lock) {
 		kfree(sbi);
-		return -ENOMEM;
+		goto out_free_orig;
 	}
 	sb->s_fs_info = sbi;
 	sbi->s_mount_opt = 0;
@@ -2482,6 +2482,7 @@ static int ext4_fill_super(struct super_
 	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
 		*cp = '!';
 
+	ret = -EINVAL;
 	blocksize = sb_min_blocksize(sb, EXT4_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		ext4_msg(sb, KERN_ERR, "unable to set blocksize");
@@ -3093,6 +3094,7 @@ out_fail:
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
 	lock_kernel();
+out_free_orig:
 	kfree(orig_data);
 	return ret;
 }
