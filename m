Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966331Ab2C3VYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:24:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936038Ab2C3VXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:23:19 -0400
Message-Id: <20120330194852.110621356@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: [ 129/175] PM / shmobile: Make TMU driver use pm_genpd_dev_always_on()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 2ee619f9487c2acc1efdf2c78e68e2bd51b635fa upstream.

Make the TMU clocksource driver mark its device as "always on"
using pm_genpd_dev_always_on() to protect it from surprise power
removals and make sh7372_add_standard_devices() add TMU devices on
sh7372 to the A4R power domain so that their "always on" flags
are taken into account as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-shmobile/setup-sh7372.c |    2 ++
 drivers/clocksource/sh_tmu.c          |    4 ++++
 2 files changed, 6 insertions(+)

--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1043,6 +1043,8 @@ void __init sh7372_add_standard_devices(
 	sh7372_add_device_to_domain(&sh7372_a4r, &veu2_device);
 	sh7372_add_device_to_domain(&sh7372_a4r, &veu3_device);
 	sh7372_add_device_to_domain(&sh7372_a4r, &jpu_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &tmu00_device);
+	sh7372_add_device_to_domain(&sh7372_a4r, &tmu01_device);
 }
 
 void __init sh7372_add_early_devices(void)
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
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


