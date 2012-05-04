Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656Ab2EDXTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:19:35 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:43908 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab2EDXTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:19:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1336173571!10619252!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor the icp_multi driver to remove forward declarations
Date: Fri, 4 May 2012 16:19:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205041619.27259.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the setup_channel_list function forward in the souce and the
struct comedi_driver and associated variables to the end of the
source. This is more typical of how other drivers are written and
removes the need for the forward declarations.

Remove the unnecessary comments for the attach/detach functions.

Change the initialization of struct boardtype to c99 syntax and
remove the comments.

Convert the driver to use the module_comedi_driver() macro which
makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 67b6f5a..0f63fc0 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -121,15 +121,6 @@ static const char range_codes_analog[] = { 0x00, 0x20, 0x10, 0x30 };
 
 /*
 ==============================================================================
-	Forward declarations
-==============================================================================
-*/
-static int icp_multi_attach(struct comedi_device *dev,
-			    struct comedi_devconfig *it);
-static int icp_multi_detach(struct comedi_device *dev);
-
-/*
-==============================================================================
 	Data & Structure declarations
 ==============================================================================
 */
@@ -154,48 +145,6 @@ struct boardtype {
 	const struct comedi_lrange *rangelist_ao;	/*  rangelist for D/A */
 };
 
-static const struct boardtype boardtypes[] = {
-	{"icp_multi",		/*  Driver name */
-	 DEVICE_ID,		/*  PCI device ID */
-	 IORANGE_ICP_MULTI,	/*  I/O range length */
-	 1,			/*  1=Card supports interrupts */
-	 TYPE_ICP_MULTI,	/*  Card type = ICP MULTI */
-	 16,			/*  Num of A/D channels */
-	 8,			/*  Num of A/D channels in diff mode */
-	 4,			/*  Num of D/A channels */
-	 16,			/*  Num of digital inputs */
-	 8,			/*  Num of digital outputs */
-	 4,			/*  Num of counters */
-	 0x0fff,		/*  Resolution of A/D */
-	 0x0fff,		/*  Resolution of D/A */
-	 &range_analog,		/*  Rangelist for A/D */
-	 range_codes_analog,	/*  Range codes for programming */
-	 &range_analog},	/*  Rangelist for D/A */
-};
-
-static struct comedi_driver driver_icp_multi = {
-	.driver_name = "icp_multi",
-	.module = THIS_MODULE,
-	.attach = icp_multi_attach,
-	.detach = icp_multi_detach,
-	.num_names = ARRAY_SIZE(boardtypes),
-	.board_name = &boardtypes[0].name,
-	.offset = sizeof(struct boardtype),
-};
-
-static int __init driver_icp_multi_init_module(void)
-{
-	return comedi_driver_register(&driver_icp_multi);
-}
-
-static void __exit driver_icp_multi_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_icp_multi);
-}
-
-module_init(driver_icp_multi_init_module);
-module_exit(driver_icp_multi_cleanup_module);
-
 struct icp_multi_private {
 	struct pcilst_struct *card;	/*  pointer to card */
 	char valid;		/*  card is usable */
@@ -220,25 +169,81 @@ struct icp_multi_private {
 
 /*
 ==============================================================================
-	More forward declarations
+
+Name:	setup_channel_list
+
+Description:
+	This function sets the appropriate channel selection,
+	differential input mode and range bits in the ADC Command/
+	Status register.
+
+Parameters:
+	struct comedi_device *dev	Pointer to current service structure
+	struct comedi_subdevice *s	Pointer to current subdevice structure
+	unsigned int *chanlist	Pointer to packed channel list
+	unsigned int n_chan	Number of channels to scan
+
+Returns:Void
+
 ==============================================================================
 */
-
-#if 0
-static int check_channel_list(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      unsigned int *chanlist, unsigned int n_chan);
-#endif
 static void setup_channel_list(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
-			       unsigned int *chanlist, unsigned int n_chan);
-static int icp_multi_reset(struct comedi_device *dev);
+			       unsigned int *chanlist, unsigned int n_chan)
+{
+	unsigned int i, range, chanprog;
+	unsigned int diff;
 
-/*
-==============================================================================
-	Functions
-==============================================================================
-*/
+#ifdef ICP_MULTI_EXTDEBUG
+	printk(KERN_DEBUG
+	       "icp multi EDBG:  setup_channel_list(...,%d)\n", n_chan);
+#endif
+	devpriv->act_chanlist_len = n_chan;
+	devpriv->act_chanlist_pos = 0;
+
+	for (i = 0; i < n_chan; i++) {
+		/*  Get channel */
+		chanprog = CR_CHAN(chanlist[i]);
+
+		/*  Determine if it is a differential channel (Bit 15  = 1) */
+		if (CR_AREF(chanlist[i]) == AREF_DIFF) {
+			diff = 1;
+			chanprog &= 0x0007;
+		} else {
+			diff = 0;
+			chanprog &= 0x000f;
+		}
+
+		/*  Clear channel, range and input mode bits
+		 *  in A/D command/status register */
+		devpriv->AdcCmdStatus &= 0xf00f;
+
+		/*  Set channel number and differential mode status bit */
+		if (diff) {
+			/*  Set channel number, bits 9-11 & mode, bit 6 */
+			devpriv->AdcCmdStatus |= (chanprog << 9);
+			devpriv->AdcCmdStatus |= ADC_DI;
+		} else
+			/*  Set channel number, bits 8-11 */
+			devpriv->AdcCmdStatus |= (chanprog << 8);
+
+		/*  Get range for current channel */
+		range = this_board->rangecode[CR_RANGE(chanlist[i])];
+		/*  Set range. bits 4-5 */
+		devpriv->AdcCmdStatus |= range;
+
+		/* Output channel, range, mode to ICP Multi */
+		writew(devpriv->AdcCmdStatus,
+		       devpriv->io_addr + ICP_MULTI_ADC_CSR);
+
+#ifdef ICP_MULTI_EXTDEBUG
+		printk(KERN_DEBUG
+		       "GS: %2d. [%4x]=%4x %4x\n", i, chanprog, range,
+		       devpriv->act_chanlist[i]);
+#endif
+	}
+
+}
 
 /*
 ==============================================================================
@@ -762,84 +767,6 @@ static int check_channel_list(struct comedi_device *dev,
 /*
 ==============================================================================
 
-Name:	setup_channel_list
-
-Description:
-	This function sets the appropriate channel selection,
-	differential input mode and range bits in the ADC Command/
-	Status register.
-
-Parameters:
-	struct comedi_device *dev	Pointer to current service structure
-	struct comedi_subdevice *s	Pointer to current subdevice structure
-	unsigned int *chanlist	Pointer to packed channel list
-	unsigned int n_chan	Number of channels to scan
-
-Returns:Void
-
-==============================================================================
-*/
-static void setup_channel_list(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       unsigned int *chanlist, unsigned int n_chan)
-{
-	unsigned int i, range, chanprog;
-	unsigned int diff;
-
-#ifdef ICP_MULTI_EXTDEBUG
-	printk(KERN_DEBUG
-	       "icp multi EDBG:  setup_channel_list(...,%d)\n", n_chan);
-#endif
-	devpriv->act_chanlist_len = n_chan;
-	devpriv->act_chanlist_pos = 0;
-
-	for (i = 0; i < n_chan; i++) {
-		/*  Get channel */
-		chanprog = CR_CHAN(chanlist[i]);
-
-		/*  Determine if it is a differential channel (Bit 15  = 1) */
-		if (CR_AREF(chanlist[i]) == AREF_DIFF) {
-			diff = 1;
-			chanprog &= 0x0007;
-		} else {
-			diff = 0;
-			chanprog &= 0x000f;
-		}
-
-		/*  Clear channel, range and input mode bits
-		 *  in A/D command/status register */
-		devpriv->AdcCmdStatus &= 0xf00f;
-
-		/*  Set channel number and differential mode status bit */
-		if (diff) {
-			/*  Set channel number, bits 9-11 & mode, bit 6 */
-			devpriv->AdcCmdStatus |= (chanprog << 9);
-			devpriv->AdcCmdStatus |= ADC_DI;
-		} else
-			/*  Set channel number, bits 8-11 */
-			devpriv->AdcCmdStatus |= (chanprog << 8);
-
-		/*  Get range for current channel */
-		range = this_board->rangecode[CR_RANGE(chanlist[i])];
-		/*  Set range. bits 4-5 */
-		devpriv->AdcCmdStatus |= range;
-
-		/* Output channel, range, mode to ICP Multi */
-		writew(devpriv->AdcCmdStatus,
-		       devpriv->io_addr + ICP_MULTI_ADC_CSR);
-
-#ifdef ICP_MULTI_EXTDEBUG
-		printk(KERN_DEBUG
-		       "GS: %2d. [%4x]=%4x %4x\n", i, chanprog, range,
-		       devpriv->act_chanlist[i]);
-#endif
-	}
-
-}
-
-/*
-==============================================================================
-
 Name:	icp_multi_reset
 
 Description:
@@ -895,23 +822,6 @@ static int icp_multi_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-==============================================================================
-
-Name:	icp_multi_attach
-
-Description:
-	This function sets up all the appropriate data for the current
-	device.
-
-Parameters:
-	struct comedi_device *dev	Pointer to current device structure
-	struct comedi_devconfig *it	Pointer to current device configuration
-
-Returns:int	0 = success
-
-==============================================================================
-*/
 static int icp_multi_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
@@ -1097,25 +1007,8 @@ static int icp_multi_attach(struct comedi_device *dev,
 	return 0;
 }
 
-/*
-==============================================================================
-
-Name:	icp_multi_detach
-
-Description:
-	This function releases all the resources used by the current
-	device.
-
-Parameters:
-	struct comedi_device *dev	Pointer to current device structure
-
-Returns:int	0 = success
-
-==============================================================================
-*/
 static int icp_multi_detach(struct comedi_device *dev)
 {
-
 	if (dev->private)
 		if (devpriv->valid)
 			icp_multi_reset(dev);
@@ -1135,6 +1028,38 @@ static int icp_multi_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct boardtype boardtypes[] = {
+	{
+		.name		= "icp_multi",
+		.device_id	= DEVICE_ID,
+		.iorange	= IORANGE_ICP_MULTI,
+		.have_irq	= 1,
+		.cardtype	= TYPE_ICP_MULTI,
+		.n_aichan	= 16,
+		.n_aichand	= 8,
+		.n_aochan	= 4,
+		.n_dichan	= 16,
+		.n_dochan	= 8,
+		.n_ctrs		= 4,
+		.ai_maxdata	= 0x0fff,
+		.ao_maxdata	= 0x0fff,
+		.rangelist_ai	= &range_analog,
+		.rangecode	= range_codes_analog,
+		.rangelist_ao	= &range_analog,
+	},
+};
+
+static struct comedi_driver icp_multi_driver = {
+	.driver_name	= "icp_multi",
+	.module		= THIS_MODULE,
+	.attach		= icp_multi_attach,
+	.detach		= icp_multi_detach,
+	.num_names	= ARRAY_SIZE(boardtypes),
+	.board_name	= &boardtypes[0].name,
+	.offset		= sizeof(struct boardtype),
+};
+module_comedi_driver(icp_multi_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
