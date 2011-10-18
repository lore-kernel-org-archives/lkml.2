Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab1JRP3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:29:43 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:41265 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1JRP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:29:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 5/6] IIO:Temporary example hwmon interface.
Date: Tue, 18 Oct 2011 16:29:35 +0100
Message-Id: <1318951776-19393-6-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
References: <1318951776-19393-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not to be merged. Breaks all sorts of elements of the hwmon
interface spec and is not flexible enough.
---
 drivers/iio/Kconfig     |    7 +++
 drivers/iio/Makefile    |    1 +
 drivers/iio/iio_hwmon.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 308bc97..334f633 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -11,6 +11,13 @@ menuconfig IIO
 
 if IIO
 
+config IIO_HWMON
+       tristate "Temporary dummy driver to test in kern interface"
+       help
+	  Dirty test of in kernel framework. Not intended to ever
+	  merge in current state.
+
+
 source "drivers/iio/adc/Kconfig"
 source "drivers/iio/imu/Kconfig"
 source "drivers/iio/light/Kconfig"
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index cfb588a..5f9c01a 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -6,6 +6,7 @@ obj-y = inkern.o
 obj-$(CONFIG_IIO) += iio.o
 industrialio-y := core.o
 
+obj-$(CONFIG_IIO_HWMON) += iio_hwmon.o
 obj-y += adc/
 obj-y += imu/
 obj-y += light/
diff --git a/drivers/iio/iio_hwmon.c b/drivers/iio/iio_hwmon.c
new file mode 100644
index 0000000..03fc590
--- /dev/null
+++ b/drivers/iio/iio_hwmon.c
@@ -0,0 +1,104 @@
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/iio/inkern.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+
+struct iio_hwmon_state {
+	struct iio_channel *channel;
+	struct device *hwmon_dev;
+};
+
+static ssize_t iio_hwmon_read_val(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	int val, ret;
+	struct iio_hwmon_state *state = dev_get_drvdata(dev);
+
+	ret = iio_read_channel_raw(state->channel, &val);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%d\n", val);
+}
+static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, iio_hwmon_read_val, NULL, 0);
+
+static struct attribute *iio_hwmon_attrs[] = {
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group iio_hwmon_attr_group = {
+	.attrs = iio_hwmon_attrs
+};
+
+static int __devinit iio_hwmon_probe(struct platform_device *pdev)
+{
+	struct iio_hwmon_state *st;
+	int ret;
+
+	st = kzalloc(sizeof(*st), GFP_KERNEL);
+	if (st == NULL) {
+		ret = -ENOMEM;
+		goto error_ret;
+	}
+
+	st->channel = iio_channel_get(&pdev->dev, NULL, "testchan1");
+	if (IS_ERR(st->channel)) {
+		ret = PTR_ERR(st->channel);
+		goto error_free_state;
+	}
+
+	st->hwmon_dev = hwmon_device_register(&pdev->dev);
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &iio_hwmon_attr_group);
+	if (ret < 0)
+		goto error_release_channel;
+
+	platform_set_drvdata(pdev, st);
+	return 0;
+
+error_release_channel:
+	iio_channel_release(st->channel);
+error_free_state:
+	kfree(st);
+error_ret:
+	return ret;
+}
+
+static int __devexit iio_hwmon_remove(struct platform_device *pdev)
+{
+	struct iio_hwmon_state *st = platform_get_drvdata(pdev);
+	sysfs_remove_group(&pdev->dev.kobj, &iio_hwmon_attr_group);
+	hwmon_device_unregister(st->hwmon_dev);
+	iio_channel_release(st->channel);
+	return 0;
+}
+
+static struct platform_driver __refdata iio_hwmon_driver = {
+	.driver = {
+		.name = "iio_hwmon",
+		.owner = THIS_MODULE,
+	},
+	.probe = iio_hwmon_probe,
+	.remove = __devexit_p(iio_hwmon_remove),
+};
+
+static int iio_inkern_init(void)
+{
+	return platform_driver_register(&iio_hwmon_driver);
+}
+module_init(iio_inkern_init);
+
+static void iio_inkern_exit(void)
+{
+	platform_driver_unregister(&iio_hwmon_driver);
+}
+module_exit(iio_inkern_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("IIO to hwmon driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.7

