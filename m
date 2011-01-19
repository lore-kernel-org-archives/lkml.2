Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1ASJMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:12:30 -0500
Received: from ebb06.tieto.com ([131.207.168.38]:63403 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1ASJM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:12:27 -0500
X-AuditID: 83cfa826-b7bdbae000001a50-22-4d36aaf9956f
Date: Wed, 19 Jan 2011 17:20:11 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Felipe Balbi <felipe.balbi@nokia.com>,
        Heikki Krogerus <ext-heikki.krogerus@nokia.com>,
        Tejun Heo <tj@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hema HK <hemahk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb otg: use atomic notifier instead of blocking notifier
Message-ID: <20110119092011.GA23624@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAARchlS0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


following bug happens with meego 2.6.35 kernel on nokia n900:

[   28.693756] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
[   28.693786] in_atomic(): 1, irqs_disabled(): 128, pid: 706, name: udisks-part-id
[   28.693817] 1 lock held by udisks-part-id/706:
[   28.693817]  #0:  (&(&musb->lock)->rlock){-.-...}, at: [<c0278590>] musb_g_disconnect+0x90/0x148
[   28.693908] irq event stamp: 1169
[   28.693908] hardirqs last  enabled at (1168): [<c00c4b3c>] kmem_cache_alloc+0xd0/0x128
[   28.693969] hardirqs last disabled at (1169): [<c002da34>] __irq_svc+0x34/0xb4
[   28.694000] softirqs last  enabled at (0): [<c0054bcc>] copy_process+0x304/0xe18
[   28.694030] softirqs last disabled at (0): [<(null)>] (null)
[   28.694091] [<c00326a0>] (unwind_backtrace+0x0/0xec) from [<c037e6b0>] (down_read+0x20/0x5c)
[   28.694152] [<c037e6b0>] (down_read+0x20/0x5c) from [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c)
[   28.694183] [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c) from [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18)
[   28.694213] [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18) from [<c02784d8>] (musb_gadget_vbus_draw+0x38/0x60)
[   28.694274] [<c02784d8>] (musb_gadget_vbus_draw+0x38/0x60) from [<c0276d10>] (musb_interrupt+0xb08/0xcb0)
[   28.694305] [<c0276d10>] (musb_interrupt+0xb08/0xcb0) from [<c0276f08>] (generic_interrupt+0x50/0x68)
[   28.694335] [<c0276f08>] (generic_interrupt+0x50/0x68) from [<c008fcf4>] (handle_IRQ_event+0x24/0xe8)
[   28.694396] [<c008fcf4>] (handle_IRQ_event+0x24/0xe8) from [<c0091924>] (handle_level_irq+0xac/0x128)
[   28.694427] [<c0091924>] (handle_level_irq+0xac/0x128) from [<c002d070>] (asm_do_IRQ+0x70/0x90)
[   28.694458] [<c002d070>] (asm_do_IRQ+0x70/0x90) from [<c002da4c>] (__irq_svc+0x4c/0xb4)
[   28.694488] Exception stack(0xcd835ed0 to 0xcd835f18)
[   28.694519] 5ec0:                                     cfc0a240 c8282000 0000006b 0000006b
[   28.694549] 5ee0: cfc0a240 0000041a 00001000 00000000 c8282000 cd834000 c8282000 be80c464
[   28.694580] 5f00: 00000c1e cd835f18 c00c333c c00c297c 80000013 ffffffff
[   28.694610] [<c002da4c>] (__irq_svc+0x4c/0xb4) from [<c00c297c>] (check_poison_obj+0x24/0x194)
[   28.694641] [<c00c297c>] (check_poison_obj+0x24/0x194) from [<c00c333c>] (cache_alloc_debugcheck_after+0x28/0x188)
[   28.694671] [<c00c333c>] (cache_alloc_debugcheck_after+0x28/0x188) from [<c00c4b54>] (kmem_cache_alloc+0xe8/0x128)
[   28.694732] [<c00c4b54>] (kmem_cache_alloc+0xe8/0x128) from [<c00d79dc>] (getname+0x18/0xcc)
[   28.694763] [<c00d79dc>] (getname+0x18/0xcc) from [<c00cbca8>] (do_sys_open+0x18/0x10c)
[   28.694793] [<c00cbca8>] (do_sys_open+0x18/0x10c) from [<c002df40>] (ret_fast_syscall+0x0/0x3c)
[   28.694854] 
[   28.694854] =================================
[   28.709014] [ INFO: inconsistent lock state ]
[   28.717254] 2.6.35.96.5-adaptation-n900 #1
[   28.725128] ---------------------------------
[   28.733123] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage.
[   28.742980] udisks-part-id/706 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   28.752441]  (&(&twl->otg.notifier)->rwsem){+-+...}, at: [<c0070770>] __blocking_notifier_call_chain+0x2c/0x5c
[   28.769836] {HARDIRQ-ON-W} state was registered at:
[   28.778320]   [<c007c1dc>] __lock_acquire+0x618/0x1730
[   28.787109]   [<c007d354>] lock_acquire+0x60/0x74
[   28.795227]   [<c037e67c>] down_write+0x48/0x5c
[   28.803131]   [<c00708a8>] blocking_notifier_chain_register+0x30/0x54
[   28.812896]   [<bf0da9f8>] isp1704_charger_probe+0x268/0x39c [isp1704_charger]
[   28.823394]   [<c0239410>] platform_drv_probe+0x18/0x1c
[   28.831787]   [<c02385c8>] driver_probe_device+0xa8/0x158
[   28.840332]   [<c02386e0>] __driver_attach+0x68/0x8c
[   28.848510]   [<c0237e68>] bus_for_each_dev+0x44/0x74
[   28.856689]   [<c02377c8>] bus_add_driver+0x9c/0x20c
[   28.864746]   [<c02389b0>] driver_register+0xa8/0x138
[   28.872955]   [<c002d340>] do_one_initcall+0x58/0x1ac
[   28.881134]   [<c0085cdc>] sys_init_module+0x90/0x1b0
[   28.889343]   [<c002df40>] ret_fast_syscall+0x0/0x3c
[   28.897491] irq event stamp: 1169
[   28.904083] hardirqs last  enabled at (1168): [<c00c4b3c>] kmem_cache_alloc+0xd0/0x128
[   28.915557] hardirqs last disabled at (1169): [<c002da34>] __irq_svc+0x34/0xb4
[   28.926239] softirqs last  enabled at (0): [<c0054bcc>] copy_process+0x304/0xe18
[   28.937194] softirqs last disabled at (0): [<(null)>] (null)
[   28.946258] 
[   28.946258] other info that might help us debug this:
[   28.959381] 1 lock held by udisks-part-id/706:
[   28.967163]  #0:  (&(&musb->lock)->rlock){-.-...}, at: [<c0278590>] musb_g_disconnect+0x90/0x148
[   28.979705] 
[   28.979705] stack backtrace:
[   28.990997] [<c00326a0>] (unwind_backtrace+0x0/0xec) from [<c007a39c>] (print_usage_bug+0x170/0x1b4)
[   29.007293] [<c007a39c>] (print_usage_bug+0x170/0x1b4) from [<c007a738>] (mark_lock+0x358/0x628)
[   29.019836] [<c007a738>] (mark_lock+0x358/0x628) from [<c007c118>] (__lock_acquire+0x554/0x1730)
[   29.032409] [<c007c118>] (__lock_acquire+0x554/0x1730) from [<c007d354>] (lock_acquire+0x60/0x74)
[   29.045166] [<c007d354>] (lock_acquire+0x60/0x74) from [<c037e6d8>] (down_read+0x48/0x5c)
[   29.057250] [<c037e6d8>] (down_read+0x48/0x5c) from [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c)
[   29.074920] [<c0070770>] (__blocking_notifier_call_chain+0x2c/0x5c) from [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18)
[   29.094573] [<c00707b4>] (blocking_notifier_call_chain+0x14/0x18) from [<c02784d8>] (musb_gadget_vbus_draw+0x38/0x60)
[   29.113891] [<c02784d8>] (musb_gadget_vbus_draw+0x38/0x60) from [<c0276d10>] (musb_interrupt+0xb08/0xcb0)
[   29.132629] [<c0276d10>] (musb_interrupt+0xb08/0xcb0) from [<c0276f08>] (generic_interrupt+0x50/0x68)
[   29.151580] [<c0276f08>] (generic_interrupt+0x50/0x68) from [<c008fcf4>] (handle_IRQ_event+0x24/0xe8)
[   29.171081] [<c008fcf4>] (handle_IRQ_event+0x24/0xe8) from [<c0091924>] (handle_level_irq+0xac/0x128)
[   29.190948] [<c0091924>] (handle_level_irq+0xac/0x128) from [<c002d070>] (asm_do_IRQ+0x70/0x90)
[   29.205291] [<c002d070>] (asm_do_IRQ+0x70/0x90) from [<c002da4c>] (__irq_svc+0x4c/0xb4)
[   29.218963] Exception stack(0xcd835ed0 to 0xcd835f18)
[   29.229644] 5ec0:                                     cfc0a240 c8282000 0000006b 0000006b
[   29.243591] 5ee0: cfc0a240 0000041a 00001000 00000000 c8282000 cd834000 c8282000 be80c464
[   29.257629] 5f00: 00000c1e cd835f18 c00c333c c00c297c 80000013 ffffffff
[   29.270111] [<c002da4c>] (__irq_svc+0x4c/0xb4) from [<c00c297c>] (check_poison_obj+0x24/0x194)
[   29.284637] [<c00c297c>] (check_poison_obj+0x24/0x194) from [<c00c333c>] (cache_alloc_debugcheck_after+0x28/0x188)
[   29.306732] [<c00c333c>] (cache_alloc_debugcheck_after+0x28/0x188) from [<c00c4b54>] (kmem_cache_alloc+0xe8/0x128)
[   29.329071] [<c00c4b54>] (kmem_cache_alloc+0xe8/0x128) from [<c00d79dc>] (getname+0x18/0xcc)
[   29.343597] [<c00d79dc>] (getname+0x18/0xcc) from [<c00cbca8>] (do_sys_open+0x18/0x10c)
[   29.357696] [<c00cbca8>] (do_sys_open+0x18/0x10c) from [<c002df40>] (ret_fast_syscall+0x0/0x3c)

