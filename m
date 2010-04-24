Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0DXClW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab0DXClU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:41:20 -0400
Message-ID: <4BD25A4B.4050000@redhat.com>
Date: Fri, 23 Apr 2010 21:41:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [PATCH] ecryptfs: disallow ecryptfs as underlying filesystem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mounting stacked ecryptfs on ecryptfs has been shown to lead to bugs
in testing.  For crypto info in xattr, there is no mechanism for handling
this at all, and for normal file headers, we run into other trouble:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffffa015b0b3>] ecryptfs_d_revalidate+0x43/0xa0 [ecryptfs]
...

There doesn't seem to be any good usecase for this, so I'd suggest just
disallowing the configuration.

Based on a patch originally, I believe, from Mike Halcrow.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index af1a8f0..7ada044 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -594,28 +594,46 @@ static int ecryptfs_get_sb(struct file_system_type *fs_type, int flags,
 			struct vfsmount *mnt)
 {
 	int rc;
-	struct super_block *sb;
+	struct super_block *sb, *lower_sb;
+	struct nameidata nd;
+
+	rc = path_lookup(dev_name, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &nd);
+	if (rc) {
+		printk(KERN_WARNING
+			"path_lookup() failed on dev_name = [%s]\n", dev_name);
+		goto out;
+	}
+	lower_sb = nd.path.dentry->d_sb;
+	if (strcmp(lower_sb->s_type->name, "ecryptfs") == 0) {
+		rc = -EINVAL;
+		printk(KERN_ERR "Mount on filesystem of type "
+			"eCryptfs explicitly disallowed due to "
+			"known incompatibilities\n");
+		goto out_pathput;
+	}
 
 	rc = get_sb_nodev(fs_type, flags, raw_data, ecryptfs_fill_super, mnt);
 	if (rc < 0) {
 		printk(KERN_ERR "Getting sb failed; rc = [%d]\n", rc);
-		goto out;
+		goto out_pathput;
 	}
 	sb = mnt->mnt_sb;
 	rc = ecryptfs_parse_options(sb, raw_data);
 	if (rc) {
 		printk(KERN_ERR "Error parsing options; rc = [%d]\n", rc);
-		goto out_abort;
+		goto out_dput;
 	}
 	rc = ecryptfs_read_super(sb, dev_name);
 	if (rc) {
 		printk(KERN_ERR "Reading sb failed; rc = [%d]\n", rc);
-		goto out_abort;
+		goto out_dput;
 	}
 	goto out;
-out_abort:
+out_dput:
 	dput(sb->s_root); /* aka mnt->mnt_root, as set by get_sb_nodev() */
 	deactivate_locked_super(sb);
+out_pathput:
+	path_put(&nd.path);
 out:
 	return rc;
 }


