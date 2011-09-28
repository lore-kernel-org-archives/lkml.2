Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1I1Ks6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:48:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1I1Ks4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:48:56 -0400
Message-ID: <4E82FC4E.5010101@redhat.com>
Date: Wed, 28 Sep 2011 18:51:58 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110126 Red Hat/3.1.8-1.el6 Thunderbird/3.1.8
MIME-Version: 1.0
To: netdev@vger.kernel.org, eric.dumazet@gmail.com,
        "David S. Miller" <davem@redhat.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, stable@kernel.org
CC: "Michael S. Tsirkin" <mst@redhat.com>, Amos Kong <akong@redhat.com>
Subject: Possible NULL dereference caused by -stable commit ef81bb40bf15f350fe865f31fa42f1082772a576
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

A possible NULL dereference were noticed by the stable commit 
ef81bb40bf15f350fe865f31fa42f1082772a576 (which is a backport of 
87c48fa3b4630905f98268dde838ee43626a060c). The case happens when bridge 
froward a packet from guest to a physical nic, at this time no route is 
attached to the skb which may lead a NULL dereference in 
ipv6_select_ident(). -Next version have this check so it is fine. The 
following patch may be used to avoid this but may also lead the ip 
identification predicable, and this defect is also exist -next version 
when no route because we still depends on a global variable to generate 
the identification.  Any thought on this?

Thanks.

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4ea6e21..414e2f4 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -622,7 +622,9 @@ static u32 __ipv6_select_ident(const struct in6_addr 
*addr)

  void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
  {
-       fhdr->identification = 
htonl(__ipv6_select_ident(&rt->rt6i_dst.addr));
+       const struct in6_addr addr = IN6ADDR_ANY_INIT;
+       fhdr->identification =
+               htonl(__ipv6_select_ident(rt ? &rt->rt6i_dst.addr : &addr));
  }

  int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))


