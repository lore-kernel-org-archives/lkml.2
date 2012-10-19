Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2JSDRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:17:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:54545 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964969Ab2JSDRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:17:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: [ 20/37] ipvs: fix oops in ip_vs_dst_event on rmmod
Date: Thu, 18 Oct 2012 20:16:43 -0700
Message-Id: <20121019031306.102504876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019031302.789593147@linuxfoundation.org>
References: <20121019031302.789593147@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 283283c4da91adc44b03519f434ee1e7e91d6fdb upstream.

	After commit 39f618b4fd95ae243d940ec64c961009c74e3333 (3.4)
"ipvs: reset ipvs pointer in netns" we can oops in
ip_vs_dst_event on rmmod ip_vs because ip_vs_control_cleanup
is called after the ipvs_core_ops subsys is unregistered and
net->ipvs is NULL. Fix it by exiting early from ip_vs_dst_event
if ipvs is NULL. It is safe because all services and dests
for the net are already freed.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1520,11 +1520,12 @@ static int ip_vs_dst_event(struct notifi
 {
 	struct net_device *dev = ptr;
 	struct net *net = dev_net(dev);
+	struct netns_ipvs *ipvs = net_ipvs(net);
 	struct ip_vs_service *svc;
 	struct ip_vs_dest *dest;
 	unsigned int idx;
 
-	if (event != NETDEV_UNREGISTER)
+	if (event != NETDEV_UNREGISTER || !ipvs)
 		return NOTIFY_DONE;
 	IP_VS_DBG(3, "%s() dev=%s\n", __func__, dev->name);
 	EnterFunction(2);
@@ -1550,7 +1551,7 @@ static int ip_vs_dst_event(struct notifi
 		}
 	}
 
-	list_for_each_entry(dest, &net_ipvs(net)->dest_trash, n_list) {
+	list_for_each_entry(dest, &ipvs->dest_trash, n_list) {
 		__ip_vs_dev_reset(dest, dev);
 	}
 	mutex_unlock(&__ip_vs_mutex);


