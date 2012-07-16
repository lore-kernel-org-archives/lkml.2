Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2GPV3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:29:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43111 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2GPV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:28:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 9/14] ARM: shmobile: Move sh7372's PM domain objects to a table
Date: Mon, 16 Jul 2012 23:26:37 +0200
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
Message-Id: <201207162326.37644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Instead of giving a name to every sh7372's PM domain object, put them
all into a table and use rmobile_init_domains(), introduced by a
previous patch, for initializing them all altogether.  Also, use
pm_genpd_add_subdomain_names() for adding subdomains to the PM
domains and pm_genpd_poweron_name() for turning on the A4S domain
when preparing for system suspend.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/sh7372.h |   18 +---
 arch/arm/mach-shmobile/pm-sh7372.c           |  109 +++++++++++++--------------
 arch/arm/mach-shmobile/setup-sh7372.c        |   16 ---
 3 files changed, 63 insertions(+), 80 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -71,21 +71,6 @@
 
 #ifdef CONFIG_PM
 
-struct rmobile_pm_domain sh7372_pd_a4lc = {
-	.genpd.name = "A4LC",
-	.bit_shift = 1,
-};
-
-struct rmobile_pm_domain sh7372_pd_a4mp = {
-	.genpd.name = "A4MP",
-	.bit_shift = 2,
-};
-
-struct rmobile_pm_domain sh7372_pd_d4 = {
-	.genpd.name = "D4",
-	.bit_shift = 3,
-};
-
 static int sh7372_a4r_pd_suspend(void)
 {
 	sh7372_intcs_suspend();
@@ -93,40 +78,15 @@ static int sh7372_a4r_pd_suspend(void)
 	return 0;
 }
 
-struct rmobile_pm_domain sh7372_pd_a4r = {
-	.genpd.name = "A4R",
-	.bit_shift = 5,
-	.suspend = sh7372_a4r_pd_suspend,
-	.resume = sh7372_intcs_resume,
-};
-
-struct rmobile_pm_domain sh7372_pd_a3rv = {
-	.genpd.name = "A3RV",
-	.bit_shift = 6,
-};
-
-struct rmobile_pm_domain sh7372_pd_a3ri = {
-	.genpd.name = "A3RI",
-	.bit_shift = 8,
-};
-
-static int sh7372_pd_a4s_suspend(void)
+static int sh7372_a4s_pd_suspend(void)
 {
 	/*
 	 * The A4S domain contains the CPU core and therefore it should
-	 * only be turned off if the CPU is in use.
+	 * only be turned off if the CPU is not in use.
 	 */
 	return -EBUSY;
 }
 
