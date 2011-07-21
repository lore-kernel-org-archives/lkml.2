Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1GUOtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:49:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1GUOtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:49:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] MSM fix
Date: Thu, 21 Jul 2011 16:49:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20110720203703.GA4495@huya.qualcomm.com> <20110720225010.GA18381@huya.qualcomm.com> <20110720225406.GB20310@n2100.arm.linux.org.uk>
In-Reply-To: <20110720225406.GB20310@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107211649.39902.arnd@arndb.de>
X-Provags-ID: V02:K0:DAEfr35NXKxP73k98sxxP7bVS2wc+HVTO9GKNJUeMG3
 J83G8+K9QZCD6OQMH6W2Q/r7Xg59WjQGLHbbgMi2BV3HJKt3Jl
 BhUiMU42zWcKX4DTCjyeOwP6RTtZwmy5bRK/ZVaiWEMUeMKsPi
 wrI5QsDQYKL+8FE7UC91KE6+rb/nJ/hqUXzkHIBxYvB+Wl4jWX
 Qc/bwYAjC8GucFLUU+GAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 July 2011, Russell King - ARM Linux wrote:
> > It looks like it would apply to 2.6.38 and 39 as well.  I'm not sure
> > it qualifies under the "It must fix a real bug that bothers people".
> > It would only apply if someone had set NR_CPUS to more than 2.
> 
> Err, this makes no sense.  MSM doesn't have a get_core_count function
> and as far as I can see never has done in mainline.

I've committed the version below now, with a clarified title.
The patch looks reasonable to me, but there may be some issue
I'm missing of course. The other platforms that used to have
a get_core_count function no longer have that because you changed
them to use scu_get_core_count, but that doesn't seem to apply
to mach-msm.

I did not add a stable tag though.

	Arnd

8<---
Subject: [PATCH] ARM: msm: platsmp: determine number of CPU cores at boot time

Previously we just assumed there were CONFIG_NR_CPUS cpus present in
the system. Instead, figure out the number of cpus from the MIDR
register.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
[arnd: clarified patch title]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 2034098..5ba77d0 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -18,6 +18,7 @@
 
 #include <asm/hardware/gic.h>
 #include <asm/cacheflush.h>
+#include <asm/cputype.h>
 #include <asm/mach-types.h>
 
 #include <mach/msm_iomap.h>
@@ -40,6 +41,12 @@ volatile int pen_release = -1;
 
 static DEFINE_SPINLOCK(boot_lock);
 
+static inline int get_core_count(void)
+{
+	/* 1 + the PART[1:0] field of MIDR */
+	return ((read_cpuid_id() >> 4) & 3) + 1;
+}
+
 void __cpuinit platform_secondary_init(unsigned int cpu)
 {
 	/* Configure edge-triggered PPIs */
@@ -147,9 +154,9 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i;
+	unsigned int i, ncores = get_core_count();
 
-	for (i = 0; i < NR_CPUS; i++)
+	for (i = 0; i < ncores; i++)
 		set_cpu_possible(i, true);
 
         set_smp_cross_call(gic_raise_softirq);
