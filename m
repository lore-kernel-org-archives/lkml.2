Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0CaAaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:30:00 -0400
Received: from kroah.org ([198.145.64.141]:48870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756406Ab0C3XMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:24 2010
Message-Id: <20100330225824.006390017@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Carpenter <error27@gmail.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/89] ecryptfs: use after free
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit ece550f51ba175c14ec3ec047815927d7386ea1f upstream.

The "full_alg_name" variable is used on a couple error paths, so we
shouldn't free it until the end.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1745,7 +1745,7 @@ ecryptfs_process_key_cipher(struct crypt
 			    char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
-	char *full_alg_name;
+	char *full_alg_name = NULL;
 	int rc;
 
 	*key_tfm = NULL;
@@ -1760,7 +1760,6 @@ ecryptfs_process_key_cipher(struct crypt
 	if (rc)
 		goto out;
 	*key_tfm = crypto_alloc_blkcipher(full_alg_name, 0, CRYPTO_ALG_ASYNC);
-	kfree(full_alg_name);
 	if (IS_ERR(*key_tfm)) {
 		rc = PTR_ERR(*key_tfm);
 		printk(KERN_ERR "Unable to allocate crypto cipher with name "
@@ -1782,6 +1781,7 @@ ecryptfs_process_key_cipher(struct crypt
 		goto out;
 	}
 out:
+	kfree(full_alg_name);
 	return rc;
 }
 


