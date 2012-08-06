Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab2HFXNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:13:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab2HFXLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:11:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 11/12] ARM: shmobile: Move r8a7779's PM domain objects to a table
Date: Tue, 7 Aug 2012 01:14:14 +0200
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
Message-Id: <201208070114.15231.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of giving a name to every r8a7779's PM domain object, put
them all into a table and initialize them all together in a loop.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/include/mach/r8a7779.h |    9 ---
 arch/arm/mach-shmobile/pm-r8a7779.c           |   65 ++++++++++++++------------
 arch/arm/mach-shmobile/setup-r8a7779.c        |    5 --
 3 files changed, 39 insertions(+), 40 deletions(-)

Index: linux/arch/arm/mach-shmobile/include/mach/r8a7779.h
===================================================================
--- linux.orig/arch/arm/mach-shmobile/include/mach/r8a7779.h
+++ linux/arch/arm/mach-shmobile/include/mach/r8a7779.h
@@ -347,14 +347,9 @@ extern int r8a7779_sysc_power_down(struc
 extern int r8a7779_sysc_power_up(struct r8a7779_pm_ch *r8a7779_ch);
 
 #ifdef CONFIG_PM
-extern struct r8a7779_pm_domain r8a7779_sh4a;
-extern struct r8a7779_pm_domain r8a7779_sgx;
-extern struct r8a7779_pm_domain r8a7779_vdp1;
-extern struct r8a7779_pm_domain r8a7779_impx3;
-
-extern void r8a7779_init_pm_domain(struct r8a7779_pm_domain *r8a7779_pd);
+extern void __init r8a7779_init_pm_domains(void);
 #else
-#define r8a7779_init_pm_domain(pd) do { } while (0)
+static inline void r8a7779_init_pm_domains(void) {}
 #endif /* CONFIG_PM */
 
 #endif /* __ASM_R8A7779_H__ */
Index: linux/arch/arm/mach-shmobile/pm-r8a7779.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-r8a7779.c
+++ linux/arch/arm/mach-shmobile/pm-r8a7779.c
@@ -183,7 +183,7 @@ static bool pd_active_wakeup(struct devi
 	return true;
 }
 
-void r8a7779_init_pm_domain(struct r8a7779_pm_domain *r8a7779_pd)
+static void r8a7779_init_pm_domain(struct r8a7779_pm_domain *r8a7779_pd)
 {
 	struct generic_pm_domain *genpd = &r8a7779_pd->genpd;
 
@@ -199,37 +199,44 @@ void r8a7779_init_pm_domain(struct r8a77
 		pd_power_up(&r8a7779_pd->genpd);
 }
 
-struct r8a7779_pm_domain r8a7779_sh4a = {
-	.genpd_name = "SH4A",
-	.ch = {
-		.chan_offs = 0x80, /* PWRSR1 .. PWRER1 */
-		.isr_bit = 16, /* SH4A */
-	}
+static struct r8a7779_pm_domain r8a7779_pm_domains[] = {
+	{
+		.genpd_name = "SH4A",
+		.ch = {
+			.chan_offs = 0x80, /* PWRSR1 .. PWRER1 */
+			.isr_bit = 16, /* SH4A */
+		},
+	},
+	{
+		.genpd_name = "SGX",
+		.ch = {
+			.chan_offs = 0xc0, /* PWRSR2 .. PWRER2 */
+			.isr_bit = 20, /* SGX */
+		},
+	},
+	{
+		.genpd_name = "VDP1",
+		.ch = {
+			.chan_offs = 0x100, /* PWRSR3 .. PWRER3 */
+			.isr_bit = 21, /* VDP */
+		},
+	},
+	{
+		.genpd_name = "IMPX3",
+		.ch = {
+			.chan_offs = 0x140, /* PWRSR4 .. PWRER4 */
+			.isr_bit = 24, /* IMP */
+		},
+	},
 };
 
-struct r8a7779_pm_domain r8a7779_sgx = {
-	.genpd_name = "SGX",
-	.ch = {
-		.chan_offs = 0xc0, /* PWRSR2 .. PWRER2 */
-		.isr_bit = 20, /* SGX */
-	}
-};
-
-struct r8a7779_pm_domain r8a7779_vdp1 = {
-	.genpd_name = "VDP1",
-	.ch = {
-		.chan_offs = 0x100, /* PWRSR3 .. PWRER3 */
-		.isr_bit = 21, /* VDP */
-	}
-};
+void __init r8a7779_init_pm_domains(void)
+{
+	int j;
 
-struct r8a7779_pm_domain r8a7779_impx3 = {
-	.genpd_name = "IMPX3",
-	.ch = {
-		.chan_offs = 0x140, /* PWRSR4 .. PWRER4 */
-		.isr_bit = 24, /* IMP */
-	}
-};
+	for (j = 0; j < ARRAY_SIZE(r8a7779_pm_domains); j++)
+		r8a7779_init_pm_domain(&r8a7779_pm_domains[j]);
+}
 
 #endif /* CONFIG_PM */
 
Index: linux/arch/arm/mach-shmobile/setup-r8a7779.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-r8a7779.c
+++ linux/arch/arm/mach-shmobile/setup-r8a7779.c
@@ -251,10 +251,7 @@ void __init r8a7779_add_standard_devices
 #endif
 	r8a7779_pm_init();
 
-	r8a7779_init_pm_domain(&r8a7779_sh4a);
-	r8a7779_init_pm_domain(&r8a7779_sgx);
-	r8a7779_init_pm_domain(&r8a7779_vdp1);
-	r8a7779_init_pm_domain(&r8a7779_impx3);
+	r8a7779_init_pm_domains();
 
 	platform_add_devices(r8a7779_early_devices,
 			    ARRAY_SIZE(r8a7779_early_devices));

