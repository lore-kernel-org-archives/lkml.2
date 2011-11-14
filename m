Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1KNINY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 03:13:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43737 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1KNINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 03:13:23 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
Date: Mon, 14 Nov 2011 17:13:21 +0900
X-Google-Sender-Auth: LOreoBjUow09YFgl2_kM_SjBNpo
Message-ID: <CAJ0PZbS_KFO2d4qKxUfL8imvfKXGcSr+sAwMf-VB1RcDpSsrHA@mail.gmail.com>
Subject: [PATCH v2 2/2] HWMON: support in-kernel HWMON API: NTC, S3C-HWMON, Exynos4-TMU
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, dg77.kim@samsung.com,
        kyungmin.park@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supports in-kernel HWMON interfaces for
1. NTC Thermistor
2. Exynos4 TMU
3. S3C-HWMON
device drivers.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/hwmon/exynos4_tmu.c    |    2 ++
 drivers/hwmon/ntc_thermistor.c |    2 ++
 drivers/hwmon/s3c-hwmon.c      |   10 ++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/hwmon/exynos4_tmu.c
index faa0884..f9566b9 100644
--- a/drivers/hwmon/exynos4_tmu.c
+++ b/drivers/hwmon/exynos4_tmu.c
@@ -431,6 +431,8 @@ static int __devinit exynos4_tmu_probe(struct
platform_device *pdev)
 		goto err_create_group;
 	}

+	hwmon_register_properties(data->hwmon_dev, &exynos4_tmu_attr_group);
+
 	exynos4_tmu_control(pdev, true);

 	return 0;
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index eab1161..21060ff 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -389,6 +389,8 @@ static int __devinit ntc_thermistor_probe(struct
platform_device *pdev)
 		goto err_after_sysfs;
 	}

+	hwmon_register_properties(data->hwmon_dev, &ntc_attr_group);
+
 	dev_info(&pdev->dev, "Thermistor %s:%d (type: %s/%lu) successfully probed.\n",
 			pdev->name, pdev->id, pdev->id_entry->name,
 			pdev->id_entry->driver_data);
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index b39f52e..e003001 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -227,6 +227,8 @@ static int s3c_hwmon_create_attr(struct device *dev,
 {
 	struct sensor_device_attribute *attr;
 	int ret;
+	struct platform_device = to_platform_device(dev);
+	struct s3c_hwmon *hwmon = platform_get_drvdata(pdev, hwmon);

 	snprintf(attrs->in_name, sizeof(attrs->in_name), "in%d_input", channel);

@@ -242,6 +244,7 @@ static int s3c_hwmon_create_attr(struct device *dev,
 		dev_err(dev, "failed to create input attribute\n");
 		return ret;
 	}
+	hwmon_register_property(hwmon->hwmon_dev, &attr->dev_attr);

 	/* if this has a name, add a label */
 	if (cfg->name) {
@@ -260,6 +263,7 @@ static int s3c_hwmon_create_attr(struct device *dev,
 			device_remove_file(dev, &attrs->in.dev_attr);
 			dev_err(dev, "failed to create label attribute\n");
 		}
+		hwmon_register_property(hwmon->hwmon_dev, &attr->dev_attr);
 	}

 	return ret;
@@ -268,6 +272,12 @@ static int s3c_hwmon_create_attr(struct device *dev,
 static void s3c_hwmon_remove_attr(struct device *dev,
 				  struct s3c_hwmon_attr *attrs)
 {
+	/*
+	 * hwmon_unregister_property is not needed for this as
+	 * hwmon_device_unregister() is always called in the paths
+	 * when s3c_hwmon_revoce_attr() is called. And hwmon_device_unregister
+	 * calls hwmon_unregister_property for all properties.
+	 */
 	device_remove_file(dev, &attrs->in.dev_attr);
 	device_remove_file(dev, &attrs->label.dev_attr);
 }
-- 
1.7.4.1
