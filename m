Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2HFXNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:13:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44964 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab2HFXLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:11:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 5/12] ARM: shmobile: Use domain names when adding subdomains to power domains
Date: Tue, 7 Aug 2012 01:09:31 +0200
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
Message-Id: <201208070109.31453.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make the power management code under arch/arm/mach-shmobile/
use pm_genpd_add_subdomain_names() for adding subdomains to power
domains, which makes it possible to drop
rmobile_pm_add_subdomain() and will allow us to carry out those
operations for domain objects stored in tables in a straightforward
way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/pm-rmobile.h |    3 ---
 arch/arm/mach-shmobile/pm-rmobile.c              |    6 ------
 arch/arm/mach-shmobile/setup-r8a7740.c           |    2 +-
 arch/arm/mach-shmobile/setup-sh7372.c            |    8 ++++----
 4 files changed, 5 insertions(+), 14 deletions(-)

Index: linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
+++ linux/arch/arm/mach-shmobile/include/mach/pm-rmobile.h
@@ -33,12 +33,9 @@ struct rmobile_pm_domain *to_rmobile_pd(
 extern void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd);
 extern void rmobile_add_device_to_domain(const char *domain_name,
 					struct platform_device *pdev);
-extern void rmobile_pm_add_subdomain(struct rmobile_pm_domain *rmobile_pd,
-				    struct rmobile_pm_domain *rmobile_sd);
 #else
 #define rmobile_init_pm_domain(pd) do { } while (0)
 #define rmobile_add_device_to_domain(name, pdev) do { } while (0)
-#define rmobile_pm_add_subdomain(pd, sd) do { } while (0)
 #endif /* CONFIG_PM */
 
 #endif /* PM_RMOBILE_H */
Index: linux/arch/arm/mach-shmobile/pm-rmobile.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-rmobile.c
+++ linux/arch/arm/mach-shmobile/pm-rmobile.c
@@ -158,10 +158,4 @@ void rmobile_add_device_to_domain(const
 	if (pm_clk_no_clocks(dev))
 		pm_clk_add(dev, NULL);
 }
-
-void rmobile_pm_add_subdomain(struct rmobile_pm_domain *rmobile_pd,
-			     struct rmobile_pm_domain *rmobile_sd)
-{
-	pm_genpd_add_subdomain(&rmobile_pd->genpd, &rmobile_sd->genpd);
-}
 #endif /* CONFIG_PM */
Index: linux/arch/arm/mach-shmobile/setup-r8a7740.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-r8a7740.c
+++ linux/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -678,7 +678,7 @@ void __init r8a7740_add_standard_devices
 	rmobile_init_pm_domain(&r8a7740_pd_a3sp);
 	rmobile_init_pm_domain(&r8a7740_pd_a4lc);
 
-	rmobile_pm_add_subdomain(&r8a7740_pd_a4s, &r8a7740_pd_a3sp);
+	pm_genpd_add_subdomain_names("A4S", "A3SP");
 
 	/* add devices */
 	platform_add_devices(r8a7740_early_devices,
Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1011,11 +1011,11 @@ void __init sh7372_add_standard_devices(
 	rmobile_init_pm_domain(&sh7372_pd_a3sp);
 	rmobile_init_pm_domain(&sh7372_pd_a3sg);
 
-	rmobile_pm_add_subdomain(&sh7372_pd_a4lc, &sh7372_pd_a3rv);
-	rmobile_pm_add_subdomain(&sh7372_pd_a4r, &sh7372_pd_a4lc);
+	pm_genpd_add_subdomain_names("A4LC", "A3RV");
+	pm_genpd_add_subdomain_names("A4R", "A4LC");
 
-	rmobile_pm_add_subdomain(&sh7372_pd_a4s, &sh7372_pd_a3sg);
-	rmobile_pm_add_subdomain(&sh7372_pd_a4s, &sh7372_pd_a3sp);
+	pm_genpd_add_subdomain_names("A4S", "A3SG");
+	pm_genpd_add_subdomain_names("A4S", "A3SP");
 
 	platform_add_devices(sh7372_early_devices,
 			    ARRAY_SIZE(sh7372_early_devices));

