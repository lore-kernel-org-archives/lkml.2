Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab0EGJur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:50:47 -0400
Received: from mga05.intel.com ([192.55.52.89]:24441 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755727Ab0EGJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,347,1270450800"; 
   d="scan'208";a="565044403"
Date: Fri, 7 May 2010 17:59:45 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: huaxu.wan@intel.com, khali@linux-fr.org
Subject: [PATCH 2/2] hwmon: (coretemp) Get TjMax value from MSR
Message-ID: <20100507095945.GB12190@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The MSR IA32_TEMPERATURE_TARGET contains the TjMax value in the newer
processers.

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
---
 drivers/hwmon/coretemp.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 237c68d..7a01032 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -241,6 +241,49 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
        return tjmax;
 }

+static int __devinit get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
+{
+       /* The 100C is default for both mobile and non mobile CPUs */
+       int err;
+       u32 eax, edx;
+       u32 val;
+
+       /* A new feature of current Intel(R) processors, the
+          IA32_TEMPERATURE_TARGET(0x1a2) contains the TjMax value */
+       err = rdmsr_safe_on_cpu(id, 0x1a2, &eax, &edx);
+       if (err){
+               printk_once(KERN_WARNING DRVNAME  " : Unable to read TjMax from CPU.\n");
+       } else {
+               val = (eax >> 16 ) & 0xff;
+               /* If the TjMax is not reasonable, an assumption value
+                  will be used */
+               if (( val > 80) && (val < 120)){
+                       printk_once(KERN_INFO DRVNAME " : The TjMax is %d C. \n", val);
+                       return val * 1000;
+               }
+       }
+
+       /* For the early CPUs, an approximation is given.
+        NOTE: the given value may not be correct. */
+       switch(c->x86_model){
+       case 0xe :
+       case 0xf :
+       case 0x16 :
+       case 0x1a :
+               printk_once(KERN_WARNING DRVNAME  " : TjMax is assumed as 100 C! \n");
+               return 100000;
+               break;
+       case 0x17 :
+       case 0x1c :             /* Atom CPUs */
+               return adjust_tjmax(c, id, dev);
+               break;
+       default :
+               printk_once(KERN_WARNING DRVNAME " : Your CPU is not support yet,"
+                       "using the default TjMax: 100 C.\n");
+               return 100000;
+       }
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
        struct coretemp_data *data;
@@ -283,7 +326,7 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
                }
        }

-       data->tjmax = adjust_tjmax(c, data->id, &pdev->dev);
+       data->tjmax = get_tjmax(c, data->id, &pdev->dev);
        platform_set_drvdata(pdev, data);

        /* read the still undocumented IA32_TEMPERATURE_TARGET it exists
--
1.6.3.3.363.g725cf7
