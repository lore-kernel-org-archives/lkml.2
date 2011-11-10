Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1KJKeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:34:24 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34372 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab1KJKeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:34:22 -0500
Subject: [PATCH] SUNRPC: destroy freshly allocated transport in case of
	sockaddr init error
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Thu, 10 Nov 2011 14:33:23 +0300
Message-ID: <20111110103323.14486.24233.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we will leak xprt structure and struct net reference.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 net/sunrpc/xprtsock.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index d7f97ef..2d78d95 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2530,8 +2530,10 @@ static struct rpc_xprt *xs_setup_xprt(struct xprt_create *args,
 		int err;
 		err = xs_init_anyaddr(args->dstaddr->sa_family,
 					(struct sockaddr *)&new->srcaddr);
-		if (err != 0)
+		if (err != 0) {
+			xprt_free(xprt);
 			return ERR_PTR(err);
+		}
 	}
 
 	return xprt;

