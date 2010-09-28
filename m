Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0I1Khg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:37:36 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52460 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab0I1KgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:36:12 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <arun.murthy@stericsson.com>,
        <STEricsson_nomadik_linux@list.st.com>
Subject: [PATCH 1/7] pwm: Add pwm core driver
Date: Tue, 28 Sep 2010 16:05:28 +0530
Message-ID: <1285670134-18063-2-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
References: <1285670134-18063-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing pwm based led and backlight driver makes use of the
pwm(include/linux/pwm.h). So all the board specific pwm drivers will
be exposing the same set of function name as in include/linux/pwm.h.
As a result build fails in case of multi soc environments where each soc
has a pwm device in it.

In order to overcome this issue all the pwm drivers must register to
some core pwm driver with function pointers for pwm operations (i.e
pwm_config, pwm_enable, pwm_disable).

The clients of pwm device will have to call pwm_request, wherein
they will get the pointer to struct pwm_ops. This structure include
function pointers for pwm_config, pwm_enable and pwm_disable.

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/Kconfig        |    2 +
 drivers/Makefile       |    1 +
 drivers/pwm/Kconfig    |   16 ++++++
 drivers/pwm/Makefile   |    1 +
 drivers/pwm/pwm-core.c |  129 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h    |   12 ++++-
 6 files changed, 160 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/pwm-core.c

diff --git a/drivers/Kconfig b/drivers/Kconfig
index a2b902f..e042f27 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
+
+source "drivers/pwm/Kconfig"
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 4ca727d..0061ec4 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -116,3 +116,4 @@ obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
 obj-y				+= vbus/
+obj-$(CONFIG_PWM_DEVICES)	+= pwm/
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
new file mode 100644
index 0000000..5d10106
--- /dev/null
+++ b/drivers/pwm/Kconfig
@@ -0,0 +1,16 @@
+#
+# PWM devices
+#
+
+menuconfig PWM_DEVICES
+	bool "PWM devices"
+	default y
+	---help---
+	  Say Y here to get to see options for device drivers from various
+	  different categories. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if PWM_DEVICES
+
+endif # PWM_DEVICES
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
new file mode 100644
index 0000000..552f969
--- /dev/null
+++ b/drivers/pwm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PWM_DEVICES)	+= pwm-core.o
diff --git a/drivers/pwm/pwm-core.c b/drivers/pwm/pwm-core.c
new file mode 100644
index 0000000..b84027a
--- /dev/null
+++ b/drivers/pwm/pwm-core.c
@@ -0,0 +1,129 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ */
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/rwsem.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+
+struct pwm_device {
+	struct pwm_ops *pops;
+	int pwm_id;
+};
+
+struct pwm_dev_info {
+	struct pwm_device *pwm_dev;
+	struct list_head list;
+};
+static struct pwm_dev_info *di;
+
+DECLARE_RWSEM(pwm_list_lock);
+
+void __deprecated pwm_free(struct pwm_device *pwm)
+{
+}
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	return pwm->pops->pwm_config(pwm, duty_ns, period_ns);
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	return pwm->pops->pwm_enable(pwm);
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	pwm->pops->pwm_disable(pwm);
+}
+EXPORT_SYMBOL(pwm_disable);
+
+int pwm_device_register(struct pwm_device *pwm_dev)
+{
+	struct pwm_dev_info *pwm;
+
+	down_write(&pwm_list_lock);
+	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
+	if (!pwm) {
+		up_write(&pwm_list_lock);
+		return -ENOMEM;
+	}
+	pwm->pwm_dev = pwm_dev;
+	list_add_tail(&pwm->list, &di->list);
+	up_write(&pwm_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_device_register);
+
+int pwm_device_unregister(struct pwm_device *pwm_dev)
+{
+	struct pwm_dev_info *tmp;
+	struct list_head *pos, *tmp_lst;
+
+	down_write(&pwm_list_lock);
+	list_for_each_safe(pos, tmp_lst, &di->list) {
+		tmp = list_entry(pos, struct pwm_dev_info, list);
+		if (tmp->pwm_dev == pwm_dev) {
+			list_del(pos);
+			kfree(tmp);
+			up_write(&pwm_list_lock);
+			return 0;
+		}
+	}
+	up_write(&pwm_list_lock);
+	return -ENOENT;
+}
+EXPORT_SYMBOL(pwm_device_unregister);
+
+struct pwm_device *pwm_request(int pwm_id, const char *name)
+{
+	struct pwm_dev_info *pwm;
+	struct list_head *pos;
+
+	down_read(&pwm_list_lock);
+	list_for_each(pos, &di->list) {
+		pwm = list_entry(pos, struct pwm_dev_info, list);
+		if ((!strcmp(pwm->pwm_dev->pops->name, name)) &&
+				(pwm->pwm_dev->pwm_id == pwm_id)) {
+			up_read(&pwm_list_lock);
+			return pwm->pwm_dev;
+		}
+	}
+	up_read(&pwm_list_lock);
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(pwm_request);
+
+static int __init pwm_init(void)
+{
+	struct pwm_dev_info *pwm;
+
+	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
+	if (!pwm)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&pwm->list);
+	di = pwm;
+	return 0;
+}
+
+static void __exit pwm_exit(void)
+{
+	kfree(di);
+}
+
+subsys_initcall(pwm_init);
+module_exit(pwm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Arun R Murthy");
+MODULE_ALIAS("core:pwm");
+MODULE_DESCRIPTION("Core pwm driver");
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 7c77575..6e7da1f 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -3,6 +3,13 @@
 
 struct pwm_device;
 
+struct pwm_ops {
+	int (*pwm_config)(struct pwm_device *pwm, int duty_ns, int period_ns);
+	int (*pwm_enable)(struct pwm_device *pwm);
+	int (*pwm_disable)(struct pwm_device *pwm);
+	char *name;
+};
+
 /*
  * pwm_request - request a PWM device
  */
@@ -11,7 +18,7 @@ struct pwm_device *pwm_request(int pwm_id, const char *label);
 /*
  * pwm_free - free a PWM device
  */
-void pwm_free(struct pwm_device *pwm);
+void __deprecated pwm_free(struct pwm_device *pwm);
 
 /*
  * pwm_config - change a PWM device configuration
@@ -28,4 +35,7 @@ int pwm_enable(struct pwm_device *pwm);
  */
 void pwm_disable(struct pwm_device *pwm);
 
+int pwm_device_register(struct pwm_device *pwm_dev);
+int pwm_device_unregister(struct pwm_device *pwm_dev);
+
 #endif /* __LINUX_PWM_H */
-- 
1.7.2.dirty

