Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0DVTfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:35:44 -0400
Received: from kroah.org ([198.145.64.141]:41525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab0DVT3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:50 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.080178028@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [175/197] Revert "sunrpc: move the close processing after do recvfrom method"
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -711,7 +711,10 @@ int svc_recv(struct svc_rqst *rqstp, lon
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
@@ -737,7 +740,7 @@ int svc_recv(struct svc_rqst *rqstp, lon
 			svc_xprt_received(newxpt);
 		}
 		svc_xprt_received(xprt);
-	} else if (!test_bit(XPT_CLOSE, &xprt->xpt_flags)) {
+	} else {
 		dprintk("svc: server %p, pool %u, transport %p, inuse=%d\n",
 			rqstp, pool->sp_id, xprt,
 			atomic_read(&xprt->xpt_ref.refcount));
@@ -750,11 +753,6 @@ int svc_recv(struct svc_rqst *rqstp, lon
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


