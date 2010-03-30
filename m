Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0C3Xoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:44:34 -0400
Received: from kroah.org ([198.145.64.141]:46130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab0C3XUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:13 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:02 2010
Message-Id: <20100330224801.348758963@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [063/156] Revert "sunrpc: move the close processing after do recvfrom method"
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 1b644b6e6f6160ae35ce4b52c2ca89ed3e356e18 upstream.

This reverts commit b0401d725334a94d57335790b8ac2404144748ee, which
moved svc_delete_xprt() outside of XPT_BUSY, and allowed it to be called
after svc_xpt_recived(), removing its last reference and destroying it
after it had already been queued for future processing.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc_xprt.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -699,7 +699,10 @@ int svc_recv(struct svc_rqst *rqstp, lon
 	spin_unlock_bh(&pool->sp_lock);
 
 	len = 0;
-	if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
+	if (test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
+		dprintk("svc_recv: found XPT_CLOSE\n");
+		svc_delete_xprt(xprt);
+	} else if (test_bit(XPT_LISTENER, &xprt->xpt_flags)) {
 		struct svc_xprt *newxpt;
 		newxpt = xprt->xpt_ops->xpo_accept(xprt);
 		if (newxpt) {
@@ -725,7 +728,7 @@ int svc_recv(struct svc_rqst *rqstp, lon
 			svc_xprt_received(newxpt);
 		}
 		svc_xprt_received(xprt);
-	} else if (!test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
+	} else {
 		dprintk("svc: server %p, pool %u, transport %p, inuse=%d\n",
 			rqstp, pool->sp_id, xprt,
 			atomic_read(&xprt->xpt_ref.refcount));
@@ -738,11 +741,6 @@ int svc_recv(struct svc_rqst *rqstp, lon
 		dprintk("svc: got len=%d\n", len);
 	}
 
-	if (test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
-		dprintk("svc_recv: found XPT_CLOSE\n");
-		svc_delete_xprt(xprt);
-	}
-
 	/* No data, incomplete (TCP) read, or accept() */
 	if (len == 0 || len == -EAGAIN) {
 		rqstp->rq_res.len = 0;


