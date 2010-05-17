Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0EQJuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:50:46 -0400
Received: from toro.web-alm.net ([62.245.132.31]:52812 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0EQJup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:50:45 -0400
Message-Id: <20100517094340.900829891@osadl.org>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:41:38 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
       Carsten Emde <C.Emde@osadl.org>, LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Huaxu Wan <huaxu.wan@linux.intel.com>
Subject: [PATCH 2/2] Get TjMax value from	MSR
References: <20100510035031.GD9181@owl> <20100514065808.GA11598@owl>
 <20100517094136.094800562@osadl.org>
Content-Disposition: inline; filename=coretemp-add-tjmax-method-for-i-series-processors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSR IA32_TEMPERATURE_TARGET contains the TjMax value in the newer
Intel processors.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 arch/x86/include/asm/msr-index.h |    2 +
 drivers/hwmon/coretemp.c         |   61 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 59 insertions(+), 4 deletions(-)

Index: head/arch/x86/include/asm/msr-index.h
===================================================================
--- head.orig/arch/x86/include/asm/msr-index.h
+++ head/arch/x86/include/asm/msr-index.h
@@ -235,6 +235,8 @@
 
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+#define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
Index: head/drivers/hwmon/coretemp.c
===================================================================
--- head.orig/drivers/hwmon/coretemp.c
+++ head/drivers/hwmon/coretemp.c
@@ -241,6 +241,55 @@ static int __devinit adjust_tjmax(struct
 	return tjmax;
 }
 
+static int __devinit get_tjmax(struct cpuinfo_x86 *c, u32 id,
+			       struct device *dev)
+{
+	/* The 100C is default for both mobile and non mobile CPUs */
+	int err;
+	u32 eax, edx;
+	u32 val;
+
+	/* A new feature of current Intel(R) processors, the
+	   IA32_TEMPERATURE_TARGET contains the TjMax value */
+	err = rdmsr_safe_on_cpu(id, MSR_IA32_TEMPERATURE_TARGET, &eax, &edx);
+	if (err) {
+		dev_warn(dev, "Unable to read TjMax from CPU.\n");
+	} else {
+		val = (eax >> 16) & 0xff;
+		/*
+		 * If the TjMax is not plausible, an assumption
+		 * will be used
+		 */
+		if ((val > 80) && (val < 120)) {
+			dev_info(dev, "TjMax is %d C.\n", val);
+			return val * 1000;
+		}
+	}
+
+	/*
+	 * An assumption is made for early CPUs and unreadable MSR.
+	 * NOTE: the given value may not be correct.
+	 */
+
+	switch (c->x86_model) {
+	case 0xe:
+	case 0xf:
+	case 0x16:
+	case 0x1a:
+		dev_warn(dev, "TjMax is assumed as 100 C!\n");
+		return 100000;
+		break;
+	case 0x17:
+	case 0x1c:		/* Atom CPUs */
+		return adjust_tjmax(c, id, dev);
+		break;
+	default:
+		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
+			" using default TjMax of 100C.\n", c->x86_model);
+		return 100000;
+	}
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
 	struct coretemp_data *data;
@@ -283,14 +332,18 @@ static int __devinit coretemp_probe(stru
 		}
 	}
 
-	data->tjmax = adjust_tjmax(c, data->id, &pdev->dev);
+	data->tjmax = get_tjmax(c, data->id, &pdev->dev);
 	platform_set_drvdata(pdev, data);
 
-	/* read the still undocumented IA32_TEMPERATURE_TARGET it exists
-	   on older CPUs but not in this register, Atoms don't have it either */
+	/*
+	 * read the still undocumented IA32_TEMPERATURE_TARGET. It exists
+	 * on older CPUs but not in this register,
+	 * Atoms don't have it either.
+	 */
 
 	if ((c->x86_model > 0xe) && (c->x86_model != 0x1c)) {
-		err = rdmsr_safe_on_cpu(data->id, 0x1a2, &eax, &edx);
+		err = rdmsr_safe_on_cpu(data->id, MSR_IA32_TEMPERATURE_TARGET,
+		    &eax, &edx);
 		if (err) {
 			dev_warn(&pdev->dev, "Unable to read"
 					" IA32_TEMPERATURE_TARGET MSR\n");

