Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0IRThQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:37:16 -0400
Received: from kroah.org ([198.145.64.141]:43244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab0IRTOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:53 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.057161869@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>,
        Chuck Ebbert <cebbert@redhat.com>
Subject: [021/129] xfs: move aio completion after unwritten extent conversion
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit fb511f2150174b18b28ad54708c1adda0df39b17 upstream.

If we write into an unwritten extent using AIO we need to complete the AIO
request after the extent conversion has finished.  Without that a read could
race to see see the extent still unwritten and return zeros.   For synchronous
I/O we already take care of that by flushing the xfsconvertd workqueue (which
might be a bit of overkill).

To do that add iocb and result fields to struct xfs_ioend, so that we can
call aio_complete from xfs_end_io after the extent conversion has happened.
Note that we need a new result field as io_error is used for positive errno
values, while the AIO code can return negative error values and positive
transfer sizes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/linux-2.6/xfs_aops.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -275,8 +275,11 @@ xfs_end_io(
 		xfs_finish_ioend(ioend, 0);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
-	} else
+	} else {
+		if (ioend->io_iocb)
+			aio_complete(ioend->io_iocb, ioend->io_result, 0);
 		xfs_destroy_ioend(ioend);
+	}
 }
 
 /*
@@ -309,6 +312,8 @@ xfs_alloc_ioend(
 	atomic_inc(&XFS_I(ioend->io_inode)->i_iocount);
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
+	ioend->io_iocb = NULL;
+	ioend->io_result = 0;
 
 	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
@@ -1604,6 +1609,7 @@ xfs_end_io_direct(
 	bool		is_async)
 {
 	xfs_ioend_t	*ioend = iocb->private;
+	bool		complete_aio = is_async;
 
 	/*
 	 * Non-NULL private data means we need to issue a transaction to
@@ -1629,7 +1635,14 @@ xfs_end_io_direct(
 	if (ioend->io_type == IO_READ) {
 		xfs_finish_ioend(ioend, 0);
 	} else if (private && size > 0) {
-		xfs_finish_ioend(ioend, is_sync_kiocb(iocb));
+		if (is_async) {
+			ioend->io_iocb = iocb;
+			ioend->io_result = ret;
+			complete_aio = false;
+			xfs_finish_ioend(ioend, 0);
+		} else {
+			xfs_finish_ioend(ioend, 1);
+		}
 	} else {
 		/*
 		 * A direct I/O write ioend starts it's life in unwritten
@@ -1648,7 +1661,7 @@ xfs_end_io_direct(
 	 */
 	iocb->private = NULL;
 
-	if (is_async)
+	if (complete_aio)
 		aio_complete(iocb, ret, 0);
 }
 


