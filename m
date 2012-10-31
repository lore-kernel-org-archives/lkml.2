Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862Ab2JaETU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:19:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47156 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2JaETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:19:18 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-79-5090a6c40cb2
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Date: Wed, 31 Oct 2012 13:19:07 +0900
Message-id: <1351657147-26092-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jAd0jyyYEGBy4r2lxedccNovPvUcY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4MqYMmkaU0G7RcX3J4ENjE06XYycHBICJhKNl3azQdhi
	EhfurQeyuTiEBBYxSmz5uY0Jwmlhkpj67xczSBWbgI7E/3032UFsEQEZialX9rOCFDELPGWU
	+L5qHiNIQlggUuJBawfQKA4OFgFVifPfK0HCvAIeEiuvrWeE2KYgseDeW7YJjNwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgT78pnUDsaVDRaHGAU4GJV4eA3/9QcIsSaWFVfmHmKU
	4GBWEuEtmTEhQIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvs0dKgJBAemJJanZqakFqEUyWiYNT
	qoFxc1TJvUUzpU+KZzEcyc3h/tSp++vGtrmtRlP2zZf/mqZz/1/Di/LkF7Uxgufmp2w8/VKK
	q6Zwiaxjqfa1aq+2Cww8M9dZ7F3uHyE9KX/uZN6lzVEXGGe0+PtN8XHzbspdIsw87+3ZX99D
	GO5NWiqkMveLSOMmc09j225LqTcF1oHvIytMjwgpsRRnJBpqMRcVJwIALaaI0OEBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports exynos's emulation mode with newly created sysfs node.
Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal
management unit. Thermal emulation mode supports software debug for TMU's
operation. User can set temperature manually with software code and TMU
will read current temperature from user value not from sensor's value.
This patch includes also documentary placed under Documentation/thermal/.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
v2
 exynos_thermal.c
 - Fix build error occured by wrong emulation control register name.
 - Remove exynos5410 dependent codes.
 exynos_theraml_emulation
 - Align indentation.

 Documentation/thermal/exynos_thermal_emulation |   49 +++++++++++++
 drivers/thermal/Kconfig                        |    9 +++
 drivers/thermal/exynos_thermal.c               |   88 ++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/thermal/exynos_thermal_emulation

diff --git a/Documentation/thermal/exynos_thermal_emulation b/Documentation/thermal/exynos_thermal_emulation
new file mode 100644
index 0000000..062d867
--- /dev/null
+++ b/Documentation/thermal/exynos_thermal_emulation
@@ -0,0 +1,49 @@
+EXYNOS EMULATION MODE
+========================
+
+Copyright (C) 2012 Samsung Electronics
+
+Writen by Jonghwa Lee <jonghwa3.lee@samsung.com>
+
+Description
+-----------
+
+Exynos 4x12 (4212, 4412) and 5 series provide emulation mode for thermal management unit.
+Thermal emulation mode supports software debug for TMU's operation. User can set temperature
+manually with software code and TMU will read current temperature from user value not from
+sensor's value.
+
+Enabling CONFIG_EXYNOS_THERMAL_EMUL option will make this support in available.
+When it's enabled, sysfs node will be created under
+/sys/bus/platform/devices/'exynos device name'/ with name of 'emulation'.
+
+The sysfs node, 'emulation', will contain value 0 for the initial state. When you input any
+temperature you want to update to sysfs node, it automatically enable emulation mode and
+current temperature will be changed into it.
+(Exynos also supports user changable delay time which would be used to delay of
+ changing temperature. However, this node only uses same delay of real sensing time, 938us.)
+
+Disabling emulation mode only requires writing value 0 to sysfs node.
+
+
+TEMP	120 |
+	    |
+	100 |
+	    |
+	 80 |
+	    |		     	 	 +-----------
+	 60 |      		     	 |	    |
+	    |	           +-------------|          |
+	 40 |              |         	 |          |
+   	    |		   |	     	 |          |
+	 20 |		   |	     	 |          +----------
+	    |	 	   |	     	 |          |          |
+  	  0 |______________|_____________|__________|__________|_________
+		   A	    	 A	    A	   	       A     TIME
+		   |<----->|	 |<----->|  |<----->|	       |
+		   | 938us |  	 |	 |  |       |          |
+emulation    :  0  50	   |  	 70      |  20      |          0
+current temp :   sensor   50		 70         20	      sensor
+
+
+
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e1cb6bd..c02a66c 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -55,3 +55,12 @@ config EXYNOS_THERMAL
 	help
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
+
+config EXYNOS_THERMAL_EMUL
+	bool "EXYNOS TMU emulation mode support"
+	depends on !CPU_EXYNOS4210 && EXYNOS_THERMAL
+	help
+	  Exynos 4412 and 4414 and 5 series has emulation mode on TMU.
+	  Enable this option will be make sysfs node in exynos thermal platform
+	  device directory to support emulation mode. With emulation mode sysfs
+	  node, you can manually input temperature to TMU for simulation purpose.
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index fd03e85..9e3c150 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -99,6 +99,15 @@
 #define IDLE_INTERVAL 10000
 #define MCELSIUS	1000
 
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+#define EXYNOS_EMUL_TIME	0x57F0
+#define EXYNOS_EMUL_TIME_SHIFT	16
+#define EXYNOS_EMUL_DATA_SHIFT	8
+#define EXYNOS_EMUL_DATA_MASK	0xFF
+#define EXYNOS_EMUL_DISABLE	0x0
+#define EXYNOS_EMUL_ENABLE	0x1
+#endif /* CONFIG_EXYNOS_THERMAL_EMUL */
+
 /* CPU Zone information */
 #define PANIC_ZONE      4
 #define WARN_ZONE       3
