Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1JKLnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:43:08 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:38454 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1JKLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:43:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, zdevai@gmail.com,
        linus.walleij@linaro.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH] staging:iio:proof of concept in kernel interface.
Date: Tue, 11 Oct 2011 12:43:03 +0100
Message-Id: <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/Kconfig             |    5 ++++
 drivers/staging/iio/Makefile            |    3 ++
 drivers/staging/iio/iio.h               |    5 ++++
 drivers/staging/iio/industrialio-core.c |   38 ++++++++++++++++++++++++++++
 drivers/staging/iio/inkern.c            |   41 +++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index 09cf580..b613379 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -70,6 +70,11 @@ source "drivers/staging/iio/meter/Kconfig"
 source "drivers/staging/iio/resolver/Kconfig"
 source "drivers/staging/iio/trigger/Kconfig"
 
+config IIO_INKERN_TEST
+       tristate "In kernel interface test module"
+       help
+	 A dumb test of the in kernel interfaces
+
 config IIO_DUMMY_EVGEN
        tristate
 
diff --git a/drivers/staging/iio/Makefile b/drivers/staging/iio/Makefile
index eaa07b0..53aff59 100644
--- a/drivers/staging/iio/Makefile
+++ b/drivers/staging/iio/Makefile
@@ -17,6 +17,9 @@ iio_dummy-$(CONFIG_IIO_SIMPLE_DUMMY_BUFFER) += iio_simple_dummy_buffer.o
 
 obj-$(CONFIG_IIO_DUMMY_EVGEN) += iio_dummy_evgen.o
 
+obj-$(CONFIG_IIO_INKERN_TEST) += iio_inkern.o
+iio_inkern-y := inkern.o
+
 obj-y += accel/
 obj-y += adc/
 obj-y += addac/
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 1eedf2b..2c02e01 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -321,6 +321,7 @@ struct iio_dev {
 #define IIO_MAX_GROUPS 6
 	const struct attribute_group	*groups[IIO_MAX_GROUPS + 1];
 	int				groupcounter;
+	struct list_head		dev_list_entry;
 };
 
 /**
@@ -390,4 +391,8 @@ static inline bool iio_buffer_enabled(struct iio_dev *indio_dev)
 		& (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE);
 };
 
+struct iio_dev *iio_find_dev(const char *name);
+void iio_release_dev(struct iio_dev *indio_dev);
+
+
 #endif /* _INDUSTRIAL_IO_H_ */
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 0589891..565e2c9 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -22,12 +22,15 @@
 #include <linux/cdev.h>
 #include <linux/slab.h>
 #include <linux/anon_inodes.h>
+#include <linux/list.h>
 #include "iio.h"
 #include "iio_core.h"
 #include "iio_core_trigger.h"
 #include "chrdev.h"
 #include "sysfs.h"
 
+static DEFINE_MUTEX(iio_device_list_lock);
+static LIST_HEAD(iio_device_list);
 /* IDA to assign each registered device a unique id*/
 static DEFINE_IDA(iio_ida);
 
@@ -90,6 +93,31 @@ static const char * const iio_chan_info_postfix[] = {
 	= "filter_low_pass_3db_frequency",
 };
 
+
+/* hacked together in kernel querying  proof of concept */
+struct iio_dev *iio_find_dev(const char *name)
+{
+	struct iio_dev *indio_dev;
+	printk("find dev called\n");
+	mutex_lock(&iio_device_list_lock);
+	list_for_each_entry(indio_dev, &iio_device_list, dev_list_entry)
+		if (strcmp(indio_dev->name, name) == 0) {
+			mutex_unlock(&iio_device_list_lock);
+			__module_get(indio_dev->info->driver_module);
+			return indio_dev;
+		}
+	mutex_unlock(&iio_device_list_lock);
+	return ERR_PTR(ENODEV);
+}
+EXPORT_SYMBOL(iio_find_dev);
+
+void iio_release_dev(struct iio_dev *indio_dev)
+{
+	module_put(indio_dev->info->driver_module);
+}
+EXPORT_SYMBOL(iio_release_dev);
+
+
 /**
  * struct iio_detected_event_list - list element for events that have occurred
  * @list:		linked list header
@@ -998,6 +1026,7 @@ static void iio_device_unregister_eventset(struct iio_dev *indio_dev)
 static void iio_dev_release(struct device *device)
 {
 	struct iio_dev *indio_dev = container_of(device, struct iio_dev, dev);
+
 	cdev_del(&indio_dev->chrdev);
 	if (indio_dev->modes & INDIO_BUFFER_TRIGGERED)
 		iio_device_unregister_trigger_consumer(indio_dev);
@@ -1128,6 +1157,7 @@ int iio_device_register(struct iio_dev *indio_dev)
 	if (indio_dev->modes & INDIO_BUFFER_TRIGGERED)
 		iio_device_register_trigger_consumer(indio_dev);
 
+
 	ret = device_add(&indio_dev->dev);
 	if (ret < 0)
 		goto error_unreg_eventset;
@@ -1136,6 +1166,10 @@ int iio_device_register(struct iio_dev *indio_dev)
 	ret = cdev_add(&indio_dev->chrdev, indio_dev->dev.devt, 1);
 	if (ret < 0)
 		goto error_del_device;
+
+	mutex_lock(&iio_device_list_lock);
+	list_add(&indio_dev->dev_list_entry, &iio_device_list);
+	mutex_unlock(&iio_device_list_lock);
 	return 0;
 
 error_del_device:
@@ -1151,6 +1185,10 @@ EXPORT_SYMBOL(iio_device_register);
 
 void iio_device_unregister(struct iio_dev *indio_dev)
 {
+	mutex_lock(&iio_device_list_lock);
+	list_del(&indio_dev->dev_list_entry);
+	mutex_unlock(&iio_device_list_lock);
+
 	device_unregister(&indio_dev->dev);
 }
 EXPORT_SYMBOL(iio_device_unregister);
diff --git a/drivers/staging/iio/inkern.c b/drivers/staging/iio/inkern.c
new file mode 100644
index 0000000..39c5129
--- /dev/null
+++ b/drivers/staging/iio/inkern.c
@@ -0,0 +1,41 @@
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/err.h>
+
+#include "iio.h"
+#include "sysfs.h"
+#include "buffer_generic.h"
+#include "iio_simple_dummy.h"
+
+struct iio_dev *indio_dev;
+static int iio_inkern_init(void)
+{
+	int ret;
+	int val, val2;
+	indio_dev = iio_find_dev("max1363");
+	if (IS_ERR(indio_dev))
+		return PTR_ERR(indio_dev);
+	/* read from channel 1 and exit */
+	ret = indio_dev->info->read_raw(indio_dev, &indio_dev->channels[0], &val, &val2, 0);
+	if (ret < 0)
+		return ret;
+	printk("%d\n", val);
+
+	return 0;
+}
+module_init(iio_inkern_init);
+
+
+static void iio_inkern_exit(void)
+{
+	iio_release_dev(indio_dev);
+}
+module_exit(iio_inkern_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("IIO inkern interface test driver");
+MODULE_LICENSE("GPL v2");
+
+	    
-- 
1.7.3.4

