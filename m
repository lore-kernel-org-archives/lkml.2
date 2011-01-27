Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1A0LM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 06:12:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38610 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab1A0LMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 06:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eZ3e/VQfJPuiS9wSO6OaKMhdGjaqJ3DuELiVUzlZop1qCxDNcCQQrhKlZSX3p+qQUQ
         klOYPXRXpjfENkT8ASp2kMqbteuGt4qcXsbYkVTqgPukJDlcqTS5mgIuUmtx+orxFHLE
         jWAK2MBhrVZqM1cUaRejjfGZF9dX9WwKIZJPI=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: gregkh@suse.de, dbrownell@users.sourceforge.net, ust@denx.de,
        pkondeti@codeaurora.org, stern@rowland.harvard.edu, gadiyar@ti.com,
        alek.du@intel.com, jacob.jun.pan@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH v3] EHCI bus glue for on-chip PMC MSP USB controller.
Date: Thu, 27 Jan 2011 16:58:56 +0530
Message-Id: <1296127736-28208-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTimu_gzsd3NY+HDp7jV+EMtrHGZq7qNc3OedyT3C@mail.gmail.com>
References: <AANLkTimu_gzsd3NY+HDp7jV+EMtrHGZq7qNc3OedyT3C@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
Tested-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 drivers/usb/host/Kconfig       |   15 +-
 drivers/usb/host/ehci-hcd.c    |    7 +
 drivers/usb/host/ehci-pmcmsp.c |  552 ++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci.h        |    3 +
 4 files changed, 575 insertions(+), 2 deletions(-)
 create mode 100644 drivers/usb/host/ehci-pmcmsp.c

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 24046c0..1f73127 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -91,17 +91,28 @@ config USB_EHCI_TT_NEWSCHED
 
 	  If unsure, say Y.
 
+config USB_EHCI_HCD_PMC_MSP
+	tristate "EHCI support for on-chip PMC MSP USB controller"
+	depends on USB_EHCI_HCD && MSP_HAS_USB
+	default y
+	select USB_EHCI_BIG_ENDIAN_DESC
+	select USB_EHCI_BIG_ENDIAN_MMIO
+	---help---
+		Enables support for the onchip USB controller on the PMC_MSP7100 Family SoC's.
+		If unsure, say N.
+
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
 	depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
 				    ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x || CPU_CAVIUM_OCTEON)
+				    PPC_MPC512x || CPU_CAVIUM_OCTEON || \
+				    PMC_MSP)
 	default y
 
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
 	depends on USB_EHCI_HCD && (440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
-				    PPC_MPC512x)
+				    PPC_MPC512x || PMC_MSP)
 	default y
 
 config XPS_USB_HCD_XILINX
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6fee3cd..a591890 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -262,6 +262,8 @@ static void tdi_reset (struct ehci_hcd *ehci)
 	if (ehci_big_endian_mmio(ehci))
 		tmp |= USBMODE_BE;
 	ehci_writel(ehci, tmp, reg_ptr);
+	if (ehci->pmc_msp_tdi)
+		usb_hcd_tdi_set_mode(ehci);
 }
 
 /* reset a non-running (STS_HALT == 1) controller */
@@ -1249,6 +1251,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ehci_msm_driver
 #endif
 
+#ifdef CONFIG_USB_EHCI_HCD_PMC_MSP
+#include "ehci-pmcmsp.c"
+#define	PLATFORM_DRIVER		ehci_hcd_msp_driver
+#endif
+
 #if !defined(PCI_DRIVER) && !defined(PLATFORM_DRIVER) && \
     !defined(PS3_SYSTEM_BUS_DRIVER) && !defined(OF_PLATFORM_DRIVER) && \
     !defined(XILINX_OF_PLATFORM_DRIVER)
