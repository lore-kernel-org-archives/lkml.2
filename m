Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1DLOrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:47:15 -0400
Received: from kroah.org ([198.145.64.141]:57677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab1DLOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:55 2011
Message-Id: <20110412143555.245843388@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        RA-Jay Hung <jay_hung@ralinktech.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [068/105] rt2x00: Fix radio off hang issue for PCIE interface
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: RA-Jay Hung <jay_hung@ralinktech.com>

commit 7f6e144fb99a4a70d3c5ad5f074204c5b89a6f65 upstream.

PCI/PCIE radio off behavior is different from SOC/USB.
They mainly use MCU command to disable DMA, TX/RX and enter power saving mode.

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 -----
 drivers/net/wireless/rt2x00/rt2800pci.c |   36 ++++++++------------------------
 2 files changed, 10 insertions(+), 32 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2810,10 +2810,7 @@ void rt2800_disable_radio(struct rt2x00_
 
 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
 	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
 
 	/* Wait for DMA, ignore error */
@@ -2823,9 +2820,6 @@ void rt2800_disable_radio(struct rt2x00_
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_TX, 0);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
 	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
-	rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
 }
 EXPORT_SYMBOL_GPL(rt2800_disable_radio);
 
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -475,39 +475,23 @@ static int rt2800pci_enable_radio(struct
 
 static void rt2800pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2800_disable_radio(rt2x00dev);
-
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001280);
-
-	rt2800_register_read(rt2x00dev, WPDMA_RST_IDX, &reg);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
-
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
-	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	if (rt2x00_is_soc(rt2x00dev)) {
+		rt2800_disable_radio(rt2x00dev);
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0);
+		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0);
+	}
 }
 
 static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 			       enum dev_state state)
 {
-	/*
-	 * Always put the device to sleep (even when we intend to wakeup!)
-	 * if the device is booting and wasn't asleep it will return
-	 * failure when attempting to wakeup.
-	 */
-	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0xff, 0xff, 2);
-
 	if (state == STATE_AWAKE) {
-		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0);
+		rt2800_mcu_request(rt2x00dev, MCU_WAKEUP, TOKEN_WAKUP, 0, 0x02);
 		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKUP);
+	} else if (state == STATE_SLEEP) {
+		rt2800_register_write(rt2x00dev, H2M_MAILBOX_STATUS, 0xffffffff);
+		rt2800_register_write(rt2x00dev, H2M_MAILBOX_CID, 0xffffffff);
+		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, 0x01, 0xff, 0x01);
 	}
 
 	return 0;


