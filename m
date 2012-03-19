Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2CSDJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:09:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46271 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2CSDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:09:30 -0400
Date: Sun, 18 Mar 2012 20:09:25 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: devel@driverdev.osuosl.org
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120319030925.GB22956@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
References: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332123921-14347-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s626_attach is referencing s626_pci_table which is annotated
__devinitconst. Put pci vendor/device ids in the s626_board struct and
use s626_boards instead similar to what is done in gsc_hpdi.

v2: I had moved the PCI id defines to s626.h earlier, but later
decided to leave them in s626.c and forgot to move them up above where
they are being used in s626_boards.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/staging/comedi/drivers/s626.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 23fc64b..e531f1c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -83,8 +83,17 @@ MODULE_AUTHOR("Gianluca Palli <gpalli@deis.unibo.it>");
 MODULE_DESCRIPTION("Sensoray 626 Comedi driver module");
 MODULE_LICENSE("GPL");
 
+#define PCI_VENDOR_ID_S626 0x1131
+#define PCI_DEVICE_ID_S626 0x7146
+#define PCI_SUBVENDOR_ID_S626 0x6000
+#define PCI_SUBDEVICE_ID_S626 0x0272
+
 struct s626_board {
        const char *name;
+       int vendor_id;
+       int device_id;
+       int subvendor_id;
+       int subdevice_id;
        int ai_chans;
        int ai_bits;
        int ao_chans;
@@ -97,6 +106,10 @@ struct s626_board {
 static const struct s626_board s626_boards[] = {
        {
         .name = "s626",
+        .vendor_id = PCI_VENDOR_ID_S626,
+        .device_id = PCI_DEVICE_ID_S626,
+        .subvendor_id = PCI_SUBVENDOR_ID_S626,
+        .subdevice_id = PCI_SUBDEVICE_ID_S626,
         .ai_chans = S626_ADC_CHANNELS,
         .ai_bits = 14,
         .ao_chans = S626_DAC_CHANNELS,
@@ -108,8 +121,6 @@ static const struct s626_board s626_boards[] = {
 };
 
 #define thisboard ((const struct s626_board *)dev->board_ptr)
-#define PCI_VENDOR_ID_S626 0x1131
-#define PCI_DEVICE_ID_S626 0x7146
 
 /*
  * For devices with vendor:device id == 0x1131:0x7146 you must specify
@@ -117,7 +128,7 @@ static const struct s626_board s626_boards[] = {
  * Philips SAA7146 media/dvb based cards.
  */
 static DEFINE_PCI_DEVICE_TABLE(s626_pci_table) = {
-       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
+       {PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_SUBVENDOR_ID_S626, PCI_SUBDEVICE_ID_S626, 0, 0, 0},
        {0}
 };
 
@@ -554,17 +565,17 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
        resource_size_t resourceStart;
        dma_addr_t appdma;
        struct comedi_subdevice *s;
-       const struct pci_device_id *ids;
        struct pci_dev *pdev = NULL;
 
        if (alloc_private(dev, sizeof(struct s626_private)) < 0)
                return -ENOMEM;
 
-       for (i = 0; i < (ARRAY_SIZE(s626_pci_table) - 1) && !pdev; i++) {
-               ids = &s626_pci_table[i];
+       for (i = 0; i < ARRAY_SIZE(s626_boards) && !pdev; i++) {
                do {
-                       pdev = pci_get_subsys(ids->vendor, ids->device,
-                                             ids->subvendor, ids->subdevice,
+                       pdev = pci_get_subsys(s626_boards[i].vendor_id,
+                                             s626_boards[i].device_id,
+                                             s626_boards[i].subvendor_id,
+                                             s626_boards[i].subdevice_id,
                                              pdev);
 
                        if ((it->options[0] || it->options[1]) && pdev) {
-- 
1.7.7.6

