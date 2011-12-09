Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1LIXoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:44:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab1LIXoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:44:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [RFC][PATCH 2/4] PM / shmobile: Remove the stay_on flag from SH7372's PM domains
Date: Sat, 10 Dec 2011 00:44:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl>
In-Reply-To: <201112100042.45168.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100044.35717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SH7372 uses two independent mechanisms for ensuring that power
domains will never be turned off: the stay_on flag and the "always
on" domain governor.  Moreover, the "always on" governor is only taken
into accout by runtime PM code paths, while the stay_on flag affects
all attempts to turn the given domain off.  Thus setting the stay_on
flag causes the "always on" governor to be unnecessary, which is
quite confusing.

However, the stay_on flag is currently only set for the A3SP PM
domain and only if console_suspend_enabled, so it may be replaced
by checking console_suspend_enabled directly in the A3SP's
.suspend() routine.  [This requires domain .suspend() to return
a result, but that is a minor modification.]

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/sh7372.h |    3 --
 arch/arm/mach-shmobile/pm-sh7372.c           |   36 ++++++++++++---------------
 2 files changed, 18 insertions(+), 21 deletions(-)

Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -480,11 +480,10 @@ struct platform_device;
 struct sh7372_pm_domain {
 	struct generic_pm_domain genpd;
 	struct dev_power_governor *gov;
-	void (*suspend)(void);
+	int (*suspend)(void);
 	void (*resume)(void);
 	unsigned int bit_shift;
 	bool no_debug;
-	bool stay_on;
 };
 
 static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -82,11 +82,12 @@ static int pd_power_down(struct generic_
 	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
 	unsigned int mask = 1 << sh7372_pd->bit_shift;
 
-	if (sh7372_pd->suspend)
-		sh7372_pd->suspend();
+	if (sh7372_pd->suspend) {
+		int ret = sh7372_pd->suspend();
 
-	if (sh7372_pd->stay_on)
-		return 0;
+		if (ret)
+			return ret;
+	}
 
 	if (__raw_readl(PSTR) & mask) {
 		unsigned int retry_count;
@@ -113,9 +114,6 @@ static int __pd_power_up(struct sh7372_p
 	unsigned int retry_count;
 	int ret = 0;
 
-	if (sh7372_pd->stay_on)
-		goto out;
-
 	if (__raw_readl(PSTR) & mask)
 		goto out;
 
@@ -148,10 +146,11 @@ static int pd_power_up(struct generic_pm
 	 return __pd_power_up(to_sh7372_pd(genpd), true);
 }
 
-static void sh7372_a4r_suspend(void)
+static int sh7372_a4r_suspend(void)
 {
 	sh7372_intcs_suspend();
 	__raw_writel(0x300fffff, WUPRMSK); /* avoid wakeup */
+	return 0;
 }
 
 static bool pd_active_wakeup(struct device *dev)
@@ -243,7 +242,6 @@ struct sh7372_pm_domain sh7372_a4r = {
 	.gov = &pm_domain_always_on_gov,
 	.suspend = sh7372_a4r_suspend,
 	.resume = sh7372_intcs_resume,
-	.stay_on = true,
 };
 
 struct sh7372_pm_domain sh7372_a3rv = {
@@ -256,21 +254,23 @@ struct sh7372_pm_domain sh7372_a3ri = {
 	.bit_shift = 8,
 };
 
+static int sh7372_a3sp_suspend(void)
+{
+	/*
+	 * Serial consoles make use of SCIF hardware located in A3SP,
+	 * keep such power domain on if "no_console_suspend" is set.
+	 */
+	return console_suspend_enabled ? -EBUSY : 0;
+}
+
 struct sh7372_pm_domain sh7372_a3sp = {
 	.genpd.name = "A3SP",
 	.bit_shift = 11,
 	.gov = &pm_domain_always_on_gov,
 	.no_debug = true,
+	.suspend = sh7372_a3sp_suspend,
 };
 
-static void sh7372_a3sp_init(void)
-{
-	/* serial consoles make use of SCIF hardware located in A3SP,
-	 * keep such power domain on if "no_console_suspend" is set.
-	 */
-	sh7372_a3sp.stay_on = !console_suspend_enabled;
-}
-
 struct sh7372_pm_domain sh7372_a3sg = {
 	.genpd.name = "A3SG",
 	.bit_shift = 13,
@@ -514,8 +514,6 @@ void __init sh7372_pm_init(void)
 	/* do not convert A3SM, A3SP, A3SG, A4R power down into A4S */
 	__raw_writel(0, PDNSEL);
 
-	sh7372_a3sp_init();
-
 	sh7372_suspend_init();
 	sh7372_cpuidle_init();
 }

