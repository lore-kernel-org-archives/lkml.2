Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab0HDMlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:41:51 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57136 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab0HDMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:41:48 -0400
Date: Wed, 4 Aug 2010 14:41:45 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Sam Creasey <sammy@sammy.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Joe Perches <joe@perches.com>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/9] arch/m68k{,nommu}: Removing dead SMP config option
Message-ID: <86fd3a30b5cce0a637243e822e96f5bc76269670.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_SMP doesn't exist in Kconfig (for this architecure), therefore
removing all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68k/include/asm/system_mm.h |    2 --
 arch/m68k/include/asm/system_no.h |    9 ---------
 arch/m68k/kernel/time.c           |    2 --
 arch/m68k/sun3/sun3ints.c         |    8 +++-----
 arch/m68knommu/kernel/time.c      |    3 +--
 5 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/include/asm/system_mm.h b/arch/m68k/include/asm/system_mm.h
index dbb6515..485daec 100644
--- a/arch/m68k/include/asm/system_mm.h
+++ b/arch/m68k/include/asm/system_mm.h
@@ -205,9 +205,7 @@ static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
 	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
 			(unsigned long)(n), sizeof(*(ptr))))
 
-#ifndef CONFIG_SMP
 #include <asm-generic/cmpxchg.h>
-#endif
 
 #endif
 
diff --git a/arch/m68k/include/asm/system_no.h b/arch/m68k/include/asm/system_no.h
index 3c0718d..08f31bd 100644
--- a/arch/m68k/include/asm/system_no.h
+++ b/arch/m68k/include/asm/system_no.h
@@ -106,17 +106,10 @@ asmlinkage void resume(void);
 #define wmb()  asm volatile (""   : : :"memory")
 #define set_mb(var, value)	({ (var) = (value); wmb(); })
 
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do { } while(0)
-#endif
 
 #define read_barrier_depends()  ((void)0)
 
@@ -199,9 +192,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int siz
 			(unsigned long)(n), sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-#ifndef CONFIG_SMP
 #include <asm-generic/cmpxchg.h>
-#endif
 
 #define arch_align_stack(x) (x)
 
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 4926b38..06438da 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -42,9 +42,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	do_timer(1);
-#ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
-#endif
 	profile_tick(CPU_PROFILING);
 
 #ifdef CONFIG_HEARTBEAT
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index ad90393..606ff4d 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -66,12 +66,10 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
-        do_timer(1);
-#ifndef CONFIG_SMP
+    do_timer(1);
 	update_process_times(user_mode(get_irq_regs()));
-#endif
-        if (!(kstat_cpu(0).irqs[irq] % 20))
-                sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
+    if (!(kstat_cpu(0).irqs[irq] % 20))
+        sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index a90acf5..7089dd9 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -50,9 +50,8 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 
 	write_sequnlock(&xtime_lock);
 
-#ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
-#endif
+
 	return(IRQ_HANDLED);
 }
 #endif
-- 
1.7.0.4

