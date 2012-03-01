Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251Ab2CAVuC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:50:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46239 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207Ab2CAVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:49:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.228.41 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.357116491@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>, <stable@kernel.org>,
        Tyler Hicks <tyler.hicks@canonical.com>
Subject: [ 13/34] Add mount option to check uid of device being mounted = expect uid, CVE-2011-1833
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

(backported from commit 764355487ea220fdc2faf128d577d7f679b91f97)

Close a TOCTOU race for mounts done via ecryptfs-mount-private.  The mount
source (device) can be raced when the ownership test is done in userspace.
Provide Ecryptfs a means to force the uid check at mount time.

BugLink: http://bugs.launchpad.net/bugs/732628
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Tyler Hicks <tyler.hicks@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/main.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -212,7 +212,8 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ec
        ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
-       ecryptfs_opt_unlink_sigs, ecryptfs_opt_err };
+       ecryptfs_opt_unlink_sigs, ecryptfs_opt_check_dev_ruid,
+       ecryptfs_opt_err };
 
 static const match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -227,6 +228,7 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_fn_cipher, "ecryptfs_fn_cipher=%s"},
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
 	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
+	{ecryptfs_opt_check_dev_ruid, "ecryptfs_check_dev_ruid"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -270,6 +272,7 @@ static void ecryptfs_init_mount_crypt_st
  * ecryptfs_parse_options
  * @sb: The ecryptfs super block
  * @options: The options pased to the kernel
+ * @check_ruid: set to 1 if device uid should be checked against the ruid
  *
  * Parse mount options:
  * debug=N 	   - ecryptfs_verbosity level for debug output
@@ -285,7 +288,8 @@ static void ecryptfs_init_mount_crypt_st
  *
  * Returns zero on success; non-zero on error
  */
-static int ecryptfs_parse_options(struct super_block *sb, char *options)
+static int ecryptfs_parse_options(struct super_block *sb, char *options,
+					uid_t *check_ruid)
 {
 	char *p;
 	int rc = 0;
@@ -310,6 +314,8 @@ static int ecryptfs_parse_options(struct
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
 
+	*check_ruid = 0;
+
 	if (!options) {
 		rc = -EINVAL;
 		goto out;
@@ -410,6 +416,9 @@ static int ecryptfs_parse_options(struct
 		case ecryptfs_opt_unlink_sigs:
 			mount_crypt_stat->flags |= ECRYPTFS_UNLINK_SIGS;
 			break;
+		case ecryptfs_opt_check_dev_ruid:
+			*check_ruid = 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
@@ -552,7 +561,8 @@ out:
  * ecryptfs_interpose to create our initial inode and super block
  * struct.
  */
-static int ecryptfs_read_super(struct super_block *sb, const char *dev_name)
+static int ecryptfs_read_super(struct super_block *sb, const char *dev_name,
+				uid_t check_ruid)
 {
 	struct path path;
 	int rc;
@@ -569,6 +579,15 @@ static int ecryptfs_read_super(struct su
 			"known incompatibilities\n");
 		goto out_free;
 	}
+
+	if (check_ruid && path.dentry->d_inode->i_uid != current_uid()) {
+		rc = -EPERM;
+		printk(KERN_ERR "Mount of device (uid: %d) not owned by "
+		       "requested user (uid: %d)\n",
+		       path.dentry->d_inode->i_uid, current_uid());
+		goto out_free;
+	}
+
 	ecryptfs_set_superblock_lower(sb, path.dentry->d_sb);
 	sb->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	sb->s_blocksize = path.dentry->d_sb->s_blocksize;
@@ -607,6 +626,7 @@ static int ecryptfs_get_sb(struct file_s
 {
 	int rc;
 	struct super_block *sb;
+	uid_t check_ruid;
 
 	rc = get_sb_nodev(fs_type, flags, raw_data, ecryptfs_fill_super, mnt);
 	if (rc < 0) {
@@ -614,12 +634,12 @@ static int ecryptfs_get_sb(struct file_s
 		goto out;
 	}
 	sb = mnt->mnt_sb;
-	rc = ecryptfs_parse_options(sb, raw_data);
+	rc = ecryptfs_parse_options(sb, raw_data, &check_ruid);
 	if (rc) {
 		printk(KERN_ERR "Error parsing options; rc = [%d]\n", rc);
 		goto out_abort;
 	}
-	rc = ecryptfs_read_super(sb, dev_name);
+	rc = ecryptfs_read_super(sb, dev_name, check_ruid);
 	if (rc) {
 		printk(KERN_ERR "Reading sb failed; rc = [%d]\n", rc);
 		goto out_abort;


