Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030812Ab2HQDdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:33:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46780 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030652Ab2HQD07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:59 -0400
Message-Id: <20120817030245.769285357@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dean Nelson <dnelson@redhat.com>,
        Tobias Klausmann <klausman@schwarzvogel.de>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 13/37] e1000: add dropped DMA receive enable back in for WoL
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit b868179c47e9e8eadcd04c1f3105998e528988a3 upstream.

Commit d5bc77a223b0e9b9dfb002048d2b34a79e7d0b48 broke Wake-on-LAN by
inadvertently dropping the enabling of DMA receives.

Restore the enabling of DMA receives for WoL.

This is applicable to 3.1+ stable trees.

Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
Signed-off-by: Dean Nelson <dnelson@redhat.com>
Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 669ca38..d94d64b 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -4740,12 +4740,14 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake)
 		e1000_setup_rctl(adapter);
 		e1000_set_rx_mode(netdev);
 
+		rctl = er32(RCTL);
+
 		/* turn on all-multi mode if wake on multicast is enabled */
-		if (wufc & E1000_WUFC_MC) {
-			rctl = er32(RCTL);
+		if (wufc & E1000_WUFC_MC)
 			rctl |= E1000_RCTL_MPE;
-			ew32(RCTL, rctl);
-		}
+
+		/* enable receives in the hardware */
+		ew32(RCTL, rctl | E1000_RCTL_EN);
 
 		if (hw->mac_type >= e1000_82540) {
 			ctrl = er32(CTRL);


