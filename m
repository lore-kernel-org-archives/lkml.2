Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2ILXoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:44:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2ILXoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Michael Tokarev <mjt@tls.msk.ru>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 21/46] svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
Date: Wed, 12 Sep 2012 16:39:11 -0700
Message-Id: <20120912233819.885242313@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svc_xprt.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -323,7 +323,6 @@ static bool svc_xprt_has_something_to_do
  */
 void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
-	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp;
 	int cpu;
@@ -369,8 +368,6 @@ void svc_xprt_enqueue(struct svc_xprt *x
 				rqstp, rqstp->rq_xprt);
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 		pool->sp_stats.threads_woken++;
 		wake_up(&rqstp->rq_wait);
 	} else {
@@ -650,8 +647,6 @@ int svc_recv(struct svc_rqst *rqstp, lon
 	if (xprt) {
 		rqstp->rq_xprt = xprt;
 		svc_xprt_get(xprt);
-		rqstp->rq_reserved = serv->sv_max_mesg;
-		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 
 		/* As there is a shortage of threads and this request
 		 * had to be queued, don't allow the thread to wait so
@@ -748,6 +743,8 @@ int svc_recv(struct svc_rqst *rqstp, lon
 		else
 			len = xprt->xpt_ops->xpo_recvfrom(rqstp);
 		dprintk("svc: got len=%d\n", len);
+		rqstp->rq_reserved = serv->sv_max_mesg;
+		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
 	}
 	svc_xprt_received(xprt);
 


