Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935255Ab2C3VHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:07:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935241Ab2C3VHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:42 -0400
Message-Id: <20120330195733.789810217@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiaying Zhang <jiayingz@google.com>,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: [ 081/108] ext4: flush any pending end_io requests before DIO reads w/dioread_nolock
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaying Zhang <jiayingz@google.com>

commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b upstream.

(backported to 3.0 by mjt)

There is a race between ext4 buffer write and direct_IO read with
dioread_nolock mount option enabled. The problem is that we clear
PageWriteback flag during end_io time but will do
uninitialized-to-initialized extent conversion later with dioread_nolock.
If an O_direct read request comes in during this period, ext4 will return
zero instead of the recently written data.

This patch checks whether there are any pending uninitialized-to-initialized
extent conversion requests before doing O_direct read to close the race.
Note that this is just a bandaid fix. The fundamental issue is that we
clear PageWriteback flag before we really complete an IO, which is
problem-prone. To fix the fundamental issue, we may need to implement an
extent tree cache that we can use to look up pending to-be-converted extents.

Signed-off-by: Jiaying Zhang <jiayingz@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/ext4/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3510,12 +3510,17 @@ static ssize_t ext4_ind_direct_IO(int rw
 	}
 
 retry:
-	if (rw == READ && ext4_should_dioread_nolock(inode))
+	if (rw == READ && ext4_should_dioread_nolock(inode)) {
+		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+			mutex_lock(&inode->i_mutex);
+			ext4_flush_completed_IO(inode);
+			mutex_unlock(&inode->i_mutex);
+		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
-	else {
+	} else {
 		ret = blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,


