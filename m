Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2GPVaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:30:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2GPV2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:28:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 7/14] ARM: shmobile: Remove dead sh7372 power management code
Date: Mon, 16 Jul 2012 23:24:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>
References: <201207032302.17805.rjw@sisk.pl> <201207052217.48086.rjw@sisk.pl> <201207162315.49073.rjw@sisk.pl>
In-Reply-To: <201207162315.49073.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207162324.08995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the sh7372_pd_a4s.genpd.status == GPD_STATE_POWER_OFF condition
is never satisfied, remove the code depending on it for now.
That (or equivalent) code will be added again when the cpuidle state
involving the A4S domain is added to the sh7372's cpuidle driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   94 -------------------------------------
 1 file changed, 94 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -174,75 +174,6 @@ static void sh7372_enter_sysc(int pllc0_
 	__raw_writel(0, SBAR);
 }
 
-static int sh7372_sysc_valid(unsigned long *mskp, unsigned long *msk2p)
-{
-	unsigned long mstpsr0, mstpsr1, mstpsr2, mstpsr3, mstpsr4;
-	unsigned long msk, msk2;
-
-	/* check active clocks to determine potential wakeup sources */
-
-	mstpsr0 = __raw_readl(MSTPSR0);
-	if ((mstpsr0 & 0x00000003) != 0x00000003) {
-		pr_debug("sh7372 mstpsr0 0x%08lx\n", mstpsr0);
-		return 0;
-	}
-
-	mstpsr1 = __raw_readl(MSTPSR1);
-	if ((mstpsr1 & 0xff079b7f) != 0xff079b7f) {
-		pr_debug("sh7372 mstpsr1 0x%08lx\n", mstpsr1);
-		return 0;
-	}
-
-	mstpsr2 = __raw_readl(MSTPSR2);
-	if ((mstpsr2 & 0x000741ff) != 0x000741ff) {
-		pr_debug("sh7372 mstpsr2 0x%08lx\n", mstpsr2);
-		return 0;
-	}
-
-	mstpsr3 = __raw_readl(MSTPSR3);
-	if ((mstpsr3 & 0x1a60f010) != 0x1a60f010) {
-		pr_debug("sh7372 mstpsr3 0x%08lx\n", mstpsr3);
-		return 0;
-	}
-
-	mstpsr4 = __raw_readl(MSTPSR4);
-	if ((mstpsr4 & 0x00008cf0) != 0x00008cf0) {
-		pr_debug("sh7372 mstpsr4 0x%08lx\n", mstpsr4);
-		return 0;
-	}
-
-	msk = 0;
-	msk2 = 0;
-
-	/* make bitmaps of limited number of wakeup sources */
-
-	if ((mstpsr2 & (1 << 23)) == 0) /* SPU2 */
-		msk |= 1 << 31;
-
-	if ((mstpsr2 & (1 << 12)) == 0) /* MFI_MFIM */
-		msk |= 1 << 21;
-
-	if ((mstpsr4 & (1 << 3)) == 0) /* KEYSC */
-		msk |= 1 << 2;
-
-	if ((mstpsr1 & (1 << 24)) == 0) /* CMT0 */
-		msk |= 1 << 1;
-
-	if ((mstpsr3 & (1 << 29)) == 0) /* CMT1 */
-		msk |= 1 << 1;
-
-	if ((mstpsr4 & (1 << 0)) == 0) /* CMT2 */
-		msk |= 1 << 1;
-
-	if ((mstpsr2 & (1 << 13)) == 0) /* MFI_MFIS */
-		msk2 |= 1 << 17;
-
-	*mskp = msk;
-	*msk2p = msk2;
-
-	return 1;
-}
-
 static void sh7372_icr_to_irqcr(unsigned long icr, u16 *irqcr1p, u16 *irqcr2p)
 {
 	u16 tmp, irqcr1, irqcr2;
@@ -375,33 +306,8 @@ static void sh7372_cpuidle_init(void) {}
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
-	unsigned long msk, msk2;
-
-	/* check active clocks to determine potential wakeup sources */
-	if (sh7372_sysc_valid(&msk, &msk2)) {
-		if (!console_suspend_enabled &&
-		    sh7372_pd_a4s.genpd.status == GPD_STATE_POWER_OFF) {
-			/* convert INTC mask/sense to SYSC mask/sense */
-			sh7372_setup_sysc(msk, msk2);
-
-			/* enter A4S sleep with PLLC0 off */
-			pr_debug("entering A4S\n");
-			sh7372_enter_a4s_common(0);
-			return 0;
-		}
-	}
-
 	/* default to enter A3SM sleep with PLLC0 off */
 	pr_debug("entering A3SM\n");
 	sh7372_enter_a3sm_common(0);

