Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab2EOCRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:49177 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890Ab2EOCQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 033/179] eCryptfs: Allow 2 scatterlist entries for encrypted filenames
Date: Mon, 14 May 2012 22:12:09 -0400
Message-ID: <1337048075-6132-34-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8d08dab786ad5cc2aca2bf870de370144b78c85a upstream.

The buffers allocated while encrypting and decrypting long filenames can
sometimes straddle two pages. In this situation, virt_to_scatterlist()
will return -ENOMEM, causing the operation to fail and the user will get
scary error messages in their logs:

kernel: ecryptfs_write_tag_70_packet: Internal error whilst attempting
to convert filename memory to scatterlist; expected rc = 1; got rc =
[-12]. block_aligned_filename_size = [272]
kernel: ecryptfs_encrypt_filename: Error attempting to generate tag 70
packet; rc = [-12]
kernel: ecryptfs_encrypt_and_encode_filename: Error attempting to
encrypt filename; rc = [-12]
kernel: ecryptfs_lookup: Error attempting to encrypt and encode
filename; rc = [-12]

The solution is to allow up to 2 scatterlist entries to be used.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/keystore.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index d6e9355..07f23c5 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -482,8 +482,8 @@ struct ecryptfs_write_tag_70_packet_silly_stack {
 	struct mutex *tfm_mutex;
 	char *block_aligned_filename;
 	struct ecryptfs_auth_tok *auth_tok;
-	struct scatterlist src_sg;
-	struct scatterlist dst_sg;
+	struct scatterlist src_sg[2];
+	struct scatterlist dst_sg[2];
 	struct blkcipher_desc desc;
 	char iv[ECRYPTFS_MAX_IV_BYTES];
 	char hash[ECRYPTFS_TAG_70_DIGEST_SIZE];
@@ -696,23 +696,21 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 	memcpy(&s->block_aligned_filename[s->num_rand_bytes], filename,
 	       filename_size);
 	rc = virt_to_scatterlist(s->block_aligned_filename,
-				 s->block_aligned_filename_size, &s->src_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->src_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
-		       "convert filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
+		       "convert filename memory to scatterlist; rc = [%d]. "
 		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
 		       s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
 	rc = virt_to_scatterlist(&dest[s->i], s->block_aligned_filename_size,
-				 &s->dst_sg, 1);
-	if (rc != 1) {
+				 s->dst_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_release_free_unlock;
 	}
 	/* The characters in the first block effectively do the job
@@ -735,7 +733,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_release_free_unlock;
 	}
-	rc = crypto_blkcipher_encrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_encrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to encrypt filename; "
@@ -767,8 +765,8 @@ struct ecryptfs_parse_tag_70_packet_silly_stack {
 	struct mutex *tfm_mutex;
 	char *decrypted_filename;
 	struct ecryptfs_auth_tok *auth_tok;
-	struct scatterlist src_sg;
-	struct scatterlist dst_sg;
+	struct scatterlist src_sg[2];
+	struct scatterlist dst_sg[2];
 	struct blkcipher_desc desc;
 	char fnek_sig_hex[ECRYPTFS_SIG_SIZE_HEX + 1];
 	char iv[ECRYPTFS_MAX_IV_BYTES];
@@ -873,13 +871,12 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 	}
 	mutex_lock(s->tfm_mutex);
 	rc = virt_to_scatterlist(&data[(*packet_size)],
-				 s->block_aligned_filename_size, &s->src_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->src_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert encrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_unlock;
 	}
 	(*packet_size) += s->block_aligned_filename_size;
@@ -893,13 +890,12 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		goto out_unlock;
 	}
 	rc = virt_to_scatterlist(s->decrypted_filename,
-				 s->block_aligned_filename_size, &s->dst_sg, 1);
-	if (rc != 1) {
+				 s->block_aligned_filename_size, s->dst_sg, 2);
+	if (rc < 1) {
 		printk(KERN_ERR "%s: Internal error whilst attempting to "
 		       "convert decrypted filename memory to scatterlist; "
-		       "expected rc = 1; got rc = [%d]. "
-		       "block_aligned_filename_size = [%zd]\n", __func__, rc,
-		       s->block_aligned_filename_size);
+		       "rc = [%d]. block_aligned_filename_size = [%zd]\n",
+		       __func__, rc, s->block_aligned_filename_size);
 		goto out_free_unlock;
 	}
 	/* The characters in the first block effectively do the job of
@@ -938,7 +934,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_free_unlock;
 	}
-	rc = crypto_blkcipher_decrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_decrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to decrypt filename; "
-- 
1.7.9.6

