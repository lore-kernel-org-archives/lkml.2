Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1KUXdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:33:08 -0500
Received: from mail-qy0-f202.google.com ([209.85.216.202]:40501 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1KUXdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:33:04 -0500
Date: Mon, 21 Nov 2011 15:32:58 -0800
From: Michael Halcrow <mhalcrow@google.com>
To: torvalds@linux-foundation.org, tyhicks@canonical.com
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, thieule@google.com
Subject: [PATCH] eCryptfs: Check array bounds for filename characters
Message-ID: <20111121233258.GA18466@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Characters with ASCII values greater than the size of
filename_rev_map[] are valid filename
characters. ecryptfs_decode_from_filename() will access kernel memory
beyond that array, and ecryptfs_parse_tag_70_packet() will then
decrypt those characters. The attacker, using the FNEK of the crafted
file, can then re-encrypt the characters to reveal the kernel memory
past the end of the filename_rev_map[] array. I expect low security
impact since this array is statically allocated in the text area, and
the amount of memory past the array that is accessible is limited by
the largest possible ASCII filename character.

This change verifies that the offset into filename_rev_map[] is within
bounds. If any one character is not, then eCryptfs will consider the
filename to not be a valid encrypted filename and will copy it
verbatim rather than try to decode/decrypt it.

Signed-off-by: Mike Halcrow <mhalcrow@google.com>


diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 58609bd..d2d2b9e 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -2032,11 +2032,14 @@ out:
  * @dst_size: Set to the size of the decoded string.
  * @src: The encoded set of octets to decode.
  * @src_size: The size of the encoded set of octets to decode.
+ *
+ * Returns zero on success; non-zero otherwise
  */
-static void
+static int
 ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
 			      const unsigned char *src, size_t src_size)
 {
+	int rc = 0;
 	u8 current_bit_offset = 0;
 	size_t src_byte_offset = 0;
 	size_t dst_byte_offset = 0;
@@ -2052,9 +2055,13 @@ ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
 		goto out;
 	}
 	while (src_byte_offset < src_size) {
-		unsigned char src_byte =
-				filename_rev_map[(int)src[src_byte_offset]];
-
+		int rev_map_offset = (int)src[src_byte_offset];
+		unsigned char src_byte;
+		if (rev_map_offset > (ARRAY_SIZE(filename_rev_map) - 1)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		src_byte = filename_rev_map[rev_map_offset];
 		switch (current_bit_offset) {
 		case 0:
 			dst[dst_byte_offset] = (src_byte << 2);
@@ -2081,7 +2088,7 @@ ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
 	}
 	(*dst_size) = dst_byte_offset;
 out:
-	return;
+	return rc;
 }
 
 /**
@@ -2235,8 +2242,14 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 
 		name += ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
 		name_size -= ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
-		ecryptfs_decode_from_filename(NULL, &decoded_name_size,
-					      name, name_size);
+		rc = ecryptfs_decode_from_filename(NULL, &decoded_name_size,
+						   name, name_size);
+		if (rc) {
+			rc = ecryptfs_copy_filename(plaintext_name,
+						    plaintext_name_size,
+						    orig_name, orig_name_size);
+			goto out;
+		}
 		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
 		if (!decoded_name) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
@@ -2245,8 +2258,16 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 			rc = -ENOMEM;
 			goto out;
 		}
-		ecryptfs_decode_from_filename(decoded_name, &decoded_name_size,
-					      name, name_size);
+		rc = ecryptfs_decode_from_filename(decoded_name,
+						   &decoded_name_size,
+						   name,
+						   name_size);
+		if (rc) {
+			rc = ecryptfs_copy_filename(plaintext_name,
+						    plaintext_name_size,
+						    orig_name, orig_name_size);
+			goto out_free;
+		}
 		rc = ecryptfs_parse_tag_70_packet(plaintext_name,
 						  plaintext_name_size,
 						  &packet_size,
