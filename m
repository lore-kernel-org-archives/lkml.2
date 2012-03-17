Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031281Ab2CQRT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 13:19:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47933 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030379Ab2CQRT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 13:19:26 -0400
References: <201203171136.44415.linux@rainbow-software.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <201203171136.44415.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [resend] Add support for Rise mP6 CPUs
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 17 Mar 2012 10:16:53 -0700
To: Ondrej Zary <linux@rainbow-software.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <cca346f3-b150-441e-a89e-83abce037b31@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did Rise ever ship any production parts?

Ondrej Zary <linux@rainbow-software.org> wrote:

>Add detection for Rise mP6 x86 CPUs and a quirk to mark CMPXCHG8B as
>present.
>
>Result:
>$ cat /proc/cpuinfo
>processor       : 0
>vendor_id       : RiseRiseRise
>cpu family      : 5
>model           : 0
>model name      : mP6 (Kirin)
>stepping        : 4
>cpu MHz         : 200.443
>cache size      : 16 KB
>fdiv_bug        : no
>hlt_bug         : no
>f00f_bug        : no
>coma_bug        : no
>fpu             : yes
>fpu_exception   : yes
>cpuid level     : 1
>wp              : yes
>flags           : fpu tsc cx8 mmx up
>bogomips        : 400.88
>clflush size    : 32
>cache_alignment : 32
>address sizes   : 32 bits physical, 32 bits virtual
>power management:
>
>Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
>diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
>index 3c57033..5a356f3 100644
>--- a/arch/x86/Kconfig.cpu
>+++ b/arch/x86/Kconfig.cpu
>@@ -505,3 +505,12 @@ config CPU_SUP_UMC_32
> 	  CPU might render the kernel unbootable.
> 
> 	  If unsure, say N.
>+
>+config CPU_SUP_RISE_32
>+	default y
>+	bool "Support Rise processors" if PROCESSOR_SELECT
>+	depends on !64BIT
>+	---help---
>+	  This enables detection, tunings and quirks for Rise processors
>+
>+	  If unsure, say N.
>diff --git a/arch/x86/include/asm/processor.h
>b/arch/x86/include/asm/processor.h
>index aa9088c..e3a4e7f 100644
>--- a/arch/x86/include/asm/processor.h
>+++ b/arch/x86/include/asm/processor.h
>@@ -119,7 +119,8 @@ struct cpuinfo_x86 {
> #define X86_VENDOR_CENTAUR	5
> #define X86_VENDOR_TRANSMETA	7
> #define X86_VENDOR_NSC		8
>-#define X86_VENDOR_NUM		9
>+#define X86_VENDOR_RISE		9
>+#define X86_VENDOR_NUM		10
> 
> #define X86_VENDOR_UNKNOWN	0xff
> 
>diff --git a/arch/x86/kernel/cpu/Makefile
>b/arch/x86/kernel/cpu/Makefile
>index 25f24dc..1013eb6 100644
>--- a/arch/x86/kernel/cpu/Makefile
>+++ b/arch/x86/kernel/cpu/Makefile
>@@ -26,6 +26,7 @@ obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
> obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
> obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
> obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
>+obj-$(CONFIG_CPU_SUP_RISE_32)		+= rise.o
> 
> obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
> 
>diff --git a/arch/x86/kernel/cpu/rise.c b/arch/x86/kernel/cpu/rise.c
>new file mode 100644
>index 0000000..2072a0f
>--- /dev/null
>+++ b/arch/x86/kernel/cpu/rise.c
>@@ -0,0 +1,34 @@
>+#include <linux/kernel.h>
>+#include <linux/init.h>
>+#include <asm/processor.h>
>+#include "cpu.h"
>+
>+static void __cpuinit init_rise(struct cpuinfo_x86 *c)
>+{
>+	/*
>+	 * Datasheet says:
>+	 * The CMPXCHG8B instruction is supported and always enabled on the
>+	 * Rise mP6 processor; however, the default CPUID function bit is set
>+	 * to 0 to circumvent a reported bug in Windows NT.
>+	 */
>+	set_cpu_cap(c, X86_FEATURE_CX8);
>+	/* cache is always 16KB (8KB code + 8KB data) */
>+	c->x86_cache_size = 16;
>+}
>+
>+static const struct cpu_dev __cpuinitconst rise_cpu_dev = {
>+	.c_vendor	= "Rise",
>+	.c_ident	= { "RiseRiseRise" },
>+	.c_models = {
>+		{ .vendor = X86_VENDOR_RISE, .family = 5, .model_names =
>+		  {
>+			  [0] = "mP6 (Kirin)",
>+			  [2] = "mP6 (Lynx)",
>+		  }
>+		},
>+	},
>+	.c_init		= init_rise,
>+	.c_x86_vendor	= X86_VENDOR_RISE,
>+};
>+
>+cpu_dev_register(rise_cpu_dev);
>
>-- 
>Ondrej Zary

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
