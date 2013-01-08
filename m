Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3AHXgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:55 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53557 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3AHXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 25/77] SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared
Date: Tue, 8 Jan 2013 18:35:04 -0500
Message-ID: <1357688156-25387-26-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 24ca9a847791fd53d9b217330b15f3c285827a18 upstream.

By returning '0' instead of 'EAGAIN' when the tests in xs_nospace() fail
to find evidence of socket congestion, we are making the RPC engine believe
that the message was incorrectly sent and so it disconnects the socket
instead of just retrying.

The bug appears to have been introduced by commit
5e3771ce2d6a69e10fcc870cdf226d121d868491 (SUNRPC: Ensure that xs_nospace
return values are propagated).

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sunrpc/xprtsock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b502700..fc5b9f3 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -478,7 +478,7 @@ static int xs_nospace(struct rpc_task *task)
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
-	int ret = 0;
+	int ret = -EAGAIN;
 
 	dprintk("RPC: %5u xmit incomplete (%u left of %u)\n",
 			task->tk_pid, req->rq_slen - req->rq_bytes_sent,
@@ -490,7 +490,6 @@ static int xs_nospace(struct rpc_task *task)
 	/* Don't race with disconnect */
 	if (xprt_connected(xprt)) {
 		if (test_bit(SOCK_ASYNC_NOSPACE, &transport->sock->flags)) {
-			ret = -EAGAIN;
 			/*
 			 * Notify TCP that we're limited by the application
 			 * window size
-- 
1.7.12.1

