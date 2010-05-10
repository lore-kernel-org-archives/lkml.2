Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0EJDlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:41:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:21350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab0EJDlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:41:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,359,1270450800"; 
   d="scan'208";a="516458606"
Date: Mon, 10 May 2010 11:50:31 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       huaxu.wan@intel.com, Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 2/2 V2] hwmon: (coretemp) Get TjMax value from MSR
Message-ID: <20100510035031.GD9181@owl>
References: <20100507095945.GB12190@owl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507095945.GB12190@owl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSR IA32_TEMPERATURE_TARGET contains the TjMax value in the newer
processers.

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
---
 arch/x86/include/asm/msr-index.h |    2 +
 drivers/hwmon/coretemp.c         |   52 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4604e6a..9bc0cf8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -232,6 +232,8 @@
 
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+#define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index d194207..9959390 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -241,6 +241,54 @@ static int __devinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *
 	return tjmax;
 }
 
+static int __devinit get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
+{
+	/* The 100C is default for both mobile and non mobile CPUs */
+	int err;
+	u32 eax, edx;
+	u32 val;
+
+	/* A new feature of current Intel(R) processors, the
+	   IA32_TEMPERATURE_TARGET contains the TjMax value */
+	err = rdmsr_safe_on_cpu(id, MSR_IA32_TEMPERATURE_TARGET, &eax, &edx);
+	if (err){
+		dev_warn(dev, "Unable to read TjMax from CPU.\n");
+	} else {
+		val = (eax >> 16 ) & 0xff;
+		/*
+		 * If the TjMax is not plausible, an assumption
+		 * will be used
+		 */
+		if (( val > 80) && (val < 120)){
+			dev_info(dev, "TjMax is %d C. \n", val);
+			return val * 1000;
+		}
+	}
+
+	/*
+	 * An assumption is made for early CPUs and unreadable MSR.
+	 * NOTE: the given value may not be correct.
+	 */
+
+	switch(c->x86_model){
+	case 0xe :
+	case 0xf :
+	case 0x16 :
+	case 0x1a :
+		dev_warn(dev, "TjMax is assumed as 100 C! \n");
+		return 100000;
+		break;
+	case 0x17 :
+	case 0x1c :		/* Atom CPUs */
+		return adjust_tjmax(c, id, dev);
+		break;
+	default :
+		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
+			" using default TjMax of 100C.\n", c->x86_model);
+		return 100000;
+	}
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
 	struct coretemp_data *data;
@@ -283,14 +331,14 @@ static int __devinit coretemp_probe(struct platform_device *pdev)
 		}
 	}
 
-	data->tjmax = adjust_tjmax(c, data->id, &pdev->dev);
+	data->tjmax = get_tjmax(c, data->id, &pdev->dev);
 	platform_set_drvdata(pdev, data);
 
 	/* read the still undocumented IA32_TEMPERATURE_TARGET it exists
 	   on older CPUs but not in this register, Atoms don't have it either */
 
 	if ((c->x86_model > 0xe) && (c->x86_model != 0x1c)) {
-		err = rdmsr_safe_on_cpu(data->id, 0x1a2, &eax, &edx);
+		err = rdmsr_safe_on_cpu(data->id, MSR_IA32_TEMPERATURE_TARGET, &eax, &edx);
 		if (err) {
 			dev_warn(&pdev->dev, "Unable to read"
 					" IA32_TEMPERATURE_TARGET MSR\n");
-- 
1.6.3.3.363.g725cf7

