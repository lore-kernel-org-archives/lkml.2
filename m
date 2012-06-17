Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2FQSZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:25:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50402 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612Ab2FQSXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:23:03 -0400
Message-Id: <20120617175944.182051758@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 20/69] NFSv4.1: Fix a request leak on the back channel
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b3b02ae5865c2dcd506322e0fc6def59a042e72f upstream.

If the call to svc_process_common() fails, then the request
needs to be freed before we can exit bc_svc_process.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 017c011..074df5a 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1377,7 +1377,8 @@ bc_svc_process(struct svc_serv *serv, struct rpc_rqst *req,
 						sizeof(req->rq_snd_buf));
 		return bc_send(req);
 	} else {
-		/* Nothing to do to drop request */
+		/* drop request */
+		xprt_free_bc_request(req);
 		return 0;
 	}
 }


