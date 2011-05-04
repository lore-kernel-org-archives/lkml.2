Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1EDUxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:53:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40254 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab1EDUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:53:11 -0400
Date: Wed, 4 May 2011 22:53:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christian Hoffmann <email@christianhoffmann.info>
cc: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
In-Reply-To: <4DC1AB9B.8080501@christianhoffmann.info>
Message-ID: <alpine.LFD.2.02.1105042154410.3005@ionos>
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm>
 <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Christian Hoffmann wrote:

> > 
> > Hmm. So I really wonder why it refuses to switch to acpi_pm when you
> > select it on the kernel command line.
> > 
> > Does "echo acpi_pm>
> > /sys/devices/system/clocksource/clocksource0/current_clocksource"
> > work ?
> 
> Yes, that seems to work:
> 
> root@c3po:~# echo acpi_pm >
> /sys/devices/system/clocksource/clocksource0/current_clocksource
> root@c3po:~# dmesg | grep clocksource
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch+
> root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.39-rc5-ch+
> root=/dev/mapper/vg-root ro quiet splash vt.handoff=7 clocksource=acpi_pm
> [    1.463754] Switching to clocksource tsc
> [    1.470700] Override clocksource acpi_pm is not HRT compatible. Cannot
> switch while in HRT/NOHZ mode

Weird, I think it's unrelated to the hang, but still something which
wants to be investigated.

> [  125.808622] Switching to clocksource acpi_pm

At least that works :)
 
> > 
> > Ok. That excludes HPET. So the only difference left is the late
> > registration of TSC which happens _AFTER_ the hang.
> > 
> > Can you boot the non working kernel with "lpj=28098860" on the kernel
> > command line ?
> 
> The dmesg output with lpj is here (and it still hangs):
> 
> http://pastebin.com/raw.php?i=wZWrbc7Z

That excludes some odd interaction with the udelay code.

So we are back to:

[    0.644189] Calling fixup hook: quirk_usb_early_handoff+0x0/0x4a6
[  145.936254] Calling fixup hook: pci_fixup_video+0x0/0xac

So we really need to know what's happening there.

Can you please apply the following patch and enable
CONFIG_FUNCTION_TRACER and add "ftrace=function" on the command line?

When the box is up, mount debugfs (mount -t debugfs debugfs
/sys/kernel/debug) and read out /sys/kernel/debug/tracing/trace, bzip2
it and provide it somewhere for download. If you have no way to do
that, mail it to me offlist.

Thanks,

	tglx

--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2787,11 +2787,17 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IN
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
+	u64 t1, t2;
+
 	while (f < end) {
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
 		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
+			t1 = sched_clock();
 			f->hook(dev);
+			t2 = sched_clock();
+			if ((t2 - t1) > NSEC_PER_SEC)
+				tracing_off();
 		}
 		f++;
 	}
