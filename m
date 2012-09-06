Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2IFAjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:39:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:19499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2IFAjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:39:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,377,1344236400"; 
   d="scan'208";a="189411484"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] USB/host: Cleanup unneccessary irq disable code
Thread-Topic: [PATCH] USB/host: Cleanup unneccessary irq disable code
Thread-Index: AQHNi8L1FX3hLQ7HiEOljWX276GrZZd8d4vg
Date: Thu, 6 Sep 2012 00:39:09 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A177FB0@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A174713@SHSMSX101.ccr.corp.intel.com>
 <20120905235947.GA19050@kroah.com>
In-Reply-To: <20120905235947.GA19050@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch is corrupted and can not be applied at all.  Please fix your email
> client and try again.
> 
> greg k-h

I am very sorry to waste your time, resend it again.

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] USB/host: Cleanup unneccessary irq disable code

Because the IRQF_DISABLED as the flag is now a NOOP and has been
deprecated and in hardirq context the interrupt is disabled.

so in usb/host code:
Removing the usage of flag IRQF_DISABLED;
Removing the calling local_irq save/restore actions in irq
handler usb_hcd_irq();

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/usb/core/hcd.c       |   15 ---------------
 drivers/usb/host/ehci-ls1x.c |    2 +-
 drivers/usb/host/ohci-xls.c  |    2 +-
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bc84106..f84ddea 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2153,15 +2153,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
        struct usb_hcd          *hcd = __hcd;
-       unsigned long           flags;
        irqreturn_t             rc;
 
-       /* IRQF_DISABLED doesn't work correctly with shared IRQs
-        * when the first handler doesn't use it.  So let's just
-        * assume it's never used.
-        */
-       local_irq_save(flags);
-
        if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
                rc = IRQ_NONE;
        else if (hcd->driver->irq(hcd) == IRQ_NONE)
@@ -2169,7 +2162,6 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
        else
                rc = IRQ_HANDLED;
 
-       local_irq_restore(flags);
        return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_irq);
@@ -2358,13 +2350,6 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 
        if (hcd->driver->irq) {
 
-               /* IRQF_DISABLED doesn't work as advertised when used together
-                * with IRQF_SHARED. As usb_hcd_irq() will always disable
-                * interrupts we can remove it here.
-                */
-               if (irqflags & IRQF_SHARED)
-                       irqflags &= ~IRQF_DISABLED;
-
                snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
                                hcd->driver->description, hcd->self.busnum);
                retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
diff --git a/drivers/usb/host/ehci-ls1x.c b/drivers/usb/host/ehci-ls1x.c
index a283e59..425cb4a 100644
--- a/drivers/usb/host/ehci-ls1x.c
+++ b/drivers/usb/host/ehci-ls1x.c
@@ -119,7 +119,7 @@ static int ehci_hcd_ls1x_probe(struct platform_device *pdev)
                goto err_release_region;
        }
 
-       ret = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+       ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
        if (ret)
                goto err_iounmap;
 
diff --git a/drivers/usb/host/ohci-xls.c b/drivers/usb/host/ohci-xls.c
index 41e378f..84201cd 100644
--- a/drivers/usb/host/ohci-xls.c
+++ b/drivers/usb/host/ohci-xls.c
@@ -56,7 +56,7 @@ static int ohci_xls_probe_internal(const struct hc_driver *driver,
                goto err3;
        }
 
-       retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+       retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
        if (retval != 0)
                goto err4;
        return retval;
-- 
1.7.0.4
