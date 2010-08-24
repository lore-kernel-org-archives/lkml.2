Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0HXOjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:39:55 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59427 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0HXOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:39:51 -0400
Date: Tue, 24 Aug 2010 16:39:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] net/netfilter/ipvs: Eliminate memory leak
Message-ID: <Pine.LNX.4.64.1008241639300.15172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

__ip_vs_service_get and __ip_vs_svc_fwm_get increment a reference count, so
that reference count should be decremented before leaving the function in an
error case.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = __ip_vs_service_get(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0f0c079..f98169b 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2155,7 +2155,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	if (cmd != IP_VS_SO_SET_ADD
 	    && (svc == NULL || svc->protocol != usvc.protocol)) {
 		ret = -ESRCH;
-		goto out_unlock;
+		goto out_drop_service;
 	}
 
 	switch (cmd) {
@@ -2189,6 +2189,7 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		ret = -EINVAL;
 	}
 
+out_drop_service:
 	if (svc)
 		ip_vs_service_put(svc);
 
