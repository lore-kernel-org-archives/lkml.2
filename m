Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab1ALBJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:09:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30788 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1ALBI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:08:59 -0500
Message-ID: <4D2CFEAD.6070206@kernel.org>
Date: Tue, 11 Jan 2011 17:06:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH] x86: Add safe_udelay() and safe_msleep()
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org> <4D2BAA75.60001@kernel.org> <20110111010714.GB32585@kroah.com> <4D2BB048.2050509@kernel.org> <1294723290.17779.349.camel@pasglop> <4D2BF9F3.5080709@kernel.org> <1294731467.17779.352.camel@pasglop> <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com> <20110111135655.GA6901@kroah.com>
In-Reply-To: <20110111135655.GA6901@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We need to use those function in early-quirk stage with code that is shared with
later stage.

for x86, normal udelay() will need to wait per_cpu(cpu_info) is allocated... that i
after smp_prepare_cpus(), because it need to use percpu.loops_per_jiffy.

Also msleep() will need to wait schedular is ready.

Try to have one early version udelay that use loops_per_jiffy directly.
and early msleep is just early delay.

This patch will set safe_udelay to early in x86 early arch code, and then init/main.c
will set them back.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/delay.h |    3 +++
 arch/x86/kernel/setup.c      |    4 ++++
 arch/x86/lib/delay.c         |   28 ++++++++++++++++++++++++++++
 include/linux/delay.h        |    2 ++
 init/main.c                  |    6 ++++++
 5 files changed, 43 insertions(+)

Index: linux-2.6/arch/x86/include/asm/delay.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/delay.h
+++ linux-2.6/arch/x86/include/asm/delay.h
@@ -28,4 +28,7 @@ extern void __delay(unsigned long loops)
 
 void use_tsc_delay(void);
 
+extern void __early_udelay(unsigned long usecs);
+extern void __early_msleep(unsigned int msecs);
+
 #endif /* _ASM_X86_DELAY_H */
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -853,6 +853,10 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
+	/* for early using */
+	safe_udelay = __early_udelay;
+	safe_msleep = __early_msleep;
+
 	/*
 	 * VMware detection requires dmi to be available, so this
 	 * needs to be done after dmi_scan_machine, for the BP.
Index: linux-2.6/arch/x86/lib/delay.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/delay.c
+++ linux-2.6/arch/x86/lib/delay.c
@@ -138,3 +138,31 @@ void __ndelay(unsigned long nsecs)
 	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
 }
 EXPORT_SYMBOL(__ndelay);
+
+/* before cpu_info.loops_per_jiffy get set */
+static inline void __early_const_udelay(unsigned long xloops)
+{
+	int d0;
+
+	xloops *= 4;
+	asm("mull %%edx"
+		: "=d" (xloops), "=&a" (d0)
+		: "1" (xloops), "0"
+		(loops_per_jiffy * (HZ/4)));
+
+	delay_loop(++xloops);
+}
+
+/* usecs need to < 2000 */
+void __init __early_udelay(unsigned long usecs)
+{
+	/* 2**32 / 1000000 (rounded up) */
+	__early_const_udelay(usecs * 0x000010c7);
+}
+
+/* before schedular is there */
+void __init __early_msleep(unsigned int msecs)
+{
+	while (msecs--)
+		__early_udelay(1000);
+}
Index: linux-2.6/include/linux/delay.h
===================================================================
--- linux-2.6.orig/include/linux/delay.h
+++ linux-2.6/include/linux/delay.h
@@ -52,4 +52,6 @@ static inline void ssleep(unsigned int s
 	msleep(seconds * 1000);
 }
 
+extern void (*safe_udelay)(unsigned long);
+extern void (*safe_msleep)(unsigned int);
 #endif /* defined(_LINUX_DELAY_H) */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -240,6 +240,9 @@ unsigned long loops_per_jiffy = (1<<12);
 
 EXPORT_SYMBOL(loops_per_jiffy);
 
+void (*safe_udelay)(unsigned long) = __udelay;
+void (*safe_msleep)(unsigned int) = msleep;
+
 static int __init debug_kernel(char *str)
 {
 	console_loglevel = 10;
@@ -879,6 +882,9 @@ static int __init kernel_init(void * unu
 	cad_pid = task_pid(current);
 
 	smp_prepare_cpus(setup_max_cpus);
+	/* set them back, x86 use it for early delay*/
+	safe_udelay = __udelay;
+	safe_msleep = msleep;
 
 	do_pre_smp_initcalls();
 	lockup_detector_init();
