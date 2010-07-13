Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0GMKXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab0GMKW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:22:59 -0400
Date: Tue, 13 Jul 2010 06:22:29 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc: riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        lwang@redhat.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
        davem@davemloft.net
Message-Id: <20100713102228.2835.64815.sendpatchset@danny.redhat>
In-Reply-To: <20100713101650.2835.15245.sendpatchset@danny.redhat>
References: <20100713101650.2835.15245.sendpatchset@danny.redhat>
Subject: [PATCH -mmotm 30/30] fix mess up on swap with multi files from same nfs server
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From fd03848cadf5719228f617b72039cc8302d892ef Mon Sep 17 00:00:00 2001
From: Xiaotian Feng <dfeng@redhat.com>
Date: Tue, 13 Jul 2010 14:00:02 +0800
Subject: [PATCH 30/30] fix mess up on swap with multi files from same nfs server

xs_swapper() will set xprt->swapper when swapon nfs files, unset xprt->swapper
when swapoff nfs files. This will lead a bug if we swapon multi files from
the same nfs server, they had the same xprt, then the reserved memory could
not be disconnected when we swapoff all files.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 include/linux/sunrpc/xprt.h |    4 ++--
 net/sunrpc/xprtsock.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index ba2330d..bc49091 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -171,8 +171,8 @@ struct rpc_xprt {
 	unsigned int		max_reqs;	/* total slots */
 	unsigned long		state;		/* transport state */
 	unsigned char		shutdown   : 1,	/* being shut down */
-				resvport   : 1, /* use a reserved port */
-				swapper    : 1; /* we're swapping over this
+				resvport   : 1;	/* use a reserved port */
+	unsigned int		swapper;	/* we're swapping over this
 						   transport */
 	unsigned int		bind_index;	/* bind function index */
 
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 5c8b918..30bb8ce 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1662,11 +1662,11 @@ int xs_swapper(struct rpc_xprt *xprt, int enable)
 		 */
 		err = sk_adjust_memalloc(1, RPC_RESERVE_PAGES);
 		if (!err) {
-			xprt->swapper = 1;
+			xprt->swapper++;
 			xs_set_memalloc(xprt);
 		}
 	} else if (xprt->swapper) {
-		xprt->swapper = 0;
+		xprt->swapper--;
 		sk_clear_memalloc(transport->inet);
 		sk_adjust_memalloc(-1, -RPC_RESERVE_PAGES);
 	}
-- 
1.7.1.1

