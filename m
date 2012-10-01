Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2JAXCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:02:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35561 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab2JAXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:39 -0400
Message-Id: <20121001225200.993302108@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 080/180] net/ethernet: ks8851_mll fix rx frame buffer overflow
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Ciminaghi <ciminaghi@gnudd.com>

[ Upstream commit 8a9a0ea6032186e3030419262678d652b88bf6a8 ]

At the beginning of ks_rcv(), a for loop retrieves the
header information relevant to all the frames stored
in the mac's internal buffers. The number of pending
frames is stored as an 8 bits field in KS_RXFCTR.
If interrupts are disabled long enough to allow for more than
32 frames to accumulate in the MAC's internal buffers, a buffer
overflow occurs.
This patch fixes the problem by making the
driver's frame_head_info buffer big enough.
Well actually, since the chip appears to have 12K of
internal rx buffers and the shortest ethernet frame should
be 64 bytes long, maybe the limit could be set to
12*1024/64 = 192 frames, but 255 should be safer.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/ks8851_mll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ks8851_mll.c b/drivers/net/ks8851_mll.c
index c0ceebc..4e3a69c 100644
--- a/drivers/net/ks8851_mll.c
+++ b/drivers/net/ks8851_mll.c
@@ -35,7 +35,7 @@
 #define	DRV_NAME	"ks8851_mll"
 
 static u8 KS_DEFAULT_MAC_ADDRESS[] = { 0x00, 0x10, 0xA1, 0x86, 0x95, 0x11 };
-#define MAX_RECV_FRAMES			32
+#define MAX_RECV_FRAMES			255
 #define MAX_BUF_SIZE			2048
 #define TX_BUF_SIZE			2000
 #define RX_BUF_SIZE			2000
-- 
1.7.2.1.45.g54fbc



