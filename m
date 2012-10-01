Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab2JAXTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:19:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35421 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993Ab2JAXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:43 -0400
Message-Id: <20121001225203.206503826@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 132/180] svcrpc: sends on closed socket should stop immediately
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

commit f06f00a24d76e168ecb38d352126fd203937b601 upstream.

svc_tcp_sendto sets XPT_CLOSE if we fail to transmit the entire reply.
However, the XPT_CLOSE won't be acted on immediately.  Meanwhile other
threads could send further replies before the socket is really shut
down.  This can manifest as data corruption: for example, if a truncated
read reply is followed by another rpc reply, that second reply will look
to the client like further read data.

Symptoms were data corruption preceded by svc_tcp_sendto logging
something like

	kernel: rpc-srv/tcp: nfsd: sent only 963696 when sending 1048708 bytes - shutting down socket

Reported-by: Malahal Naineni <malahal@us.ibm.com>
Tested-by: Malahal Naineni <malahal@us.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sunrpc/svc_xprt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 0ab2fed..8d72660 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -808,7 +808,8 @@ int svc_send(struct svc_rqst *rqstp)
 
 	/* Grab mutex to serialize outgoing data. */
 	mutex_lock(&xprt->xpt_mutex);
-	if (test_bit(XPT_DEAD, &xprt->xpt_flags))
+	if (test_bit(XPT_DEAD, &xprt->xpt_flags)
+			|| test_bit(XPT_CLOSE, &xprt->xpt_flags))
 		len = -ENOTCONN;
 	else
 		len = xprt->xpt_ops->xpo_sendto(rqstp);
-- 
1.7.2.1.45.g54fbc



