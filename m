Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab0JVSjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:39:11 -0400
Received: from kroah.org ([198.145.64.141]:45901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab0JVSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:08 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:01 2010
Message-Id: <20101022183601.910822183@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?R=C3=A9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [64/66] Phonet: disable network namespace support
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

[Solved differently upstream]

Network namespace in the Phonet socket stack causes an OOPS when a
namespace is destroyed. This occurs as the loopback exit_net handler is
called after the Phonet exit_net handler, and re-enters the Phonet
stack. I cannot think of any nice way to fix this in kernel <= 2.6.32.

For lack of a better solution, disable namespace support completely.
If you need that, upgrade to a newer kernel.

Signed-off-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Acked-by: David S. Miller <davem@davemloft.net>

---
 net/phonet/af_phonet.c  |    4 ++++
 net/phonet/pn_dev.c     |   12 ++++++++++--
 net/phonet/pn_netlink.c |    9 ++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -67,6 +67,8 @@ static int pn_socket_create(struct net *
 	struct phonet_protocol *pnp;
 	int err;
 
+	if (!net_eq(net, &init_net))
+		return -EAFNOSUPPORT;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -353,6 +355,8 @@ static int phonet_rcv(struct sk_buff *sk
 	struct sockaddr_pn sa;
 	u16 len;
 
+	if (!net_eq(net, &init_net))
+		goto out;
 	/* check we have at least a full Phonet header */
 	if (!pskb_pull(skb, sizeof(struct phonethdr)))
 		goto out;
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -246,7 +246,11 @@ static struct notifier_block phonet_devi
 /* Per-namespace Phonet devices handling */
 static int phonet_init_net(struct net *net)
 {
-	struct phonet_net *pnn = kmalloc(sizeof(*pnn), GFP_KERNEL);
+	struct phonet_net *pnn;
+
+	if (!net_eq(net, &init_net))
+		return 0;
+	pnn = kmalloc(sizeof(*pnn), GFP_KERNEL);
 	if (!pnn)
 		return -ENOMEM;
 
@@ -263,9 +267,13 @@ static int phonet_init_net(struct net *n
 
 static void phonet_exit_net(struct net *net)
 {
-	struct phonet_net *pnn = net_generic(net, phonet_net_id);
+	struct phonet_net *pnn;
 	struct net_device *dev;
 
+	if (!net_eq(net, &init_net))
+		return;
+	pnn = net_generic(net, phonet_net_id);
+
 	rtnl_lock();
 	for_each_netdev(net, dev)
 		phonet_device_destroy(dev);
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -68,6 +68,8 @@ static int addr_doit(struct sk_buff *skb
 	int err;
 	u8 pnaddr;
 
+	if (!net_eq(net, &init_net))
+		return -EOPNOTSUPP;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -124,12 +126,16 @@ nla_put_failure:
 
 static int getaddr_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct net *net = sock_net(skb->sk);
 	struct phonet_device_list *pndevs;
 	struct phonet_device *pnd;
 	int dev_idx = 0, dev_start_idx = cb->args[0];
 	int addr_idx = 0, addr_start_idx = cb->args[1];
 
-	pndevs = phonet_device_list(sock_net(skb->sk));
+	if (!net_eq(net, &init_net))
+		goto skip;
+
+	pndevs = phonet_device_list(net);
 	spin_lock_bh(&pndevs->lock);
 	list_for_each_entry(pnd, &pndevs->list, list) {
 		u8 addr;
@@ -154,6 +160,7 @@ static int getaddr_dumpit(struct sk_buff
 
 out:
 	spin_unlock_bh(&pndevs->lock);
+skip:
 	cb->args[0] = dev_idx;
 	cb->args[1] = addr_idx;
 


