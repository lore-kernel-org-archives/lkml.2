Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2DCANf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 20:13:35 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49182 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751497Ab2DCANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 20:13:34 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19wdzhgxnRwszLozDx4BAZCguS93kHa5DlJa2dd55
	Gk7gJ2A/b/M5rD
Date: Tue, 3 Apr 2012 02:13:27 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: shemminger@vyatta.com, mlindner@marvell.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sky2: in free_buffers() do proper checks before call of rx_clean()
Message-ID: <20120403001327.GB10227@Neptun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sky2_open() free_buffers() is called in case that alloc_buffers() failed.
Here we do the check for sky2->rx_le too late, since we already called
rx_clean() which accessed rx_le. Furthermore we lack a check for sky2->rx_ring
which is also accessed by rx_clean().

With this patch both sky2->rx_le and sky2->rx_ring are checked before
alloc_buffers() is called.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 This applies against 3.3

 drivers/net/ethernet/marvell/sky2.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 760c2b1..3e3eda6 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1628,9 +1628,10 @@ static void sky2_free_buffers(struct sky2_port *sky2)
 {
 	struct sky2_hw *hw = sky2->hw;
 
-	sky2_rx_clean(sky2);
-
 	if (sky2->rx_le) {
+		if (sky2->rx_ring)
+			sky2_rx_clean(sky2);
+
 		pci_free_consistent(hw->pdev, RX_LE_BYTES,
 				    sky2->rx_le, sky2->rx_le_map);
 		sky2->rx_le = NULL;
-- 
1.7.2.5

