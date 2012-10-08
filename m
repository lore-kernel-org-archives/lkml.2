Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab2JHNVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:21:01 -0400
Received: from zmc.proxad.net ([212.27.53.206]:32895 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2JHNN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:13:29 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/32 v4] USB: EHCI: add no_io_watchdog platform_data parameter to ehci-platform
Date: Mon,  8 Oct 2012 15:11:21 +0200
Message-Id: <1349701906-16481-8-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349701906-16481-1-git-send-email-florian@openwrt.org>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the ehci-platform driver to also accept no_io_watchdog as a platform
data parameter. When no_io_watchdog is set to 1, the ehci controller will set
ehci->need_io_watchdog to 0. Since most EHCI controllers do need the I/O
watchdog to be on, only let those which need it to turn the watchdog off.

Make sure that we change need_io_watchdog after the call to ehci_setup()
because ehci_setup() will unconditionnaly set need_io_watchdog to 1.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes in v4:
- rebased against greg's latest usb-next

Changes in v3:
- set need_io_watchdog after the call to ehci_setup()

Changes in v2:
- reworked patch to introduce "no_io_watchdog" instead of "need_io_watchdog"
- reworded commit message accordingly

 drivers/usb/host/ehci-platform.c |    2 ++
 include/linux/usb/ehci_pdriver.h |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 764e010..607adf9 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -38,6 +38,8 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
 	if (retval)
 		return retval;
 
+	if (pdata->no_io_watchdog)
+		ehci->need_io_watchdog = 0;
 	if (pdata->port_power_on)
 		ehci_port_power(ehci, 1);
 	if (pdata->port_power_off)
diff --git a/include/linux/usb/ehci_pdriver.h b/include/linux/usb/ehci_pdriver.h
index c9d09f8..67ac74b 100644
--- a/include/linux/usb/ehci_pdriver.h
+++ b/include/linux/usb/ehci_pdriver.h
@@ -29,6 +29,8 @@
  *			initialization.
  * @port_power_off:	set to 1 if the controller needs to be powered down
  *			after initialization.
+ * @no_io_watchdog:	set to 1 if the controller does not need the I/O
+ *			watchdog to run.
  *
  * These are general configuration options for the EHCI controller. All of
  * these options are activating more or less workarounds for some hardware.
@@ -41,6 +43,7 @@ struct usb_ehci_pdata {
 	unsigned	big_endian_mmio:1;
 	unsigned	port_power_on:1;
 	unsigned	port_power_off:1;
+	unsigned	no_io_watchdog:1;
 
 	/* Turn on all power and clocks */
 	int (*power_on)(struct platform_device *pdev);
-- 
1.7.9.5

