Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab2BJWoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:44:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2BJWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:43 -0500
MIME-Version: 1.0
Message-Id: <20120210223440.415587615@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [patch 01/55] readahead: fix pipeline break caused by block plug
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 3deaa7190a8da38453c4fabd9dec7f66d17fff67 upstream.

Herbert Poetzl reported a performance regression since 2.6.39.  The test
is a simple dd read, but with big block size.  The reason is:

T1: ra (A, A+128k), (A+128k, A+256k)
T2: lock_page for page A, submit the 256k
T3: hit page A+128K, ra (A+256k, A+384). the range isn't submitted
because of plug and there isn't any lock_page till we hit page A+256k
because all pages from A to A+256k is in memory
T4: hit page A+256k, ra (A+384, A+ 512). Because of plug, the range isn't
submitted again.
T5: lock_page A+256k, so (A+256k, A+512k) will be submitted. The task is
waitting for (A+256k, A+512k) finish.

There is no request to disk in T3 and T4, so readahead pipeline breaks.

We really don't need block plug for generic_file_aio_read() for buffered
I/O.  The readahead already has plug and has fine grained control when I/O
should be submitted.  Deleting plug for buffered I/O fixes the regression.

One side effect is plug makes the request size 256k, the size is 128k
without it.  This is because default ra size is 128k and not a reason we
need plug here.

Vivek said:

: We submit some readahead IO to device request queue but because of nested
: plug, queue never gets unplugged.  When read logic reaches a page which is
: not in page cache, it waits for page to be read from the disk
: (lock_page_killable()) and that time we flush the plug list.
:
: So effectively read ahead logic is kind of broken in parts because of
: nested plugging.  Removing top level plug (generic_file_aio_read()) for
: buffered reads, will allow unplugging queue earlier for readahead.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reported-by: Herbert Poetzl <herbert@13thfloor.at>
Tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1379,15 +1379,12 @@ generic_file_aio_read(struct kiocb *iocb
 	unsigned long seg = 0;
 	size_t count;
 	loff_t *ppos = &iocb->ki_pos;
-	struct blk_plug plug;
 
 	count = 0;
 	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
 	if (retval)
 		return retval;
 
-	blk_start_plug(&plug);
-
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1403,8 +1400,12 @@ generic_file_aio_read(struct kiocb *iocb
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
+				struct blk_plug plug;
+
+				blk_start_plug(&plug);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
+				blk_finish_plug(&plug);
 			}
 			if (retval > 0) {
 				*ppos = pos + retval;
@@ -1460,7 +1461,6 @@ generic_file_aio_read(struct kiocb *iocb
 			break;
 	}
 out:
-	blk_finish_plug(&plug);
 	return retval;
 }
 EXPORT_SYMBOL(generic_file_aio_read);


