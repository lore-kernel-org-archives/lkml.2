Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1HFAJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:09:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab1HFAJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:09:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:53 2011
Message-Id: <20110806000253.697217252@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [48/55] tunnels: fix netns vs proto registration ordering
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit d5aa407f59f5b83d2c50ec88f5bf56d40f1f8978 upstream.

Same stuff as in ip_gre patch: receive hook can be called before netns
setup is done, oopsing in net_generic().

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipip.c         |   13 ++++++-------
 net/ipv6/ip6_tunnel.c   |   28 +++++++++++++++-------------
 net/ipv6/sit.c          |   13 ++++++-------
 net/ipv6/xfrm6_tunnel.c |   22 +++++++++++-----------
 4 files changed, 38 insertions(+), 38 deletions(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -830,15 +830,14 @@ static int __init ipip_init(void)
 
 	printk(banner);
 
-	if (xfrm4_tunnel_register(&ipip_handler, AF_INET)) {
+	err = register_pernet_gen_device(&ipip_net_id, &ipip_net_ops);
+	if (err < 0)
+		return err;
+	err = xfrm4_tunnel_register(&ipip_handler, AF_INET);
+	if (err < 0) {
+		unregister_pernet_device(&ipip_net_ops);
 		printk(KERN_INFO "ipip init: can't register tunnel\n");
-		return -EAGAIN;
 	}
-
-	err = register_pernet_gen_device(&ipip_net_id, &ipip_net_ops);
-	if (err)
-		xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
-
 	return err;
 }
 
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1466,27 +1466,29 @@ static int __init ip6_tunnel_init(void)
 {
 	int  err;
 
-	if (xfrm6_tunnel_register(&ip4ip6_handler, AF_INET)) {
+	err = register_pernet_device(&ip6_tnl_net_ops);
+	if (err < 0)
+		goto out_pernet;
+
+	err = xfrm6_tunnel_register(&ip4ip6_handler, AF_INET);
+	if (err < 0) {
 		printk(KERN_ERR "ip6_tunnel init: can't register ip4ip6\n");
-		err = -EAGAIN;
-		goto out;
+		goto out_ip4ip6;
 	}
 
-	if (xfrm6_tunnel_register(&ip6ip6_handler, AF_INET6)) {
+	err = xfrm6_tunnel_register(&ip6ip6_handler, AF_INET6);
+	if (err < 0) {
 		printk(KERN_ERR "ip6_tunnel init: can't register ip6ip6\n");
-		err = -EAGAIN;
-		goto unreg_ip4ip6;
+		goto out_ip6ip6;
 	}
 
-	err = register_pernet_gen_device(&ip6_tnl_net_id, &ip6_tnl_net_ops);
-	if (err < 0)
-		goto err_pernet;
 	return 0;
-err_pernet:
-	xfrm6_tunnel_deregister(&ip6ip6_handler, AF_INET6);
-unreg_ip4ip6:
+
+out_ip6ip6:
 	xfrm6_tunnel_deregister(&ip4ip6_handler, AF_INET);
-out:
+out_ip4ip6:
+	unregister_pernet_device(&ip6_tnl_net_ops);
+out_pernet:
 	return err;
 }
 
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1086,15 +1086,14 @@ static int __init sit_init(void)
 
 	printk(KERN_INFO "IPv6 over IPv4 tunneling driver\n");
 
-	if (xfrm4_tunnel_register(&sit_handler, AF_INET6) < 0) {
-		printk(KERN_INFO "sit init: Can't add protocol\n");
-		return -EAGAIN;
-	}
-
 	err = register_pernet_gen_device(&sit_net_id, &sit_net_ops);
 	if (err < 0)
-		xfrm4_tunnel_deregister(&sit_handler, AF_INET6);
-
+		return err;
+	err = xfrm4_tunnel_register(&sit_handler, AF_INET6);
+	if (err < 0) {
+		unregister_pernet_device(&sit_net_ops);
+		printk(KERN_INFO "sit init: Can't add protocol\n");
+	}
 	return err;
 }
 
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -346,36 +346,36 @@ static int __init xfrm6_tunnel_init(void
 {
 	int rv;
 
-	rv = xfrm_register_type(&xfrm6_tunnel_type, AF_INET6);
+	rv = xfrm6_tunnel_spi_init();
 	if (rv < 0)
 		goto err;
+	rv = xfrm_register_type(&xfrm6_tunnel_type, AF_INET6);
+	if (rv < 0)
+		goto out_type;
 	rv = xfrm6_tunnel_register(&xfrm6_tunnel_handler, AF_INET6);
 	if (rv < 0)
-		goto unreg;
+		goto out_xfrm6;
 	rv = xfrm6_tunnel_register(&xfrm46_tunnel_handler, AF_INET);
 	if (rv < 0)
-		goto dereg6;
-	rv = xfrm6_tunnel_spi_init();
-	if (rv < 0)
-		goto dereg46;
+		goto out_xfrm46;
 	return 0;
 
-dereg46:
-	xfrm6_tunnel_deregister(&xfrm46_tunnel_handler, AF_INET);
-dereg6:
+out_xfrm46:
 	xfrm6_tunnel_deregister(&xfrm6_tunnel_handler, AF_INET6);
-unreg:
+out_xfrm6:
 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
+out_type:
+	xfrm6_tunnel_spi_fini();
 err:
 	return rv;
 }
 
 static void __exit xfrm6_tunnel_fini(void)
 {
-	xfrm6_tunnel_spi_fini();
 	xfrm6_tunnel_deregister(&xfrm46_tunnel_handler, AF_INET);
 	xfrm6_tunnel_deregister(&xfrm6_tunnel_handler, AF_INET6);
 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
+	xfrm6_tunnel_spi_fini();
 }
 
 module_init(xfrm6_tunnel_init);


