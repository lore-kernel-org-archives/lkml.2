Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1A0JTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:19:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:15424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1A0JTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:19:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,385,1291622400"; 
   d="scan'208";a="596943723"
From: Yin Kangkai <kangkai.yin@intel.com>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, Yin Kangkai <kangkai.yin@intel.com>
Subject: [PATCH] USB: EHCI: fix scheduling while atomic during suspend
Date: Thu, 27 Jan 2011 17:18:59 +0800
Message-Id: <1296119939-28732-1-git-send-email-kangkai.yin@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a msleep with spin lock held during ehci pci suspend, which will
cause kernel BUG: scheduling while atomic. Fix that.

[  184.139620] BUG: scheduling while atomic: kworker/u:11/416/0x00000002
[  184.139632] 4 locks held by kworker/u:11/416:
[  184.139640]  #0:  (events_unbound){+.+.+.}, at: [<c104ddd4>] process_one_work+0x1b3/0x4cb
[  184.139669]  #1:  ((&entry->work)){+.+.+.}, at: [<c104ddd4>] process_one_work+0x1b3/0x4cb
[  184.139686]  #2:  (&__lockdep_no_validate__){+.+.+.}, at: [<c127cde3>] __device_suspend+0x2c/0x154
[  184.139706]  #3:  (&(&ehci->lock)->rlock){-.-...}, at: [<c132f3d8>] ehci_pci_suspend+0x35/0x7b
[  184.139725] Modules linked in: serio_raw pegasus joydev mrst_gfx(C) battery
[  184.139748] irq event stamp: 52
[  184.139753] hardirqs last  enabled at (51): [<c14fdaac>] mutex_lock_nested+0x258/0x293
[  184.139766] hardirqs last disabled at (52): [<c14fe7b4>] _raw_spin_lock_irqsave+0xf/0x3e
[  184.139777] softirqs last  enabled at (0): [<c10371c1>] copy_process+0x3d2/0x109d
[  184.139789] softirqs last disabled at (0): [<  (null)>]   (null)
[  184.139802] Pid: 416, comm: kworker/u:11 Tainted: G         C  2.6.37-6.3-adaptation-oaktrail #37
[  184.139809] Call Trace:
[  184.139820]  [<c102eeff>] __schedule_bug+0x5e/0x65
[  184.139829]  [<c14fbca5>] schedule+0xac/0xc4c
[  184.139840]  [<c11d4845>] ? string+0x37/0x8b
[  184.139853]  [<c1044f21>] ? lock_timer_base+0x1f/0x3e
[  184.139863]  [<c14fe7da>] ? _raw_spin_lock_irqsave+0x35/0x3e
[  184.139876]  [<c1061590>] ? trace_hardirqs_off+0xb/0xd
[  184.139885]  [<c14fccdc>] schedule_timeout+0x283/0x2d9
[  184.139896]  [<c104516f>] ? process_timeout+0x0/0xa
[  184.139906]  [<c14fcd47>] schedule_timeout_uninterruptible+0x15/0x17
[  184.139916]  [<c104566a>] msleep+0x10/0x16
[  184.139926]  [<c132f316>] ehci_adjust_port_wakeup_flags+0x69/0xf6
[  184.139937]  [<c132f3eb>] ehci_pci_suspend+0x48/0x7b
[  184.139946]  [<c1326587>] suspend_common+0x52/0xbb
[  184.139956]  [<c1326625>] hcd_pci_suspend+0x26/0x28
[  184.139967]  [<c11e7182>] pci_pm_suspend+0x5f/0xd0
[  184.139976]  [<c127ca3a>] pm_op+0x5d/0xf0
[  184.139986]  [<c127ceac>] __device_suspend+0xf5/0x154
[  184.139996]  [<c127d2c8>] async_suspend+0x16/0x3a
[  184.140006]  [<c1058f54>] async_run_entry_fn+0x89/0x111
[  184.140016]  [<c104deb6>] process_one_work+0x295/0x4cb
[  184.140026]  [<c1058ecb>] ? async_run_entry_fn+0x0/0x111
[  184.140036]  [<c104e3d0>] worker_thread+0x17f/0x298
[  184.140045]  [<c104e251>] ? worker_thread+0x0/0x298
[  184.140055]  [<c105277f>] kthread+0x64/0x69
[  184.140064]  [<c105271b>] ? kthread+0x0/0x69
[  184.140075]  [<c1002efa>] kernel_thread_helper+0x6/0x1a

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
---
 drivers/usb/host/ehci-au1xxx.c |    2 +-
 drivers/usb/host/ehci-hub.c    |   11 ++++++++++-
 drivers/usb/host/ehci-pci.c    |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-au1xxx.c b/drivers/usb/host/ehci-au1xxx.c
index 2baf8a8..a869e3c 100644
--- a/drivers/usb/host/ehci-au1xxx.c
+++ b/drivers/usb/host/ehci-au1xxx.c
@@ -227,8 +227,8 @@ static int ehci_hcd_au1xxx_drv_suspend(struct device *dev)
 	 * mark HW unaccessible.  The PM and USB cores make sure that
 	 * the root hub is either suspended or stopped.
 	 */
-	spin_lock_irqsave(&ehci->lock, flags);
 	ehci_prepare_ports_for_controller_suspend(ehci, device_may_wakeup(dev));
+	spin_lock_irqsave(&ehci->lock, flags);
 	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
 	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
 
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 86f0815..a16c94a 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -111,14 +111,19 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 {
 	int		port;
 	u32		temp;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&ehci->lock, flags);
 
 	/* If remote wakeup is enabled for the root hub but disabled
 	 * for the controller, we must adjust all the port wakeup flags
 	 * when the controller is suspended or resumed.  In all other
 	 * cases they don't need to be changed.
 	 */
-	if (!ehci_to_hcd(ehci)->self.root_hub->do_remote_wakeup || do_wakeup)
+	if (!ehci_to_hcd(ehci)->self.root_hub->do_remote_wakeup || do_wakeup) {
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return;
+	}
 
 	/* clear phy low-power mode before changing wakeup flags */
 	if (ehci->has_hostpc) {
@@ -131,7 +136,9 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 			temp = ehci_readl(ehci, hostpc_reg);
 			ehci_writel(ehci, temp & ~HOSTPC_PHCD, hostpc_reg);
 		}
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		msleep(5);
+		spin_lock_irqsave(&ehci->lock, flags);
 	}
 
 	port = HCS_N_PORTS(ehci->hcs_params);
@@ -170,6 +177,8 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
 	/* Does the root hub have a port wakeup pending? */
 	if (!suspending && (ehci_readl(ehci, &ehci->regs->status) & STS_PCD))
 		usb_hcd_resume_root_hub(ehci_to_hcd(ehci));
+
+	spin_unlock_irqrestore(&ehci->lock, flags);
 }
 
 static int ehci_bus_suspend (struct usb_hcd *hcd)
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index c84add2..b59d538 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -380,8 +380,8 @@ static int ehci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	 * mark HW unaccessible.  The PM and USB cores make sure that
 	 * the root hub is either suspended or stopped.
 	 */
-	spin_lock_irqsave (&ehci->lock, flags);
 	ehci_prepare_ports_for_controller_suspend(ehci, do_wakeup);
+	spin_lock_irqsave (&ehci->lock, flags);
 	ehci_writel(ehci, 0, &ehci->regs->intr_enable);
 	(void)ehci_readl(ehci, &ehci->regs->intr_enable);
 
-- 
1.7.2.3

