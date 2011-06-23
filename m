Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1FWRaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:30:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:65522 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab1FWRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:30:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 047/247] NFS: Fix "kernel BUG at fs/aio.c:554!"
Date: Thu, 23 Jun 2011 13:25:46 -0400
Message-Id: <1308850146-15061-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/direct.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index ad4cd31..b1c23b7 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -402,15 +402,18 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
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
@@ -830,15 +833,18 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
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
-- 
1.7.4.4

