Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1BBAn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:11107 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1BBAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960535"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: shanwei@cn.fujitsu.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [51/139] 8139cp: fix checksum broken
Message-Id: <20110202004407.390FD3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Shan Wei <shanwei@cn.fujitsu.com>

[ Upstream commit 24b7ea9f6c9787fad885442ed0cc010f1aa69cca ]

I am not family with RealTek RTL-8139C+ series 10/100 PCI Ethernet driver.
I try to guess the meaning of RxProtoIP and IPFail.
RxProtoIP stands for received IPv4 packet that upper protocol is not tcp and udp.
!(status & IPFail) is true means that driver correctly to check checksum in IPv4 header.

If these are right, driver will set ip_summed with CHECKSUM_UNNECESSARY for other
upper protocol, e.g. sctp, igmp protocol. This will cause protocol stack ignores
checksum check for packets with invalid checksum.

This patch is only compile-test.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/8139cp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/net/8139cp.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/8139cp.c
+++ linux-2.6.35.y/drivers/net/8139cp.c
@@ -490,13 +490,11 @@ static inline unsigned int cp_rx_csum_ok
 {
 	unsigned int protocol = (status >> 16) & 0x3;
 
-	if (likely((protocol == RxProtoTCP) && (!(status & TCPFail))))
+	if (((protocol == RxProtoTCP) && !(status & TCPFail)) ||
+	    ((protocol == RxProtoUDP) && !(status & UDPFail)))
 		return 1;
-	else if ((protocol == RxProtoUDP) && (!(status & UDPFail)))
-		return 1;
-	else if ((protocol == RxProtoIP) && (!(status & IPFail)))
-		return 1;
-	return 0;
+	else
+		return 0;
 }
 
 static int cp_rx_poll(struct napi_struct *napi, int budget)
