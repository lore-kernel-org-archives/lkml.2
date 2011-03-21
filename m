Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1CUQ5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:57:09 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41572 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276Ab1CUQ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:57:07 -0400
Date: Mon, 21 Mar 2011 11:56:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321165608.GA12718@sgi.com>
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321161425.GC23614@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 05:14:25PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > This fixes a problem seen on UV systems handling NMIs from the node controller.
> > The original code used the DIE notifier as the hook to get to the UV NMI
> > handler. This does not work if performance counters are active - the hw_perf
> > code consumes the NMI and the UV handler is not called.
> 
> Sigh:

Agree. X86 architecture does not make it easy to use NMIs from multiple sources.


> 
> > --- linux.orig/arch/x86/kernel/traps.c	2011-03-21 09:05:43.000000000 -0500
> > +++ linux/arch/x86/kernel/traps.c	2011-03-21 09:13:01.306555675 -0500
> > @@ -57,6 +57,7 @@
> >  #include <asm/mce.h>
> >  
> >  #include <asm/mach_traps.h>
> > +#include <asm/uv/uv.h>
> >  
> >  #ifdef CONFIG_X86_64
> >  #include <asm/x86_init.h>
> > @@ -397,13 +398,16 @@ unknown_nmi_error(unsigned char reason,
> >  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >  {
> >  	unsigned char reason = 0;
> > +	int handled;
> >  
> >  	/*
> >  	 * CPU-specific NMI must be processed before non-CPU-specific
> >  	 * NMI, otherwise we may lose it, because the CPU-specific
> >  	 * NMI can not be detected/processed on other CPUs.
> >  	 */
> > -	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> > +	handled = uv_handle_nmi(regs, reason);
> > +	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
> > +	    		handled)
> >  		return;
> 
> Such code is extremely ugly. Please *reduce* the number of is_uv_system() type 
> of hacks in core x86 code, not increase it!
> 
> Any reason why a higher priority for the UV NMI handler cannot solve the 'perf 
> eats the NMI' problem?

Yes. I tried that.

If the UV handler needs to know if hwperf is active in order to know whether or not
to return NOTIFY_STOP:

	- if the UV NMI handler returns NOTIFY_STOP and hw_perf is active, hw_perf will miss
	  and NMI & counter sometimes stop working.

	- if the UV NMI handler does not return NOTIFY_STOP and hw_perf is not active,
	  we get the "dazed" messages.

A cleaner solution would be to hide the platform specific NMI action in a x86_platform_ops 
such as (untested):


Index: linux/arch/x86/include/asm/x86_init.h
===================================================================
--- linux.orig/arch/x86/include/asm/x86_init.h	2011-03-18 11:29:08.000000000 -0500
+++ linux/arch/x86/include/asm/x86_init.h	2011-03-21 11:52:36.413496546 -0500
@@ -153,6 +153,7 @@ struct x86_platform_ops {
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
 	void (*nmi_init)(void);
+	int (*nmi_handler)(void *regs);
 	int (*i8042_detect)(void);
 };
 
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 11:40:36.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-21 11:45:14.134555108 -0500
@@ -115,6 +115,7 @@ static int __init uv_acpi_madt_oem_check
 		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
+		x86_platform.nmi_handler = uv_nmi_handler;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
Index: linux/arch/x86/kernel/traps.c
===================================================================
--- linux.orig/arch/x86/kernel/traps.c	2011-03-21 11:40:36.000000000 -0500
+++ linux/arch/x86/kernel/traps.c	2011-03-21 11:52:21.057498053 -0500
@@ -55,6 +55,8 @@
 #include <asm/desc.h>
 #include <asm/i387.h>
 #include <asm/mce.h>
+#include <asm/x86_init.h>
+
 
 #include <asm/mach_traps.h>
 
@@ -397,13 +399,16 @@ unknown_nmi_error(unsigned char reason,
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
+	int handled;
 
 	/*
 	 * CPU-specific NMI must be processed before non-CPU-specific
 	 * NMI, otherwise we may lose it, because the CPU-specific
 	 * NMI can not be detected/processed on other CPUs.
 	 */
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	handled = x86_platform.nmi_handler(regs);
+	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
+	    			handled)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
Index: linux/arch/x86/kernel/x86_init.c
===================================================================
--- linux.orig/arch/x86/kernel/x86_init.c	2011-03-18 11:29:08.000000000 -0500
+++ linux/arch/x86/kernel/x86_init.c	2011-03-21 11:53:26.849496085 -0500
@@ -89,6 +89,7 @@ struct x86_cpuinit_ops x86_cpuinit __cpu
 };
 
 static void default_nmi_init(void) { };
+static int default_nmi_handler(void *regs) { return 1; };
 static int default_i8042_detect(void) { return 1; };
 
 struct x86_platform_ops x86_platform = {
@@ -98,6 +99,7 @@ struct x86_platform_ops x86_platform = {
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
 	.nmi_init			= default_nmi_init,
+	.nmi_handler			= default_nmi_handler,
 	.i8042_detect			= default_i8042_detect
 };
 


