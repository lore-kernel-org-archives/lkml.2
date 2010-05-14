Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0ENPM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:12:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0ENPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:12:26 -0400
Date: Fri, 14 May 2010 11:11:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20100514151121.GR15159@redhat.com>
References: <20100514155312.9684cb9d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514155312.9684cb9d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 03:53:12PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> kernel/built-in.o: In function `touch_nmi_watchdog':
> (.text+0x449bc): multiple definition of `touch_nmi_watchdog'
> arch/sparc/kernel/built-in.o:(.text+0x11b28): first defined here
> 
> Probably caused by commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
> ("lockup_detector: Combine nmi_watchdog and softlockup detector").
> 
> The one in kernel/ used to only be built when CONFIG_NMI_WATCHDOG was set
> which depended on CONFIG_PERF_EVENTS_NMI which was only ever set for
> ARCH=x86.  This probably breaks mn10300 and blackfin as well, at least.
> We also have ARCH_HAS_NMI_WATCHDOG to determine this ...
> 
> I tried protecting the definition of touch_nmi_watchdog with
> ARCH_HAS_NMI_WATCHDOG, but that broke the x86_64 allmodconfig build
> (which defines ARCH_HAS_NMI_WATCHDOG if CONFIG_X86_LOCAL_APIC is defined
> but only builds its version if CONFIG_LOCKUP_DETECTOR is not 'y').
> 
> So I have left is as it is for today.  Please see if someone can come up
> with a solution.

I realized I was lazy and different provide a formal patch (and I had a
couple of warnings too).  Here is something better.

Cheers,
Don

---
commit 578178d5133403e469543bfff8a4e404d878563b
Author: Don Zickus <dzickus@redhat.com>
Date:   Fri May 14 11:04:52 2010 -0400

    [watchdog] nmi: cross arch compile fixes
    
    Combining the softlockup and hardlockup code causes watchdog.c to always be
    compiled.  Surround some code which prevents the hardlockup stuff from being
    compiled if other arches have a different NMI handler.
    
    Signed-off-by: Don Zickus <dzickus@redhat.com>

diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 52f32e0..3a57a04 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -3,10 +3,10 @@
 #
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
-ifneq ($(CONFIG_LOCKUP_DETECTOR),y)
+ifneq ($(CONFIG_PERF_EVENTS_NMI),y)
 obj-$(CONFIG_X86_LOCAL_APIC)	+= nmi.o
 endif
-obj-$(CONFIG_LOCKUP_DETECTOR)	+= hw_nmi.o
+obj-$(CONFIG_PERF_EVENTS_NMI)	+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index abd48aa..9a30da4 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -20,7 +20,7 @@ extern void touch_nmi_watchdog(void);
 extern void acpi_nmi_disable(void);
 extern void acpi_nmi_enable(void);
 #else
-#ifndef CONFIG_LOCKUP_DETECTOR
+#ifndef CONFIG_PERF_EVENTS_NMI
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index be5e74e..65429dd 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,13 +31,13 @@ int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
-static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
-static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_PERF_EVENTS_NMI
+static DEFINE_PER_CPU(bool, hard_watchdog_warn);
+static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
@@ -139,6 +139,7 @@ void touch_all_softlockup_watchdogs(void)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
 
+#ifdef CONFIG_PERF_EVENTS_NMI
 void touch_nmi_watchdog(void)
 {
 	__get_cpu_var(watchdog_nmi_touch) = true;
@@ -146,6 +147,8 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
+#endif
+
 void touch_softlockup_watchdog_sync(void)
 {
 	__raw_get_cpu_var(softlockup_touch_sync) = true;