@@ -832,6 +841,82 @@ static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
 	return (struct exynos_tmu_platform_data *)
 			platform_get_device_id(pdev)->driver_data;
 }
+
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+static ssize_t exynos_tmu_emulation_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	u8 temp_code;
+	int temp, enable;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	enable = reg & EXYNOS_EMUL_ENABLE;
+
+	if (enable) {
+		reg >>= EXYNOS_EMUL_DATA_SHIFT;
+		temp_code = reg & EXYNOS_EMUL_DATA_MASK;
+		temp = code_to_temp(data, temp_code);
+	} else {
+		temp = 0;
+	}
+
+	return sprintf(buf, "%d\n", temp);
+}
+
+static ssize_t exynos_tmu_emulation_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct platform_device *pdev = container_of(dev,
+					struct platform_device, dev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	unsigned int reg;
+	u8 temp_code;
+	int temp, enable, i;
+
+	if (!sscanf(buf, "%d\n", &temp))
+		return -EINVAL;
+
+	if (temp < 0)
+		return -EINVAL;
+
+	mutex_lock(&data->lock);
+	clk_enable(data->clk);
+
+	reg = readl(data->base + EXYNOS_EMUL_CON);
+	enable = reg & EXYNOS_EMUL_ENABLE;
+	if (!enable && !temp)
+		goto out;
+
+	temp_code = (reg >> EXYNOS_EMUL_DATA_SHIFT) & EXYNOS_EMUL_DATA_MASK;
+	temp_code = temp == 0 ? temp_code : temp_to_code(data, temp);
+
+	reg = (EXYNOS_EMUL_TIME << EXYNOS_EMUL_TIME_SHIFT) |
+		(temp_code << EXYNOS_EMUL_DATA_SHIFT) |
+		 (temp > 0 ? EXYNOS_EMUL_ENABLE : EXYNOS_EMUL_DISABLE);
+
+	writel(reg, data->base + EXYNOS_EMUL_CON);
+out:
+	clk_disable(data->clk);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(emulation, 0644, exynos_tmu_emulation_show,
+					exynos_tmu_emulation_store);
+#endif
+
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
@@ -930,6 +1015,9 @@ static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to register thermal interface\n");
 		goto err_clk;
 	}
+#ifdef CONFIG_EXYNOS_THERMAL_EMUL
+	device_create_file(&pdev->dev, &dev_attr_emulation);
+#endif
 	return 0;
 err_clk:
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.4.1

