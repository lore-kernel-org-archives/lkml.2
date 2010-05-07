Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0EGJqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:46:03 -0400
Received: from mga06.intel.com ([134.134.136.21]:47966 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753096Ab0EGJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:46:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,347,1270450800"; 
   d="scan'208";a="619683838"
Date: Fri, 7 May 2010 17:54:59 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: huaxu.wan@intel.com, khali@linux-fr.org
Subject: [PATCH 1/2] hwmon: (coretemp) Detect the thermal sensors by CPUID
Message-ID: <20100507095459.GA12190@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
indicated by CPUID.06H.EAX[0].

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index e9b7fbc..237c68d 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -440,6 +440,7 @@ static int __init coretemp_init(void)
 {
        int i, err = -ENODEV;
        struct pdev_entry *p, *n;
+       u32 eax;

        /* quick check if we run Intel */
        if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
@@ -450,23 +451,12 @@ static int __init coretemp_init(void)
                goto exit;

        for_each_online_cpu(i) {
-               struct cpuinfo_x86 *c = &cpu_data(i);
-
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
+               /* check if the CPU has thermal sensor */
+               eax = cpuid_eax(0x06);
+               if (!(eax & 0x01)) {
+                       struct cpuinfo_x86 *c = &cpu_data(i);
+                       printk_once(KERN_WARNING DRVNAME ": CPU (model=0x%x)"
+                               " has no thermal sensor!\n", c->x86_model);
                        continue;
                }

--
1.6.3.3.363.g725cf7