-struct rmobile_pm_domain sh7372_pd_a4s = {
-	.genpd.name = "A4S",
-	.bit_shift = 10,
-	.gov = &pm_domain_always_on_gov,
-	.no_debug = true,
-	.suspend = sh7372_pd_a4s_suspend,
-};
-
 static int sh7372_a3sp_pd_suspend(void)
 {
 	/*
@@ -136,18 +96,61 @@ static int sh7372_a3sp_pd_suspend(void)
 	return console_suspend_enabled ? 0 : -EBUSY;
 }
 
-struct rmobile_pm_domain sh7372_pd_a3sp = {
-	.genpd.name = "A3SP",
-	.bit_shift = 11,
-	.gov = &pm_domain_always_on_gov,
-	.no_debug = true,
-	.suspend = sh7372_a3sp_pd_suspend,
+static struct rmobile_pm_domain sh7372_pm_domains[] = {
+	{
+		.genpd.name = "A4LC",
+		.bit_shift = 1,
+	},
+	{
+		.genpd.name = "A4MP",
+		.bit_shift = 2,
+	},
+	{
+		.genpd.name = "D4",
+		.bit_shift = 3,
+	},
+	{
+		.genpd.name = "A4R",
+		.bit_shift = 5,
+		.suspend = sh7372_a4r_pd_suspend,
+		.resume = sh7372_intcs_resume,
+	},
+	{
+		.genpd.name = "A3RV",
+		.bit_shift = 6,
+	},
+	{
+		.genpd.name = "A3RI",
+		.bit_shift = 8,
+	},
+	{
+		.genpd.name = "A4S",
+		.bit_shift = 10,
+		.gov = &pm_domain_always_on_gov,
+		.no_debug = true,
+		.suspend = sh7372_a4s_pd_suspend,
+	},
+	{
+		.genpd.name = "A3SP",
+		.bit_shift = 11,
+		.gov = &pm_domain_always_on_gov,
+		.no_debug = true,
+		.suspend = sh7372_a3sp_pd_suspend,
+	},
+	{
+		.genpd.name = "A3SG",
+		.bit_shift = 13,
+	},
 };
 
-struct rmobile_pm_domain sh7372_pd_a3sg = {
-	.genpd.name = "A3SG",
-	.bit_shift = 13,
-};
+void __init sh7372_init_pm_domains(void)
+{
+	rmobile_init_domains(sh7372_pm_domains, ARRAY_SIZE(sh7372_pm_domains));
+	pm_genpd_add_subdomain_names("A4LC", "A3RV");
+	pm_genpd_add_subdomain_names("A4R", "A4LC");
+	pm_genpd_add_subdomain_names("A4S", "A3SG");
+	pm_genpd_add_subdomain_names("A4S", "A3SP");
+}
 
 #endif /* CONFIG_PM */
 
@@ -331,7 +334,7 @@ static int sh7372_pm_notifier_fn(struct
 		 * executed during system suspend and resume, respectively, so
 		 * that those functions don't crash while accessing the INTCS.
 		 */
-		pm_genpd_poweron(&sh7372_pd_a4r.genpd);
+		pm_genpd_name_poweron("A4R");
 		break;
 	case PM_POST_SUSPEND:
 		pm_genpd_poweroff_unused();
Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1001,21 +1001,7 @@ static struct platform_device *sh7372_la
 
 void __init sh7372_add_standard_devices(void)
 {
-	rmobile_init_pm_domain(&sh7372_pd_a4lc);
-	rmobile_init_pm_domain(&sh7372_pd_a4mp);
-	rmobile_init_pm_domain(&sh7372_pd_d4);
-	rmobile_init_pm_domain(&sh7372_pd_a4r);
-	rmobile_init_pm_domain(&sh7372_pd_a3rv);
-	rmobile_init_pm_domain(&sh7372_pd_a3ri);
-	rmobile_init_pm_domain(&sh7372_pd_a4s);
-	rmobile_init_pm_domain(&sh7372_pd_a3sp);
-	rmobile_init_pm_domain(&sh7372_pd_a3sg);
-
-	pm_genpd_add_subdomain_names("A4LC", "A3RV");
-	pm_genpd_add_subdomain_names("A4R", "A4LC");
-
-	pm_genpd_add_subdomain_names("A4S", "A3SG");
-	pm_genpd_add_subdomain_names("A4S", "A3SP");
+	sh7372_init_pm_domains();
 
 	platform_add_devices(sh7372_early_devices,
 			    ARRAY_SIZE(sh7372_early_devices));
Index: linux/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -478,21 +478,15 @@ extern struct clk sh7372_fsibck_clk;
 extern struct clk sh7372_fsidiva_clk;
 extern struct clk sh7372_fsidivb_clk;
 
-#ifdef CONFIG_PM
-extern struct rmobile_pm_domain sh7372_pd_a4lc;
-extern struct rmobile_pm_domain sh7372_pd_a4mp;
-extern struct rmobile_pm_domain sh7372_pd_d4;
-extern struct rmobile_pm_domain sh7372_pd_a4r;
-extern struct rmobile_pm_domain sh7372_pd_a3rv;
-extern struct rmobile_pm_domain sh7372_pd_a3ri;
-extern struct rmobile_pm_domain sh7372_pd_a4s;
-extern struct rmobile_pm_domain sh7372_pd_a3sp;
-extern struct rmobile_pm_domain sh7372_pd_a3sg;
-#endif /* CONFIG_PM */
-
 extern void sh7372_intcs_suspend(void);
 extern void sh7372_intcs_resume(void);
 extern void sh7372_intca_suspend(void);
 extern void sh7372_intca_resume(void);
 
+#ifdef CONFIG_PM
+extern void __init sh7372_init_pm_domains(void);
+#else
+static inline void sh7372_init_pm_domains(void) {}
+#endif
+
 #endif /* __ASM_SH7372_H__ */

