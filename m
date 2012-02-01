Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab2BAV7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:59:17 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58138 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab2BAVHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:40 -0500
X-Sasl-enc: B9EZl3zDWJlh6jPbUZZ8zlJBZqLZc89P1fbvL4ngrdwM 1328130459
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:31 2012
Message-Id: <20120201201531.344259682@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>
Subject: [03/20] eCryptfs: Make truncate path killable
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -136,6 +136,11 @@ int ecryptfs_write(struct file *ecryptfs
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
@@ -197,15 +202,19 @@ int ecryptfs_write(struct file *ecryptfs
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


