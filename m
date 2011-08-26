Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1H0O6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab1H0O60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.048187376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [21/35] ext4: fix nomblk_io_submit option so it correctly converts uninit blocks
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 9dd75f1f1a02d656a11a7b9b9e6c2759b9c1e946 upstream.

Bug discovered by Jan Kara:

Finally, commit 1449032be17abb69116dbc393f67ceb8bd034f92 returned back
the old IO submission code but apparently it forgot to return the old
handling of uninitialized buffers so we unconditionnaly call
block_write_full_page() without specifying end_io function. So AFAICS
we never convert unwritten extents to written in some cases. For
example when I mount the fs as: mount -t ext4 -o
nomblk_io_submit,dioread_nolock /dev/ubdb /mnt and do
        int fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0600);
        char buf[1024];
        memset(buf, 'a', sizeof(buf));
        fallocate(fd, 0, 0, 16384);
        write(fd, buf, sizeof(buf));

I get a file full of zeros (after remounting the filesystem so that
pagecache is dropped) instead of seeing the first KB contain 'a's.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2156,7 +2156,12 @@ static int mpage_da_submit_io(struct mpa
 			else if (test_opt(inode->i_sb, MBLK_IO_SUBMIT))
 				err = ext4_bio_write_page(&io_submit, page,
 							  len, mpd->wbc);
-			else
+			else if (buffer_uninit(page_bufs)) {
+				ext4_set_bh_endio(page_bufs, inode);
+				err = block_write_full_page_endio(page,
+					noalloc_get_block_write,
+					mpd->wbc, ext4_end_io_buffer_write);
+			} else
 				err = block_write_full_page(page,
 					noalloc_get_block_write, mpd->wbc);
 


