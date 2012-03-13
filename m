Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab2CMAgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:36:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014Ab2CMAY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 4/6] PM / shmobile: Make TMU driver use pm_genpd_dev_always_on()
Date: Tue, 13 Mar 2012 01:26:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl>
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130126.28000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the TMU clocksource driver mark its device as "always on"
using pm_genpd_dev_always_on() to protect it from surprise power
removals and make sh7372_add_standard_devices() add TMU devices on
sh7372 to the A4R power domain so that their "always on" flags
are taken into account as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/setup-sh7372.c |    2 ++
 drivers/clocksource/sh_tmu.c          |    4 ++++
 2 files changed, 6 insertions(+)

Index: linux/drivers/clocksource/sh_tmu.c
===================================================================
--- linux.orig/drivers/clocksource/sh_tmu.c
+++ linux/drivers/clocksource/sh_tmu.c
@@ -32,6 +32,7 @@
 #include <linux/sh_timer.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pm_domain.h>
 
 struct sh_tmu_priv {
 	void __iomem *mapbase;
@@ -410,6 +411,9 @@ static int __devinit sh_tmu_probe(struct
 	struct sh_tmu_priv *p = platform_get_drvdata(pdev);
 	int ret;
 
+	if (!is_early_platform_device(pdev))
+		pm_genpd_dev_always_on(&pdev->dev, true);
+
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		return 0;
Index: linux/arch/arm/mach-shmobile/setup-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/setup-sh7372.c
+++ linux/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1043,6 +1043,8 @@ void __init sh7372_add_standard_devices(
 	sh7372_add_device_to_domain(&sh7372_a4r, &veu2_device);
 	sh7372_add_device_to_domain(&sh7372_a4r, &veu3_device);
 	sh7372_add_device_to_domain(&sh7372_a4r, &jpu_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &tmu00_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &tmu01_device);
 }
 
 void __init sh7372_add_early_devices(void)

