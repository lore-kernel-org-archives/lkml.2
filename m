Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162124Ab1FAIRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:17:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162101Ab1FAIRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:34 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:43 2011
Message-Id: <20110601080442.027893112@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:01:01 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [125/146] eCryptfs: Allow 2 scatterlist entries for encrypted
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 filenames

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -492,8 +492,8 @@ struct ecryptfs_write_tag_70_packet_sill
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
@@ -709,23 +709,21 @@ ecryptfs_write_tag_70_packet(char *dest,
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
@@ -748,7 +746,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_release_free_unlock;
 	}
-	rc = crypto_blkcipher_encrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_encrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to encrypt filename; "
@@ -782,8 +780,8 @@ struct ecryptfs_parse_tag_70_packet_sill
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
@@ -890,13 +888,12 @@ ecryptfs_parse_tag_70_packet(char **file
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
@@ -910,13 +907,12 @@ ecryptfs_parse_tag_70_packet(char **file
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
@@ -956,7 +952,7 @@ ecryptfs_parse_tag_70_packet(char **file
 		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
 		goto out_free_unlock;
 	}
-	rc = crypto_blkcipher_decrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+	rc = crypto_blkcipher_decrypt_iv(&s->desc, s->dst_sg, s->src_sg,
 					 s->block_aligned_filename_size);
 	if (rc) {
 		printk(KERN_ERR "%s: Error attempting to decrypt filename; "


