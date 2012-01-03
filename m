Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2ACWuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:50:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab2ACWlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:41:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:23 2012
Message-Id: <20120103223323.101522455@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [25/75] SUNRPC: Ensure we always bump the backlog queue in xprt_free_slot
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c25573b5134294c0be82bfaecc6d08136835b271 upstream.

Whenever we free a slot, we know that the resulting xprt->num_reqs will
be less than xprt->max_reqs, so we know that we can release at least one
backlogged rpc_task.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprt.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -995,13 +995,11 @@ out_init_req:
 
 static void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
 {
-	if (xprt_dynamic_free_slot(xprt, req))
-		return;
-
-	memset(req, 0, sizeof(*req));	/* mark unused */
-
 	spin_lock(&xprt->reserve_lock);
-	list_add(&req->rq_list, &xprt->free);
+	if (!xprt_dynamic_free_slot(xprt, req)) {
+		memset(req, 0, sizeof(*req));	/* mark unused */
+		list_add(&req->rq_list, &xprt->free);
+	}
 	rpc_wake_up_next(&xprt->backlog);
 	spin_unlock(&xprt->reserve_lock);
 }


