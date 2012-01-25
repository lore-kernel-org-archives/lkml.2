Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2AYOht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:37:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab2AYOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:37:47 -0500
Date: Wed, 25 Jan 2012 15:37:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Greg KH <greg@kroah.com>, acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFCv3 0/9] perf tool: parser generator for events parsing
Message-ID: <20120125143711.GD2582@m.brq.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327422364.2446.75.camel@twins>
 <20120125005342.GA24662@kroah.com>
 <1327488573.2614.59.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327488573.2614.59.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:49:33AM +0100, Peter Zijlstra wrote:
> On Tue, 2012-01-24 at 16:53 -0800, Greg KH wrote:
> 
> > Well, what's to keep someone from exploding one of those files to go
> > over the buffer size without knowing it?
> 
> The content is known at compile time, we could put checks in. But yeah
> 4k isn't that much text..
> 
> > Even after reading the above link, I can't really understand what this
> > is being used for.  As it's sysfs files, why aren't Documentation/ABI/
> > files also being created with the patch explaining it all?
> 
> Ah, yeah, documentation, wasn't that written in C :-)
> 
> But fair enough... Anyway, the purpose is to describe the magic bits
> that go into perf_event_attr::config[012] for a particular pmu.
> 
> Basically they're the 'hardware' bitmasks we want to export, so that
> userspace can deal with sane name/value pairs.
> 
> > Again, if at all possible, sysfs should be one value per file.  Please
> > NEVER create a sysfs file that requires a parser to determine what is
> > going on in it.  It should be a simple 'read the value' type thing.
> 
> The whole purpose was to drive a parser :-) Anyway, is:
> "config:0-7,32-35" acceptable for a single file?
> 
> This means, the 'config' member of struct perf_event_attr bits 0-7,32-35
> form a bitfield whose name is then given by the filename that has this
> content.
> 
> > So yes, multiple sysfs files do make sense, the resource load should be
> > almost non-existant for new ones.
> 
> Surely all these attribute objects take more space than a few lines of
> text, but ok, I guess multiple files it is.
> 

please check attached patch, would something like this be ok?

jirka
---
 .../testing/sysfs-bus-event_source-devices-format  |   14 ++++++++++++
 include/linux/perf_event.h                         |   22 ++++++++++++++++++++
 kernel/events/core.c                               |   22 ++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-format

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
new file mode 100644
index 0000000..5a15221
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -0,0 +1,14 @@
+Where:		/sys/bus/event_source/devices/<dev>/format
+Date:		January 2012
+Kernel Version: 3.3
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Attribute group for to describe the magic bits that go into
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
1.7.1

