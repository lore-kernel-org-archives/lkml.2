Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0EGPrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:47:01 -0400
Received: from kroah.org ([198.145.64.141]:58510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799Ab0EGPq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:46:57 -0400
Date: Fri, 7 May 2010 08:46:43 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "K. Y. Srinivasan" <ksrinivasan@novell.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Vadim Rozenfeld <vrozenfe@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] x86: detect running on a HyperV system
Message-ID: <20100507154643.GA19847@kroah.com>
References: <20100506190841.GA1605@kroah.com>
 <4BE314CD.6060701@zytor.com>
 <20100506191816.GA20874@kroah.com>
 <4BE371AB.2000806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE371AB.2000806@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KY added to the To:, sorry for not including him earlier, he wrote this
code]

On Thu, May 06, 2010 at 06:49:31PM -0700, H. Peter Anvin wrote:
> On 05/06/2010 12:18 PM, Greg KH wrote:
> > On Thu, May 06, 2010 at 12:13:17PM -0700, H. Peter Anvin wrote:
> >> On 05/06/2010 12:08 PM, Greg KH wrote:
> >>>
> >>> x86-maintainers, we need this patch in the tree to get a -staging driver
> >>> to work properly.  If you don't object, can I take it through the
> >>> staging tree?  Or do you want to take it in -tip?
> >>>
> >>
> >> I'd prefer to take it in -tip, partly because I would like to rework a
> >> few things -- including preexisting braindamage like c->x86_hyper_vendor
> >> (since when was hypervisor vendor a per-cpu property!?)
> > 
> > Heh, good point, but where should it live?
> > 
> > And I have no objection to taking it in -tip, thanks for doing so.
> > 
> >> I'll try to get to it today, if not feel free to bug me.
> > 
> > Will do :)
> > 
> > thanks again,
> > 
> 
> Okay... we write something called x86_hyper_features, but it isn't
> actually used for anything.  I'm assuming based on what I can see in
> <asm/hyperv.h> that it is almost certainly not anything CPU-based.  I
> really don't like a random field that can be stuffed with information
> from random locations, and it doesn't look like it's even a flag field
> in any meaningful way.  Worse, the field is just used to mix bits from
> two different CPUID levels at what appears to be a completely arbitrary
> boundary:
> 
>         /*
>          * Extract the features, recommendations etc.
>          * The first 9 bits will be used to track hypervisor features.
>          * The next 6 bits will be used to track the hypervisor
>          * recommendations.
>          */
>         cpuid(HYPERV_CPUID_FEATURES, &eax, &ebx, &ecx, &edx);
>         c->x86_hyper_features |= (eax & 0x1ff);
> 
>         cpuid(HYPERV_CPUID_ENLIGHTMENT_INFO, &eax, &ebx, &ecx, &edx);
>         c->x86_hyper_features |= ((eax & 0x3f) << 9);
> 
> Why 9?  Why 6?  The only thing that I can think of that justifies those
> particular numbers is what the *current* version of Hyper-V does.

I think that is what Hyper-V is saying it will always do.  Hank?  Any
help here?

> It would be better to just have a global variable where these two levels
> are separately stuffed away instead of arbitrarily commingled (again,
> I'm assuming none of the bits are actually per CPU.)

Sure, that would be fine, that's all we really need.

> What does this driver of yours do with them?

It just tests to see if the functionality is present.  I've included the
driver below to show this.

thanks,

greg k-h

--------
From: K. Y. Srinivasan <ksrinivasan@novell.com>
Subject: Staging: A clocksource for Linux guests hosted on HyperV.

This patch is a clocksource implementation suitable for guests hosted on
HyperV.  Time keeping in Linux guests hosted on HyperV is unstable. This
clocksource driver fixes the problem.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/Makefile        |    2 
 drivers/staging/hv/hv_timesource.c |   94 +++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)

--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_HYPERV)		+= hv_vmbus.o
+obj-$(CONFIG_HYPERV)		+= hv_vmbus.o hv_timesource.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
 obj-$(CONFIG_HYPERV_BLOCK)	+= hv_blkvsc.o
 obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
--- /dev/null
+++ b/drivers/staging/hv/hv_timesource.c
@@ -0,0 +1,94 @@
+/*
+ * A clocksource for Linux running on HyperV.
+ *
+ * Copyright (C) 2010, Novell, Inc.
+ * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#include <linux/init.h>
+#include <linux/clocksource.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/dmi.h>
+#include <asm/hyperv.h>
+
+#define HV_CLOCK_SHIFT	22
+
+static cycle_t read_hv_clock(struct clocksource *arg)
+{
+	cycle_t current_tick;
+	/*
+	 * Read the partition counter to get the current tick count. This count
+	 * is set to 0 when the partition is created and is incremented in
+	 * 100 nanosecond units.
+	 */
+	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
+	return current_tick;
+}
+
+static struct clocksource hyperv_cs = {
+	.name           = "hyperv_clocksource",
+	.rating         = 400, /* use this when running on Hyperv*/
+	.read           = read_hv_clock,
+	.mask           = CLOCKSOURCE_MASK(64),
+	/*
+	 * The time ref counter in HyperV is in 100ns units.
+	 * The definition of mult is:
+	 * mult/2^shift = ns/cyc = 100
+	 * mult = (100 << shift)
+	 */
+	.mult           = (100 << HV_CLOCK_SHIFT),
+	.shift          = HV_CLOCK_SHIFT,
+};
+
+static const struct dmi_system_id __initconst
+hv_timesource_dmi_table[] __maybe_unused  = {
+	{
+		.ident = "Hyper-V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+		},
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
+
+static const struct pci_device_id __initconst
+hv_timesource_pci_table[] __maybe_unused = {
+	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, hv_timesource_pci_table);
+
+
+static int __init init_hv_clocksource(void)
+{
+	if ((boot_cpu_data.x86_hyper_vendor != X86_HYPER_VENDOR_MSFT) ||
+		!(boot_cpu_data.x86_hyper_features &
+		HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
+		return -ENODEV;
+	printk(KERN_INFO "Registering HyperV clock source\n");
+	return clocksource_register(&hyperv_cs);
+}
+
+module_init(init_hv_clocksource);
+MODULE_DESCRIPTION("HyperV based clocksource");
+MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
+MODULE_LICENSE("GPL");
