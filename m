Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1HNQKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab1HNQKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.874394229@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Johansen <john.johansen@canonical.com>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [77/90] Ecryptfs: Add mount option to check uid of device being
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------
 mounted = expect uid

From: John Johansen <john.johansen@canonical.com>

commit 764355487ea220fdc2faf128d577d7f679b91f97 upstream.

Close a TOCTOU race for mounts done via ecryptfs-mount-private.  The mount
source (device) can be raced when the ownership test is done in userspace.
Provide Ecryptfs a means to force the uid check at mount time.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/main.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -175,6 +175,7 @@ enum { ecryptfs_opt_sig, ecryptfs_opt_ec
        ecryptfs_opt_encrypted_view, ecryptfs_opt_fnek_sig,
        ecryptfs_opt_fn_cipher, ecryptfs_opt_fn_cipher_key_bytes,
        ecryptfs_opt_unlink_sigs, ecryptfs_opt_mount_auth_tok_only,
+       ecryptfs_opt_check_dev_ruid,
        ecryptfs_opt_err };
 
 static const match_table_t tokens = {
@@ -191,6 +192,7 @@ static const match_table_t tokens = {
 	{ecryptfs_opt_fn_cipher_key_bytes, "ecryptfs_fn_key_bytes=%u"},
 	{ecryptfs_opt_unlink_sigs, "ecryptfs_unlink_sigs"},
 	{ecryptfs_opt_mount_auth_tok_only, "ecryptfs_mount_auth_tok_only"},
+	{ecryptfs_opt_check_dev_ruid, "ecryptfs_check_dev_ruid"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -236,6 +238,7 @@ static void ecryptfs_init_mount_crypt_st
  * ecryptfs_parse_options
  * @sb: The ecryptfs super block
  * @options: The options passed to the kernel
+ * @check_ruid: set to 1 if device uid should be checked against the ruid
  *
  * Parse mount options:
  * debug=N 	   - ecryptfs_verbosity level for debug output
@@ -251,7 +254,8 @@ static void ecryptfs_init_mount_crypt_st
  *
  * Returns zero on success; non-zero on error
  */
-static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options)
+static int ecryptfs_parse_options(struct ecryptfs_sb_info *sbi, char *options,
+				  uid_t *check_ruid)
 {
 	char *p;
 	int rc = 0;
@@ -276,6 +280,8 @@ static int ecryptfs_parse_options(struct
 	char *cipher_key_bytes_src;
 	char *fn_cipher_key_bytes_src;
 
+	*check_ruid = 0;
+
 	if (!options) {
 		rc = -EINVAL;
 		goto out;
@@ -380,6 +386,9 @@ static int ecryptfs_parse_options(struct
 			mount_crypt_stat->flags |=
 				ECRYPTFS_GLOBAL_MOUNT_AUTH_TOK_ONLY;
 			break;
+		case ecryptfs_opt_check_dev_ruid:
+			*check_ruid = 1;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			printk(KERN_WARNING
@@ -475,6 +484,7 @@ static struct dentry *ecryptfs_mount(str
 	const char *err = "Getting sb failed";
 	struct inode *inode;
 	struct path path;
+	uid_t check_ruid;
 	int rc;
 
 	sbi = kmem_cache_zalloc(ecryptfs_sb_info_cache, GFP_KERNEL);
@@ -483,7 +493,7 @@ static struct dentry *ecryptfs_mount(str
 		goto out;
 	}
 
-	rc = ecryptfs_parse_options(sbi, raw_data);
+	rc = ecryptfs_parse_options(sbi, raw_data, &check_ruid);
 	if (rc) {
 		err = "Error parsing options";
 		goto out;
@@ -521,6 +531,15 @@ static struct dentry *ecryptfs_mount(str
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
 	ecryptfs_set_superblock_lower(s, path.dentry->d_sb);
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;


