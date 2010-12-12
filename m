Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0LLXst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab0LLXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:46 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: shanwei@cn.fujitsu.com, romieu@fr.zoreil.com, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [217/223] r8169: fix checksum broken
Message-Id: <20101212234844.EB52EB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Shan Wei <shanwei@cn.fujitsu.com>

commit d5d3ebe3be5c5123f2d444e186717f45284151e2 upstream.

If r8196 received packets with invalid sctp/igmp(not tcp, udp) checksum, r8196 set skb->ip_summed
wit CHECKSUM_UNNECESSARY. This cause that upper protocol don't check checksum field.

I am not family with r8196 driver. I try to guess the meaning of RxProtoIP and IPFail.
RxProtoIP stands for received IPv4 packet that upper protocol is not tcp and udp.
!(opts1 & IPFail) is true means that driver correctly to check checksum in IPv4 header.

If it's right, I think we should not set ip_summed wit CHECKSUM_UNNECESSARY for my sctp packets
with invalid checksum.

If it's not right, please tell me.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/r8169.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/drivers/net/r8169.c
===================================================================
--- linux.orig/drivers/net/r8169.c
+++ linux/drivers/net/r8169.c
@@ -4463,8 +4463,7 @@ static inline void rtl8169_rx_csum(struc
 	u32 status = opts1 & RxProtoMask;
 
 	if (((status == RxProtoTCP) && !(opts1 & TCPFail)) ||
-	    ((status == RxProtoUDP) && !(opts1 & UDPFail)) ||
-	    ((status == RxProtoIP) && !(opts1 & IPFail)))
+	    ((status == RxProtoUDP) && !(opts1 & UDPFail)))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else
 		skb->ip_summed = CHECKSUM_NONE;
