Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0HAKX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 06:23:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57462 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0HAKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 06:23:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 1 Aug 2010 12:23:14 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: add forgotten dummy driver methods, remove
 unused ones
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.49951b72693972f0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an at least theoretic race condition in which .start_iso etc.
could still be called between when the dummy driver is bound to the card
and when the children devices are being shut down.  Add dummy_start_iso
and friends.

On the other hand, .enable, .set_config_rom, .read_csr, write_csr do not
need to be implemented by the dummy driver, as commented.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   64 +++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 26 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -552,15 +552,13 @@ EXPORT_SYMBOL(fw_card_add);
  * as all IO to the card will be handled (and failed) by the dummy driver
  * instead of calling into the module.  Only functions for iso context
  * shutdown still need to be provided by the card driver.
+ *
+ * .read/write_csr() should never be called anymore after the dummy driver
+ * was bound since they are only used within request handler context.
+ * .set_config_rom() is never called since the card is taken out of card_list
+ * before switching to the dummy driver.
  */
 
-static int dummy_enable(struct fw_card *card,
-			const __be32 *config_rom, size_t length)
-{
-	BUG();
-	return -1;
-}
-
 static int dummy_read_phy_reg(struct fw_card *card, int address)
 {
 	return -ENODEV;
@@ -572,17 +570,6 @@ static int dummy_update_phy_reg(struct f
 	return -ENODEV;
 }
 
-static int dummy_set_config_rom(struct fw_card *card,
-				const __be32 *config_rom, size_t length)
-{
-	/*
-	 * We take the card out of card_list before setting the dummy
-	 * driver, so this should never get called.
-	 */
-	BUG();
-	return -1;
-}
-
 static void dummy_send_request(struct fw_card *card, struct fw_packet *packet)
 {
 	packet->callback(packet, card, RCODE_CANCELLED);
@@ -604,15 +591,40 @@ static int dummy_enable_phys_dma(struct 
 	return -ENODEV;
 }
 
+static struct fw_iso_context *dummy_allocate_iso_context(struct fw_card *card,
+				int type, int channel, size_t header_size)
+{
+	return ERR_PTR(-ENODEV);
+}
+
+static int dummy_start_iso(struct fw_iso_context *ctx,
+			   s32 cycle, u32 sync, u32 tags)
+{
+	return -ENODEV;
+}
+
+static int dummy_set_iso_channels(struct fw_iso_context *ctx, u64 *channels)
+{
+	return -ENODEV;
+}
+
+static int dummy_queue_iso(struct fw_iso_context *ctx, struct fw_iso_packet *p,
+			   struct fw_iso_buffer *buffer, unsigned long payload)
+{
+	return -ENODEV;
+}
+
 static const struct fw_card_driver dummy_driver_template = {
-	.enable          = dummy_enable,
-	.read_phy_reg    = dummy_read_phy_reg,
-	.update_phy_reg  = dummy_update_phy_reg,
-	.set_config_rom  = dummy_set_config_rom,
-	.send_request    = dummy_send_request,
-	.cancel_packet   = dummy_cancel_packet,
-	.send_response   = dummy_send_response,
-	.enable_phys_dma = dummy_enable_phys_dma,
+	.read_phy_reg		= dummy_read_phy_reg,
+	.update_phy_reg		= dummy_update_phy_reg,
+	.send_request		= dummy_send_request,
+	.send_response		= dummy_send_response,
+	.cancel_packet		= dummy_cancel_packet,
+	.enable_phys_dma	= dummy_enable_phys_dma,
+	.allocate_iso_context	= dummy_allocate_iso_context,
+	.start_iso		= dummy_start_iso,
+	.set_iso_channels	= dummy_set_iso_channels,
+	.queue_iso		= dummy_queue_iso,
 };
 
 void fw_card_release(struct kref *kref)

-- 
Stefan Richter
-=====-==-=- =--- ----=
http://arcgraph.de/sr/

