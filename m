Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2BAVIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:13 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55592 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755984Ab2BAVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:11 -0500
X-Sasl-enc: O9DOBJJXRQDGMxtR/AIRW9h3YFfFamc6NCAKGkssbzD6 1328130490
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:37 2012
Message-Id: <20120201205737.822818760@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>
Subject: [04/65] eCryptfs: Make truncate path killable
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 5e6f0d769017cc49207ef56996e42363ec26c1f0 upstream.

ecryptfs_write() handles the truncation of eCryptfs inodes. It grabs a
page, zeroes out the appropriate portions, and then encrypts the page
before writing it to the lower filesystem. It was unkillable and due to
the lack of sparse file support could result in tying up a large portion
of system resources, while encrypting pages of zeros, with no way for
the truncate operation to be stopped from userspace.

This patch adds the ability for ecryptfs_write() to detect a pending
fatal signal and return as gracefully as possible. The intent is to
leave the lower file in a useable state, while still allowing a user to
break out of the encryption loop. If a pending fatal signal is detected,
the eCryptfs inode size is updated to reflect the modified inode size
and then -EINTR is returned.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/read_write.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -132,6 +132,11 @@ int ecryptfs_write(struct inode *ecryptf
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
 		size_t total_remaining_bytes = ((offset + size) - pos);
 
+		if (fatal_signal_pending(current)) {
+			rc = -EINTR;
+			break;
+		}
+
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
@@ -193,15 +198,19 @@ int ecryptfs_write(struct inode *ecryptf
 		}
 		pos += num_bytes;
 	}
-	if ((offset + size) > ecryptfs_file_size) {
-		i_size_write(ecryptfs_inode, (offset + size));
+	if (pos > ecryptfs_file_size) {
+		i_size_write(ecryptfs_inode, pos);
 		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED) {
-			rc = ecryptfs_write_inode_size_to_metadata(
+			int rc2;
+
+			rc2 = ecryptfs_write_inode_size_to_metadata(
 								ecryptfs_inode);
-			if (rc) {
+			if (rc2) {
 				printk(KERN_ERR	"Problem with "
 				       "ecryptfs_write_inode_size_to_metadata; "
-				       "rc = [%d]\n", rc);
+				       "rc = [%d]\n", rc2);
+				if (!rc)
+					rc = rc2;
 				goto out;
 			}
 		}


