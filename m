Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2JZAOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:14:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:53975 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab2JZAIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [ 75/85] ipv4: make sure nh_pcpu_rth_output is always allocated
Date: Thu, 25 Oct 2012 17:06:33 -0700
Message-Id: <20121026000038.647177176@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit f8a17175c63fd3e8b573719f7538816f8c96abf4 ]

Avoid checking nh_pcpu_rth_output in fast path,
abort fib_info creation on alloc_percpu failure.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    2 ++
 net/ipv4/route.c         |    3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -840,6 +840,8 @@ struct fib_info *fib_create_info(struct
 	change_nexthops(fi) {
 		nexthop_nh->nh_parent = fi;
 		nexthop_nh->nh_pcpu_rth_output = alloc_percpu(struct rtable __rcu *);
+		if (!nexthop_nh->nh_pcpu_rth_output)
+			goto failure;
 	} endfor_nexthops(fi)
 
 	if (cfg->fc_mx) {
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1210,8 +1210,6 @@ static bool rt_cache_route(struct fib_nh
 	if (rt_is_input_route(rt)) {
 		p = (struct rtable **)&nh->nh_rth_input;
 	} else {
-		if (!nh->nh_pcpu_rth_output)
-			goto nocache;
 		p = (struct rtable **)__this_cpu_ptr(nh->nh_pcpu_rth_output);
 	}
 	orig = *p;
@@ -1226,7 +1224,6 @@ static bool rt_cache_route(struct fib_nh
 		 * unsuccessful at storing this route into the cache
 		 * we really need to set it.
 		 */
-nocache:
 		rt->dst.flags |= DST_NOCACHE;
 		ret = false;
 	}


