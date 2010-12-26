Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0LZWHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:07:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0LZWHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:07:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Xu, Andiry" <Andiry.Xu@amd.com>
Subject: Re: Scary warnings from xhci_hcd on rmmod and during shutdown/suspend/resume
Date: Sun, 26 Dec 2010 23:06:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
References: <201012170039.16185.rjw@sisk.pl> <2DEEA3AB13739D45A22ADDB5086AEA0BC080D3@sshaexmb1.amd.com> <201012171421.45367.rjw@sisk.pl>
In-Reply-To: <201012171421.45367.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012262306.48266.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 17, 2010, Rafael J. Wysocki wrote:
> On Friday, December 17, 2010, Xu, Andiry wrote:
> > > 
> > > and during shutdown (I believe the warnings are the same or analogous
> > to
> > > the
> > > above).
> > > 
> > > I tested with the attached patch from Andiry applied and I got the
> > > following
> > > BUG during resume:
> > 
> > Does this bug occurs without the synchronize irq patch?
> 
> Yes, it does.
> 
> > Seems the rmmod, shutdown and resume bugs are caused by xhci_cleanup_msix().
> > 
> > > 
> > > [   91.703778] sd 0:0:0:0: [sda] Starting disk
> > > [   91.704054] sd 2:0:0:0: [sdb] Starting disk
> > > [   91.703680] xhci_hcd 0000:04:00.0: Host controller not halted,
> > aborting
> > > reset.
> > > [   91.703680] BUG: sleeping function called from invalid context at
> > > /home/rafael/src/linux-2.6/kernel/mutex.c:278
> > > [   91.703680] in_atomic(): 1, irqs_disabled(): 1, pid: 1234, name:
> > > kworker/u:6
> > > [   91.703680] INFO: lockdep is turned off.
> > > [   91.703680] irq event stamp: 24060
> > > [   91.703680] hardirqs last  enabled at (24059): [<ffffffff810aa071>]
> > > rcu_note_context_switch+0xa1/0x1c0
> > > [   91.703680] hardirqs last disabled at (24060): [<ffffffff81494e92>]
> > > _raw_spin_lock_irq+0x12/0x50
> > > [   91.703680] softirqs last  enabled at (20026): [<ffffffff8105056e>]
> > > __do_softirq+0x11e/0x160
> > > [   91.703680] softirqs last disabled at (20011): [<ffffffff8100368c>]
> > > call_softirq+0x1c/0x30
> > > [   91.703680] Pid: 1234, comm: kworker/u:6 Tainted: G        W
> > 2.6.37-
> > > rc6+ #12
> > > [   91.703680] Call Trace:
> > > [   91.703680]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
> > > [   91.703680]  [<ffffffff81036783>] __might_sleep+0x103/0x130
> > > [   91.703680]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
> > > [   91.703680]  [<ffffffff81495727>] ?
> > > _raw_spin_unlock_irqrestore+0x67/0x70
> > > [   91.703680]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
> > > [   91.703680]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
> > > [   91.703680]  [<ffffffff81022008>] destroy_irq+0x78/0x90
> > > [   91.703680]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
> > > [   91.703680]  [<ffffffff811ee0b0>]
> > default_teardown_msi_irqs+0x70/0xa0
> > > [   91.703680]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
> > > [   91.703680]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
> > > [   91.703680]  [<ffffffffa03f0609>] xhci_cleanup_msix+0x39/0x80
> > [xhci_hcd]
> > > [   91.703680]  [<ffffffffa03f111c>] xhci_resume+0x1ac/0x250
> > [xhci_hcd]
> > > [   91.703680]  [<ffffffffa03f65c4>] xhci_pci_resume+0x14/0x20
> > [xhci_hcd]
> > > [   91.703680]  [<ffffffff8138996b>] resume_common+0xbb/0x140
> > > [   91.703680]  [<ffffffff81389a5e>] hcd_pci_restore+0xe/0x10
> > > [   91.703680]  [<ffffffff811e36f3>] pci_pm_restore+0x63/0xb0
> > > [   91.703680]  [<ffffffff813334bd>] pm_op+0x19d/0x1c0
> > > [   91.703680]  [<ffffffff81333be4>] device_resume+0x94/0x220
> > > [   91.703680]  [<ffffffff81333d8c>] async_resume+0x1c/0x50
> > > [   91.703680]  [<ffffffff8106e6e6>] async_run_entry_fn+0x86/0x160
> > > [   91.703680]  [<ffffffff81060672>] process_one_work+0x1a2/0x450
> > > [   91.703680]  [<ffffffff81060614>] ? process_one_work+0x144/0x450
> > > [   91.703680]  [<ffffffff811d2704>] ? do_raw_spin_lock+0x104/0x170
> > > [   91.703680]  [<ffffffff8106e660>] ? async_run_entry_fn+0x0/0x160
> > > [   91.703680]  [<ffffffff81061e32>] worker_thread+0x162/0x340
> > > [   91.703680]  [<ffffffff81061cd0>] ? worker_thread+0x0/0x340
> > > [   91.703680]  [<ffffffff81066836>] kthread+0x96/0xa0
> > > [   91.703680]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
> > > [   91.703680]  [<ffffffff81036fdb>] ? finish_task_switch+0x7b/0xe0
> > > [   91.703680]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
> > > [   91.703680]  [<ffffffff810667a0>] ? kthread+0x0/0xa0
> > > [   91.703680]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
> > > [   91.706248] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
> > > [   91.706251] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
> > > [   91.706253] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
> > > [   91.706256] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
> > > [   91.706258] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
> > > [   91.706260] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
> > > [   91.706262] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
> > > 
> > > The issues appear to be 100% reproducible.
> > > 
> > 
> > I'm not able to reproduce the issue. Can you specify your kernel version
> > and attach your .config?
> 
> The kernel is basically 2.6.37-rc6, but I was able to reproduce this with
> previous 2.6.37-rc too.
> 
> Attached are the full dmesg containing the traces I sent before and .config.

