Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825Ab1KCBmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:42:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801Ab1KCBmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222747.560311798@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Fertser <fercerpav@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [085/101] plat-mxc: iomux-v3.h: implicitly enable pull-up/down when thats desired
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Fertser <fercerpav@gmail.com>

commit 6571534b600b8ca1936ff5630b9e0947f21faf16 upstream.

To configure pads during the initialisation a set of special constants
is used, e.g.
#define MX25_PAD_FEC_MDIO__FEC_MDIO IOMUX_PAD(0x3c4, 0x1cc, 0x10, 0, 0, PAD_CTL_HYS | PAD_CTL_PUS_22K_UP)

The problem is that no pull-up/down is getting activated unless both
PAD_CTL_PUE (pull-up enable) and PAD_CTL_PKE (pull/keeper module
enable) set. This is clearly stated in the i.MX25 datasheet and is
confirmed by the measurements on hardware. This leads to some rather
hard to understand bugs such as misdetecting an absent ethernet PHY (a
real bug i had), unstable data transfer etc. This might affect mx25,
mx35, mx50, mx51 and mx53 SoCs.

It's reasonable to expect that if the pullup value is specified, the
intention was to have it actually active, so we implicitly add the
needed bits.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-mxc/include/mach/iomux-v3.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -73,11 +73,11 @@ struct pad_desc {
 #define PAD_CTL_HYS			(1 << 8)
 
 #define PAD_CTL_PKE			(1 << 7)
-#define PAD_CTL_PUE			(1 << 6)
-#define PAD_CTL_PUS_100K_DOWN		(0 << 4)
-#define PAD_CTL_PUS_47K_UP		(1 << 4)
-#define PAD_CTL_PUS_100K_UP		(2 << 4)
-#define PAD_CTL_PUS_22K_UP		(3 << 4)
+#define PAD_CTL_PUE			(1 << 6 | PAD_CTL_PKE)
+#define PAD_CTL_PUS_100K_DOWN		(0 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_47K_UP		(1 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_100K_UP		(2 << 4 | PAD_CTL_PUE)
+#define PAD_CTL_PUS_22K_UP		(3 << 4 | PAD_CTL_PUE)
 
 #define PAD_CTL_ODE			(1 << 3)
 


