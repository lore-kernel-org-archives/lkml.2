Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab0JFQAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:00:18 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:33822 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759222Ab0JFQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:00:16 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <lars@metafoo.de>, <akpm@linux-foundation.org>, <kernel@pengutronix.de>,
        <philipp.zabel@gmail.com>, <robert.jarzmik@free.fr>,
        <marek.vasut@gmail.com>, <eric.y.miao@gmail.com>, <rpurdie@rpsys.net>,
        <sameo@linux.intel.com>, <kgene.kim@samsung.com>,
        <linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>, <bgat@billgatliff.com>,
        <khilman@deeprootsystems.com>
Subject: [PATCHv3 1/7] pwm: Add pwm core driver
Date: Wed, 6 Oct 2010 21:29:12 +0530
Message-ID: <1286380758-14063-2-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1286380758-14063-1-git-send-email-arun.murthy@stericsson.com>
References: <1286380758-14063-1-git-send-email-arun.murthy@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing pwm based led and backlight driver makes use of the
pwm(include/linux/pwm.h). So all the board specific pwm drivers will
be exposing the same set of function name as in include/linux/pwm.h.
Consder a platform with multi Soc or having more than one pwm module, in
such a case, there exists more than one pwm driver for a platform. Each
of these pwm drivers export the same set of function and hence leads to
re-declaration build error.

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
 drivers/pwm/Kconfig    |   18 +++++
 drivers/pwm/Makefile   |    1 +
 drivers/pwm/pwm-core.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h    |   12 +++-
 6 files changed, 204 insertions(+), 1 deletions(-)
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
index 443c4eb..1aec04e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -116,3 +116,4 @@ obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
 obj-y				+= vbus/
+obj-$(CONFIG_PWM_DEVICES)	+= pwm/
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
new file mode 100644
index 0000000..03a9813
--- /dev/null
+++ b/drivers/pwm/Kconfig
@@ -0,0 +1,18 @@
+#
+# PWM devices
+#
+
+menuconfig PWM_DEVICES
+	bool "PWM devices"
+	default y
+	---help---
+	  Say Y to enable pwm core driver and see options for various pwm
+	  drivers. This option enables pwm drivers to register with the
+	  pwm core driver and thereby provide a single interface to the
+	  clients using PWM.
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
index 0000000..c323969
--- /dev/null
+++ b/drivers/pwm/pwm-core.c
@@ -0,0 +1,171 @@
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
+	struct device *dev;
+	int pwm_id;
+	const char *name;
+};
+
+static struct class *pwm_class;
+
+/*
+ * TODO: This function is referenced in pwm based led and backlight driver.
+ * This function is no more required with the implementation of pwm core
+ * driver. This is retained as deprecated to make sure that the mips
+ * jz4740 pwm driver works fine as that is not aligned with this pwm core
+ * driver. On aligning the same this has to be removed.
+ */
+void __deprecated pwm_free(struct pwm_device *pwm)
+{
+}
+
+/**
+ * pwm_config() - configure the pwm device
+ * @pwm:	pointer to the struct pwm_device
+ * @period_ns:	period in nano seconds
+ *
+ * This function verifies for the presence of the pops structure and if so
+ * calls the pwm device specific config fucntion.
+ */
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	if (!pwm->pops)
+		return -EFAULT;
+	return pwm->pops->pwm_config(pwm, duty_ns, period_ns);
+}
+EXPORT_SYMBOL(pwm_config);
+
+/**
+ * pwm_enable() - enable pwm device
+ * @pwm:	pointer to the struct pwm_device
+ *
+ * This function verifies for the presence of the pops structure and if so
+ * calls the pwm device specific enable function.
+ */
+int pwm_enable(struct pwm_device *pwm)
+{
+	if (!pwm->pops)
+		return -EFAULT;
+	return pwm->pops->pwm_enable(pwm);
+}
+EXPORT_SYMBOL(pwm_enable);
+
+/**
+ * pwm_disable() - disable pwm device
+ * @pwm:	pointer to the struct pwm_device
+ *
+ * This function verifies for the presence of the pops structure and if so
+ * calls the pwm device specific disable function.
+ */
+void pwm_disable(struct pwm_device *pwm)
+{
+	if (!pwm->pops)
+		return -EFAULT;
+	pwm->pops->pwm_disable(pwm);
+}
+EXPORT_SYMBOL(pwm_disable);
+
+static int pwm_match_device_by_pwm_id(struct device *dev, void *data)
+{
+	int *pwm_id = data;
+	struct pwm_device *pwm = dev_get_drvdata(dev);
+	const char *name = pwm->name;
+
+	return (strcmp(name, pwm->name) == 0 && pwm->pwm_id == *pwm_id);
+}
+
+static int pwm_match_device_by_name(struct device *dev, void *data)
+{
+	const char *name = data;
+	struct pwm_device *pwm = dev_get_drvdata(dev);
+
+	return strcmp(pwm->name, name) == 0;
+}
+
+/**
+ * pwm_request() - request for a pwm device
+ * @pwm_id:	pwm device id
+ * @name:	pwm device name
+ *
+ * This function searches for the pwm device with the specified name in the
+ * list of pre registered pwm devices and return the pointer to the struct
+ * pwm_device. Clients using pwm device will first have to call this function
+ * to get the pointer to the pwm_device. This pointer to struct pwm_device
+ * will be further be used in all operation(pwm_enable/disable/config).
+ */
+struct pwm_device *pwm_request(int pwm_id, const char *name)
+{
+	struct device *dev = class_find_device(pwm_class, NULL, name,
+			pwm_match_device_by_name);
+	dev = class_find_device(pwm_class, dev, pwm_id,
+			pwm_match_device_by_pwm_id);
+
+	return dev ? dev_get_drvdata(dev) : NULL;
+}
+EXPORT_SYMBOL(pwm_request);
+
+/**
+ * pwm_device_register() - registers pwm driver with the pwm core driver
+ * @parent:	pointer to the parent's device struct
+ * @pwm:	pointer to the struct pwm_device
+ *
+ * This function registers the pwm device with the pwm core driver, thereby
+ * proposing a single interface exposure to the clients using the pwm device.
+ */
+int pwm_device_register(struct device *parent, struct pwm_device *pwm)
+{
+	pwm->dev = device_create(pwm_class, parent, 0, pwm, "%s", pwm->name);
+	if (IS_ERR(pwm->dev))
+		return PTR_ERR(pwm->dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(pwm_device_register);
+
+/**
+ * pwm_device_unregister() - unregisters the pre registered pwm device
+ * @pwm:	pointer to the struct pwm_device
+ * 
+ * This function unregisters the pwm device from the pwm core driver. Clients
+ * can no more use this pwm device.
+ */
+int pwm_device_unregister(struct pwm_device *pwm)
+{
+	device_unregister(pwm->dev);
+	return 0;
+}
+EXPORT_SYMBOL(pwm_device_unregister);
+
+static int __init pwm_init(void)
+{
+	pwm_class = class_create(THIS_MODULE, "pwm_core");
+	if (IS_ERR(pwm_class))
+		return PTR_ERR(pwm_class);
+
+	return 0;
+}
+subsys_initcall(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	class_destroy(pwm_class);
+}
+
+module_exit(pwm_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Arun R Murthy");
+MODULE_ALIAS("core:pwm");
+MODULE_DESCRIPTION("Core pwm driver");
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 7c77575..c41e0da 100644
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
 
+int pwm_device_register(struct device *parent, struct pwm_device *pwm);
+int pwm_device_unregister(struct pwm_device *pwm);
+
 #endif /* __LINUX_PWM_H */
-- 
1.7.2.dirty

