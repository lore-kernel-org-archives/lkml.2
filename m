Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2HRWEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:04:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46293 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2HRWEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:04:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: [Update][PATCH] ARM: shmobile: Add A4S cpuidle state on sh7372
Date: Sun, 19 Aug 2012 00:10:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <201208162210.31058.rjw@sisk.pl> <CANqRtoSh0GvUws5hj9nZvVg4wZ0zDNB+-spuWt5RTVJUNe4h0A@mail.gmail.com>
In-Reply-To: <CANqRtoSh0GvUws5hj9nZvVg4wZ0zDNB+-spuWt5RTVJUNe4h0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208190010.36593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, August 17, 2012, Magnus Damm wrote:
> Hi Rafael,
> 
> Thanks for your patch. Please see below for my comment.
> 
> On Fri, Aug 17, 2012 at 5:10 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Add a "C5" cpuidle state to the SH7372 SoC connected to the A4S power
> > domain in such a way that A4S may be turned off by cpuidle if all
> > I/O devices in that domain have been suspended (or do not have
> > attached drivers).
> >
> > This requires some reorganization of the initialization of SH7372
> > power management which affects the the boards based on it, Mackerel
> > and AP4EVB.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> 
> [snip]
> 
> > --- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
> > +++ linux/arch/arm/mach-shmobile/pm-sh7372.c
> > @@ -339,6 +339,21 @@ static void sh7372_enter_a3sm_common(int
> >         sh7372_set_reset_vector(__pa(sh7372_resume_core_standby_sysc));
> >         sh7372_enter_sysc(pllc0_on, 1 << 12);
> >  }
> > +
> > +static void sh7372_enter_a4s_common(int pllc0_on)
> > +{
> > +       sh7372_intca_suspend();
> > +       sh7372_enter_sysc(pllc0_on, 1 << 10);
> > +       sh7372_intca_resume();
> > +}
> > +
> > +static void sh7372_pm_setup_smfram(void)
> > +{
> > +       memcpy((void *)SMFRAM, sh7372_resume_core_standby_sysc, 0x100);
> > +       sh7372_set_reset_vector(SMFRAM);
> > +}
> 
> I believe the reset vector is being setup dynamically depending on the
> sleep mode,

Yes, it is, sorry for overlooking that!

> so you probably want to move sh7372_set_reset_vector()
> into sh7372_enter_a4s_common().

Thanks for the review, updated patch follows.

Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ARM: shmobile: Add A4S cpuidle state on sh7372

Add a "C5" cpuidle state to the SH7372 SoC connected to the A4S power
domain in such a way that A4S may be turned off by cpuidle if all
I/O devices in that domain have been suspended (or do not have
attached drivers).

This requires some reorganization of the initialization of SH7372
power management which affects the the boards based on it, Mackerel
and AP4EVB.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/board-ap4evb.c        |    2 
 arch/arm/mach-shmobile/board-mackerel.c      |    2 
 arch/arm/mach-shmobile/include/mach/sh7372.h |    2 
 arch/arm/mach-shmobile/pm-sh7372.c           |   56 ++++++++++++++++++++++-----
 4 files changed, 50 insertions(+), 12 deletions(-)

Index: linux/arch/arm/mach-shmobile/board-ap4evb.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-ap4evb.c
+++ linux/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1486,6 +1486,6 @@ MACHINE_START(AP4EVB, "ap4evb")
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= ap4evb_init,
-	.init_late	= shmobile_init_late,
+	.init_late	= sh7372_pm_init_late,
 	.timer		= &shmobile_timer,
 MACHINE_END
Index: linux/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux/arch/arm/mach-shmobile/board-mackerel.c
@@ -1654,6 +1654,6 @@ MACHINE_START(MACKEREL, "mackerel")
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= mackerel_init,
-	.init_late	= shmobile_init_late,
+	.init_late	= sh7372_pm_init_late,
 	.timer		= &shmobile_timer,
 MACHINE_END
Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -489,4 +489,6 @@ extern void __init sh7372_init_pm_domain
 static inline void sh7372_init_pm_domains(void) {}
 #endif
 
