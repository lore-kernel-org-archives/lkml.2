Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab0J1UAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:00:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37658
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948Ab0J1UAC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:00:02 -0400
Date: Thu, 28 Oct 2010 13:00:25 -0700 (PDT)
Message-Id: <20101028.130025.102564000.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: bazsi@balabit.hu, hidden@balabit.hu, kaber@trash.net,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: tproxy: added IPv6 support to the socket match
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
References: <201010231923.o9NJNK9U013494@hera.kernel.org>
	<AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 28 Oct 2010 20:51:43 +0200

>> +       u8 tproto;
> 
> tproto is unsigned...
> 
>> +       const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
>> +
>> +       tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);
> 
> but ipv6_find_hdr() returns int, and negative values for errors...

Thanks Geert, I'll fix it like so:

--------------------
netfilter: xt_socket: Make tproto signed in socket_mt6_v1().

Otherwise error indications from ipv6_find_hdr() won't be noticed.

This required making the protocol argument to extract_icmp6_fields()
signed too.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/netfilter/xt_socket.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index d94a858..00d6ae8 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -195,7 +195,7 @@ socket_mt4_v1(const struct sk_buff *skb, struct xt_action_param *par)
 static int
 extract_icmp6_fields(const struct sk_buff *skb,
 		     unsigned int outside_hdrlen,
-		     u8 *protocol,
+		     int *protocol,
 		     struct in6_addr **raddr,
 		     struct in6_addr **laddr,
 		     __be16 *rport,
@@ -252,8 +252,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
 	struct sock *sk;
 	struct in6_addr *daddr, *saddr;
 	__be16 dport, sport;
-	int thoff;
-	u8 tproto;
+	int thoff, tproto;
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
 
 	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);
@@ -305,7 +304,7 @@ socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
 			sk = NULL;
 	}
 
-	pr_debug("proto %hhu %pI6:%hu -> %pI6:%hu "
+	pr_debug("proto %hhd %pI6:%hu -> %pI6:%hu "
 		 "(orig %pI6:%hu) sock %p\n",
 		 tproto, saddr, ntohs(sport),
 		 daddr, ntohs(dport),
-- 
1.7.3.2

