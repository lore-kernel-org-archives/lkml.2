Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2BXJi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:38:57 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:58079 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756298Ab2BXJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:38:55 -0500
From: Viresh Kumar <viresh.kumar@st.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <armando.visconti@st.com>, <shiraz.hashim@st.com>,
        <vipin.kumar@st.com>, <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <bhavna.yadav@st.com>,
        <vincenzo.frascino@st.com>, <mirko.gardi@st.com>,
        <salvatore.dedominicis@st.com>
Subject: [PATCH] USB: ehci-spear: Add PM support
Date: Fri, 24 Feb 2012 14:49:31 +0530
Message-ID: <120edceab87bd3ef0559f87dc81bf31e9518f507.1330075010.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.8.110.g4cb5d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Sikri <deepak.sikri@st.com>

This patch adds support for standby/S2R/hibernate for ehci-spear driver.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/usb/host/ehci-spear.c |   83 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index b115b0b..6e92855 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -11,8 +11,10 @@
 * more details.
 */
 
-#include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
 
 struct spear_ehci {
 	struct ehci_hcd ehci;
@@ -90,6 +92,82 @@ static const struct hc_driver ehci_spear_hc_driver = {
 	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
 };
 
+#ifdef CONFIG_PM
+static int ehci_spear_drv_suspend(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	unsigned long flags;
+	int rc = 0;
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(10);
+
+	/*
+	 * Root hub was already suspended. Disable irq emission and mark HW
+	 * unaccessible. The PM and USB cores make sure that the root hub is
+	 * either suspended or stopped.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
+	ehci_prepare_ports_for_controller_suspend(ehci, device_may_wakeup(dev));
+	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
+	ehci_readl(ehci, &ehci->regs->intr_enable);
+	spin_unlock_irqrestore(&ehci->lock, flags);
+
+	return rc;
+}
+
+static int ehci_spear_drv_resume(struct device *dev)
+{
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+
+	if (time_before(jiffies, ehci->next_statechange))
+		msleep(100);
+
+	if (ehci_readl(ehci, &ehci->regs->configured_flag) == FLAG_CF) {
+		int mask = INTR_MASK;
+
+		ehci_prepare_ports_for_controller_resume(ehci);
+
+		if (!hcd->self.root_hub->do_remote_wakeup)
+			mask &= ~STS_PCD;
+
+		ehci_writel(ehci, mask, &ehci->regs->intr_enable);
+		ehci_readl(ehci, &ehci->regs->intr_enable);
+		return 0;
+	}
+
+	usb_root_hub_lost_power(hcd->self.root_hub);
+
+	/*
+	 * Else reset, to cope with power loss or flush-to-storage style
+	 * "resume" having let BIOS kick in during reboot.
+	 */
+	ehci_halt(ehci);
+	ehci_reset(ehci);
+
+	/* emptying the schedule aborts any urbs */
+	spin_lock_irq(&ehci->lock);
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
+	ehci_work(ehci);
+	spin_unlock_irq(&ehci->lock);
+
+	ehci_writel(ehci, ehci->command, &ehci->regs->command);
+	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
+	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+
+	/* here we "know" root ports should always stay powered */
+	ehci_port_power(ehci, 1);
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(ehci_spear_pm_ops, ehci_spear_drv_suspend,
+		ehci_spear_drv_resume);
+
 static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd ;
@@ -205,7 +283,8 @@ static struct platform_driver spear_ehci_hcd_driver = {
 	.shutdown	= usb_hcd_platform_shutdown,
 	.driver		= {
 		.name = "spear-ehci",
-		.bus = &platform_bus_type
+		.bus = &platform_bus_type,
+		.pm = &ehci_spear_pm_ops,
 	}
 };
 
-- 
1.7.8.110.g4cb5d

