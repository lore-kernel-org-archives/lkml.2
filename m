Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2IIX1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:27:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51327 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082Ab2IIXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:37 -0400
Message-Id: <20120909224159.874363167@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>,
        Malahal Naineni <malahal@us.ibm.com>
Subject: [ 67/95] svcrpc: sends on closed socket should stop immediately
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svc_xprt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 88f2bf6..0d693a8 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -794,7 +794,8 @@ int svc_send(struct svc_rqst *rqstp)
 
 	/* Grab mutex to serialize outgoing data. */
 	mutex_lock(&xprt->xpt_mutex);
-	if (test_bit(XPT_DEAD, &xprt->xpt_flags))
+	if (test_bit(XPT_DEAD, &xprt->xpt_flags)
+			|| test_bit(XPT_CLOSE, &xprt->xpt_flags))
 		len = -ENOTCONN;
 	else
 		len = xprt->xpt_ops->xpo_sendto(rqstp);


