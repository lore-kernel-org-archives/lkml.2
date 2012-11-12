Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab2KLO1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:27:06 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60664 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2KLO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:27:04 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [REGRESSION] 3.7-rc3+git hard lockup on CPU after inserting/removing USB stick
Date: Mon, 12 Nov 2012 15:27:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc5-f2fs-usb-hcd-nothread-tp520+; KDE/4.8.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211071501.38288.Martin@lichtvoll.de> <201211101734.07084.Martin@lichtvoll.de> <27240C0AC20F114CBF8149A2696CBE4A1C2915@SHSMSX101.ccr.corp.intel.com> (sfid-20121111_105423_761739_F064F5AE)
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1C2915@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121527.02007.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. November 2012 schrieb Liu, Chuansheng:
> > The first bad commit is:
> > 
> > commit 73d4066055e0e2830533041f4b91df8e6e5976ff
> > Author: Chuansheng Liu <chuansheng.liu@intel.com>
> > Date:   Tue Sep 11 16:00:30 2012 +0800
> > 
> >     USB/host: Cleanup unneccessary irq disable code
> > 
> >     Because the IRQF_DISABLED as the flag is now a NOOP and has been
> >     deprecated and in hardirq context the interrupt is disabled.
> > 
> >     so in usb/host code:
> >     Removing the usage of flag IRQF_DISABLED;
> >     Removing the calling local_irq save/restore actions in irq
> >     handler usb_hcd_irq();
> > 
> >     Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> >     Acked-by: Alan Stern <stern@rowland.harvard.edu>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > 
> > But:
> > 
> > This ony happens with threadirqs option!
> > 
> > When I remove threadirqs from kernel command line and reboot with this
> > last bisect kernel USB sticks work.
> > 
> > That may explain why nobody else has seen this.
> > 
> > So I will try a 3.7-rc4 now, but without threadirqs enabled.
> > 
> Thanks your pointing out, the USB HCD irq handler is designed to execute in irq handler with irq disabled.
> When threadirqs is in commandline, it will be executed in thread context with local irq enabling, which causes
> this hardlockup.
> 
> I prepared one patch, could you have time to test it? Thanks. Sorry for missing threadirqs case.
> 
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] USB/host: Mark USB HCD irq as non-threaded
> 
> Mark USB HCD irq as non-threaded. This prevent one crash/hard lockup
> when "threadirqs" is on the kernel commandline.
> And this interrupt handle is handling critial events which should not
> be in thread context.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/usb/core/hcd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 1e741bc..b1cd46e 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2349,7 +2349,7 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
>         if (hcd->driver->irq) {
>                 snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
>                                 hcd->driver->description, hcd->self.busnum);
> -               retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
> +               retval = request_irq(irqnum, &usb_hcd_irq, irqflags|IRQF_NO_THREAD,
>                                 hcd->irq_descr, hcd);
>                 if (retval != 0) {
>                         dev_err(hcd->self.controller,
> 

3.7-rc5 with manually patched to

martin@merkaba:~/Computer/Merkaba/Kernel/linux-2.6> git diff drivers | cat
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

(KMail outputs your mail as base64 and cut&paste did not retain tabs.)

gives:

1) with threadirqs enabled: No action at all when inserting USB sticks,
nothing in dmesg.

2) with threadirqs disabled: USB sticks work normal.

So your patch fixed the CPU lockup by disabling USB altogether, when
thread IRQs are active it seems. :) Or I made a mistake while manually
applying your patch. Seems okay to me tough.


PS: I think that thread IRQs for USB based interrupts might not be a good
from another experience I had with an ThinkPad T42 and USB sound card
Sonica Theater. I was not able to have it produce fluent sound with
Phonon Gstreamer or Phonon VLC from Amarok playing back music unless
I disabled threadirqs on that machine as well. Often I just heard a view
seconds of sound at the beginning and then nothing more at all. Works fine
with thread IRQs disabled. At least from VLC backend. Gives about 30% CPU
usage for that interrupt with thread IRQs enabled. Card is USB 1.1 only.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
