Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2B0WBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:01:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2B0WBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:01:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Date: Mon, 27 Feb 2012 22:01:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        Roland Stigge <stigge@antcom.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com
References: <Pine.LNX.4.44L0.1202271131070.1539-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202271131070.1539-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202272201.14665.arnd@arndb.de>
X-Provags-ID: V02:K0:7Bqe4iBKx7wjr6EnkiO0KfbSW5gV2Pii/U1Irw1NqSh
 4j59EYO6JjfZwmhHn2+6emfgc1PPbxjZ0VjHFOJlUn46HXZQ12
 87tyT1CMw0fmA0irXWPs7rCQz6CvfCLTKP5a2WFJ2N00oXgB8d
 u4GJzXTnHeT+3guNjwVnmr0Qcs0ragX3z4xINEid7TdaImV/CM
 +9dg0o2Q+U/NXJP8FPT82SFKyXeRcrRlDzRnzdRx90rh+DY1AM
 XMgsP3Ifjs5VK5MwE5B4KPfwyu3QVTz21NMQjn7xF1x8jckhZ6
 m04Esk6gQFByldIjvtyGmUqdE4oiNKAFT5i2rzh5Ja1knHZvSs
 OYb51FXBn4R2q9QVNTy8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 February 2012, Alan Stern wrote:
> On Mon, 27 Feb 2012, Arnd Bergmann wrote:
>
> > > At the moment, switching the pnx4008 driver to use the generic bus glue
> > > doesn't look easy.  The generic code doesn't know anything about i2c.
> > 
> > Maybe I misunderstood what the generic bus glue does then, because I
> > would not expect that it should know about i2c ;-)
> > 
> > I would think the generic bus glue would be a very simple library that
> > just exports the various symbols that are defined in ohci-hcd.c and
> > used in the bus specific driver so that the driver can be a separate
> > module. Is it something different from that?
> 
> Quite different.  What you just described is ohci-hcd.c itself -- 
> except that it doesn't export the necessary symbols.
> 
> The generic driver, as you'll see when you read the patch, includes 
> generic versions of the various routines that a bus glue file has to 
> provide (probe, remove, initialize, and so on).

Ok, I see. Nevermind then, I don't think this will help to solve
the problem of building multiple ARM platforms together when they
provide conflicting bus glues, although it seems generally to be
a good idea in order to reduce the number of platform glues that there
are

What do you think about an approach like below?

	Arnd

8<----------
[POC] usb/ohci: Turn ohci-hcd.c into a library

This is an attempt to turn the ohci host controller driver into a library
similar to how many other kernel drivers work that have a common register
interface on a number of different buses.  

The conversion is straightforward: all functions that are used by the pci
specific frontend are exported from the common code and declared in a header.
The ohci-pci.c file is turned into a module by listing it in the Makefile
and adding a module_pci_driver() definition as well as all the #include
statements that are needed to build it standalone.

Doing the same for the other bus glues should be a trivial change to
enable separate compilation in each one, with a module_platform_driver()
statement.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
 drivers/usb/host/Makefile     |    1 +
 drivers/usb/host/ohci-dbg.c   |   10 +---
 drivers/usb/host/ohci-hcd.c   |   88 +++++++++++------------------------------
 drivers/usb/host/ohci-hub.c   |   19 ++++++---
 drivers/usb/host/ohci-mem.c   |    3 +-
 drivers/usb/host/ohci-pci.c   |   47 +++++++++++++--------
 drivers/usb/host/ohci-q.c     |   14 ++++---
 drivers/usb/host/ohci.h       |   37 +++++++++++++++++
 drivers/usb/host/pci-quirks.c |   13 ++++++
 drivers/usb/host/pci-quirks.h |    2 +
 10 files changed, 130 insertions(+), 104 deletions(-)

diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 7ca290f..338e1cc 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
+obj-$(CONFIG_USB_OHCI_HCD_PCI)	+= ohci-pci.o
 obj-$(CONFIG_USB_UHCI_HCD)	+= uhci-hcd.o
 obj-$(CONFIG_USB_FHCI_HCD)	+= fhci.o
 obj-$(CONFIG_USB_XHCI_HCD)	+= xhci-hcd.o
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index e4bcb62..1b868b76 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -289,7 +289,7 @@ ohci_dump_roothub (
 	}
 }
 
