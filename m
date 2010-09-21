Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0IUVum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:50:42 -0400
Received: from shakespeare.ccsl.carleton.ca ([134.117.225.11]:37224 "EHLO
	shakespeare.ccsl.carleton.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756603Ab0IUVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:50:41 -0400
Message-Id: <E1Oy9vd-0001vO-Qw@shakespeare.ccsl.carleton.ca>
From: gwurster@scs.carleton.ca
Date: Tue, 21 Sep 2010 16:59:05 -0400
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 36cd6bd6ec6eae8eb7b6adabc0a0e73db791bc36 Mon Sep 17 00:00:00 2001
From: Glenn Wurster <gwurster@scs.carleton.ca>
Date: Tue, 21 Sep 2010 16:59:04 -0400
Subject: [PATCH 2.6.36-rc3 1/1] IPv6 BUG: Temp addresses are immediately deleted after being created.
Cc: "David S. Miller" <davem@davemloft.net>,
 Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
 "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
 James Morris <jmorris@namei.org>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Patrick McHardy <kaber@trash.net>,
 Stephen Hemminger <shemminger@vyatta.com>,
 Eric Dumazet <eric.dumazet@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org
X-Length: 2827
MIME-Version: 1.0
Content-Disposition: inline
X-UID: 9
Content-Transfer-Encoding: 7bit
Message-Id: <201009211659.05584.gwurster@scs.carleton.ca>

There is a bug in the interaction between ipv6_create_tempaddr and 
addrconf_verify.  Because ipv6_create_tempaddr uses the cstamp and tstamp 
from the public address in creating a private address, if we have not 
received a router advertisement in a while, tstamp + temp_valid_lft might be 
< now.  If this happens, the new address is created inside 
ipv6_create_tempaddr, then the loop within addrconf_verify starts again and 
the address is immediately deleted.  We are left with no temporary addresses 
on the interface, and no more will be created until the public IP address is 
updated.  To avoid this, set the expiry time to be the minimum of the time 
left on the public address or the config option PLUS the current age of the 
public interface.

Signed-off-by: Glenn Wurster <gwurster@scs.carleton.ca>
---
 net/ipv6/addrconf.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cfee6ae..9c74454 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -836,7 +836,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, 
struct inet6_ifaddr *i
 {
 	struct inet6_dev *idev = ifp->idev;
 	struct in6_addr addr, *tmpaddr;
-	unsigned long tmp_prefered_lft, tmp_valid_lft, tmp_cstamp, tmp_tstamp;
+	unsigned long tmp_prefered_lft, tmp_valid_lft, tmp_cstamp, tmp_tstamp, age;
 	unsigned long regen_advance;
 	int tmp_plen;
 	int ret = 0;
@@ -886,12 +886,13 @@ retry:
 		goto out;
 	}
 	memcpy(&addr.s6_addr[8], idev->rndid, 8);
+	age = (jiffies - ifp->tstamp) / HZ;
 	tmp_valid_lft = min_t(__u32,
 			      ifp->valid_lft,
-			      idev->cnf.temp_valid_lft);
+			      idev->cnf.temp_valid_lft + age);
 	tmp_prefered_lft = min_t(__u32,
 				 ifp->prefered_lft,
-				 idev->cnf.temp_prefered_lft -
+				 idev->cnf.temp_prefered_lft + age -
 				 idev->cnf.max_desync_factor);
 	tmp_plen = ifp->prefix_len;
 	max_addresses = idev->cnf.max_addresses;

