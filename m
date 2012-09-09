Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab2IIXQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51289 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048Ab2IIXQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:33 -0400
Message-Id: <20120909224200.004195670@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: [ 68/95] svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svc_xprt.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 0d693a8..bac973a 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -316,7 +316,6 @@ static bool svc_xprt_has_something_to_do(struct svc_xprt *xprt)
  */
 void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
-	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp;
 	int cpu;
@@ -362,8 +361,6 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 				rqstp, rqstp->rq_xprt);
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 		pool->sp_stats.threads_woken++;
 		wake_up(&rqstp->rq_wait);
 	} else {
@@ -640,8 +637,6 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 	if (xprt) {
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 
 		/* As there is a shortage of threads and this request
 		 * had to be queued, don't allow the thread to wait so
@@ -738,6 +733,8 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 		else
 			len = xprt->xpt_ops->xpo_recvfrom(rqstp);
 		dprintk("svc: got len=%d\n", len);
+		rqstp->rq_reserved = serv->sv_max_mesg;
+		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	}
 	svc_xprt_received(xprt);
 