OK, so the problem seems to be that xhci_cleanup_msix() cannot be called under
a spinlock, because it causes a mutex to be acquired somewhere up the call
chain.

Also, you don't really need to do this "drop MSI-X and acquire a 'normal' IRQ
to fool the USB core" thing during suspend.

The appended patch works on my test machine, where I mean that (a) the reported
warnings don't appear and (b) it doesn't crash the system during resume (from
hibernation).

Thanks,
Rafael

---
 drivers/usb/core/hcd-pci.c |    3 ++-
 drivers/usb/host/xhci.c    |   38 ++++++++------------------------------
 include/linux/usb/hcd.h    |    1 +
 3 files changed, 11 insertions(+), 31 deletions(-)

Index: linux-2.6/include/linux/usb/hcd.h
===================================================================
--- linux-2.6.orig/include/linux/usb/hcd.h
+++ linux-2.6/include/linux/usb/hcd.h
@@ -119,6 +119,7 @@ struct usb_hcd {
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
+	unsigned		multiple_irqs:1;	/* Multiple IRQs used */
 
 	int			irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */
Index: linux-2.6/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd-pci.c
+++ linux-2.6/drivers/usb/core/hcd-pci.c
@@ -406,7 +406,8 @@ static int suspend_common(struct device
 			return retval;
 	}
 
-	synchronize_irq(pci_dev->irq);
+	if (!hcd->multiple_irqs)
+		synchronize_irq(pci_dev->irq);
 
 	/* Downstream ports from this root hub should already be quiesced, so
 	 * there will be no DMA activity.  Now we can shut down the upstream
Index: linux-2.6/drivers/usb/host/xhci.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/xhci.c
+++ linux-2.6/drivers/usb/host/xhci.c
@@ -263,6 +263,8 @@ static int xhci_setup_msix(struct xhci_h
 				0, "xhci_hcd", xhci_to_hcd(xhci));
 		if (ret)
 			goto disable_msix;
+		else
+			xhci_to_hcd(xhci)->multiple_irqs = true;
 	}
 
 	return ret;
@@ -508,9 +510,10 @@ void xhci_stop(struct usb_hcd *hcd)
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
 	xhci_reset(xhci);
-	xhci_cleanup_msix(xhci);
 	spin_unlock_irq(&xhci->lock);
 
+	xhci_cleanup_msix(xhci);
+
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 	/* Tell the event ring poll function not to reschedule */
 	xhci->zombie = 1;
@@ -544,9 +547,10 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	xhci_cleanup_msix(xhci);
 	spin_unlock_irq(&xhci->lock);
 
+	xhci_cleanup_msix(xhci);
+
 	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
 }
@@ -677,8 +681,6 @@ int xhci_suspend(struct xhci_hcd *xhci)
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
 	}
-	/* step 5: remove core well power */
-	xhci_cleanup_msix(xhci);
 	spin_unlock_irq(&xhci->lock);
 
 	return rc;
@@ -694,7 +696,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 {
 	u32			command, temp = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
-	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 	int	old_state, retval;
 
 	old_state = hcd->state;
@@ -729,9 +730,10 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_reset(xhci);
+		spin_unlock_irq(&xhci->lock);
+
 		if (hibernated)
 			xhci_cleanup_msix(xhci);
-		spin_unlock_irq(&xhci->lock);
 
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
 		/* Tell the event ring poll function not to reschedule */
@@ -765,30 +767,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		return retval;
 	}
 
-	spin_unlock_irq(&xhci->lock);
-	/* Re-setup MSI-X */
-	if (hcd->irq)
-		free_irq(hcd->irq, hcd);
-	hcd->irq = -1;
-
-	retval = xhci_setup_msix(xhci);
-	if (retval)
-		/* fall back to msi*/
-		retval = xhci_setup_msi(xhci);
-
-	if (retval) {
-		/* fall back to legacy interrupt*/
-		retval = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
-					hcd->irq_descr, hcd);
-		if (retval) {
-			xhci_err(xhci, "request interrupt %d failed\n",
-					pdev->irq);
-			return retval;
-		}
-		hcd->irq = pdev->irq;
-	}
-
-	spin_lock_irq(&xhci->lock);
 	/* step 4: set Run/Stop bit */
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command |= CMD_RUN;
