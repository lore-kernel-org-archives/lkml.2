Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab1CIRF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:05:57 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:38370 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932800Ab1CIRFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:05:54 -0500
From: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: <maxime_coquelin@yahoo.fr>, ext Nishanth Menon <nm@ti.com>,
        ext Tony Lindgren <tony@atomide.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        Ambresh <a0393775@ti.com>, Jouni Hogander <jouni.hogander@nokia.com>,
        Lee Jones <Lee.Jones@linaro.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas ABERG <jonas.aberg@stericsson.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Andrei Warkentin <andreiw@motorola.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maxime Coquelin <maxime.coquelin-nonst@stericsson.com>
Subject: [RFC PATCHv1 1/2] Export SoC info through sysfs
Date: Wed, 9 Mar 2011 17:59:20 +0100
Message-ID: <1299689961-5028-2-git-send-email-maxime.coquelin-nonst@stericsson.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299689961-5028-1-git-send-email-maxime.coquelin-nonst@stericsson.com>
References: <1299689961-5028-1-git-send-email-maxime.coquelin-nonst@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common base to export System-on-Chip related informations through sysfs.

Creation of a "soc" directory under /sys/devices/system/.
Creation of a common "mach_name" entry to export machine name.
Creation of platform-defined SoC information entries.

Signed-off-by: Maxime COQUELIN <maxime.coquelin-nonst@stericsson.com>
---
 drivers/base/Kconfig    |    4 ++
 drivers/base/Makefile   |    1 +
 drivers/base/soc.c      |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sys_soc.h |   33 +++++++++++++++++
 4 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 drivers/base/soc.c
 create mode 100644 include/linux/sys_soc.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d57e8d0..4f2b56d 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -168,4 +168,8 @@ config SYS_HYPERVISOR
 	bool
 	default n
 
+config SYS_SOC
+	bool "Export SoC specific informations"
+	depends on EMBEDDED
+
 endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5f51c3b..f3bcfb3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -18,6 +18,7 @@ ifeq ($(CONFIG_SYSFS),y)
 obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
+obj-$(CONFIG_SYS_SOC) += soc.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/soc.c b/drivers/base/soc.c
new file mode 100644
index 0000000..6fa538b
--- /dev/null
+++ b/drivers/base/soc.c
@@ -0,0 +1,88 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ * Author: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/sysdev.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
+
+static struct sysdev_class_attribute *soc_default_attrs[];
+
+struct sys_soc {
+	char *mach_name;
+	struct sysdev_class class;
+};
+
+struct sys_soc soc = {
+	.class = {
+		.name = "soc",
+		.attrs = soc_default_attrs,
+	},
+};
+
+static ssize_t show_mach_name(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", soc.mach_name);
+}
+static SYSDEV_CLASS_ATTR(mach_name, S_IRUGO, show_mach_name, NULL);
+
+static ssize_t show_info(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr, char *buf)
+{
+	struct sys_soc_info *si = container_of(attr,
+			struct sys_soc_info, attr);
+
+	if (si->info)
+		return sprintf(buf, "%s\n", si->info);
+	else if (si->get_info)
+		return sprintf(buf, "%s\n", si->get_info(si));
+	else
+		return sprintf(buf, "No data\n");
+}
+
+void __init register_sys_soc_info(struct sys_soc_info *info, int nb_info)
+{
+	int i;
+
+	for (i = 0; i < nb_info; i++) {
+		info[i].attr.attr.name = info[i].name;
+		info[i].attr.attr.mode = S_IRUGO;
+		info[i].attr.show = show_info;
+
+		sysdev_class_create_file(&soc.class, &info[i].attr);
+	}
+}
+
+void __init register_sys_soc(char *name, struct sys_soc_info *info, int num)
+{
+	int len;
+
+	len = strlen(name);
+	soc.mach_name = kzalloc(len + 1, GFP_KERNEL);
+	if (!soc.mach_name)
+		return;
+
+	sprintf(soc.mach_name, "%s", name);
+
+	if (sysdev_class_register(&soc.class)) {
+		kfree(soc.mach_name);
+		return;
+	}
+
+	register_sys_soc_info(info, num);
+}
+
+/*
+ * Common attributes for all platforms.
+ * Only machine name for now
+ */
+static struct sysdev_class_attribute *soc_default_attrs[] = {
+	&attr_mach_name,
+	NULL
+};
diff --git a/include/linux/sys_soc.h b/include/linux/sys_soc.h
new file mode 100644
index 0000000..b91a924
--- /dev/null
+++ b/include/linux/sys_soc.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2011
+ * Author: Maxime Coquelin <maxime.coquelin-nonst@stericsson.com> for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+#ifndef __SYS_SOC_H
+#define __SYS_SOC_H
+
+#include <linux/sysdev.h>
+
+/**
+ * struct sys_soc_info - SoC exports related informations
+ * @name: name of the export
+ * @info: pointer on the key to export
+ * @get_info: callback to retrieve key if info field is NULL
+ * @attr: export's sysdev class attribute
+ */
+struct sys_soc_info {
+	char *name;
+	char *info;
+	char *(*get_info)(struct sys_soc_info *);
+	struct sysdev_class_attribute attr;
+};
+
+/**
+ * void register_sys_soc(char *name, struct sys_soc_info *, int num)
+ * @name: name of the machine
+ * @info: pointer on the info table to export
+ * @num: number of info to export
+ */
+void register_sys_soc(char *name, struct sys_soc_info *info, int num);
+
+#endif /* __SYS_SOC_H */
-- 
1.7.1

