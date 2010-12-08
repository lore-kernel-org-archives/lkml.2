Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0LHBE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:26 -0500
Received: from kroah.org ([198.145.64.141]:33952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab0LHBER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:17 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:50 2010
Message-Id: <20101208005749.918360796@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:01:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shan Wei <shanwei@cn.fujitsu.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [285/289] r8169: fix checksum broken
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/r8169.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4460,8 +4460,7 @@ static inline void rtl8169_rx_csum(struc
 	u32 status = opts1 & RxProtoMask;
 
 	if (((status == RxProtoTCP) && !(opts1 & TCPFail)) ||
-	    ((status == RxProtoUDP) && !(opts1 & UDPFail)) ||
-	    ((status == RxProtoIP) && !(opts1 & IPFail)))
+	    ((status == RxProtoUDP) && !(opts1 & UDPFail)))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else
 		skb->ip_summed = CHECKSUM_NONE;


