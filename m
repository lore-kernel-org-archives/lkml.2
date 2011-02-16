Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1BPBuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:20 -0500
Received: from kroah.org ([198.145.64.141]:48950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758267Ab1BPBuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:59 2011
Message-Id: <20110216014659.098612008@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [048/115] NFS: Fix "kernel BUG at fs/aio.c:554!"
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 839f7ad6932d95f4d5ae7267b95c574714ff3d5b upstream.

Nick Piggin reports:

> I'm getting use after frees in aio code in NFS
>
> [ 2703.396766] Call Trace:
> [ 2703.396858]  [<ffffffff8100b057>] ? native_sched_clock+0x27/0x80
> [ 2703.396959]  [<ffffffff8108509e>] ? put_lock_stats+0xe/0x40
> [ 2703.397058]  [<ffffffff81088348>] ? lock_release_holdtime+0xa8/0x140
> [ 2703.397159]  [<ffffffff8108a2a5>] lock_acquire+0x95/0x1b0
> [ 2703.397260]  [<ffffffff811627db>] ? aio_put_req+0x2b/0x60
> [ 2703.397361]  [<ffffffff81039701>] ? get_parent_ip+0x11/0x50
> [ 2703.397464]  [<ffffffff81612a31>] _raw_spin_lock_irq+0x41/0x80
> [ 2703.397564]  [<ffffffff811627db>] ? aio_put_req+0x2b/0x60
> [ 2703.397662]  [<ffffffff811627db>] aio_put_req+0x2b/0x60
> [ 2703.397761]  [<ffffffff811647fe>] do_io_submit+0x2be/0x7c0
> [ 2703.397895]  [<ffffffff81164d0b>] sys_io_submit+0xb/0x10
> [ 2703.397995]  [<ffffffff8100307b>] system_call_fastpath+0x16/0x1b
>
> Adding some tracing, it is due to nfs completing the request then
> returning something other than -EIOCBQUEUED, so aio.c
> also completes the request.

To address this, prevent the NFS direct I/O engine from completing
async iocbs when the forward path returns an error without starting
any I/O.

This fix appears to survive ^C during both "xfstest no. 208" and "fsx
-Z."

It's likely this bug has existed for a very long while, as we are seeing
very similar symptoms in OEL 5.  Copying stable.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/direct.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -401,15 +401,18 @@ static ssize_t nfs_direct_read_schedule_
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_complete(dreq);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
@@ -829,15 +832,18 @@ static ssize_t nfs_direct_write_schedule
 		pos += vec->iov_len;
 	}
 
+	/*
+	 * If no bytes were started, return the error, and let the
+	 * generic layer handle the completion.
+	 */
+	if (requested_bytes == 0) {
+		nfs_direct_req_release(dreq);
+		return result < 0 ? result : -EIO;
+	}
+
 	if (put_dreq(dreq))
 		nfs_direct_write_complete(dreq, dreq->inode);
-
-	if (requested_bytes != 0)
-		return 0;
-
-	if (result < 0)
-		return result;
-	return -EIO;
+	return 0;
 }
 
 static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,


