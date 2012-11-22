Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2KVV7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:59:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab2KVSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Michal Schmidt <mschmidt@redhat.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/38] r8169: use unlimited DMA burst for TX
Date: Wed, 21 Nov 2012 16:40:04 -0800
Message-Id: <20121122003906.518263635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit aee77e4accbeb2c86b1d294cd84fec4a12dde3bd upstream.

The r8169 driver currently limits the DMA burst for TX to 1024 bytes. I have
a box where this prevents the interface from using the gigabit line to its full
potential. This patch solves the problem by setting TX_DMA_BURST to unlimited.

The box has an ASRock B75M motherboard with on-board RTL8168evl/8111evl
(XID 0c900880). TSO is enabled.

I used netperf (TCP_STREAM test) to measure the dependency of TX throughput
on MTU. I did it for three different values of TX_DMA_BURST ('5'=512, '6'=1024,
'7'=unlimited). This chart shows the results:
http://michich.fedorapeople.org/r8169/r8169-effects-of-TX_DMA_BURST.png

Interesting points:
 - With the current DMA burst limit (1024):
   - at the default MTU=1500 I get only 842 Mbit/s.
   - when going from small MTU, the performance rises monotonically with
     increasing MTU only up to a peak at MTU=1076 (908 MBit/s). Then there's
     a sudden drop to 762 MBit/s from which the throughput rises monotonically
     again with further MTU increases.
 - With a smaller DMA burst limit (512):
   - there's a similar peak at MTU=1076 and another one at MTU=564.
 - With unlimited DMA burst:
   - at the default MTU=1500 I get nice 940 Mbit/s.
   - the throughput rises monotonically with increasing MTU with no strange
     peaks.

Notice that the peaks occur at MTU sizes that are multiples of the DMA burst
limit plus 52. Why 52? Because:
  20 (IP header) + 20 (TCP header) + 12 (TCP options) = 52

The Realtek-provided r8168 driver (v8.032.00) uses unlimited TX DMA burst too,
except for CFG_METHOD_1 where the TX DMA burst is set to 512 bytes.
CFG_METHOD_1 appears to be the oldest MAC version of "RTL8168B/8111B",
i.e. RTL_GIGA_MAC_VER_11 in r8169. Not sure if this MAC version really needs
the smaller burst limit, or if any other versions have similar requirements.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -75,7 +75,7 @@ static const int multicast_filter_limit
 #define MAX_READ_REQUEST_SHIFT	12
 #define RX_FIFO_THRESH	7	/* 7 means NO threshold, Rx buffer level before first PCI xfer. */
 #define RX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
-#define TX_DMA_BURST	6	/* Maximum PCI burst, '6' is 1024 */
+#define TX_DMA_BURST	7	/* Maximum PCI burst, '7' is unlimited */
 #define SafeMtu		0x1c20	/* ... actually life sucks beyond ~7k */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
 