-static void ohci_dump (struct ohci_hcd *controller, int verbose)
+void ohci_dump (struct ohci_hcd *controller, int verbose)
 {
 	ohci_dbg (controller, "OHCI controller state\n");
 
@@ -300,6 +300,7 @@ static void ohci_dump (struct ohci_hcd *controller, int verbose)
 			"hcca frame #%04x\n", ohci_frame_no(controller));
 	ohci_dump_roothub (controller, 1, NULL, NULL);
 }
+EXPORT_SYMBOL_GPL(ohci_dump);
 
 static const char data0 [] = "DATA0";
 static const char data1 [] = "DATA1";
@@ -407,12 +408,7 @@ ohci_dump_ed (const struct ohci_hcd *ohci, const char *label,
 	}
 }
 
-#else
-static inline void ohci_dump (struct ohci_hcd *controller, int verbose) {}
-
-#undef OHCI_VERBOSE_DEBUG
-
-#endif /* DEBUG */
+#endif
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..99c8dc4 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -72,31 +72,12 @@
 
 /*-------------------------------------------------------------------------*/
 
-static const char	hcd_name [] = "ohci_hcd";
+static const char      hcd_name [] = "ohci_hcd";
 
 #define	STATECHANGE_DELAY	msecs_to_jiffies(300)
 
 #include "ohci.h"
 #include "pci-quirks.h"
-
-static void ohci_dump (struct ohci_hcd *ohci, int verbose);
-static int ohci_init (struct ohci_hcd *ohci);
-static void ohci_stop (struct usb_hcd *hcd);
-
-#if defined(CONFIG_PM) || defined(CONFIG_PCI)
-static int ohci_restart (struct ohci_hcd *ohci);
-#endif
-
-#ifdef CONFIG_PCI
-static void sb800_prefetch(struct ohci_hcd *ohci, int on);
-#else
-static inline void sb800_prefetch(struct ohci_hcd *ohci, int on)
-{
-	return;
-}
-#endif
-
-
 #include "ohci-hub.c"
 #include "ohci-dbg.c"
 #include "ohci-mem.c"
@@ -130,7 +111,7 @@ MODULE_PARM_DESC (no_handshake, "true (not default) disables BIOS handshake");
 /*
  * queue up an urb for anything except the root hub
  */
-static int ohci_urb_enqueue (
+int ohci_urb_enqueue (
 	struct usb_hcd	*hcd,
 	struct urb	*urb,
 	gfp_t		mem_flags
@@ -253,6 +234,7 @@ fail:
 	spin_unlock_irqrestore (&ohci->lock, flags);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(ohci_urb_enqueue);
 
 /*
  * decouple the URB from the HC queues (TDs, urb_priv).
@@ -260,7 +242,7 @@ fail:
  * asynchronously, and we might be dealing with an urb that's
  * partially transferred, or an ED with other urbs being unlinked.
  */
-static int ohci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
+int ohci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	unsigned long		flags;
@@ -297,6 +279,7 @@ static int ohci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	spin_unlock_irqrestore (&ohci->lock, flags);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ohci_urb_dequeue);
 
 /*-------------------------------------------------------------------------*/
 
@@ -304,8 +287,7 @@ static int ohci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
  * including ED memory, dummy TD, and bulk/intr data toggle
  */
 
-static void
-ohci_endpoint_disable (struct usb_hcd *hcd, struct usb_host_endpoint *ep)
+void ohci_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoint *ep)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	unsigned long		flags;
@@ -364,28 +346,30 @@ sanitize:
 	ep->hcpriv = NULL;
 	spin_unlock_irqrestore (&ohci->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ohci_endpoint_disable);
 
-static int ohci_get_frame (struct usb_hcd *hcd)
+int ohci_get_frame(struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
 	return ohci_frame_no(ohci);
 }
+EXPORT_SYMBOL_GPL(ohci_get_frame);
 
-static void ohci_usb_reset (struct ohci_hcd *ohci)
+void ohci_usb_reset(struct ohci_hcd *ohci)
 {
 	ohci->hc_control = ohci_readl (ohci, &ohci->regs->control);
 	ohci->hc_control &= OHCI_CTRL_RWC;
 	ohci_writel (ohci, ohci->hc_control, &ohci->regs->control);
 	ohci->rh_state = OHCI_RH_HALTED;
 }
+EXPORT_SYMBOL_GPL(ohci_usb_reset);
 
 /* ohci_shutdown forcibly disables IRQs and DMA, helping kexec and
  * other cases where the next software may expect clean state from the
  * "firmware".  this is bus-neutral, unlike shutdown() methods.
  */
