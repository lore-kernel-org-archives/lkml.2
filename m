Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1DSXu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:50:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab1DSXu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:50:57 -0400
Date: Tue, 19 Apr 2011 16:50:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] leds: provide helper to register "leds-gpio" devices
Message-Id: <20110419165023.6aed127b.akpm@linux-foundation.org>
In-Reply-To: <20110419232420.GA3673@n2100.arm.linux.org.uk>
References: <20110405073030.GI13963@pengutronix.de>
	<1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20110405163338.GA11832@n2100.arm.linux.org.uk>
	<20110419161913.a1c18599.akpm@linux-foundation.org>
	<20110419232420.GA3673@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 00:24:20 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Apr 19, 2011 at 04:19:13PM -0700, Andrew Morton wrote:
> > On Tue, 5 Apr 2011 17:33:39 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Tue, Apr 05, 2011 at 10:37:35AM +0200, Uwe Kleine-K__nig wrote:
> > > > +struct platform_device *__init gpio_led_register_device(
> > > > +		const struct gpio_led_platform_data *pdata);
> > > 
> > > Please don't add __init annotations to declarations.
> > 
> > Reasons?
> 
> It's noise.
> 
> > A year or so ago we had to *add* an __init to a declaration, because
> > one architecture was generating a short-mode-addressing relative branch
> > to the callee, assuming the target was in the same section as the call
> > site.  When the linker went to resolve the branch, it discovered that
> > the target was in fact in a different section and was too far away to
> > be able to use the short-mode addressing.  IIRC, that architecture was
> > arm.
> 
> I'm not aware of ARM ever requiring that.  If it was, we'd have to add
> a heck of a lot of those annotations.  And those annotations don't tell
> the compiler that it might be far away.
> 
> We _do_ have a problem if someone decides to include a big ramdisk or
> initramfs image in the discarded section, which is something I have a
> patch kicking around to completely change the vmlinux layout to resolve.
> That's taking something of a low priority at the moment though as we've
> been turned upside down by Linus...

<spends 20 minutes hunting>

OK, maybe it was the below patch in which case I misremembered - this
patch is FRV and __meminitdata.

But I do have a feeling that we had a similar problem with .text ->
.init.text references.


commit 9dec17eb577169f78d642c5424e4264186d27115
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Mon Jul 10 04:44:51 2006 -0700
Commit:     Linus Torvalds <torvalds@g5.osdl.org>
CommitDate: Mon Jul 10 13:24:21 2006 -0700

    [PATCH] FRV: Fix FRV arch compile errors
    
    Fix some FRV arch compile errors, including:
    
     (*) Marking nr_kernel_pages as __meminitdata so that references to it end up
         being properly calculated rather than being assumed to be in the small
         data section (and thus calculated wrt the GP register).  Not doing this
         causes the linker to emit errors as the offset is too big to fit into the
         load instruction.
    
     (*) Move pm_power_off into an unconditionally compiled .c file as it's now
         unconditionally accessed.
    
     (*) Declare frv_change_cmode() in a header file rather than in a .c file, and
         declare it asmlinkage.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/arch/frv/kernel/local.h b/arch/frv/kernel/local.h
index e947176..76606d1 100644
--- a/arch/frv/kernel/local.h
+++ b/arch/frv/kernel/local.h
@@ -51,6 +51,9 @@ extern void (*__power_switch_wake_cleanup)(void);
 /* time.c */
 extern void time_divisor_init(void);
 
+/* cmode.S */
+extern asmlinkage void frv_change_cmode(int);
+
 
 #endif /* __ASSEMBLY__ */
 #endif /* _FRV_LOCAL_H */
diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index e65a9f1..c1d9fc8 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -26,11 +26,6 @@
 
 #include "local.h"
 
-void (*pm_power_off)(void);
-EXPORT_SYMBOL(pm_power_off);
-
-extern void frv_change_cmode(int);
-
 /*
  * Debug macros
  */
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index eeeb1e2..ecdeafb 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -10,6 +10,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -38,6 +39,9 @@ asmlinkage void ret_from_fork(void);
 
 #include <asm/pgalloc.h>
 
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
 struct task_struct *alloc_task_struct(void)
 {
 	struct task_struct *p = kmalloc(THREAD_SIZE, GFP_KERNEL);
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index fb98e90..f7279d7 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -406,7 +406,9 @@ int __init pcibios_init(void)
 	ioport_resource.end	= (__reg_MB86943_sl_pci_io_range << 9) | 0x3ff;
 	ioport_resource.end	+= ioport_resource.start;
 
-	printk("PCI IO window:  %08lx-%08lx\n", ioport_resource.start, ioport_resource.end);
+	printk("PCI IO window:  %08llx-%08llx\n",
+	       (unsigned long long) ioport_resource.start,
+	       (unsigned long long) ioport_resource.end);
 
 	iomem_resource.start	= (__reg_MB86943_sl_pci_mem_base << 9) & 0xfffffc00;
 
@@ -416,8 +418,11 @@ int __init pcibios_init(void)
 	iomem_resource.end	= (__reg_MB86943_sl_pci_mem_range << 9) | 0x3ff;
 	iomem_resource.end	+= iomem_resource.start;
 
-	printk("PCI MEM window: %08lx-%08lx\n", iomem_resource.start, iomem_resource.end);
-	printk("PCI DMA memory: %08lx-%08lx\n", dma_coherent_mem_start, dma_coherent_mem_end);
+	printk("PCI MEM window: %08llx-%08llx\n",
+	       (unsigned long long) iomem_resource.start,
+	       (unsigned long long) iomem_resource.end);
+	printk("PCI DMA memory: %08lx-%08lx\n",
+	       dma_coherent_mem_start, dma_coherent_mem_end);
 
 	if (!pci_probe)
 		return -ENXIO;
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 22866fa..1021f50 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -91,7 +91,7 @@ static inline void *alloc_remap(int nid, unsigned long size)
 }
 #endif
 
-extern unsigned long nr_kernel_pages;
+extern unsigned long __meminitdata nr_kernel_pages;
 extern unsigned long nr_all_pages;
 
 extern void *__init alloc_large_system_hash(const char *tablename,

