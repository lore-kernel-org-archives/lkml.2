Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422742Ab2JDPZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:25:42 -0400
Received: from zmc.proxad.net ([212.27.53.206]:34639 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965609Ab2JDPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:19:22 -0400
From: Florian Fainelli <florian@openwrt.org>
To: stern@rowland.harvard.edu
Cc: linux-usb@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/24 v2] USB: EHCI: add no_io_watchdog platform_data parameter to ehci-platform
Date: Thu,  4 Oct 2012 17:17:34 +0200
Message-Id: <1349363872-27004-7-git-send-email-florian@openwrt.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349363872-27004-1-git-send-email-florian@openwrt.org>
References: <1349363872-27004-1-git-send-email-florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance the ehci-platform driver to also accept no_io_watchdog as a platform
data parameter. When no_io_watchdog is set to 1, the ehci controller will set
ehci->need_io_watchdog to 0. Since most EHCI controllers do need the I/O
watchdog to be on, only let those which need it to turn the watchdog off.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
Changes since v1:
- reworked patch to introduce "no_io_watchdog" instead of "need_io_watchdog"
- reworded commit message accordingly

 drivers/usb/host/ehci-platform.c |    2 ++
 include/linux/usb/ehci_pdriver.h |    3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index 764e010..83b486e 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -32,6 +32,8 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
 	ehci->has_synopsys_hc_bug = pdata->has_synopsys_hc_bug;
 	ehci->big_endian_desc = pdata->big_endian_desc;
 	ehci->big_endian_mmio = pdata->big_endian_mmio;
+	if (pdata->no_io_watchdog)
+		ehci->need_io_watchdog = 0;
 
 	ehci->caps = hcd->regs + pdata->caps_offset;
 	retval = ehci_setup(hcd);
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

