Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2ACWmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:42:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2ACWmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:42:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:26 2012
Message-Id: <20120103223326.791344797@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Steffen Klassert <steffen.klassert@secunet.com>,
        =?UTF-8?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [68/75] net: Add a flow_cache_flush_deferred function
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit c0ed1c14a72ca9ebacd51fb94a8aca488b0d361e ]

flow_cach_flush() might sleep but can be called from
atomic context via the xfrm garbage collector. So add
a flow_cache_flush_deferred() function and use this if
the xfrm garbage colector is invoked from within the
packet path.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Acked-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/net/flow.h     |    1 +
 net/core/flow.c        |   12 ++++++++++++
 net/xfrm/xfrm_policy.c |   18 ++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -207,6 +207,7 @@ extern struct flow_cache_object *flow_ca
 		u8 dir, flow_resolve_t resolver, void *ctx);
 
 extern void flow_cache_flush(void);
+extern void flow_cache_flush_deferred(void);
 extern atomic_t flow_cache_genid;
 
 #endif
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -358,6 +358,18 @@ void flow_cache_flush(void)
 	put_online_cpus();
 }
 
+static void flow_cache_flush_task(struct work_struct *work)
+{
+	flow_cache_flush();
+}
+
+static DECLARE_WORK(flow_cache_flush_work, flow_cache_flush_task);
+
+void flow_cache_flush_deferred(void)
+{
+	schedule_work(&flow_cache_flush_work);
+}
+
 static int __cpuinit flow_cache_cpu_prepare(struct flow_cache *fc, int cpu)
 {
 	struct flow_cache_percpu *fcp = per_cpu_ptr(fc->percpu, cpu);
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2276,8 +2276,6 @@ static void __xfrm_garbage_collect(struc
 {
 	struct dst_entry *head, *next;
 
-	flow_cache_flush();
-
 	spin_lock_bh(&xfrm_policy_sk_bundle_lock);
 	head = xfrm_policy_sk_bundles;
 	xfrm_policy_sk_bundles = NULL;
@@ -2290,6 +2288,18 @@ static void __xfrm_garbage_collect(struc
 	}
 }
 
+static void xfrm_garbage_collect(struct net *net)
+{
+	flow_cache_flush();
+	__xfrm_garbage_collect(net);
+}
+
+static void xfrm_garbage_collect_deferred(struct net *net)
+{
+	flow_cache_flush_deferred();
+	__xfrm_garbage_collect(net);
+}
+
 static void xfrm_init_pmtu(struct dst_entry *dst)
 {
 	do {
@@ -2420,7 +2430,7 @@ int xfrm_policy_register_afinfo(struct x
 		if (likely(dst_ops->neigh_lookup == NULL))
 			dst_ops->neigh_lookup = xfrm_neigh_lookup;
 		if (likely(afinfo->garbage_collect == NULL))
-			afinfo->garbage_collect = __xfrm_garbage_collect;
+			afinfo->garbage_collect = xfrm_garbage_collect_deferred;
 		xfrm_policy_afinfo[afinfo->family] = afinfo;
 	}
 	write_unlock_bh(&xfrm_policy_afinfo_lock);
@@ -2514,7 +2524,7 @@ static int xfrm_dev_event(struct notifie
 
 	switch (event) {
 	case NETDEV_DOWN:
-		__xfrm_garbage_collect(dev_net(dev));
+		xfrm_garbage_collect(dev_net(dev));
 	}
 	return NOTIFY_DONE;
 }


