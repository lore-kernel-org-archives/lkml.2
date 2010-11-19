Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0KSV7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:01 -0500
Received: from kroah.org ([198.145.64.141]:45305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab0KSV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:57 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.836075327@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ursula Braun <ursula.braun@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [62/82] ipv6: fix refcnt problem related to POSTDAD state
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Ursula Braun <ursula.braun@de.ibm.com>

[ Upstream commit 801715f95be37b865af83b9909ad93da141a9306 ]

After running this bonding setup script
    modprobe bonding miimon=100 mode=0 max_bonds=1
    ifconfig bond0 10.1.1.1/16
    ifenslave bond0 eth1
    ifenslave bond0 eth3
on s390 with qeth-driven slaves, modprobe -r fails with this message
    unregister_netdevice: waiting for bond0 to become free. Usage count = 1
due to twice detection of duplicate address.
Problem is caused by a missing decrease of ifp->refcnt in addrconf_dad_failure.
An extra call of in6_ifa_put(ifp) solves it.
Problem has been introduced with commit f2344a131bccdbfc5338e17fa71a807dee7944fa.

Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/addrconf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1424,8 +1424,10 @@ void addrconf_dad_failure(struct inet6_i
 {
 	struct inet6_dev *idev = ifp->idev;
 
-	if (addrconf_dad_end(ifp))
+	if (addrconf_dad_end(ifp)) {
+		in6_ifa_put(ifp);
 		return;
+	}
 
 	if (net_ratelimit())
 		printk(KERN_INFO "%s: IPv6 duplicate address %pI6c detected!\n",


