Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab0HLBjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:39:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63855 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758831Ab0HLBjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sYvyS5HoynOeAMZ21ljd2OBIbetgU6jTZY5T+6OyC87nvIjILsdlF7xB9xLsJbtXR6
         L5sDeiPpx0zI2bU2Jp8H0w/GYm7P9CuBPYPEJOkU+mj28kYa90oU0YgIcmhEbGqLWtyf
         yHrWtaD6S6cVwzgG+c7Y9GJ++4XprpAX4cxGM=
MIME-Version: 1.0
Date: Thu, 12 Aug 2010 09:39:15 +0800
Message-ID: <AANLkTimQSppX5HzBoAcU73+7odFBJ8jXHBtszBO+8LVm@mail.gmail.com>
Subject: [PATCH] IPVS : bugfix for ICMPv6 checksum calculation
From: xiaoyu Du <tingsrain@gmail.com>
To: linux-kernel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

This patch correct the ICMPv6 checksum calculation when IPv6 vs is used.

Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4f8ddba..124a1ae 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -638,8 +638,12 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb,
struct ip_vs_protocol *pp,

 	/* And finally the ICMP checksum */
 	icmph->icmp6_cksum = 0;
-	/* TODO IPv6: is this correct for ICMPv6? */
 	ip_vs_checksum_complete(skb, icmp_offset);
+	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
+			&iph->daddr,
+			skb->len - icmp_offset, IPPROTO_ICMPV6,
+			skb->csum);
+
 	skb->ip_summed = CHECKSUM_UNNECESSARY;

 	if (inout)
--
