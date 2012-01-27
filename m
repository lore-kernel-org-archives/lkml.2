Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2A0OfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:35:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab2A0OfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:35:02 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu device
Date: Fri, 27 Jan 2012 15:34:24 +0100
Message-Id: <1327674868-10486-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327674868-10486-1-git-send-email-jolsa@redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding sysfs group 'format' attribute for pmu device that
contains a syntax description on how to construct raw events.

The event configuration is described in following
struct pefr_event_attr attributes:

  config
  config1
  config2

Each sysfs attribute within the format attribute group,
describes mapping of name and bitfield definition within
one of above attributes.

eg:
  "/sys/...<dev>/format/event" contains "config:0-7"
  "/sys/...<dev>/format/umask" contains "config:8-15"
  "/sys/...<dev>/format/usr"   contains "config:16"

the attribute value syntax is:

  line:      config ':' bits
  config:    'config' | 'config1' | 'config2"
  bits:      bits ',' bit_term | bit_term
  bit_term:  VALUE '-' VALUE | VALUE

Adding format_defined bool to the struct pmu to specify wether
pmu defines its own set of format attributes (within the
attr_groups member) or the default format attributes should be
used:
  "/sys/...<dev>/format/config"  contains "config:0-63"
  "/sys/...<dev>/format/config1" contains "config1:0-63"
  "/sys/...<dev>/format/config2" contains "config2:0-63"

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 .../testing/sysfs-bus-event_source-devices-format  |   14 ++++++++++++
 include/linux/perf_event.h                         |   22 ++++++++++++++++++++
 kernel/events/core.c                               |   22 ++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-format

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
new file mode 100644
index 0000000..079afc7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -0,0 +1,14 @@
+Where:		/sys/bus/event_source/devices/<dev>/format
+Date:		January 2012
+Kernel Version: 3.3
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Attribute group to describe the magic bits that go into
+		perf_event_attr::config[012] for a particular pmu.
+		Each attribute of this group defines the 'hardware' bitmask
+		we want to export, so that userspace can deal with sane
+		name/value pairs.
+
+		Example: 'config1:1,6-10,44'
+		Defines contents of attribute that occupies bits 1,6-10,44 of
+		perf_event_attr::config1.
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0b91db2..e2bf1c7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -516,6 +516,7 @@ struct perf_guest_info_callbacks {
 #include <linux/irq_work.h>
 #include <linux/jump_label.h>
 #include <linux/atomic.h>
+#include <linux/sysfs.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -626,6 +627,12 @@ struct pmu {
 	int				task_ctx_nr;
 
 	/*
+	 * True if the pmu defines its own set of format attributes within
+	 * attr_groups. If false, default format attributes are used.
+	 */
+	bool				format_defined;
+
+	/*
 	 * Fully disable/enable this PMU, can be used to protect from the PMI
 	 * as well as for lazy/batch writing of the MSRs.
 	 */
@@ -1215,5 +1222,20 @@ do {									\
 	register_cpu_notifier(&fn##_nb);				\
 } while (0)
 
+
+#define PMU_FORMAT_ATTR(_name, _format)				\
+static ssize_t							\
+pmu_format_attr_##_name##_show(struct device *dev,		\
+			       struct device_attribute *attr,	\
+			       char *page)			\
+{								\
+	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);		\
+	return sprintf(page, _format "\n");			\
+}								\
+								\
+static struct device_attribute format_attr_##_name =		\
+	__ATTR(_name, 0444,					\
+	       pmu_format_attr_##_name##_show, NULL)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index de859fb..8d2d6f3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5503,6 +5503,22 @@ static struct bus_type pmu_bus = {
 	.dev_attrs	= pmu_dev_attrs,
 };
 
+/* Default format attributes. */
+PMU_FORMAT_ATTR(config,  "config:0-63");
+PMU_FORMAT_ATTR(config1, "config1:0-63");
+PMU_FORMAT_ATTR(config2, "config2:0-63");
+
+static struct attribute *format_attrs[] = {
+	&format_attr_config.attr,
+	&format_attr_config1.attr,
+	&format_attr_config2.attr,
+};
+
+static struct attribute_group format_attr_group = {
+	.name   = "format",
+	.attrs  = format_attrs,
+};
+
 static void pmu_dev_release(struct device *dev)
 {
 	kfree(dev);
@@ -5529,6 +5545,12 @@ static int pmu_dev_alloc(struct pmu *pmu)
 	if (ret)
 		goto free_dev;
 
+	if (!pmu->format_defined) {
+		ret = sysfs_create_group(&pmu->dev->kobj, &format_attr_group);
+		if (ret)
+			goto free_dev;
+	}
+
 out:
 	return ret;
 
-- 
1.7.4.4