-static void
-ohci_shutdown (struct usb_hcd *hcd)
+void ohci_shutdown(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci;
 
@@ -399,6 +383,7 @@ ohci_shutdown (struct usb_hcd *hcd)
 
 	ohci_writel(ohci, ohci->fminterval, &ohci->regs->fminterval);
 }
+EXPORT_SYMBOL_GPL(ohci_shutdown);
 
 static int check_ed(struct ohci_hcd *ohci, struct ed *ed)
 {
@@ -493,7 +478,7 @@ done:
 
 /* init memory, and kick BIOS/SMM off */
 
-static int ohci_init (struct ohci_hcd *ohci)
+int ohci_init (struct ohci_hcd *ohci)
 {
 	int ret;
 	struct usb_hcd *hcd = ohci_to_hcd(ohci);
@@ -563,6 +548,7 @@ static int ohci_init (struct ohci_hcd *ohci)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ohci_init);
 
 /*-------------------------------------------------------------------------*/
 
@@ -570,7 +556,7 @@ static int ohci_init (struct ohci_hcd *ohci)
  * resets USB and controller
  * enable interrupts
  */
-static int ohci_run (struct ohci_hcd *ohci)
+int ohci_run (struct ohci_hcd *ohci)
 {
 	u32			mask, val;
 	int			first = ohci->fminterval == 0;
@@ -740,12 +726,13 @@ retry:
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ohci_run);
 
 /*-------------------------------------------------------------------------*/
 
 /* an interrupt happens */
 
-static irqreturn_t ohci_irq (struct usb_hcd *hcd)
+irqreturn_t ohci_irq (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	struct ohci_regs __iomem *regs = ohci->regs;
@@ -884,10 +871,11 @@ static irqreturn_t ohci_irq (struct usb_hcd *hcd)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(ohci_irq);
 
 /*-------------------------------------------------------------------------*/
 
-static void ohci_stop (struct usb_hcd *hcd)
+void ohci_stop (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
@@ -916,13 +904,14 @@ static void ohci_stop (struct usb_hcd *hcd)
 		ohci->hcca_dma = 0;
 	}
 }
+EXPORT_SYMBOL_GPL(ohci_stop);
 
 /*-------------------------------------------------------------------------*/
 
 #if defined(CONFIG_PM) || defined(CONFIG_PCI)
 
 /* must not be called from interrupt context */
-static int ohci_restart (struct ohci_hcd *ohci)
+int ohci_restart (struct ohci_hcd *ohci)
 {
 	int temp;
 	int i;
@@ -981,7 +970,7 @@ static int ohci_restart (struct ohci_hcd *ohci)
 	ohci_dbg(ohci, "restart complete\n");
 	return 0;
 }
-
+EXPORT_SYMBOL_GPL(ohci_restart);
 #endif
 
 /*-------------------------------------------------------------------------*/
@@ -990,11 +979,6 @@ MODULE_AUTHOR (DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE ("GPL");
 
-#ifdef CONFIG_PCI
-#include "ohci-pci.c"
-#define PCI_DRIVER		ohci_pci_driver
-#endif
-
 #if defined(CONFIG_ARCH_SA1100) && defined(CONFIG_SA1111)
 #include "ohci-sa1111.c"
 #define SA1111_DRIVER		ohci_hcd_sa1111_driver
@@ -1121,19 +1105,6 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_xls_driver
 #endif
 
-#if	!defined(PCI_DRIVER) &&		\
-	!defined(PLATFORM_DRIVER) &&	\
-	!defined(OMAP1_PLATFORM_DRIVER) &&	\
-	!defined(OMAP3_PLATFORM_DRIVER) &&	\
-	!defined(OF_PLATFORM_DRIVER) &&	\
-	!defined(SA1111_DRIVER) &&	\
-	!defined(PS3_SYSTEM_BUS_DRIVER) && \
-	!defined(SM501_OHCI_DRIVER) && \
-	!defined(TMIO_OHCI_DRIVER) && \
-	!defined(SSB_OHCI_DRIVER)
-#error "missing bus glue for ohci-hcd"
-#endif
-
 static int __init ohci_hcd_mod_init(void)
 {
 	int retval = 0;
@@ -1190,12 +1161,6 @@ static int __init ohci_hcd_mod_init(void)
 		goto error_sa1111;
 #endif
 
-#ifdef PCI_DRIVER
-	retval = pci_register_driver(&PCI_DRIVER);
-	if (retval < 0)
-		goto error_pci;
-#endif
-
 #ifdef SSB_OHCI_DRIVER
 	retval = ssb_driver_register(&SSB_OHCI_DRIVER);
 	if (retval)
@@ -1229,10 +1194,6 @@ static int __init ohci_hcd_mod_init(void)
 	ssb_driver_unregister(&SSB_OHCI_DRIVER);
  error_ssb:
 #endif
-#ifdef PCI_DRIVER
-	pci_unregister_driver(&PCI_DRIVER);
- error_pci:
-#endif
 #ifdef SA1111_DRIVER
 	sa1111_driver_unregister(&SA1111_DRIVER);
  error_sa1111:
@@ -1279,9 +1240,6 @@ static void __exit ohci_hcd_mod_exit(void)
 #ifdef SSB_OHCI_DRIVER
 	ssb_driver_unregister(&SSB_OHCI_DRIVER);
 #endif
-#ifdef PCI_DRIVER
-	pci_unregister_driver(&PCI_DRIVER);
-#endif
 #ifdef SA1111_DRIVER
 	sa1111_driver_unregister(&SA1111_DRIVER);
 #endif
diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index 836772d..b7c6c05 100644
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -279,7 +279,7 @@ skip_resume:
 	return 0;
 }
 
-static int ohci_bus_suspend (struct usb_hcd *hcd)
+int ohci_bus_suspend (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	int			rc;
@@ -293,8 +293,9 @@ static int ohci_bus_suspend (struct usb_hcd *hcd)
 	spin_unlock_irq (&ohci->lock);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ohci_bus_suspend);
 
-static int ohci_bus_resume (struct usb_hcd *hcd)
+int ohci_bus_resume (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 	int			rc;
@@ -315,9 +316,10 @@ static int ohci_bus_resume (struct usb_hcd *hcd)
 		usb_hcd_poll_rh_status(hcd);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ohci_bus_resume);
 
 /* Carry out the final steps of resuming the controller device */
-static void ohci_finish_controller_resume(struct usb_hcd *hcd)
+void ohci_finish_controller_resume(struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
 	int			port;
@@ -357,6 +359,7 @@ static void ohci_finish_controller_resume(struct usb_hcd *hcd)
 
 	usb_hcd_resume_root_hub(hcd);
 }
+EXPORT_SYMBOL_GPL(ohci_finish_controller_resume);
 
 /* Carry out polling-, autostop-, and autoresume-related state changes */
 static int ohci_root_hub_state_changes(struct ohci_hcd *ohci, int changed,
@@ -480,8 +483,7 @@ static int ohci_root_hub_state_changes(struct ohci_hcd *ohci, int changed,
 
 /* build "status change" packet (one or two bytes) from HC registers */
 
-static int
-ohci_hub_status_data (struct usb_hcd *hcd, char *buf)
+int ohci_hub_status_data (struct usb_hcd *hcd, char *buf)
 {
 	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
 	int		i, changed = 0, length = 1;
@@ -546,6 +548,7 @@ done:
 
 	return changed ? length : 0;
 }
+EXPORT_SYMBOL_GPL(ohci_hub_status_data);
 
 /*-------------------------------------------------------------------------*/
 
@@ -592,7 +595,7 @@ ohci_hub_descriptor (
 
 #ifdef	CONFIG_USB_OTG
 
-static int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port)
+int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port)
 {
 	struct ohci_hcd	*ohci = hcd_to_ohci (hcd);
 	u32			status;
@@ -610,6 +613,7 @@ static int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port)
 	ohci_writel(ohci, RH_PS_PRS, &ohci->regs->roothub.portstatus [port]);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ohci_start_port_reset);
 
 #else
 
@@ -694,7 +698,7 @@ static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 	return 0;
 }
 
-static int ohci_hub_control (
+int ohci_hub_control (
 	struct usb_hcd	*hcd,
 	u16		typeReq,
 	u16		wValue,
@@ -822,4 +826,5 @@ error:
 	}
 	return retval;
 }
+EXPORT_SYMBOL_GPL(ohci_hub_control);
 
diff --git a/drivers/usb/host/ohci-mem.c b/drivers/usb/host/ohci-mem.c
index 2f20d3d..1a4dede 100644
--- a/drivers/usb/host/ohci-mem.c
+++ b/drivers/usb/host/ohci-mem.c
@@ -23,12 +23,13 @@
 
 /*-------------------------------------------------------------------------*/
 
-static void ohci_hcd_init (struct ohci_hcd *ohci)
+void ohci_hcd_init (struct ohci_hcd *ohci)
 {
 	ohci->next_statechange = jiffies;
 	spin_lock_init (&ohci->lock);
 	INIT_LIST_HEAD (&ohci->pending);
 }
+EXPORT_SYMBOL_GPL(ohci_hcd_init);
 
 /*-------------------------------------------------------------------------*/
 
diff --git a/drivers/usb/host/ohci-pci.c b/drivers/usb/host/ohci-pci.c
index 1843bb6..fa436ea 100644
--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -14,13 +14,35 @@
  * This file is licenced under the GPL.
  */
 
-#ifndef CONFIG_PCI
-#error "This file is PCI bus glue.  CONFIG_PCI must be defined."
-#endif
-
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/pci.h>
-#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/usb.h>
+#include <linux/usb/otg.h>
+#include <linux/usb/hcd.h>
+#include <linux/workqueue.h>
+
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/system.h>
+#include <asm/unaligned.h>
+
+#include "ohci.h"
+#include "pci-quirks.h"
+
+#define DRIVER_AUTHOR "Roman Weissgaerber, David Brownell"
+#define DRIVER_DESC "USB 1.1 'Open' Host Controller (OHCI) Driver"
 
+static const char	hcd_name [] = "ohci_hcd";
+
+MODULE_AUTHOR (DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE ("GPL");
 
 /*-------------------------------------------------------------------------*/
 
@@ -175,19 +197,6 @@ static int ohci_quirk_amd700(struct usb_hcd *hcd)
 	return 0;
 }
 
-static void sb800_prefetch(struct ohci_hcd *ohci, int on)
-{
-	struct pci_dev *pdev;
-	u16 misc;
-
-	pdev = to_pci_dev(ohci_to_hcd(ohci)->self.controller);
-	pci_read_config_word(pdev, 0x50, &misc);
-	if (on == 0)
-		pci_write_config_word(pdev, 0x50, misc & 0xfcff);
-	else
-		pci_write_config_word(pdev, 0x50, misc | 0x0300);
-}
-
 /* List of quirks for OHCI */
 static const struct pci_device_id ohci_pci_quirks[] = {
 	{
@@ -420,3 +429,5 @@ static struct pci_driver ohci_pci_driver = {
 	},
 #endif
 };
+
+module_pci_driver(ohci_pci_driver);
diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index c5a1ea9..e7e86db 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -42,6 +42,7 @@ __releases(ohci->lock)
 __acquires(ohci->lock)
 {
 	// ASSERT (urb->hcpriv != 0);
+	struct usb_bus *bus = &ohci_to_hcd(ohci)->self;
 
 	urb_free_priv (ohci, urb->hcpriv);
 	if (likely(status == -EINPROGRESS))
@@ -49,16 +50,16 @@ __acquires(ohci->lock)
 
 	switch (usb_pipetype (urb->pipe)) {
 	case PIPE_ISOCHRONOUS:
-		ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs--;
-		if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0) {
+		bus->bandwidth_isoc_reqs--;
+		if (bus->bandwidth_isoc_reqs == 0) {
 			if (quirk_amdiso(ohci))
 				usb_amd_quirk_pll_enable();
 			if (quirk_amdprefetch(ohci))
-				sb800_prefetch(ohci, 0);
+				usb_sb800_prefetch(bus->controller, 0);
 		}
 		break;
 	case PIPE_INTERRUPT:
-		ohci_to_hcd(ohci)->self.bandwidth_int_reqs--;
+		bus->bandwidth_int_reqs--;
 		break;
 	}
 
@@ -73,7 +74,7 @@ __acquires(ohci->lock)
 	spin_lock (&ohci->lock);
 
 	/* stop periodic dma if it's not needed */
-	if (ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs == 0
+	if (bus->bandwidth_isoc_reqs == 0
 			&& ohci_to_hcd(ohci)->self.bandwidth_int_reqs == 0) {
 		ohci->hc_control &= ~(OHCI_CTRL_PLE|OHCI_CTRL_IE);
 		ohci_writel (ohci, ohci->hc_control, &ohci->regs->control);
@@ -579,6 +580,7 @@ static void td_submit_urb (
 	struct urb	*urb
 ) {
 	struct urb_priv	*urb_priv = urb->hcpriv;
+	struct usb_bus	*bus = &ohci_to_hcd(ohci)->self;
 	dma_addr_t	data;
 	int		data_len = urb->transfer_buffer_length;
 	int		cnt = 0;
@@ -688,7 +690,7 @@ static void td_submit_urb (
 			if (quirk_amdiso(ohci))
 				usb_amd_quirk_pll_disable();
 			if (quirk_amdprefetch(ohci))
-				sb800_prefetch(ohci, 1);
+				usb_sb800_prefetch(bus->controller, 1);
 		}
 		periodic = ohci_to_hcd(ohci)->self.bandwidth_isoc_reqs++ == 0
 			&& ohci_to_hcd(ohci)->self.bandwidth_int_reqs == 0;
diff --git a/drivers/usb/host/ohci.h b/drivers/usb/host/ohci.h
index 8ff6f7e..0c99267 100644
--- a/drivers/usb/host/ohci.h
+++ b/drivers/usb/host/ohci.h
@@ -723,3 +723,40 @@ static inline u32 roothub_status (struct ohci_hcd *hc)
 	{ return ohci_readl (hc, &hc->regs->roothub.status); }
 static inline u32 roothub_portstatus (struct ohci_hcd *hc, int i)
 	{ return read_roothub (hc, portstatus [i], 0xffe0fce0); }
+
+#ifdef DEBUG
+void ohci_dump(struct ohci_hcd *ohci, int verbose);
+#else
+static inline void ohci_dump(struct ohci_hcd *controller, int verbose) {}
+#undef OHCI_VERBOSE_DEBUG
+#endif /* DEBUG */
+
+/* ohci-hub.c */
+int ohci_bus_suspend(struct usb_hcd *hcd);
+int ohci_bus_resume(struct usb_hcd *hcd);
+void ohci_finish_controller_resume(struct usb_hcd *hcd);
+int ohci_hub_status_data (struct usb_hcd *hcd, char *buf);
+int ohci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue, u16 wIndex, char *buf, u16 wLength);
+#ifdef	CONFIG_USB_OTG
+int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port);
+#else
+#define	ohci_start_port_reset		NULL
+#endif
+
+/* ohci-mem.c */
+void ohci_hcd_init(struct ohci_hcd *ohci);
+
+/* ohci-hcd.c */
+int ohci_init(struct ohci_hcd *ohci);
+void ohci_stop(struct usb_hcd *hcd);
+int ohci_restart(struct ohci_hcd *ohci);
+int ohci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flags);
+int ohci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status);
+void ohci_endpoint_disable(struct usb_hcd *hcd, struct usb_host_endpoint *ep);
+int ohci_get_frame(struct usb_hcd *hcd);
+irqreturn_t ohci_irq (struct usb_hcd *hcd);
+int ohci_run (struct ohci_hcd *ohci);
+void ohci_usb_reset(struct ohci_hcd *ohci);
+void ohci_shutdown(struct usb_hcd *hcd);
+
+
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 7732d69..72f2d7a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -181,6 +181,19 @@ commit:
 }
 EXPORT_SYMBOL_GPL(usb_amd_find_chipset_info);
 
+void usb_sb800_prefetch(struct device *dev, int on)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u16 misc;
+
+	pci_read_config_word(pdev, 0x50, &misc);
+	if (on == 0)
+		pci_write_config_word(pdev, 0x50, misc & 0xfcff);
+	else
+		pci_write_config_word(pdev, 0x50, misc | 0x0300);
+}
+EXPORT_SYMBOL_GPL(usb_sb800_prefetch);
+
 /*
  * The hardware normally enables the A-link power management feature, which
  * lets the system lower the power consumption in idle states.
diff --git a/drivers/usb/host/pci-quirks.h b/drivers/usb/host/pci-quirks.h
index b1002a8..c473b0b 100644
--- a/drivers/usb/host/pci-quirks.h
+++ b/drivers/usb/host/pci-quirks.h
@@ -8,12 +8,14 @@ int usb_amd_find_chipset_info(void);
 void usb_amd_dev_put(void);
 void usb_amd_quirk_pll_disable(void);
 void usb_amd_quirk_pll_enable(void);
+void usb_sb800_prefetch(struct device *dev, int on);
 bool usb_is_intel_switchable_xhci(struct pci_dev *pdev);
 void usb_enable_xhci_ports(struct pci_dev *xhci_pdev);
 #else
 static inline void usb_amd_quirk_pll_disable(void) {}
 static inline void usb_amd_quirk_pll_enable(void) {}
 static inline void usb_amd_dev_put(void) {}
+static inline void usb_sb800_prefetch(struct device *dev, int on) {}
 #endif  /* CONFIG_PCI */
 
 #endif  /*  __LINUX_USB_PCI_QUIRKS_H  */
