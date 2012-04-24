Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2DXBaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:30:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64839 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2DXBaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:30:11 -0400
Date: Mon, 23 Apr 2012 18:30:06 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH v2 resend] staging: comedi: resolve section mismatch in
 s626
Message-ID: <20120424013006.GB2321@cantor.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Greg KH <gregkh@linuxfoundation.org>,
	Ian Abbott <abbotti@mev.co.uk>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Ian Abbott <ian.abbott@mev.co.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
References: <20120319163103.GC3694@kroah.com>
 <20120319164325.GA31833@perelman.Home>
 <20120319224649.GA7679@perelman.Home>
 <20120319232656.GB6386@kroah.com>
 <4F798416.8040709@mev.co.uk>
 <20120410182438.GB2052@kroah.com>
 <4F86D294.3050108@mev.co.uk>
 <20120418232824.GA9419@kroah.com>
 <20120420013411.GA3769@cantor.Home>
 <20120420153331.GA19219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420153331.GA19219@kroah.com>
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
+	int vendor_id;
+	int device_id;
+	int subvendor_id;
+	int subdevice_id;
 	int ai_chans;
 	int ai_bits;
 	int ao_chans;
@@ -97,6 +106,10 @@ struct s626_board {
 static const struct s626_board s626_boards[] = {
 	{
 	 .name = "s626",
+	 .vendor_id = PCI_VENDOR_ID_S626,
+	 .device_id = PCI_DEVICE_ID_S626,
+	 .subvendor_id = PCI_SUBVENDOR_ID_S626,
+	 .subdevice_id = PCI_SUBDEVICE_ID_S626,
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
-	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, 0x6000, 0x0272, 0, 0, 0},
+	{PCI_VENDOR_ID_S626, PCI_DEVICE_ID_S626, PCI_SUBVENDOR_ID_S626, PCI_SUBDEVICE_ID_S626, 0, 0, 0},
 	{0}
 };
 
@@ -554,17 +565,17 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	resource_size_t resourceStart;
 	dma_addr_t appdma;
 	struct comedi_subdevice *s;
-	const struct pci_device_id *ids;
 	struct pci_dev *pdev = NULL;
 
 	if (alloc_private(dev, sizeof(struct s626_private)) < 0)
 		return -ENOMEM;
 
-	for (i = 0; i < (ARRAY_SIZE(s626_pci_table) - 1) && !pdev; i++) {
-		ids = &s626_pci_table[i];
+	for (i = 0; i < ARRAY_SIZE(s626_boards) && !pdev; i++) {
 		do {
-			pdev = pci_get_subsys(ids->vendor, ids->device,
-					      ids->subvendor, ids->subdevice,
+			pdev = pci_get_subsys(s626_boards[i].vendor_id,
+					      s626_boards[i].device_id,
+					      s626_boards[i].subvendor_id,
+					      s626_boards[i].subdevice_id,
 					      pdev);
 
 			if ((it->options[0] || it->options[1]) && pdev) {
-- 
1.7.7.6