+extern void __init sh7372_pm_init_late(void);
+
 #endif /* __ASM_SH7372_H__ */
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -339,6 +339,21 @@ static void sh7372_enter_a3sm_common(int
 	sh7372_set_reset_vector(__pa(sh7372_resume_core_standby_sysc));
 	sh7372_enter_sysc(pllc0_on, 1 << 12);
 }
+
+static void sh7372_enter_a4s_common(int pllc0_on)
+{
+	sh7372_intca_suspend();
+	sh7372_set_reset_vector(SMFRAM);
+	sh7372_enter_sysc(pllc0_on, 1 << 10);
+	sh7372_intca_resume();
+}
+
+static void sh7372_pm_setup_smfram(void)
+{
+	memcpy((void *)SMFRAM, sh7372_resume_core_standby_sysc, 0x100);
+}
+#else
+static inline void sh7372_pm_setup_smfram(void) {}
 #endif /* CONFIG_SUSPEND || CONFIG_CPU_IDLE */
 
 #ifdef CONFIG_CPU_IDLE
@@ -378,11 +393,24 @@ static int sh7372_enter_a3sm_pll_off(str
 	return 3;
 }
 
+static int sh7372_enter_a4s(struct cpuidle_device *dev,
+			    struct cpuidle_driver *drv, int index)
+{
+	unsigned long msk, msk2;
+
+	if (!sh7372_sysc_valid(&msk, &msk2))
+		return sh7372_enter_a3sm_pll_off(dev, drv, index);
+
+	sh7372_setup_sysc(msk, msk2);
+	sh7372_enter_a4s_common(0);
+	return 4;
+}
+
 static struct cpuidle_driver sh7372_cpuidle_driver = {
 	.name			= "sh7372_cpuidle",
 	.owner			= THIS_MODULE,
 	.en_core_tk_irqen	= 1,
-	.state_count		= 4,
+	.state_count		= 5,
 	.safe_state_index	= 0, /* C1 */
 	.states[0] = ARM_CPUIDLE_WFI_STATE,
 	.states[0].enter = shmobile_enter_wfi,
@@ -410,6 +438,15 @@ static struct cpuidle_driver sh7372_cpui
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.enter = sh7372_enter_a3sm_pll_off,
 	},
+	.states[4] = {
+		.name = "C5",
+		.desc = "A4S PLL OFF",
+		.exit_latency = 240,
+		.target_residency = 30 + 240,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.enter = sh7372_enter_a4s,
+		.disabled = true,
+	},
 };
 
 static void sh7372_cpuidle_init(void)
@@ -421,15 +458,6 @@ static void sh7372_cpuidle_init(void) {}
 #endif
 
 #ifdef CONFIG_SUSPEND
-static void sh7372_enter_a4s_common(int pllc0_on)
-{
-	sh7372_intca_suspend();
-	memcpy((void *)SMFRAM, sh7372_resume_core_standby_sysc, 0x100);
-	sh7372_set_reset_vector(SMFRAM);
-	sh7372_enter_sysc(pllc0_on, 1 << 10);
-	sh7372_intca_resume();
-}
-
 static int sh7372_enter_suspend(suspend_state_t suspend_state)
 {
 	unsigned long msk, msk2;
@@ -497,6 +525,14 @@ void __init sh7372_pm_init(void)
 	/* do not convert A3SM, A3SP, A3SG, A4R power down into A4S */
 	__raw_writel(0, PDNSEL);
 
+	sh7372_pm_setup_smfram();
+
 	sh7372_suspend_init();
 	sh7372_cpuidle_init();
 }
+
+void __init sh7372_pm_init_late(void)
+{
+	shmobile_init_late();
+	pm_genpd_name_attach_cpuidle("A4S", 4);
+}
