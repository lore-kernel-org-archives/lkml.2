Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab0I0RKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:10:42 -0400
Received: from shakespeare.ccsl.carleton.ca ([134.117.225.11]:56148 "EHLO
	shakespeare.ccsl.carleton.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757041Ab0I0RKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:10:41 -0400
Date: Mon, 27 Sep 2010 13:10:10 -0400
From: Glenn Wurster <gwurster@scs.carleton.ca>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH linux-2.6 v2] IPv6: Temp addresses are immediately deleted.
Message-ID: <20100927171010.GB7106@adams.ccsl.carleton.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TUID: c0de4ddd34f07db9
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Version 2, now with 100% fewer line wraps.  Thanks to David Miller for
pointing out the line wrapping issue.

Signed-off-by: Glenn Wurster <gwurster@scs.carleton.ca>
---
 net/ipv6/addrconf.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cfee6ae..9c74454 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -836,7 +836,7 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, struct inet6_ifaddr *i
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
-- 
1.5.6.5

