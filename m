Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2EANqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2EANqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:46:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com,
        Kyle McMartin <kmcmarti@redhat.com>
Subject: [patch|rfc] block: don't mark buffers beyond end of disk as mapped
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 May 2012 09:46:11 -0400
Message-ID: <x49pqaom2u4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a bug report open where a squashfs image mounted on ppc64 would
exhibit errors due to trying to read beyond the end of the disk.  It can
easily be reproduced by doing the following:

[root@ibm-p750e-02-lp3 ~]# ls -l install.img
-rw-r--r-- 1 root root 142032896 Apr 30 16:46 install.img
[root@ibm-p750e-02-lp3 ~]# mount -o loop ./install.img /mnt/test
[root@ibm-p750e-02-lp3 ~]# dd if=/dev/loop0 of=/dev/null 
dd: reading `/dev/loop0': Input/output error
277376+0 records in
277376+0 records out
142016512 bytes (142 MB) copied, 0.9465 s, 150 MB/s

In dmesg, you'll find the following:

squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   43.106012] attempt to access beyond end of device
[   43.106029] loop0: rw=0, want=277410, limit=277408
[   43.106039] Buffer I/O error on device loop0, logical block 138704
[   43.106053] attempt to access beyond end of device
[   43.106057] loop0: rw=0, want=277412, limit=277408
[   43.106061] Buffer I/O error on device loop0, logical block 138705
[   43.106066] attempt to access beyond end of device
[   43.106070] loop0: rw=0, want=277414, limit=277408
[   43.106073] Buffer I/O error on device loop0, logical block 138706
[   43.106078] attempt to access beyond end of device
[   43.106081] loop0: rw=0, want=277416, limit=277408
[   43.106085] Buffer I/O error on device loop0, logical block 138707
[   43.106089] attempt to access beyond end of device
[   43.106093] loop0: rw=0, want=277418, limit=277408
[   43.106096] Buffer I/O error on device loop0, logical block 138708
[   43.106101] attempt to access beyond end of device
[   43.106104] loop0: rw=0, want=277420, limit=277408
[   43.106108] Buffer I/O error on device loop0, logical block 138709
[   43.106112] attempt to access beyond end of device
[   43.106116] loop0: rw=0, want=277422, limit=277408
[   43.106120] Buffer I/O error on device loop0, logical block 138710
[   43.106124] attempt to access beyond end of device
[   43.106128] loop0: rw=0, want=277424, limit=277408
[   43.106131] Buffer I/O error on device loop0, logical block 138711
[   43.106135] attempt to access beyond end of device
[   43.106139] loop0: rw=0, want=277426, limit=277408
[   43.106143] Buffer I/O error on device loop0, logical block 138712
[   43.106147] attempt to access beyond end of device
[   43.106151] loop0: rw=0, want=277428, limit=277408
[   43.106154] Buffer I/O error on device loop0, logical block 138713
[   43.106158] attempt to access beyond end of device
[   43.106162] loop0: rw=0, want=277430, limit=277408
[   43.106166] attempt to access beyond end of device
[   43.106169] loop0: rw=0, want=277432, limit=277408
...
[   43.106307] attempt to access beyond end of device
[   43.106311] loop0: rw=0, want=277470, limit=2774

What's strange is that the same messages aren't output when mounting an
ext2, 3, or 4 image of the same size.  Digging into this, I found that
squashfs manages to read in the end block(s) of the disk during the
mount operation.  That leads to block_read_full_page being called with
buffers that are beyond end of disk, but are marked as mapped.  Thus, it
would end up submitting read I/O against them, resulting in the errors
mentioned above.  I fixed the problem by modifying init_page_buffers to
only set the buffer mapped if it fell inside of i_size.  Since I haven't
fully explained the reason that extN does not hit this problem, I'm
proposing this as an RFC, though it does look like a good fix to me.

Comments would be appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/buffer.c b/fs/buffer.c
index 351e18e..b3d6a97 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -921,6 +921,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 	struct buffer_head *head = page_buffers(page);
 	struct buffer_head *bh = head;
 	int uptodate = PageUptodate(page);
+	struct inode *inode = bdev->bd_inode;
+	sector_t last_block = (i_size_read(inode) - 1) >> inode->i_blkbits;
 
 	do {
 		if (!buffer_mapped(bh)) {
@@ -929,7 +931,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
-			set_buffer_mapped(bh);
+			if (block <= last_block)
+				set_buffer_mapped(bh);
 		}
 		block++;
 		bh = bh->b_this_page;
