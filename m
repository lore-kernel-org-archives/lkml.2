Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735Ab2CFNcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 08:32:07 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49142 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030568Ab2CFNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 08:32:02 -0500
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/3] x86, RAS: Add a decoded msg buffer
Date: Tue,  6 Mar 2012 14:31:32 +0100
Message-Id: <1331040694-12558-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1331040694-12558-1-git-send-email-bp@amd64.org>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Echoing 1 into /sys/devices/system/ras/agent causes the ras_printk()
function to buffer a string describing a hardware error. This is meant
for userspace daemons which are running on the system and are going to
consume decoded information through the MCE tracepoint.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig           |    9 +++
 arch/x86/Makefile          |    3 +
 arch/x86/include/asm/ras.h |   15 +++++
 arch/x86/ras/Makefile      |    1 +
 arch/x86/ras/ras.c         |  145 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/ras.h
 create mode 100644 arch/x86/ras/Makefile
 create mode 100644 arch/x86/ras/ras.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e189fa..bda1480241b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -657,6 +657,15 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_SUMMIT
 
+config X86_RAS
+	def_bool y
+	prompt "X86 RAS features"
+	---help---
+	A collection of Reliability, Availability and Serviceability
+	software features which aim to enable hardware error logging
+	and reporting. Leave it at 'y' unless you really know what
+	you're doing
+
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba1294592..a6b6bb1f308b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -146,6 +146,9 @@ drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 # suspend and hibernation support
 drivers-$(CONFIG_PM) += arch/x86/power/
 
+# RAS support
+core-y += arch/x86/ras/
+
 drivers-$(CONFIG_FB) += arch/x86/video/
 
 ####
diff --git a/arch/x86/include/asm/ras.h b/arch/x86/include/asm/ras.h
new file mode 100644
index 000000000000..b51838514259
--- /dev/null
+++ b/arch/x86/include/asm/ras.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_X86_RAS_H
+#define _ASM_X86_RAS_H
+
+#define ERR_BUF_SZ 500
+
+extern bool ras_agent;
+
+#define PR_EMERG	BIT(0)
+#define PR_WARNING	BIT(4)
+#define PR_CONT		BIT(8)
+
+extern const char *ras_get_decoded_err(void);
+extern void ras_printk(unsigned long flags, const char *fmt, ...);
+
+#endif /* _ASM_X86_RAS_H */
diff --git a/arch/x86/ras/Makefile b/arch/x86/ras/Makefile
new file mode 100644
index 000000000000..7a70bb5cd057
--- /dev/null
+++ b/arch/x86/ras/Makefile
@@ -0,0 +1 @@
+obj-y		:= ras.o
diff --git a/arch/x86/ras/ras.c b/arch/x86/ras/ras.c
new file mode 100644
index 000000000000..868d732c6cd4
--- /dev/null
+++ b/arch/x86/ras/ras.c
@@ -0,0 +1,145 @@
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/ras.h>
+
+static size_t dec_len;
+static char *err_str;
+
+/*
+ * If true, userspace has an agent running and eating all the
+ * tracing data we're sending out so there's no dmesg output
+ */
+bool ras_agent;
+EXPORT_SYMBOL_GPL(ras_agent);
+
+/* getting the string implies the current buffer is emptied */
+const char *ras_get_decoded_err(void)
+{
+	dec_len = 0;
+	return err_str;
+}
+
+void ras_printk(unsigned long flags, const char *fmt, ...)
+{
+	va_list args;
+	char *buf;
+	size_t left;
+	int i;
+
+	/* add a HW_ERR prefix to a newly started line */
+	if (!(flags & PR_CONT)) {
+		strcpy(err_str + dec_len, HW_ERR);
+		dec_len += strlen(HW_ERR);
+	}
+
+	left = ERR_BUF_SZ - dec_len - 1;
+	buf = err_str + dec_len;
+
+	va_start(args, fmt);
+	i = vsnprintf(buf, left, fmt, args);
+	va_end(args);
+
+	if (i >= left) {
+		pr_err("Error decode buffer truncated.\n");
+		dec_len = ERR_BUF_SZ-1;
+		err_str[dec_len] = '\n';
+	} else
+		dec_len += i;
+
+	if (!ras_agent) {
+		if (flags & PR_EMERG)
+			pr_emerg("%s", buf);
+		else if (flags & PR_WARNING)
+			pr_warning("%s", buf);
+		else if (flags & PR_CONT)
+			pr_cont("%s", buf);
+
+		dec_len = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(ras_printk);
+
+struct bus_type ras_subsys = {
+	.name	  = "ras",
+	.dev_name = "ras",
+};
+
+struct ras_attr {
+	struct attribute attr;
+	ssize_t (*show) (struct kobject *kobj, struct ras_attr *attr, char *bf);
+	ssize_t (*store)(struct kobject *kobj, struct ras_attr *attr,
+			 const char *buf, size_t count);
+};
+
+#define RAS_ATTR(_name, _mode, _show, _store)	\
+static struct ras_attr ras_attr_##_name = __ATTR(_name, _mode, _show, _store)
+
+static ssize_t ras_agent_show(struct kobject *kobj,
+			      struct ras_attr *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%.1d\n", ras_agent);
+}
+
+static ssize_t ras_agent_store(struct kobject *kobj,
+			       struct ras_attr *attr,
+			       const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long value;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret < 0) {
+		printk(KERN_ERR "Wrong value for ras_agent field.\n");
+		return ret;
+	}
+
+	ras_agent = !!value;
+
+	return count;
+}
+
+RAS_ATTR(agent, 0644, ras_agent_show, ras_agent_store);
+
+static struct attribute *ras_root_attrs[] = {
+	&ras_attr_agent.attr,
+	NULL
+};
+
+static const struct attribute_group ras_root_attr_group = {
+	.attrs = ras_root_attrs,
+};
+
+static const struct attribute_group *ras_root_attr_groups[] = {
+	&ras_root_attr_group,
+	NULL,
+};
+
+static int __init ras_init(void)
+{
+	int err = 0;
+
+	err = subsys_system_register(&ras_subsys, ras_root_attr_groups);
+	if (err) {
+		printk(KERN_ERR "Error registering toplevel RAS sysfs node.\n");
+		return err;
+	}
+
+	/* no freeing of this since it ras.c is compiled-on only */
+	err_str = kzalloc(ERR_BUF_SZ, GFP_KERNEL);
+	if (!err_str) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	return 0;
+
+err_alloc:
+	bus_unregister(&ras_subsys);
+
+	return err;
+}
+subsys_initcall(ras_init);
-- 
1.7.8.rc0

