Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1KIIxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:53:15 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:21659 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1KIIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:53:12 -0500
X-IronPort-AV: E=Sophos;i="4.69,483,1315180800"; 
   d="scan'208";a="8831910"
Subject: Re: Linux 2.6.32.47
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Greg KH <greg@kroah.com>
CC: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20111108233543.GB15965@kroah.com>
References: <20111107213431.GA8483@kroah.com>
	 <1320708564@msgid.manchmal.in-ulm.de> <20111108003024.GA6610@suse.de>
	 <1320736973.16747.55.camel@dagon.hellion.org.uk> <4EB9AFC0.4010206@suse.cz>
	 <20111108233543.GB15965@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 9 Nov 2011 08:53:09 +0000
Message-ID: <1320828790.16747.99.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 15:35 -0800, Greg KH wrote:
> On Tue, Nov 08, 2011 at 11:40:00PM +0100, Jiri Slaby wrote:
> > On 11/08/2011 08:22 AM, Ian Campbell wrote:
> > >On Mon, 2011-11-07 at 16:30 -0800, Greg KH wrote:
> > >>On Tue, Nov 08, 2011 at 12:43:49AM +0100, Christoph Biedl wrote:
> > >>>Greg KH wrote...
> > >>>
> > >>>>I'm announcing the release of the 2.6.32.47 kernel.
> > >>>
> > >>>Unfortunately this does not build anymore on ARM (Debian armel):
> > >>>
> > >>>   CHK     include/linux/version.h
> > >>>   SYMLINK include/asm ->  include/asm-arm
> > >>>make[1]: `include/asm-arm/mach-types.h' is up to date.
> > >>>   CHK     include/linux/utsrelease.h
> > >>>   CALL    scripts/checksyscalls.sh
> > >>>   CHK     include/linux/compile.h
> > >>>   GEN     .version
> > >>>   CHK     include/linux/compile.h
> > >>>   UPD     include/linux/compile.h
> > >>>   CC      init/version.o
> > >>>   LD      init/built-in.o
> > >>>   LD      .tmp_vmlinux1
> > >>>drivers/built-in.o: In function `sysdev_resume':
> > >>>ledtrig-default-on.c:(.text+0x2a97c): undefined reference to `irq_pm_syscore_resume'
> > >>>make: *** [.tmp_vmlinux1] Error 1
> > >>>
> > >>>
> > >>>The most likely culprit is
> > >>>
> > >>>     commit 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40
> > >>>     Author: Ian Campbell<ian.campbell@citrix.com>
> > >>>     Date:   Mon Oct 3 15:37:00 2011 +0100
> > >>>
> > >>>	genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier
> > >>>
> > >>>as reverting that commit made the error go away.
> > >>>
> > >>>The .config used is attached. FWIW, the target system is a DockStar.
> > >>>
> > >>>Sorry for not having checked during the review period, I should have
> > >>>done so.
> > >>
> > >>Not good.
> > >>
> > >>Ian, Konrad, any thoughts as to how to fix this?
> > >
> > >Looks like I got the wrong CONFIG symbol for the function, or more
> > >importantly the dummy version of it. Sorry about this.
> > >
> > >Ian.
> > >
> > >8<--------------------------------------------------------------
> > >
> > >>From 33a64cf4a184b47493ef312b08468aca3361e112 Mon Sep 17 00:00:00 2001
> > >From: Ian Campbell<ian.campbell@citrix.com>
> > >Date: Tue, 8 Nov 2011 07:19:06 +0000
> > >Subject: [PATCH] irq: fix build error due to missing irq_pm_syscore_resume
> > >
> > >irq_pm_syscore_resume is only available iff CONFIG_PM_SLEEP (kernel/irq/pm.o is
> > >only built if this is true). Move the definition (and the dummy definition)
> > >under that umbrella.
> > >
> > >Introduced by the backport of upstream 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a
> > >as 0f12a6ad9fa3a03f2bcee36c9cb704821e244c40.
> > >
> > >Signed-off-by: Ian Campbell<ian.campbell@citrix.com>
> > >Reported-by: Christoph Biedl<linux-kernel.bfrz@manchmal.in-ulm.de>
> > >Reported-by: Antoine Martin<antoine@nagafix.co.uk>
> > >---
> > >  include/linux/interrupt.h |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > >diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> > >index c7e1aa5..a65ef60 100644
> > >--- a/include/linux/interrupt.h
> > >+++ b/include/linux/interrupt.h
> > >@@ -199,16 +199,16 @@ extern void enable_irq(unsigned int irq);
> > >  #ifdef CONFIG_GENERIC_HARDIRQS
> > >  extern void suspend_device_irqs(void);
> > >  extern void resume_device_irqs(void);
> > >-extern void irq_pm_syscore_resume(void);
> > >  #ifdef CONFIG_PM_SLEEP
> > >  extern int check_wakeup_irqs(void);
> > >+extern void irq_pm_syscore_resume(void);
> > >  #else
> > >  static inline int check_wakeup_irqs(void) { return 0; }
> > >+static inline void irq_pm_syscore_resume(void) { };
> > >  #endif
> > >  #else
> > >  static inline void suspend_device_irqs(void) { };
> > >  static inline void resume_device_irqs(void) { };
> > >-static inline void irq_pm_syscore_resume(void) { };
> > >  static inline int check_wakeup_irqs(void) { return 0; }
> > >  #endif
> > 
> > Hmm, sparc doesn't have generic irqs. So:
> > drivers/base/sys.c: In function 'sysdev_resume':
> > drivers/base/sys.c:478: error: implicit declaration of function
> > 'irq_pm_syscore_resume'
> 
> Ugh, what a mess.
> 
> Ian, I'm just going to revert your original patch, and the other 2
> patches that broke the builds, and do a new .32 release.
> 
> Please send me the correct patch that builds on all arches, if you all
> feel it is still needed.

Sorry about this. I should have just looked at where else
check_wakeup_irqs was stubbed out and I'd have gotten this right first
time.

I'm pretty sure this is now correct but to make double sure I've tested
by building defconfig arm amd64 cris i386 ia64 m68k and s390x. I tried a
bunch of other archs too but they failed for other (pre-existing)
reasons but with no mention of irq_pm_syscore_resume (I used "make -k"
so it'll have built as much as it could).

Sorry again for the mess.

Ian.

8<----------------------------------------

>From e3c2a4ded8a458ad0cd77017175cf1cc804fab1d Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 3 Oct 2011 15:37:00 +0100
Subject: [PATCH] genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier

commit 9bab0b7fbaceec47d32db51cd9e59c82fb071f5a upstream

This adds a mechanism to resume selected IRQs during syscore_resume
instead of dpm_resume_noirq.

Under Xen we need to resume IRQs associated with IPIs early enough
that the resched IPI is unmasked and we can therefore schedule
ourselves out of the stop_machine where the suspend/resume takes
place.

This issue was introduced by 676dc3cf5bc3 "xen: Use IRQF_FORCE_RESUME".

Back ported to 2.6.32 (which lacks syscore support) by calling the relavant
resume function directly from sysdev_resume).

v2: Fixed non-x86 build errors.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1318713254.11016.52.camel@dagon.hellion.org.uk
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c        |    6 ++++++
 drivers/xen/events.c      |    2 +-
 include/linux/interrupt.h |    6 ++++++
 kernel/irq/pm.c           |   35 ++++++++++++++++++++++++++++-------
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 0d90390..3f202f7 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -471,6 +471,12 @@ int sysdev_resume(void)
 {
 	struct sysdev_class *cls;
 
+	/*
+	 * Called from syscore in mainline but called directly here
+	 * since syscore does not exist in this tree.
+	 */
+	irq_pm_syscore_resume();
+
 	WARN_ONCE(!irqs_disabled(),
 		"Interrupts enabled while resuming system devices\n");
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 009ca4e..15ed43e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -536,7 +536,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME | IRQF_EARLY_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 4528f29..c739150 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -54,6 +54,8 @@
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
  * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
+ * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
+ *                resume time.
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -66,6 +68,7 @@
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
 #define IRQF_FORCE_RESUME	0x00008000
+#define IRQF_EARLY_RESUME	0x00020000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
@@ -198,13 +201,16 @@ extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
+extern void irq_pm_syscore_resume(void);
 #else
 static inline int check_wakeup_irqs(void) { return 0; }
+static inline void irq_pm_syscore_resume(void) { };
 #endif
 #else
 static inline void suspend_device_irqs(void) { };
 static inline void resume_device_irqs(void) { };
 static inline int check_wakeup_irqs(void) { return 0; }
+static inline void irq_pm_syscore_resume(void) { };
 #endif
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0067abb..b1fc3dd 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -39,25 +39,46 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
-/**
- * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
- *
- * Enable all interrupt lines previously disabled by suspend_device_irqs() that
- * have the IRQ_SUSPENDED flag set.
- */
-void resume_device_irqs(void)
+static void resume_irqs(bool want_early)
 {
 	struct irq_desc *desc;
 	int irq;
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
+		bool is_early = desc->action &&
+			desc->action->flags & IRQF_EARLY_RESUME;
+
+		if (is_early != want_early)
+			continue;
 
 		spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
+
+/**
+ * irq_pm_syscore_ops - enable interrupt lines early
+ *
+ * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
+ */
+void irq_pm_syscore_resume(void)
+{
+	resume_irqs(true);
+}
+
+/**
+ * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
+ *
+ * Enable all non-%IRQF_EARLY_RESUME interrupt lines previously
+ * disabled by suspend_device_irqs() that have the IRQS_SUSPENDED flag
+ * set as well as those with %IRQF_FORCE_RESUME.
+ */
+void resume_device_irqs(void)
+{
+	resume_irqs(false);
+}
 EXPORT_SYMBOL_GPL(resume_device_irqs);
 
 /**
-- 
1.7.2.5



