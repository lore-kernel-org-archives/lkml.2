Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2ACWei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:34:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2ACWee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:34:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:31 2012
Message-Id: <20120103223031.446447889@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ted Feng <artisdom@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [02/67] ipip, sit: copy parms.name after register_netdevice
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ted Feng <artisdom@gmail.com>

commit 72b36015ba43a3cca5303f5534d2c3e1899eae29 upstream.

Same fix as 731abb9cb2 for ipip and sit tunnel.
Commit 1c5cae815d removed an explicit call to dev_alloc_name in
ipip_tunnel_locate and ipip6_tunnel_locate, because register_netdevice
will now create a valid name, however the tunnel keeps a copy of the
name in the private parms structure. Fix this by copying the name back
after register_netdevice has successfully returned.

This shows up if you do a simple tunnel add, followed by a tunnel show:

$ sudo ip tunnel add mode ipip remote 10.2.20.211
$ ip tunnel
tunl0: ip/ip  remote any  local any  ttl inherit  nopmtudisc
tunl%d: ip/ip  remote 10.2.20.211  local any  ttl inherit
$ sudo ip tunnel add mode sit remote 10.2.20.212
$ ip tunnel
sit0: ipv6/ip  remote any  local any  ttl 64  nopmtudisc 6rd-prefix 2002::/16
sit%d: ioctl 89f8 failed: No such device
sit%d: ipv6/ip  remote 10.2.20.212  local any  ttl inherit

Signed-off-by: Ted Feng <artisdom@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ipip.c |    7 ++++++-
 net/ipv6/sit.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -285,6 +285,8 @@ static struct ip_tunnel * ipip_tunnel_lo
 	if (register_netdevice(dev) < 0)
 		goto failed_free;
 
+	strcpy(nt->parms.name, dev->name);
+
 	dev_hold(dev);
 	ipip_tunnel_link(ipn, nt);
 	return nt;
@@ -759,7 +761,6 @@ static int ipip_tunnel_init(struct net_d
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
 	tunnel->dev = dev;
-	strcpy(tunnel->parms.name, dev->name);
 
 	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
 	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
@@ -825,6 +826,7 @@ static void ipip_destroy_tunnels(struct
 static int __net_init ipip_init_net(struct net *net)
 {
 	struct ipip_net *ipn = net_generic(net, ipip_net_id);
+	struct ip_tunnel *t;
 	int err;
 
 	ipn->tunnels[0] = ipn->tunnels_wc;
@@ -848,6 +850,9 @@ static int __net_init ipip_init_net(stru
 	if ((err = register_netdev(ipn->fb_tunnel_dev)))
 		goto err_reg_dev;
 
+	t = netdev_priv(ipn->fb_tunnel_dev);
+
+	strcpy(t->parms.name, ipn->fb_tunnel_dev->name);
 	return 0;
 
 err_reg_dev:
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -263,6 +263,8 @@ static struct ip_tunnel *ipip6_tunnel_lo
 	if (register_netdevice(dev) < 0)
 		goto failed_free;
 
+	strcpy(nt->parms.name, dev->name);
+
 	dev_hold(dev);
 
 	ipip6_tunnel_link(sitn, nt);
@@ -1141,7 +1143,6 @@ static int ipip6_tunnel_init(struct net_
 	struct ip_tunnel *tunnel = netdev_priv(dev);
 
 	tunnel->dev = dev;
-	strcpy(tunnel->parms.name, dev->name);
 
 	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
 	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
@@ -1204,6 +1205,7 @@ static void __net_exit sit_destroy_tunne
 static int __net_init sit_init_net(struct net *net)
 {
 	struct sit_net *sitn = net_generic(net, sit_net_id);
+	struct ip_tunnel *t;
 	int err;
 
 	sitn->tunnels[0] = sitn->tunnels_wc;
@@ -1228,6 +1230,9 @@ static int __net_init sit_init_net(struc
 	if ((err = register_netdev(sitn->fb_tunnel_dev)))
 		goto err_reg_dev;
 
+	t = netdev_priv(sitn->fb_tunnel_dev);
+
+	strcpy(t->parms.name, sitn->fb_tunnel_dev->name);
 	return 0;
 
 err_reg_dev:


