Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1I1Wq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:46:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933022Ab1I1Wqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:41 2011
Message-Id: <20110928220141.824857563@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [157/244] tg3: Fix io failures after chip reset
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Carlson <mcarlson@broadcom.com>

commit 9e975cc291d80d5e4562d6bed15ec171e896d69b upstream.

Commit f2096f94b514d88593355995d5dd276961e88af1, entitled
"tg3: Add 5720 H2BMC support", needed to add code to preserve some bits
set by firmware.  Unfortunately the new code causes throughput to stop
after a chip reset because it enables state machines before they are
ready.  This patch undoes the problematic code.  The bits will be
restored later in the init sequence.

Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/tg3.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -7267,16 +7267,11 @@ static int tg3_chip_reset(struct tg3 *tp
 		tw32(TG3PCI_CLOCK_CTRL, tp->pci_clock_ctrl);
 	}
 
-	if (tg3_flag(tp, ENABLE_APE))
-		tp->mac_mode = MAC_MODE_APE_TX_EN |
-			       MAC_MODE_APE_RX_EN |
-			       MAC_MODE_TDE_ENABLE;
-
 	if (tp->phy_flags & TG3_PHYFLG_PHY_SERDES) {
-		tp->mac_mode |= MAC_MODE_PORT_MODE_TBI;
+		tp->mac_mode = MAC_MODE_PORT_MODE_TBI;
 		val = tp->mac_mode;
 	} else if (tp->phy_flags & TG3_PHYFLG_MII_SERDES) {
-		tp->mac_mode |= MAC_MODE_PORT_MODE_GMII;
+		tp->mac_mode = MAC_MODE_PORT_MODE_GMII;
 		val = tp->mac_mode;
 	} else
 		val = 0;
@@ -8408,12 +8403,11 @@ static int tg3_reset_hw(struct tg3 *tp,
 		udelay(10);
 	}
 
-	if (tg3_flag(tp, ENABLE_APE))
-		tp->mac_mode = MAC_MODE_APE_TX_EN | MAC_MODE_APE_RX_EN;
-	else
-		tp->mac_mode = 0;
 	tp->mac_mode |= MAC_MODE_TXSTAT_ENABLE | MAC_MODE_RXSTAT_ENABLE |
-		MAC_MODE_TDE_ENABLE | MAC_MODE_RDE_ENABLE | MAC_MODE_FHDE_ENABLE;
+			MAC_MODE_TDE_ENABLE | MAC_MODE_RDE_ENABLE |
+			MAC_MODE_FHDE_ENABLE;
+	if (tg3_flag(tp, ENABLE_APE))
+		tp->mac_mode |= MAC_MODE_APE_TX_EN | MAC_MODE_APE_RX_EN;
 	if (!tg3_flag(tp, 5705_PLUS) &&
 	    !(tp->phy_flags & TG3_PHYFLG_PHY_SERDES) &&
 	    GET_ASIC_REV(tp->pci_chip_rev_id) != ASIC_REV_5700)


