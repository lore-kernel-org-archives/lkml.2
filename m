Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1F2JDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:03:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48957 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab1F2JDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:03:40 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        viresh kumar <viresh.kumar@st.com>, Shawn Guo <shawn.guo@linaro.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] PWM: add pwm framework support
Date: Wed, 29 Jun 2011 11:03:34 +0200
Message-Id: <1309338215-10702-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de>
References: <1309338215-10702-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds framework support for PWM (pulse width modulation) devices.

The is a barebone PWM API already in the kernel under include/linux/pwm.h,
but it does not allow for multiple drivers as each of them implements the
pwm_*() functions.

There are other PWM framework patches around from Bill Gatliff. Unlike
his framework this one does not change the existing API for PWMs so that
this framework can act as a drop in replacement for the existing API.

Why another framework?

Several people argue that there should not be another framework for PWMs
but they should be integrated into one of the existing frameworks like led
or hwmon. Unlike these frameworks the PWM framework is agnostic to the
purpose of the PWM. In fact, a PWM can drive a LED, but this makes the
LED framework a user of a PWM, like already done in leds-pwm.c. The gpio
framework also is not suitable for PWMs. Every gpio could be turned into
a PWM using timer based toggling, but on the other hand not every PWM hardware
device can be turned into a gpio due to the lack of hardware capabilities.

This patch does not try to improve the PWM API yet, this could be done in
subsequent patches.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 Documentation/pwm.txt |   56 +++++++++++++
 MAINTAINERS           |    5 +
 drivers/Kconfig       |    2 +
 drivers/Makefile      |    1 +
 drivers/pwm/Kconfig   |   12 +++
 drivers/pwm/Makefile  |    1 +
 drivers/pwm/core.c    |  220 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pwm.h   |   37 ++++++++
 8 files changed, 334 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/pwm.txt
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/core.c

diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
new file mode 100644
index 0000000..c7c5cb1
--- /dev/null
+++ b/Documentation/pwm.txt
@@ -0,0 +1,56 @@
+Pulse Width Modulation (PWM) interface
+
+This provides an overview about the Linux PWM interface
+
+PWMs are commonly used for controlling LEDs, fans or vibrators in
+cell phones. PWMs with a fixed purpose have no need implementing
+the Linux PWM API (although they could). However, PWMs are often
+found as discrete devices on SoCs which have no fixed purpose. It's
+up to the board designer to connect them to LEDs or fans. To provide
+this kind of flexibility the generic PWM API exists.
+
+Identifying PWMs
+----------------
+
+PWMs are identified by unique ids throughout the system. A platform
+should call pwmchip_reserve() during init time to reserve the id range
+for internal PWMs so that users have a fixed id to refer to specific
+PWMs.
+
+Using PWMs
+----------
+
+A PWM can be requested using pwm_request() and freed after usage with
+pwm_free(). After being requested a PWM has to be configured using
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
+
+To start/stop toggling the PWM output use pwm_enable()/pwm_disable().
+
+Implementing a PWM driver
+-------------------------
+
+Currently there are two ways to implement pwm drivers. Traditionally
+there only has been the barebone API meaning that each driver has
+to implement the pwm_*() functions itself. This means that it's impossible
+to have multiple PWM drivers in the system. For this reason it's mandatory
+for new drivers to use the generic PWM framework.
+A new PWM device can be added using pwmchip_add() and removed again with
+pwmchip_remove(). pwmchip_add() takes a filled in struct pwm_chip as
+argument which provides the ops and the pwm id to the framework.
+
+Locking
+-------
+
+The PWM core list manipulations are protected by a mutex, so pwm_request()
+and pwm_free() may not be called from an atomic context. Currently the
+PWM core does not enforce any locking to pwm_enable(), pwm_disable() and
+pwm_config(), so the calling context is currently driver specific. This
+is an issue derived from the former barebone API and should be fixed soon.
+
+Helpers
+-------
+
+Currently a PWM can only be configured with period_ns and duty_ns. For several
+use cases freq_hz and duty_percent might be better. Instead of calculating 
+this in your driver please consider adding appropriate helpers to the framework.
diff --git a/MAINTAINERS b/MAINTAINERS
index f0358cd..5a3a713 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5142,6 +5142,11 @@ M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 
+PWM core
+M:	Sascha Hauer <s.hauer@pengutronix.de>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 QLOGIC QLA1280 SCSI DRIVER
 M:	Michael Reed <mdr@sgi.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3bb154d..67f5c27 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -126,4 +126,6 @@ source "drivers/hwspinlock/Kconfig"
 
 source "drivers/clocksource/Kconfig"
 
