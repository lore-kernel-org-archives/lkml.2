Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab1D0XU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:20:57 -0400
Received: from mx2.proofpoint.com ([208.86.202.10]:10530 "EHLO
	mx2.proofpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab1D0XUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:20:55 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 19:20:55 EDT
Date: Wed, 27 Apr 2011 16:12:38 -0700
Message-Id: <201104272312.p3RNCcl6002068@jgmyers-vm1.eng.proofpoint.com>
From: John Myers <jgmyers@proofpoint.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: fix incorrect unregistration of sysctl when last ip deleted
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-04-27_08:2011-04-27,2011-04-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1104270166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the last ip address is deleted, the kernel disables IPv6 on the
interface. (Not sure why, but that's beside the point.) The call that
does this is over-aggressive--it indicates the interface is about to
be removed even though that isn't necessarily so.

This causes IPv6 to, among other things, unregister its sysctl
parameters for the interface. Thus, the "accept_ra" and "addrconf"
settings can't be set on the interface until after the interface has
been brought back up, which is too late.

Signed-off-by: John Gardiner Myers <jgmyers@proofpoint.com>
Cc: stable@kernel.org

---

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1493534..042d0aa 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2215,7 +2215,7 @@ static int inet6_addr_del(struct net *net, int ifindex, struct in6_addr *pfx,
 			   disable IPv6 on this interface.
 			 */
 			if (list_empty(&idev->addr_list))
-				addrconf_ifdown(idev->dev, 1);
+				addrconf_ifdown(idev->dev, 0);
 			return 0;
 		}
 	}