Actually the blocking notifier chain runs in process context, so not fit for use here.

For mainline kernel there's such issue as well.
Here fix this problem by changing to use atomic_notifier.

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
---
 drivers/usb/otg/ab8500-usb.c  |    6 +++---
 drivers/usb/otg/twl4030-usb.c |    6 +++---
 drivers/usb/otg/twl6030-usb.c |    6 +++---
 include/linux/usb/otg.h       |    6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

--- linux-2.6.orig/include/linux/usb/otg.h	2011-01-17 09:39:11.000000000 +0800
+++ linux-2.6/include/linux/usb/otg.h	2011-01-19 16:38:06.649546989 +0800
@@ -74,7 +74,7 @@ struct otg_transceiver {
 	void __iomem			*io_priv;
 
 	/* for notification of usb_xceiv_events */
-	struct blocking_notifier_head	notifier;
+	struct atomic_notifier_head	notifier;
 
 	/* to pass extra port status to the root hub */
 	u16			port_status;
@@ -234,13 +234,13 @@ otg_start_srp(struct otg_transceiver *ot
 static inline int
 otg_register_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
 {
-	return blocking_notifier_chain_register(&otg->notifier, nb);
+	return atomic_notifier_chain_register(&otg->notifier, nb);
 }
 
 static inline void
 otg_unregister_notifier(struct otg_transceiver *otg, struct notifier_block *nb)
 {
-	blocking_notifier_chain_unregister(&otg->notifier, nb);
+	atomic_notifier_chain_unregister(&otg->notifier, nb);
 }
 
 /* for OTG controller drivers (and maybe other stuff) */
--- linux-2.6.orig/drivers/usb/otg/ab8500-usb.c	2011-01-17 09:39:11.000000000 +0800
+++ linux-2.6/drivers/usb/otg/ab8500-usb.c	2011-01-19 16:50:21.942878632 +0800
@@ -212,7 +212,7 @@ static int ab8500_usb_link_status_update
 		break;
 	}
 
-	blocking_notifier_call_chain(&ab->otg.notifier, event, v);
+	atomic_notifier_call_chain(&ab->otg.notifier, event, v);
 
 	return 0;
 }
