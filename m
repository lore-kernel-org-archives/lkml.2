Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab2JAXhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:37:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35068 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578Ab2JAXAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:00 -0400
Message-Id: <20121001225203.164203254@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 131/180] svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit d10f27a750312ed5638c876e4bd6aa83664cccd8 upstream.

The rpc server tries to ensure that there will be room to send a reply
before it receives a request.

It does this by tracking, in xpt_reserved, an upper bound on the total
size of the replies that is has already committed to for the socket.

Currently it is adding in the estimate for a new reply *before* it
checks whether there is space available.  If it finds that there is not
space, it then subtracts the estimate back out.

This may lead the subsequent svc_xprt_enqueue to decide that there is
space after all.

The results is a svc_recv() that will repeatedly return -EAGAIN, causing
server threads to loop without doing any actual work.

Reported-by: Michael Tokarev <mjt@tls.msk.ru>
Tested-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sunrpc/svc_xprt.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 314320a..0ab2fed 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -304,7 +304,6 @@ static void svc_thread_dequeue(struct svc_pool *pool, struct svc_rqst *rqstp)
  */
 void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
-	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp;
 	int cpu;
@@ -381,8 +380,6 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 				rqstp, rqstp->rq_xprt);
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 		rqstp->rq_waking = 1;
 		pool->sp_nwaking++;
 		pool->sp_stats.threads_woken++;
@@ -667,8 +664,6 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 	if (xprt) {
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	} else {
 		/* No data pending. Go to sleep */
 		svc_thread_enqueue(pool, rqstp);
@@ -758,6 +753,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 		} else
 			len = xprt->xpt_ops->xpo_recvfrom(rqstp);
 		dprintk("svc: got len=%d\n", len);
+		rqstp->rq_reserved = serv->sv_max_mesg;
+		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	}
 
 	/* No data, incomplete (TCP) read, or accept() */
-- 
1.7.2.1.45.g54fbc



