Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2HFXL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:11:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab2HFXLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:11:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 8/12] PM / shmobile: Do not access sh7372 A4S domain internals directly
Date: Tue, 7 Aug 2012 01:11:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201208070105.23262.rjw@sisk.pl>
In-Reply-To: <201208070105.23262.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208070111.51313.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sh7372_enter_suspend() routine checks the status field of the
generic PM domain object corresponding to the A4S domain in order to
check if it can turn that domain off when entering system sleep.
However, it shouldn't rely on the specific values of the generic
data structures this way, so make it use its own mechanism to
recognize when it is safe to turn that domain off.

For this purpos, introduce a boolean variable a4s_suspend_ready
that will be set by the A4S' suspend routine and unset by its
resume routine executed by rmobile_pd_power_down() and
__rmobile_pd_power_up(), respectively.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -110,21 +110,33 @@ struct rmobile_pm_domain sh7372_pd_a3ri
 	.bit_shift = 8,
 };
 
+static bool a4s_suspend_ready;
+
 static int sh7372_pd_a4s_suspend(void)
 {
 	/*
 	 * The A4S domain contains the CPU core and therefore it should
-	 * only be turned off if the CPU is in use.
+	 * only be turned off if the CPU is not in use.  This may happen
+	 * during system suspend, when SYSC is going to be used for generating
+	 * resume signals and a4s_suspend_ready is set to let
+	 * sh7372_enter_suspend() know that it can turn A4S off.
 	 */
+	a4s_suspend_ready = true;
 	return -EBUSY;
 }
 
+static void sh7372_pd_a4s_resume(void)
+{
+	a4s_suspend_ready = false;
+}
+
 struct rmobile_pm_domain sh7372_pd_a4s = {
 	.genpd.name = "A4S",
 	.bit_shift = 10,
 	.gov = &pm_domain_always_on_gov,
 	.no_debug = true,
 	.suspend = sh7372_pd_a4s_suspend,
+	.resume = sh7372_pd_a4s_resume,
 };
 
 static int sh7372_a3sp_pd_suspend(void)
@@ -390,8 +402,7 @@ static int sh7372_enter_suspend(suspend_
 
 	/* check active clocks to determine potential wakeup sources */
 	if (sh7372_sysc_valid(&msk, &msk2)) {
-		if (!console_suspend_enabled &&
-		    sh7372_pd_a4s.genpd.status == GPD_STATE_POWER_OFF) {
+		if (!console_suspend_enabled && a4s_suspend_ready) {
 			/* convert INTC mask/sense to SYSC mask/sense */
 			sh7372_setup_sysc(msk, msk2);
 