@@ -281,7 +281,7 @@ static int ab8500_usb_set_power(struct o
 	ab->vbus_draw = mA;
 
 	if (mA)
-		blocking_notifier_call_chain(&ab->otg.notifier,
+		atomic_notifier_call_chain(&ab->otg.notifier,
 				USB_EVENT_ENUMERATED, ab->otg.gadget);
 	return 0;
 }
@@ -500,7 +500,7 @@ static int __devinit ab8500_usb_probe(st
 
 	platform_set_drvdata(pdev, ab);
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&ab->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&ab->otg.notifier);
 
 	/* v1: Wait for link status to become stable.
 	 * all: Updates form set_host and set_peripheral as they are atomic.
--- linux-2.6.orig/drivers/usb/otg/twl4030-usb.c	2011-01-17 09:39:11.000000000 +0800
+++ linux-2.6/drivers/usb/otg/twl4030-usb.c	2011-01-19 16:50:05.929545335 +0800
@@ -512,7 +512,7 @@ static irqreturn_t twl4030_usb_irq(int i
 		else
 			twl4030_phy_resume(twl);
 
-		blocking_notifier_call_chain(&twl->otg.notifier, status,
+		atomic_notifier_call_chain(&twl->otg.notifier, status,
 				twl->otg.gadget);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
@@ -534,7 +534,7 @@ static void twl4030_usb_phy_init(struct 
 			twl->asleep = 0;
 		}
 
-		blocking_notifier_call_chain(&twl->otg.notifier, status,
+		atomic_notifier_call_chain(&twl->otg.notifier, status,
 				twl->otg.gadget);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
@@ -623,7 +623,7 @@ static int __devinit twl4030_usb_probe(s
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&twl->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&twl->otg.notifier);
 
 	/* Our job is to use irqs and status from the power module
 	 * to keep the transceiver disabled when nothing's connected.
--- linux-2.6.orig/drivers/usb/otg/twl6030-usb.c	2011-01-17 09:39:11.000000000 +0800
+++ linux-2.6/drivers/usb/otg/twl6030-usb.c	2011-01-19 16:49:47.112878712 +0800
@@ -269,7 +269,7 @@ static irqreturn_t twl6030_usb_irq(int i
 		}
 		if (status >= 0) {
 			twl->linkstat = status;
-			blocking_notifier_call_chain(&twl->otg.notifier,
+			atomic_notifier_call_chain(&twl->otg.notifier,
 						status, twl->otg.gadget);
 		}
 	}
@@ -294,7 +294,7 @@ static irqreturn_t twl6030_usbotg_irq(in
 		status = USB_EVENT_ID;
 		twl->otg.default_a = true;
 		twl->otg.state = OTG_STATE_A_IDLE;
-		blocking_notifier_call_chain(&twl->otg.notifier, status,
+		atomic_notifier_call_chain(&twl->otg.notifier, status,
 							twl->otg.gadget);
 	} else  {
 		twl6030_writeb(twl, TWL_MODULE_USB, USB_ID_INT_EN_HI_CLR,
@@ -411,7 +411,7 @@ static int __devinit twl6030_usb_probe(s
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
 		dev_warn(&pdev->dev, "could not create sysfs file\n");
 
-	BLOCKING_INIT_NOTIFIER_HEAD(&twl->otg.notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&twl->otg.notifier);
 
 	twl->irq_enabled = true;
 	status = request_threaded_irq(twl->irq1, NULL, twl6030_usbotg_irq,
