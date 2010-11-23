Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KWNjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:39:41 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53593 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0KWNjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:39:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tG39dURypKWnJ0J3yW7OjPUwOaohM4qhmv2Q49/DqRd9Z0mM0ygUqqwB/dyAV74/OR
         assh7OQdr8mTsN+YKinQOP8J5x9C6C7spPmt4eGj5InrGzzlSqeOoG40BU5GWRCyhNx4
         FJCTYVGyT8iiq2n88xnFrcwiQB08aGMZncUiI=
Date: Tue, 23 Nov 2010 15:40:04 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: addrconf: refcnt with  IPV6_PRIVACY enabled
Message-ID: <20101123134003.GB4142@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've sent a patch http://lkml.org/lkml/2010/11/21/124 
"[PATCH] ipv6: fix inet6_dev refcnt with IPV6_PRIVACY enabled" related
to wrong in6_dev refcnt value when IPV6_PRIVACY enabled.

I've took a second look, and question arised - 
Is it actually necessary to in6_dev_hold/in6_dev_put in ipv6_regen_rndid?
In ipv6_regen_rndid we call in6_dev_hold only when mod_timer == 0,
and always in6_dev_put. 


I've removed check for < 0 and goto from __ipv6_regen_rndid call, since it 
always return 0.


Please, kindly review V2.

---

 net/ipv6/addrconf.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2fc35b3..8187d14 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -425,7 +425,6 @@ static struct inet6_dev * ipv6_add_dev(struct net_device *dev)
 		       dev->name);
 		ndev->cnf.use_tempaddr = -1;
 	} else {
-		in6_dev_hold(ndev);
 		ipv6_regen_rndid((unsigned long) ndev);
 	}
 #endif
@@ -1653,8 +1652,7 @@ static void ipv6_regen_rndid(unsigned long data)
 	if (idev->dead)
 		goto out;
 
-	if (__ipv6_regen_rndid(idev) < 0)
-		goto out;
+	__ipv6_regen_rndid(idev);
 
 	expires = jiffies +
 		idev->cnf.temp_prefered_lft * HZ -
@@ -1667,13 +1665,11 @@ static void ipv6_regen_rndid(unsigned long data)
 		goto out;
 	}
 
-	if (!mod_timer(&idev->regen_timer, expires))
-		in6_dev_hold(idev);
-
+	mod_timer(&idev->regen_timer, expires);
+	
 out:
 	write_unlock_bh(&idev->lock);
 	rcu_read_unlock_bh();
-	in6_dev_put(idev);
 }
 
 static int __ipv6_try_regen_rndid(struct inet6_dev *idev, struct in6_addr *tmpaddr) {

