Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2BAVKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:11 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52676 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757292Ab2BAVJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:58 -0500
X-Sasl-enc: zfBRG/czI8qHDz048z1jpOGGRU0No6P4Ml1IcjmMeTLr 1328130597
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.522179261@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>
Subject: [07/89] eCryptfs: Fix oops when printing debug info in extent crypto functions
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 58ded24f0fcb85bddb665baba75892f6ad0f4b8a upstream.

If pages passed to the eCryptfs extent-based crypto functions are not
mapped and the module parameter ecryptfs_verbosity=1 was specified at
loading time, a NULL pointer dereference will occur.

Note that this wouldn't happen on a production system, as you wouldn't
pass ecryptfs_verbosity=1 on a production system. It leaks private
information to the system logs and is for debugging only.

The debugging info printed in these messages is no longer very useful
and rather than doing a kmap() in these debugging paths, it will be
better to simply remove the debugging paths completely.

https://launchpad.net/bugs/913651

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -417,17 +417,6 @@ static int ecryptfs_encrypt_extent(struc
 			(unsigned long long)(extent_base + extent_offset), rc);
 		goto out;
 	}
-	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Encrypting extent "
-				"with iv:\n");
-		ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
-		ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
-				"encryption:\n");
-		ecryptfs_dump_hex((char *)
-				  (page_address(page)
-				   + (extent_offset * crypt_stat->extent_size)),
-				  8);
-	}
 	rc = ecryptfs_encrypt_page_offset(crypt_stat, enc_extent_page, 0,
 					  page, (extent_offset
 						 * crypt_stat->extent_size),
@@ -440,14 +429,6 @@ static int ecryptfs_encrypt_extent(struc
 		goto out;
 	}
 	rc = 0;
-	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Encrypt extent [0x%.16llx]; "
-			"rc = [%d]\n",
-			(unsigned long long)(extent_base + extent_offset), rc);
-		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
-				"encryption:\n");
-		ecryptfs_dump_hex((char *)(page_address(enc_extent_page)), 8);
-	}
 out:
 	return rc;
 }
@@ -543,17 +524,6 @@ static int ecryptfs_decrypt_extent(struc
 			(unsigned long long)(extent_base + extent_offset), rc);
 		goto out;
 	}
-	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Decrypting extent "
-				"with iv:\n");
-		ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
-		ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
-				"decryption:\n");
-		ecryptfs_dump_hex((char *)
-				  (page_address(enc_extent_page)
-				   + (extent_offset * crypt_stat->extent_size)),
-				  8);
-	}
 	rc = ecryptfs_decrypt_page_offset(crypt_stat, page,
 					  (extent_offset
 					   * crypt_stat->extent_size),
@@ -567,16 +537,6 @@ static int ecryptfs_decrypt_extent(struc
 		goto out;
 	}
 	rc = 0;
-	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Decrypt extent [0x%.16llx]; "
-			"rc = [%d]\n",
-			(unsigned long long)(extent_base + extent_offset), rc);
-		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
-				"decryption:\n");
-		ecryptfs_dump_hex((char *)(page_address(page)
-					   + (extent_offset
-					      * crypt_stat->extent_size)), 8);
-	}
 out:
 	return rc;
 }