+source "drivers/pwm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 09f3232..c321763 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-y				+= gpio/
+obj-y				+= pwm/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
 obj-$(CONFIG_RAPIDIO)		+= rapidio/
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
new file mode 100644
index 0000000..93c1052
--- /dev/null
+++ b/drivers/pwm/Kconfig
@@ -0,0 +1,12 @@
+menuconfig PWM
+	bool "PWM Support"
+	help
+	  This enables PWM support through the generic PWM framework.
+	  You only need to enable this, if you also want to enable
+	  one or more of the PWM drivers below.
+
+	  If unsure, say N.
+
+if PWM
+
+endif
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
new file mode 100644
index 0000000..3469c3d
--- /dev/null
+++ b/drivers/pwm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PWM)		+= core.o
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
new file mode 100644
index 0000000..71de479
--- /dev/null
+++ b/drivers/pwm/core.c
@@ -0,0 +1,220 @@
+/*
+ * Generic pwmlib implementation
+ *
+ * Copyright (C) 2011 Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/module.h>
+#include <linux/pwm.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+struct pwm_device {
+	struct			pwm_chip *chip;
+	const char		*label;
+	unsigned long		flags;
+#define FLAG_REQUESTED	0
+#define FLAG_ENABLED	1
+	struct list_head	node;
+};
+
+static LIST_HEAD(pwm_list);
+
+static DEFINE_MUTEX(pwm_lock);
+
+static struct pwm_device *_find_pwm(int pwm_id)
+{
+	struct pwm_device *pwm;
+
+	list_for_each_entry(pwm, &pwm_list, node) {
+		if (pwm->chip->pwm_id == pwm_id)
+			return pwm;
+	}
+
+	return NULL;
+}
+
+/**
+ * pwmchip_add() - register a new pwm
+ * @chip: the pwm
+ *
+ * register a new pwm. pwm->pwm_id must be initialized. if pwm_id < 0 then
+ * a dynamically assigned id will be used, otherwise the id specified,
+ */
+int pwmchip_add(struct pwm_chip *chip)
+{
+	struct pwm_device *pwm;
+	int ret = 0;
+
+	pwm = kzalloc(sizeof(*pwm), GFP_KERNEL);
+	if (!pwm)
+		return -ENOMEM;
+
+	pwm->chip = chip;
+
+	mutex_lock(&pwm_lock);
+
+	if (chip->pwm_id >= 0 && _find_pwm(chip->pwm_id)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	list_add_tail(&pwm->node, &pwm_list);
+out:
+	mutex_unlock(&pwm_lock);
+
+	if (ret)
+		kfree(pwm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pwmchip_add);
+
+/**
+ * pwmchip_remove() - remove a pwm
+ * @chip: the pwm
+ *
+ * remove a pwm. This function may return busy if the pwm is still requested.
+ */
+int pwmchip_remove(struct pwm_chip *chip)
+{
+	struct pwm_device *pwm;
+	int ret = 0;
+
+	mutex_lock(&pwm_lock);
+
+	pwm = _find_pwm(chip->pwm_id);
+	if (!pwm) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	list_del(&pwm->node);
+
+	kfree(pwm);
+out:
+	mutex_unlock(&pwm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pwmchip_remove);
+
+/*
+ * pwm_request - request a PWM device
+ */
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	struct pwm_device *pwm;
+	int ret;
+
+	mutex_lock(&pwm_lock);
+
+	pwm = _find_pwm(pwm_id);
+	if (!pwm) {
+		pwm = ERR_PTR(-ENOENT);
+		goto out;
+	}
+
+	if (test_bit(FLAG_REQUESTED, &pwm->flags)) {
+		pwm = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
+	if (!try_module_get(pwm->chip->ops->owner)) {
+		pwm = ERR_PTR(-ENODEV);
+		goto out;
+	}
+
+	if (pwm->chip->ops->request) {
+		ret = pwm->chip->ops->request(pwm->chip);
+		if (ret) {
+			pwm = ERR_PTR(ret);
+			goto out_put;
+		}
+	}
+
+	pwm->label = label;
+	set_bit(FLAG_REQUESTED, &pwm->flags);
+
+	goto out;
+
+out_put:
+	module_put(pwm->chip->ops->owner);
+out:
+	mutex_unlock(&pwm_lock);
+
+	return pwm;
+}
+EXPORT_SYMBOL_GPL(pwm_request);
+
+/*
+ * pwm_free - free a PWM device
+ */
+void pwm_free(struct pwm_device *pwm)
+{
+	mutex_lock(&pwm_lock);
+
+	if (!test_and_clear_bit(FLAG_REQUESTED, &pwm->flags)) {
+		pr_warning("PWM device already freed\n");
+		goto out;
+	}
+
+	pwm->label = NULL;
+
+	module_put(pwm->chip->ops->owner);
+out:
+	mutex_unlock(&pwm_lock);
+}
+EXPORT_SYMBOL_GPL(pwm_free);
+
+/*
+ * pwm_config - change a PWM device configuration
+ */
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	return pwm->chip->ops->config(pwm->chip, duty_ns, period_ns);
+}
+EXPORT_SYMBOL_GPL(pwm_config);
+
+/*
+ * pwm_enable - start a PWM output toggling
+ */
+int pwm_enable(struct pwm_device *pwm)
+{
+	if (!test_and_set_bit(FLAG_ENABLED, &pwm->flags))
+		return pwm->chip->ops->enable(pwm->chip);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pwm_enable);
+
+/*
+ * pwm_disable - stop a PWM output toggling
+ */
+void pwm_disable(struct pwm_device *pwm)
+{
+	if (test_and_clear_bit(FLAG_ENABLED, &pwm->flags))
+		pwm->chip->ops->disable(pwm->chip);
+}
+EXPORT_SYMBOL_GPL(pwm_disable);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 7c77575..df9681b 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -28,4 +28,41 @@ int pwm_enable(struct pwm_device *pwm);
  */
 void pwm_disable(struct pwm_device *pwm);
 
+#ifdef CONFIG_PWM
+struct pwm_chip;
+
+/**
+ * struct pwm_ops - PWM operations
+ * @request: optional hook for requesting a PWM
+ * @free: optional hook for freeing a PWM
+ * @config: configure duty cycles and period length for this PWM
+ * @enable: enable PWM output toggling
+ * @disable: disable PWM output toggling
+ */
+struct pwm_ops {
+	int			(*request)(struct pwm_chip *chip);
+	void			(*free)(struct pwm_chip *chip);
+	int			(*config)(struct pwm_chip *chip, int duty_ns,
+						int period_ns);
+	int			(*enable)(struct pwm_chip *chip);
+	void			(*disable)(struct pwm_chip *chip);
+	struct module		*owner;
+};
+
+/**
+ * struct pwm_chip - abstract a PWM
+ * @label: for diagnostics
+ * @owner: helps prevent removal of modules exporting active PWMs
+ * @ops: The callbacks for this PWM
+ */
+struct pwm_chip {
+	int			pwm_id;
+	const char		*label;
+	struct pwm_ops		*ops;
+};
+
+int pwmchip_add(struct pwm_chip *chip);
+int pwmchip_remove(struct pwm_chip *chip);
+#endif
+
 #endif /* __LINUX_PWM_H */
-- 
1.7.5.3