diff --git a/drivers/usb/host/ehci-pmcmsp.c b/drivers/usb/host/ehci-pmcmsp.c
new file mode 100644
index 0000000..28dd26c
--- /dev/null
+++ b/drivers/usb/host/ehci-pmcmsp.c
@@ -0,0 +1,552 @@
+/*
+ * PMC MSP EHCI (Host Controller Driver) for USB.
+ *
+ * (C) Copyright 2006-2010 PMC-Sierra Inc
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ * WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ * NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ * USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ * ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the  GNU General Public License along
+ * with this program; if not, write  to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <msp_usb.h>
+
+/* includes */
+#define USB_CTRL_MODE_HOST		0x3
+					/* host mode */
+#define USB_CTRL_MODE_BIG_ENDIAN	0x4
+					/* big endian */
+#define USB_CTRL_MODE_STREAM_DISABLE	0x10
+					/* stream disable*/
+#define USB_CTRL_FIFO_THRESH		0x00300000
+					/* thresh hold */
+#define USB_EHCI_REG_USB_MODE		0x68
+					/* register offset for usb_mode */
+#define USB_EHCI_REG_USB_FIFO		0x24
+					/* register offset for usb fifo */
+#define USB_EHCI_REG_USB_STATUS		0x44
+					/* register offset for usb status */
+#define USB_EHCI_REG_BIT_STAT_STS	(1<<29)
+					/* serial/parallel transceiver */
+#define MSP_PIN_USB0_HOST_DEV		49
+					/* TWI USB0 host device pin */
+#define MSP_PIN_USB1_HOST_DEV		50
+					/* TWI USB1 host device pin */
+
+extern int usb_disabled(void);
+
+void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci)
+{
+	u8 *base;
+	u8 *statreg;
+	u8 *fiforeg;
+	u32 val;
+	struct ehci_regs *reg_base = ehci->regs;
+
+	/* get register base */
+	base = (u8 *)reg_base + USB_EHCI_REG_USB_MODE;
+	statreg = (u8 *)reg_base + USB_EHCI_REG_USB_STATUS;
+	fiforeg = (u8 *)reg_base + USB_EHCI_REG_USB_FIFO;
+
+	/* set the controller to host mode and BIG ENDIAN */
+	ehci_writel(ehci, (USB_CTRL_MODE_HOST | USB_CTRL_MODE_BIG_ENDIAN
+		| USB_CTRL_MODE_STREAM_DISABLE), (u32 *)base);
+
+	/* clear STS to select parallel transceiver interface */
+	val = ehci_readl(ehci, (u32 *)statreg);
+	val = val & ~USB_EHCI_REG_BIT_STAT_STS;
+	ehci_writel(ehci, val, (u32 *)statreg);
+
+	/* write to set the proper fifo threshold */
+	ehci_writel(ehci, USB_CTRL_FIFO_THRESH, (u32 *)fiforeg);
+
+	/* set TWI GPIO USB_HOST_DEV pin high */
+	gpio_direction_output(MSP_PIN_USB0_HOST_DEV, 1);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_direction_output(MSP_PIN_USB1_HOST_DEV, 1);
+#endif
+}
+
+/* called after powerup, by probe or system-pm "wakeup" */
+static int ehci_msp_reinit(struct ehci_hcd *ehci)
+{
+	ehci_port_power(ehci, 0);
+
+	return 0;
+}
+
+/* called during probe() after chip reset completes */
+static int ehci_msp_setup(struct usb_hcd *hcd)
+{
+	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
+	u32			temp;
+	int			retval;
+	ehci->big_endian_mmio = 1;
+	ehci->big_endian_desc = 1;
+	ehci->pmc_msp_tdi = 1;
+
+	ehci->caps = hcd->regs;
+	ehci->regs = hcd->regs +
+			HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+	dbg_hcs_params(ehci, "reset");
+	dbg_hcc_params(ehci, "reset");
+
+	/* cache this readonly data; minimize chip reads */
+	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
+	hcd->has_tt = 1;
+	tdi_reset(ehci);
+
+	retval = ehci_halt(ehci);
+	if (retval)
+		return retval;
+
+	ehci_reset(ehci);
+
+	/* data structure init */
+	retval = ehci_init(hcd);
+	if (retval)
+		return retval;
+
+	temp = HCS_N_CC(ehci->hcs_params) * HCS_N_PCC(ehci->hcs_params);
+	temp &= 0x0f;
+	if (temp && HCS_N_PORTS(ehci->hcs_params) > temp) {
+		ehci_dbg(ehci, "bogus port configuration: "
+			"cc=%d x pcc=%d < ports=%d\n",
+			HCS_N_CC(ehci->hcs_params),
+			HCS_N_PCC(ehci->hcs_params),
+			HCS_N_PORTS(ehci->hcs_params));
+	}
+
+	retval = ehci_msp_reinit(ehci);
+
+	return retval;
+}
+
+/*-------------------------------------------------------------------------*/
+
+static void msp_start_hc(struct platform_device *dev)
+{
+	printk(KERN_DEBUG __FILE__
+		   ": starting PMC MSP EHCI USB Controller\n");
+
+	/*
+	 * Now, carefully enable the USB clock, and take
+	 * the USB host controller out of reset.
+	 */
+	printk(KERN_DEBUG __FILE__
+			": Clock to USB host has been enabled\n");
+}
+
+static void msp_stop_hc(struct platform_device *dev)
+{
+	printk(KERN_DEBUG __FILE__
+		   ": stopping PMC MSP EHCI USB Controller\n");
+}
+
+
+/*-------------------------------------------------------------------------*/
+
+/*-------------------------------------------------------------------------*/
+
+#ifdef	CONFIG_PM
+
+/* suspend/resume, section 4.3 */
+
+/* These routines rely on the bus glue
+ * to handle powerdown and wakeup, and currently also on
+ * transceivers that don't need any software attention to set up
+ * the right sort of wakeup.
+ * Also they depend on separate root hub suspend/resume.
+ */
+static int ehci_msp_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	unsigned long flags;
+	int rc;
+
+	return 0;
+	rc = 0;
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(10);
+
+	/* Root hub was already suspended. Disable irq emission and
+	 * mark HW unaccessible.  The PM and USB cores make sure that
+	 * the root hub is either suspended or stopped.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+	ehci_prepare_ports_for_controller_suspend(ehci, device_may_wakeup(dev));
+	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
+
+	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	/* could save FLADJ in case of Vaux power loss
+	... we'd only use it to handle clock skew */
+
+	return rc;
+}
+
+static int ehci_msp_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+
+
+	/* maybe restore FLADJ */
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(100);
+
+	/* Mark hardware accessible again as we are out of D3 state by now */
+	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+
+	/* If CF is still set, we maintained PCI Vaux power.
+	 * Just undo the effect of ehci_pci_suspend().
+	 */
+	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF) {
+		int	mask = INTR_MASK;
+
+		ehci_prepare_ports_for_controller_resume(ehci);
+		if (!hcd->self.root_hub->do_remote_wakeup)
+			mask &= ~STS_PCD;
+		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
+		ehci_readl(ehci, &ehci->regs->intr_enable);
+		return 0;
+	}
+
+	ehci_dbg(ehci, "lost power, restarting\n");
+	usb_root_hub_lost_power(hcd->self.root_hub);
+
+	/* Else reset, to cope with power loss or flush-to-storage
+	 * style "resume" having let BIOS kick in during reboot.
+	 */
+	(void) ehci_halt(ehci);
+	(void) ehci_reset(ehci);
+	(void) ehci_msp_reinit(ehci);
+
+	/* emptying the schedule aborts any urbs */
+	spin_lock_irq(&ehci->lock);
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+	ehci_work(ehci);
+	spin_unlock_irq(&ehci->lock);
+
+	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+
+	/* here we "know" root ports should always stay powered */
+	ehci_port_power(ehci, 1);
+
+	hcd->state = HC_STATE_SUSPENDED;
+
+	return 0;
+}
+
+static const struct dev_pm_ops ehci_msp_pmops = {
+	.suspend	= ehci_msp_suspend,
+	.resume		= ehci_msp_resume,
+};
+#endif
+
+
+/* configure so an HC device and id are always provided */
+/* always called with process context; sleeping is OK */
+
+static int usb_hcd_msp_map_regs(struct mspusb_device *dev)
+{
+	struct resource *res;
+	struct platform_device *pdev = &dev->dev;
+	u32 res_len;
+	int retval;
+
+	/* MAB register space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (res == NULL)
+		return -ENOMEM;
+	res_len = res->end - res->start + 1;
+	if (!request_mem_region(res->start, res_len, "mab regs"))
+		return -EBUSY;
+
+	dev->mab_regs = ioremap_nocache(res->start, res_len);
+	if (dev->mab_regs == NULL) {
+		retval = -ENOMEM;
+		goto err1;
+	}
+
+	/* MSP USB register space */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	if (res == NULL) {
+		retval = -ENOMEM;
+		goto err2;
+	}
+	res_len = res->end - res->start + 1;
+	if (!request_mem_region(res->start, res_len, "usbid regs")) {
+		retval = -EBUSY;
+		goto err2;
+	}
+	dev->usbid_regs = ioremap_nocache(res->start, res_len);
+	if (dev->usbid_regs == NULL) {
+		retval = -ENOMEM;
+		goto err3;
+	}
+
+	return 0;
+err3:
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
+	res_len = res->end - res->start + 1;
+	release_mem_region(res->start, res_len);
+err2:
+	iounmap(dev->mab_regs);
+err1:
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	res_len = res->end - res->start + 1;
+	release_mem_region(res->start, res_len);
+	dev_err(&pdev->dev, "Failed to map non-EHCI regs.\n");
+	return retval;
+}
+
+/**
+ * usb_hcd_msp_probe - initialize PMC MSP-based HCDs
+ * Context: !in_interrupt()
+ *
+ * Allocates basic resources for this USB host controller, and
+ * then invokes the start() method for the HCD associated with it
+ * through the hotplug entry's driver_data.
+ *
+ */
+int usb_hcd_msp_probe(const struct hc_driver *driver,
+			  struct platform_device *dev)
+{
+	int retval;
+	struct usb_hcd *hcd;
+	struct resource *res;
+	struct ehci_hcd		*ehci ;
+
+	hcd = usb_create_hcd(driver, &dev->dev, "pmcmsp");
+	if (!hcd)
+		return -ENOMEM;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		pr_debug("No IOMEM resource info for %s.\n", dev->name);
+		retval = -ENOMEM;
+		goto err1;
+	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = res->end - res->start + 1;
+	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, dev->name)) {
+		retval = -EBUSY;
+		goto err1;
+	}
+	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
+	if (!hcd->regs) {
+		pr_debug("ioremap failed");
+		retval = -ENOMEM;
+		goto err2;
+	}
+	msp_start_hc(dev);
+
+	res = platform_get_resource(dev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&dev->dev, "No IRQ resource info for %s.\n", dev->name);
+		retval = -ENOMEM;
+		goto err3;
+	}
+
+	/* Map non-EHCI register spaces */
+	retval = usb_hcd_msp_map_regs(to_mspusb_device(dev));
+	if (retval != 0)
+		goto err3;
+
+	ehci = hcd_to_ehci(hcd);
+	ehci->big_endian_mmio = 1;
+	ehci->big_endian_desc = 1;
+
+
+	retval = usb_add_hcd(hcd, res->start, IRQF_SHARED);
+	if (retval == 0)
+		return 0;
+
+	usb_remove_hcd(hcd);
+err3:
+	msp_stop_hc(dev);
+	iounmap(hcd->regs);
+err2:
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+err1:
+	usb_put_hcd(hcd);
+
+	return retval;
+}
+
+
+/* may be called without controller electrically present */
+/* may be called with controller, bus, and devices active */
+
+/**
+ * usb_hcd_msp_remove - shutdown processing for PMC MSP-based HCDs
+ * @dev: USB Host Controller being removed
+ * Context: !in_interrupt()
+ *
+ * Reverses the effect of usb_hcd_msp_probe(), first invoking
+ * the HCD's stop() method.  It is always called from a thread
+ * context, normally "rmmod", "apmd", or something similar.
+ *
+ */
+void usb_hcd_msp_remove(struct usb_hcd *hcd, struct platform_device *dev)
+{
+	usb_remove_hcd(hcd);
+	msp_stop_hc(dev);
+	iounmap(hcd->regs);
+	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
+	usb_put_hcd(hcd);
+}
+
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+/*-------------------------------------------------------------------------*/
+/*
+ * Wrapper around the main ehci_irq.  Since both USB host controllers are
+ * sharing the same IRQ, need to first determine whether we're the intended
+ * recipient of this interrupt.
+ */
+static irqreturn_t ehci_msp_irq(struct usb_hcd *hcd)
+{
+	u32 int_src;
+	struct device *dev = hcd->self.controller;
+	struct platform_device *pdev;
+	struct mspusb_device *mdev;
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+
+	/* need to reverse-map a couple of containers to get our device */
+	pdev = to_platform_device(dev);
+	mdev = to_mspusb_device(pdev);
+
+	/* Check to see if this interrupt is for this host controller */
+	int_src = ehci_readl(ehci, &mdev->mab_regs->int_stat);
+	if (int_src & (1 << pdev->id))
+		return ehci_irq(hcd);
+
+	/* Not for this device */
+	return IRQ_NONE;
+}
+/*-------------------------------------------------------------------------*/
+#endif /* DUAL_USB */
+
+static const struct hc_driver ehci_msp_hc_driver = {
+	.description =		hcd_name,
+	.product_desc =		"PMC MSP EHCI",
+	.hcd_priv_size =	sizeof(struct ehci_hcd),
+
+	/*
+	 * generic hardware linkage
+	 */
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	.irq =			ehci_msp_irq,
+#else
+	.irq =			ehci_irq,
+#endif
+	.flags =		HCD_MEMORY | HCD_USB2,
+
+	/*
+	 * basic lifecycle operations
+	 */
+	.reset =		ehci_msp_setup,
+	.start =		ehci_run,
+	.shutdown		= ehci_shutdown,
+	.start			= ehci_run,
+	.stop			= ehci_stop,
+
+	/*
+	 * managing i/o requests and associated device resources
+	 */
+	.urb_enqueue		= ehci_urb_enqueue,
+	.urb_dequeue		= ehci_urb_dequeue,
+	.endpoint_disable	= ehci_endpoint_disable,
+	.endpoint_reset		= ehci_endpoint_reset,
+
+	/*
+	 * scheduling support
+	 */
+	.get_frame_number	= ehci_get_frame,
+
+	/*
+	 * root hub support
+	 */
+	.hub_status_data	= ehci_hub_status_data,
+	.hub_control		= ehci_hub_control,
+	.bus_suspend		= ehci_bus_suspend,
+	.bus_resume		= ehci_bus_resume,
+	.relinquish_port	= ehci_relinquish_port,
+	.port_handed_over	= ehci_port_handed_over,
+
+	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
+};
+
+static int ehci_hcd_msp_drv_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	pr_debug("In ehci_hcd_msp_drv_probe");
+
+	if (usb_disabled())
+		return -ENODEV;
+
+	gpio_request(MSP_PIN_USB0_HOST_DEV, "USB0_HOST_DEV_GPIO");
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_request(MSP_PIN_USB1_HOST_DEV, "USB1_HOST_DEV_GPIO");
+#endif
+
+	ret = usb_hcd_msp_probe(&ehci_msp_hc_driver, pdev);
+
+	return ret;
+}
+
+static int ehci_hcd_msp_drv_remove(struct platform_device *pdev)
+{
+	struct usb_hcd *hcd = platform_get_drvdata(pdev);
+
+	usb_hcd_msp_remove(hcd, pdev);
+
+	/* free TWI GPIO USB_HOST_DEV pin */
+	gpio_free(MSP_PIN_USB0_HOST_DEV);
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+	gpio_free(MSP_PIN_USB1_HOST_DEV);
+#endif
+
+	return 0;
+}
+
+MODULE_ALIAS("pmcmsp-ehci");
+
+static struct platform_driver ehci_hcd_msp_driver = {
+	.probe		= ehci_hcd_msp_drv_probe,
+	.remove		= ehci_hcd_msp_drv_remove,
+	.driver		= {
+		.name	= "pmcmsp-ehci",
+		.owner	= THIS_MODULE,
+#ifdef	CONFIG_PM
+		.pm	= &ehci_msp_pmops,
+#endif
+	},
+};
diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 799ac16..1b71d6a 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -134,6 +134,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		amd_l1_fix:1;
 	unsigned		fs_i_thresh:1;	/* Intel iso scheduling */
 	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
+	unsigned		pmc_msp_tdi:1;	/* PMC MSP tdi quirk*/
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -162,6 +163,8 @@ struct ehci_hcd {			/* one per controller */
 #endif
 };
 
+extern void usb_hcd_tdi_set_mode(struct ehci_hcd *ehci);
+
 /* convert between an HCD pointer and the corresponding EHCI_HCD */
 static inline struct ehci_hcd *hcd_to_ehci (struct usb_hcd *hcd)
 {
-- 
1.7.0.4

