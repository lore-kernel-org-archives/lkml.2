Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0EQJvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:51:14 -0400
Received: from toro.web-alm.net ([62.245.132.31]:52825 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0EQJvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:51:10 -0400
Message-Id: <20100517094340.019100599@osadl.org>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:41:37 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
       Carsten Emde <C.Emde@osadl.org>, LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Huaxu Wan <huaxu.wan@linux.intel.com>
Subject: [PATCH 1/2] Detect the thermal sensors by CPUID
References: <20100510035031.GD9181@owl> <20100514065808.GA11598@owl>
 <20100517094136.094800562@osadl.org>
Content-Disposition: inline; filename=coretemp-simplify-intel-thermal-sensor-recognition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
indicated by CPUID.06H.EAX[0].

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jean Delvare <khali@linux-fr.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

---
 drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

Index: head/drivers/hwmon/coretemp.c
===================================================================
--- head.orig/drivers/hwmon/coretemp.c
+++ head/drivers/hwmon/coretemp.c
@@ -451,28 +451,20 @@ static int __init coretemp_init(void)
 
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
-
-		/* check if family 6, models 0xe (Pentium M DC),
-		  0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
-		  0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
-		  0x1e (Lynnfield) */
-		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
-		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-			(c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
-			(c->x86_model == 0x1e))) {
-
-			/* supported CPU not found, but report the unknown
-			   family 6 CPU */
-			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
-				printk(KERN_WARNING DRVNAME ": Unknown CPU "
-					"model 0x%x\n", c->x86_model);
-			continue;
+		/*
+		 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
+		 * sensors. We check this bit only, all the early CPUs
+		 * without thermal sensors will be filtered out.
+		 */
+		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
+			err = coretemp_device_add(i);
+			if (err)
+				goto exit_devices_unreg;
+
+		} else {
+			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
+				" has no thermal sensor.\n", c->x86_model);
 		}
-
-		err = coretemp_device_add(i);
-		if (err)
-			goto exit_devices_unreg;
 	}
 	if (list_empty(&pdev_list)) {
 		err = -ENODEV;

