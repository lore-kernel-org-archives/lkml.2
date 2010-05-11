Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0EKHvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:51:53 -0400
Received: from mga10.intel.com ([192.55.52.92]:3544 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149Ab0EKHvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,206,1272870000"; 
   d="scan'208";a="797312210"
Date: Tue, 11 May 2010 16:01:12 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       huaxu.wan@intel.com, Carsten Emde <Carsten.Emde@osadl.org>,
       Valdis.Kletnieks@vt.edu
Subject: [PATCH 1/2 V3] hwmon: (coretemp) Detect the thermal sensors by
 CPUID
Message-ID: <20100511080112.GB19762@owl>
References: <20100507095459.GA12190@owl>
 <20100510033525.GC9181@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510033525.GC9181@owl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
indicated by CPUID.06H.EAX[0].

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
---
 drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index e9b7fbc..be0ddcf 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -451,28 +451,20 @@ static int __init coretemp_init(void)

        for_each_online_cpu(i) {
                struct cpuinfo_x86 *c = &cpu_data(i);
+               /*
+                * CPUID.06H.EAX[0] indicates whether the CPU has thermal
+                * sensors. We check this bit only, all the early CPUs
+                * without thermal sensors will be filtered out.
+                */
+               if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
+                       err = coretemp_device_add(i);
+                       if (err)
+                               goto exit_devices_unreg;

-               /* check if family 6, models 0xe (Pentium M DC),
-                 0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
-                 0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
-                 0x1e (Lynnfield) */
-               if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
-                   !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-                       (c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-                       (c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
-                       (c->x86_model == 0x1e))) {
-
-                       /* supported CPU not found, but report the unknown
-                          family 6 CPU */
-                       if ((c->x86 == 0x6) && (c->x86_model > 0xf))
-                               printk(KERN_WARNING DRVNAME ": Unknown CPU "
-                                       "model 0x%x\n", c->x86_model);
-                       continue;
-               }
-
-               err = coretemp_device_add(i);
-               if (err)
-                       goto exit_devices_unreg;
+               } else {
+                       printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
+                               " has no thermal sensor!\n", c->x86_model);
+               }
        }
        if (list_empty(&pdev_list)) {
                err = -ENODEV;
--
1.6.3.3.363.g725cf7
