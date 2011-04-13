Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1DMO6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:58:10 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:41475 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1DMO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:56:02 -0400
X-ASG-Debug-ID: 1302706562-082e4b850001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>
X-ASG-Orig-Subj: [PATCH 05/13] w1: add DS278x slave driver
Subject: [PATCH 05/13] w1: add DS278x slave driver
Date: Wed, 13 Apr 2011 22:50:56 +0800
X-ASG-Orig-Subj: [PATCH 05/13] w1: add DS278x slave driver
Message-Id: <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
References: <2011041301>
 <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1302706562
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append DS278x slave driver.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/slaves/Kconfig     |   13 +++
 drivers/w1/slaves/Makefile    |    1 +
 drivers/w1/slaves/w1_ds278x.c |  184 +++++++++++++++++++++++++++++++++++++++++
 drivers/w1/w1_family.h        |    3 +
 4 files changed, 201 insertions(+), 0 deletions(-)
 create mode 100644 drivers/w1/slaves/w1_ds278x.c

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index f0c9096..d737aa9 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -61,6 +61,19 @@ config W1_SLAVE_DS2760
 
 	  If you are unsure, say N.
 
+config W1_SLAVE_DS278x
+	tristate "Dallas 278x battery monitor chip"
+	depends on W1
+	help
+	  If you enable this you will have the DS278x battery monitor
+	  chip support.
+
+	  The battery monitor chip is used in many batteries/devices
+	  as the one who is responsible for charging/discharging/monitoring
+	  Li+ batteries.
+
+	  If you are unsure, say N.
+
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
 	depends on W1
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 3c76350..bcc134b 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
+obj-$(CONFIG_W1_SLAVE_DS278x)	+= w1_ds278x.o
 obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
diff --git a/drivers/w1/slaves/w1_ds278x.c b/drivers/w1/slaves/w1_ds278x.c
new file mode 100644
index 0000000..9da94bb
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds278x.c
@@ -0,0 +1,184 @@
+/*
+ *	w1_ds278x.c - w1 family 27 (DS2780/DS2781) driver
+ *
+ * Copyright (c) Intel 2006 Stanley Cai <stanley.cai@intel.com>
+ * Copyright (c) Marvell 2007 Paul Shen <bo.a.shen@marvell.com>
+ *
+ * Modified from w1_ds2433 driver
+ *
+ * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+#define W1_REG_SIZE		256
+
+#define W1_F27_READ_REG		0x69
+#define W1_F27_WRITE_REG	0x6C
+#define W1_F27_COPY_REG		0x48
+#define W1_F27_RECALL_REG	0xB8
+#define W1_F27_LOCK_REG		0x6A
+
+struct w1_f27_data {
+	u8 memory[W1_REG_SIZE];
+	u32 validcrc;
+};
+
+/**
+ * Check the file size bounds and adjusts count as needed.
+ * This would not be needed if the file size didn't reset to 0 after a write.
+ */
+static inline size_t w1_f27_fix_count(loff_t off, size_t count,
+				      size_t size)
+{
+	if (off > size)
+		return 0;
+
+	if ((off + count) > size)
+		return (size - off);
+
+	return count;
+}
+
+static ssize_t w1_f27_read_bin(struct file *fp, struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 wrbuf[2];
+
+	count = w1_f27_fix_count(off, count, W1_REG_SIZE);
+	if (count == 0)
+		return 0;
+
+	atomic_inc(&sl->refcnt);
+	mutex_lock(&sl->master->mutex);
+
+	/* read directly from the REG */
+	if (w1_reset_select_slave(sl)) {
+		count = -EIO;
+		goto out_mutex_unlock;
+	}
+
+	wrbuf[0] = W1_F27_READ_REG;
+	wrbuf[1] = off & 0xff;
+	w1_write_block(sl->master, wrbuf, 2);
+	w1_read_block(sl->master, buf, count);
+
+out_mutex_unlock:
+	mutex_unlock(&sl->master->mutex);
+	atomic_dec(&sl->refcnt);
+
+	return count;
+}
+
+static ssize_t w1_f27_write_bin(struct file *fp, struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	char wrbuf[2];
+
+	count = w1_f27_fix_count(off, count, W1_REG_SIZE);
+	if (count == 0)
+		return 0;
+
+	atomic_inc(&sl->refcnt);
+	mutex_lock(&sl->master->mutex);
+
+	if (w1_reset_select_slave(sl)) {
+		count = -EIO;
+		goto out_mutex_unlock;
+	}
+
+	wrbuf[0] = W1_F27_WRITE_REG;
+	wrbuf[1] = off & 0xff;
+	w1_write_block(sl->master, wrbuf, 2);
+	w1_write_block(sl->master, buf, count);
+
+out_mutex_unlock:
+	mutex_unlock(&sl->master->mutex);
+	atomic_dec(&sl->refcnt);
+
+	return count;
+}
+
+static struct bin_attribute w1_f27_bin_attr = {
+	.attr = {
+		.name = "registers",
+		.mode = S_IRUGO | S_IWUSR,
+	},
+	.size = W1_REG_SIZE,
+	.read = w1_f27_read_bin,
+	.write = w1_f27_write_bin,
+};
+
+static int w1_f27_add_slave(struct w1_slave *sl)
+{
+	int err;
+
+	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f27_bin_attr);
+
+	return err;
+}
+
+static void w1_f27_remove_slave(struct w1_slave *sl)
+{
+	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f27_bin_attr);
+}
+
+static struct w1_family_ops w1_f27_fops = {
+	.add_slave = w1_f27_add_slave,
+	.remove_slave = w1_f27_remove_slave,
+};
+
+static struct w1_family w1_family_2780 = {
+	.fid = W1_BATTMON_DS2780,
+	.fops = &w1_f27_fops,
+};
+
+static struct w1_family w1_family_2781 = {
+	.fid = W1_BATTMON_DS2781,
+	.fops = &w1_f27_fops,
+};
+
+static struct w1_family w1_family_2783 = {
+	.fid = W1_BATTMON_DS2783,
+	.fops = &w1_f27_fops,
+};
+
+
+static int __init w1_f27_init(void)
+{
+	pr_info("1-Wire driver for the DS278x battery monitor...\n");
+	return (w1_register_family(&w1_family_2780) |
+		w1_register_family(&w1_family_2781) |
+		w1_register_family(&w1_family_2783));
+}
+
+static void __exit w1_f27_fini(void)
+{
+	w1_unregister_family(&w1_family_2781);
+	w1_unregister_family(&w1_family_2780);
+	w1_unregister_family(&w1_family_2783);
+}
+
+module_init(w1_f27_init);
+module_exit(w1_f27_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Paul Shen <bo.a.shen@marvell.com>");
+MODULE_DESCRIPTION("w1 family 27 driver for DS2780 & DS2781,"
+		   " Stand-Alone Fuel Gauge IC");
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index f3b636d..0f0b58c 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -36,6 +36,9 @@
 #define W1_THERM_DS18B20 	0x28
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
+#define W1_BATTMON_DS2780	0x32
+#define W1_BATTMON_DS2781	0x3D
+#define W1_BATTMON_DS2783	0x34
 
 #define MAXNAMELEN		32
 
-- 
1.5.6.5

