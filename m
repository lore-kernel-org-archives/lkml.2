Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0EXWil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:38:41 -0400
Received: from kroah.org ([198.145.64.141]:42426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab0EXWia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:30 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:19 2010
Message-Id: <20100524223019.724876658@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tom Tucker <tom@opengridcomputing.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       roma1390 <roma1390@gmail.com>
Subject: [24/24] svc: Clean up deferred requests on transport destruction
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tom Tucker <tom@opengridcomputing.com>

commit 22945e4a1c7454c97f5d8aee1ef526c83fef3223 upstream.

A race between svc_revisit and svc_delete_xprt can result in
deferred requests holding references on a transport that can never be
recovered because dead transports are not enqueued for subsequent
processing.

Check for XPT_DEAD in revisit to clean up completing deferrals on a dead
transport and sweep a transport's deferred queue to do the same for queued
but unprocessed deferrals.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: roma1390 <roma1390@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svc_xprt.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -810,6 +810,11 @@ static void svc_age_temp_xprts(unsigned
 void svc_delete_xprt(struct svc_xprt *xprt)
 {
 	struct svc_serv	*serv = xprt->xpt_server;
+	struct svc_deferred_req *dr;
+
+	/* Only do this once */
+	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags))
+		return;
 
 	dprintk("svc: svc_delete_xprt(%p)\n", xprt);
 	xprt->xpt_ops->xpo_detach(xprt);
@@ -824,12 +829,16 @@ void svc_delete_xprt(struct svc_xprt *xp
 	 * while still attached to a queue, the queue itself
 	 * is about to be destroyed (in svc_destroy).
 	 */
-	if (!test_and_set_bit(XPT_DEAD, &xprt->xpt_flags)) {
-		BUG_ON(atomic_read(&xprt->xpt_ref.refcount) < 2);
-		if (test_bit(XPT_TEMP, &xprt->xpt_flags))
-			serv->sv_tmpcnt--;
+	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
+		serv->sv_tmpcnt--;
+
+	for (dr = svc_deferred_dequeue(xprt); dr;
+	     dr = svc_deferred_dequeue(xprt)) {
 		svc_xprt_put(xprt);
+		kfree(dr);
 	}
+
+	svc_xprt_put(xprt);
 	spin_unlock_bh(&serv->sv_lock);
 }
 
@@ -875,17 +884,19 @@ static void svc_revisit(struct cache_def
 		container_of(dreq, struct svc_deferred_req, handle);
 	struct svc_xprt *xprt = dr->xprt;
 
-	if (too_many) {
+	spin_lock(&xprt->xpt_lock);
+	set_bit(XPT_DEFERRED, &xprt->xpt_flags);
+	if (too_many || test_bit(XPT_DEAD, &xprt->xpt_flags)) {
+		spin_unlock(&xprt->xpt_lock);
+		dprintk("revisit canceled\n");
 		svc_xprt_put(xprt);
 		kfree(dr);
 		return;
 	}
 	dprintk("revisit queued\n");
 	dr->xprt = NULL;
-	spin_lock(&xprt->xpt_lock);
 	list_add(&dr->handle.recent, &xprt->xpt_deferred);
 	spin_unlock(&xprt->xpt_lock);
-	set_bit(XPT_DEFERRED, &xprt->xpt_flags);
 	svc_xprt_enqueue(xprt);
 	svc_xprt_put(xprt);
 }


