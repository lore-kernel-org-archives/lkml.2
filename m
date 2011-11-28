Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1K1Vfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:35:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab1K1Vf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:35:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update][PATCH] PM / Domains: Make it possible to assign names to generic PM domains
Date: Mon, 28 Nov 2011 22:38:18 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201111272153.53008.rjw@sisk.pl>
In-Reply-To: <201111272153.53008.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111282238.18953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a name member pointer to struct generic_pm_domain and use it in
diagnostic messages regarding the domain power-off and power-on
latencies.  Update the ARM shmobile SH7372 code to assign names to
the PM domains used by it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

This version of the patch avoids adding a new member to
struct generic_pm_domain.

Thanks,
Rafael

---
 arch/arm/mach-shmobile/pm-sh7372.c |   16 ++++++++++++----
 drivers/base/power/domain.c        |   14 ++++++++++++--
 include/linux/pm_domain.h          |    1 +
 3 files changed, 25 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -209,8 +209,13 @@ int __pm_genpd_poweron(struct generic_pm
 			goto err;
 
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
-		if (elapsed_ns > genpd->power_on_latency_ns)
+		if (elapsed_ns > genpd->power_on_latency_ns) {
 			genpd->power_on_latency_ns = elapsed_ns;
+			if (genpd->name)
+				pr_warning("%s: Power-on latency exceeded, "
+					"new value %lld ns\n", genpd->name,
+					elapsed_ns);
+		}
 	}
 
 	genpd_set_active(genpd);
@@ -428,8 +433,13 @@ static int pm_genpd_poweroff(struct gene
 		}
 
 		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
-		if (elapsed_ns > genpd->power_off_latency_ns)
+		if (elapsed_ns > genpd->power_off_latency_ns) {
 			genpd->power_off_latency_ns = elapsed_ns;
+			if (genpd->name)
+				pr_warning("%s: Power-off latency exceeded, "
+					"new value %lld ns\n", genpd->name,
+					elapsed_ns);
+		}
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
Index: linux/include/linux/pm_domain.h
===================================================================
--- linux.orig/include/linux/pm_domain.h
+++ linux/include/linux/pm_domain.h
@@ -49,6 +49,7 @@ struct generic_pm_domain {
 	struct mutex lock;
 	struct dev_power_governor *gov;
 	struct work_struct power_off_work;
+	char *name;
 	unsigned int in_progress;	/* Number of devices being suspended now */
 	atomic_t sd_count;	/* Number of subdomains with power "on" */
 	enum gpd_status status;	/* Current state of the domain */
Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -101,8 +101,8 @@ static int pd_power_down(struct generic_
 	}
 
 	if (!sh7372_pd->no_debug)
-		pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
-			 mask, __raw_readl(PSTR));
+		pr_debug("%s: Power off, 0x%08x -> PSTR = 0x%08x\n",
+			 genpd->name, mask, __raw_readl(PSTR));
 
 	return 0;
 }
@@ -133,8 +133,8 @@ static int __pd_power_up(struct sh7372_p
 		ret = -EIO;
 
 	if (!sh7372_pd->no_debug)
-		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
-			 mask, __raw_readl(PSTR));
+		pr_debug("%s: Power on, 0x%08x -> PSTR = 0x%08x\n",
+			 sh7372_pd->genpd.name, mask, __raw_readl(PSTR));
 
  out:
 	if (ret == 0 && sh7372_pd->resume && do_resume)
@@ -233,18 +233,22 @@ void sh7372_pm_add_subdomain(struct sh73
 }
 
 struct sh7372_pm_domain sh7372_a4lc = {
+	.genpd.name = "A4LC",
 	.bit_shift = 1,
 };
 
 struct sh7372_pm_domain sh7372_a4mp = {
+	.genpd.name = "A4MP",
 	.bit_shift = 2,
 };
 
 struct sh7372_pm_domain sh7372_d4 = {
+	.genpd.name = "D4",
 	.bit_shift = 3,
 };
 
 struct sh7372_pm_domain sh7372_a4r = {
+	.genpd.name = "A4R",
 	.bit_shift = 5,
 	.gov = &sh7372_always_on_gov,
 	.suspend = sh7372_a4r_suspend,
@@ -253,14 +257,17 @@ struct sh7372_pm_domain sh7372_a4r = {
 };
 
 struct sh7372_pm_domain sh7372_a3rv = {
+	.genpd.name = "A3RV",
 	.bit_shift = 6,
 };
 
 struct sh7372_pm_domain sh7372_a3ri = {
+	.genpd.name = "A3RI",
 	.bit_shift = 8,
 };
 
 struct sh7372_pm_domain sh7372_a3sp = {
+	.genpd.name = "A3SP",
 	.bit_shift = 11,
 	.gov = &sh7372_always_on_gov,
 	.no_debug = true,
@@ -275,6 +282,7 @@ static void sh7372_a3sp_init(void)
 }
 
 struct sh7372_pm_domain sh7372_a3sg = {
+	.genpd.name = "A3SG",
 	.bit_shift = 13,
 };
 

