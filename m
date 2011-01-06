Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1AFAvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:51:47 -0500
Received: from kroah.org ([198.145.64.141]:35708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab1AFA3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:51 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.227696885@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shan Wei <shanwei@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [059/152] 8139cp: fix checksum broken
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
---
 drivers/net/8139cp.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
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


