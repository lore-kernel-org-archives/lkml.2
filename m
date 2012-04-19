Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2DSVJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:09:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933006Ab2DSVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:09 -0400
Message-Id: <20120419210611.389921911@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 03/59] rtlwifi: Add missing DMA buffer unmapping for PCI drivers
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 673f7786e205c87b5d978c62827b9a66d097bebb upstream.

In https://bugzilla.kernel.org/show_bug.cgi?id=42976, a system with driver
rtl8192se used as an AP suffers from "Out of SW-IOMMU space" errors. These
are caused by the DMA buffers used for beacons never being unmapped.

This bug was also reported at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/961618

Reported-and-Tested-by: Da Xue <da@lessconfused.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -954,8 +954,13 @@ static void _rtl_pci_prepare_bcn_tasklet
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
+	if (pskb) {
+		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
+		pci_unmap_single(rtlpci->pdev, rtlpriv->cfg->ops->get_desc(
+				 (u8 *) entry, true, HW_DESC_TXBUFF_ADDR),
+				 pskb->len, PCI_DMA_TODEVICE);
 		kfree_skb(pskb);
+	}
 
 	/*NB: the beacon data buffer must be 32-bit aligned. */
 	pskb = ieee80211_beacon_get(hw, mac->vif);


