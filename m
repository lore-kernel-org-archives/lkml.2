Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2KKAxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 19:53:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:46820 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2KKAxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 19:53:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,754,1344236400"; 
   d="scan'208";a="166799797"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Martin Steigerwald <Martin@lichtvoll.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
 inserting/removing USB stick
Thread-Topic: [REGRESSION] 3.7-rc3+git hard lockup on CPU after
 inserting/removing USB stick
Thread-Index: AQHNv2E454CB974kpkKBPC/5IWStzZfjzFBQ
Date: Sun, 11 Nov 2012 00:53:15 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1C2915@SHSMSX101.ccr.corp.intel.com>
References: <201211071501.38288.Martin@lichtvoll.de>
 <20121107143800.GA14146@kroah.com> <201211071952.24509.Martin@lichtvoll.de>
 (sfid-20121107_195431_785653_5B4780C0)
 <201211101734.07084.Martin@lichtvoll.de>
In-Reply-To: <201211101734.07084.Martin@lichtvoll.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAB0rXtB003979

> The first bad commit is:
> 
> commit 73d4066055e0e2830533041f4b91df8e6e5976ff
> Author: Chuansheng Liu <chuansheng.liu@intel.com>
> Date:   Tue Sep 11 16:00:30 2012 +0800
> 
>     USB/host: Cleanup unneccessary irq disable code
> 
>     Because the IRQF_DISABLED as the flag is now a NOOP and has been
>     deprecated and in hardirq context the interrupt is disabled.
> 
>     so in usb/host code:
>     Removing the usage of flag IRQF_DISABLED;
>     Removing the calling local_irq save/restore actions in irq
>     handler usb_hcd_irq();
> 
>     Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
>     Acked-by: Alan Stern <stern@rowland.harvard.edu>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> But:
> 
> This ony happens with threadirqs option!
> 
> When I remove threadirqs from kernel command line and reboot with this
> last bisect kernel USB sticks work.
> 
> That may explain why nobody else has seen this.
> 
> So I will try a 3.7-rc4 now, but without threadirqs enabled.
> 
Thanks your pointing out, the USB HCD irq handler is designed to execute in irq handler with irq disabled.
When threadirqs is in commandline, it will be executed in thread context with local irq enabling, which causes
this hardlockup.

I prepared one patch, could you have time to test it? Thanks. Sorry for missing threadirqs case.

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] USB/host: Mark USB HCD irq as non-threaded

Mark USB HCD irq as non-threaded. This prevent one crash/hard lockup
when "threadirqs" is on the kernel commandline.
And this interrupt handle is handling critial events which should not
be in thread context.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/usb/core/hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 1e741bc..b1cd46e 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2349,7 +2349,7 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
        if (hcd->driver->irq) {
                snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
                                hcd->driver->description, hcd->self.busnum);
-               retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
+               retval = request_irq(irqnum, &usb_hcd_irq, irqflags|IRQF_NO_THREAD,
                                hcd->irq_descr, hcd);
                if (retval != 0) {
                        dev_err(hcd->self.controller,
-- 
1.7.0.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
