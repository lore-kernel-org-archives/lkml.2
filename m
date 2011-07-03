Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1GCPEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 11:04:43 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:22299
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab1GCPEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 11:04:40 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNRJ7F-02-LTY-02
X-M-MSG: 
Date: Sun, 3 Jul 2011 17:04:30 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110703150430.GV4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

this is a prototype implementation for attaching an event to a
specific PMU. If there is a general acceptance for this approach I
will create patches for upstream integration and base my current IBS
patches on it.

-Robert


This patch creates device nodes for each pmu using udev:

 # ls -l /dev/pmu/
 total 0
 crw-rw---- 1 root root 254, 5 Jul  8  2011 breakpoint
 crw-rw---- 1 root root 254, 4 Jul  8  2011 cpu
 crw-rw---- 1 root root 254, 6 Jul  8  2011 proto
 crw-rw---- 1 root root 254, 1 Jul  8  2011 software
 crw-rw---- 1 root root 254, 2 Jul  8  2011 tracepoint

After opening a device the pmu's file descriptor can be used to attach
an event to it. This works same as attaching an event to a specific
group:

        pmu = open("/dev/pmu/proto", O_RDONLY);
        ...
        event = sys_perf_event_open(&attr, 0, -1, pmu, 0);

This patch includes a working example that attaches an event to the
PMU registered with the name 'proto':

 # ls -l /dev/pmu/proto
 crw-rw---- 1 root root 254, 6 Jul  8  2011 /dev/pmu/proto
 # dmesg -c > /dev/null
 # ./proto
 # dmesg -c
 Found event ffff88041de71c00 (config=0000000000f00ba2) for pmu proto (type=6) on cpu -1
 Adding event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
 Removing event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
 Adding event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
 Removing event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1

Building the example:

 $ cd linux         # Linux kernel source dir
 $ make -C tools/perf/Documentation/examples CFLAGS=-I../.. proto

This approach works for fixed pmu types and also for dynamically
allocated pmus.

I intend to use this event allocation method to implement AMD
IBS. Other pmus can be implemented similar, such as northbridge and/or
uncore events for x86. The implementation is generic and not limited
to a single architecture, it is useful in every system with multiple
pmus.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/perf_event.h                |    1 +
 kernel/events/core.c                      |  179 ++++++++++++++++++++++++++---
 tools/perf/Documentation/examples/proto.c |   51 ++++++++
 3 files changed, 213 insertions(+), 18 deletions(-)
 create mode 100644 tools/perf/Documentation/examples/proto.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e76a410..3c5452e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -602,6 +602,7 @@ struct pmu {
 	struct list_head		entry;
 
 	struct device			*dev;
+	struct device			*cldev;
 	char				*name;
 	int				type;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e70f62..967203c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4,7 +4,8 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2011 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  �  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright (C) 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
  *
  * For licensing details see kernel-base/COPYING
  */
@@ -35,6 +36,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/cdev.h>
 
 #include "internal.h"
 
@@ -5510,42 +5512,68 @@ static struct device_attribute pmu_dev_attrs[] = {
        __ATTR_NULL,
 };
 
-static int pmu_bus_running;
-static struct bus_type pmu_bus = {
-	.name		= "event_source",
-	.dev_attrs	= pmu_dev_attrs,
+static struct pmu_sysfs {
+	int		initialized;
+	struct bus_type	bus;
+	struct cdev	*cdev;
+	unsigned	major;
+	struct class	*class;
+} pmu_sysfs = {
+	.bus = {
+		.name		= "event_source",
+		.dev_attrs	= pmu_dev_attrs,
+	},
 };
 
 static void pmu_dev_release(struct device *dev)
 {
+	struct pmu *pmu = dev_get_drvdata(dev);
+	if (pmu->cldev)
+		device_unregister(pmu->cldev);
 	kfree(dev);
 }
 
+#define MINORMAX	(MINORMASK + 1)
+
 static int pmu_dev_alloc(struct pmu *pmu)
 {
 	int ret = -ENOMEM;
+	struct device *dev;
+	struct device *cldev = NULL;
 
-	pmu->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!pmu->dev)
+	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!dev)
 		goto out;
 
-	device_initialize(pmu->dev);
-	ret = dev_set_name(pmu->dev, "%s", pmu->name);
+	device_initialize(dev);
+	ret = dev_set_name(dev, "%s", pmu->name);
 	if (ret)
 		goto free_dev;
 
-	dev_set_drvdata(pmu->dev, pmu);
-	pmu->dev->bus = &pmu_bus;
-	pmu->dev->release = pmu_dev_release;
-	ret = device_add(pmu->dev);
+	dev_set_drvdata(dev, pmu);
+	dev->bus = &pmu_sysfs.bus;
+	dev->release = pmu_dev_release;
+	ret = device_add(dev);
 	if (ret)
 		goto free_dev;
 
+	if (pmu_sysfs.class && pmu_sysfs.major && pmu->type < MINORMAX) {
+		cldev = device_create(pmu_sysfs.class, dev,
+				      MKDEV(pmu_sysfs.major, pmu->type),
+				      NULL, "%s", pmu->name);
+		if (IS_ERR(cldev)) {
+			ret = PTR_ERR(cldev);
+			goto free_dev;
+		}
+	}
+
+	pmu->dev = dev;
+	pmu->cldev = cldev;
 out:
 	return ret;
 
 free_dev:
-	put_device(pmu->dev);
+	put_device(dev);
 	goto out;
 }
 
@@ -5580,7 +5608,7 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
 	}
 	pmu->type = type;
 
-	if (pmu_bus_running) {
+	if (pmu_sysfs.initialized) {
 		ret = pmu_dev_alloc(pmu);
 		if (ret)
 			goto free_idr;
@@ -5967,6 +5995,38 @@ out:
 	return ret;
 }
 
+static int perf_pmu_open(struct inode *inode, struct file *file)
+{
+	/* minor number is the pmu->type */
+	file->private_data = (void *)(unsigned long)iminor(inode);
+	return 0;
+}
+
+static const struct file_operations perf_pmu_fops = {
+	.owner		= THIS_MODULE,
+	.open		= perf_pmu_open,
+};
+
+static int perf_set_pmu_type(int *type, int fd)
+{
+	struct file *file;
+	int fput_needed;
+	int ret = -EBADF;
+
+	file = fget_light(fd, &fput_needed);
+	if (!file)
+		return ret;
+
+	if (file->f_op == &perf_pmu_fops) {
+		*type = (int)(unsigned long)file->private_data;
+		ret = 0;
+	}
+
+	fput_light(file, fput_needed);
+
+	return ret;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -6023,7 +6083,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (event_fd < 0)
 		return event_fd;
 
-	if (group_fd != -1) {
+	if (perf_set_pmu_type(&attr.type, group_fd) && group_fd != -1) {
 		group_leader = perf_fget_light(group_fd, &fput_needed);
 		if (IS_ERR(group_leader)) {
 			err = PTR_ERR(group_leader);
@@ -6885,6 +6945,36 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+static struct pmu perf_proto;
+
+static int perf_proto_init(struct perf_event *event)
+{
+	if (perf_proto.type != event->attr.type)
+		return -ENOENT;
+	pr_info("Found event %p (config=%016llx) for pmu %s (type=%d) on cpu %d\n",
+		event, event->attr.config, perf_proto.name, event->attr.type, event->oncpu);
+	return 0;
+}
+
+static int perf_proto_add(struct perf_event *event, int flags)
+{
+	pr_info("Adding event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
+		event, event->attr.config, perf_proto.name, event->attr.type, event->oncpu);
+	return 0;
+}
+
+static void perf_proto_del(struct perf_event *event, int flags)
+{
+	pr_info("Removing event %p (config=%016llx) to pmu %s (type=%d) on cpu %d\n",
+		event, event->attr.config, perf_proto.name, event->attr.type, event->oncpu);
+}
+
+static struct pmu perf_proto = {
+	.event_init	= perf_proto_init,
+	.add		= perf_proto_add,
+	.del		= perf_proto_del,
+};
+
 void __init perf_event_init(void)
 {
 	int ret;
@@ -6896,6 +6986,7 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
+	perf_pmu_register(&perf_proto, "proto", -1);
 	perf_tp_register();
 	perf_cpu_notifier(perf_cpu_notify);
 	register_reboot_notifier(&perf_reboot_notifier);
@@ -6904,6 +6995,55 @@ void __init perf_event_init(void)
 	WARN(ret, "hw_breakpoint initialization failed with: %d", ret);
 }
 
+static char *pmu_devnode(struct device *dev, mode_t *mode)
+{
+	return kasprintf(GFP_KERNEL, "%s/%s", dev->class->name, dev_name(dev));
+}
+
+static int __init perf_event_chrdev_init(void)
+{
+	static const char name[] = "pmu";
+	int ret = -ENOMEM;
+	struct cdev *cdev;
+	dev_t devt;
+	struct class *class;
+
+	cdev = cdev_alloc();
+	if (!cdev)
+		goto out;
+
+	ret = alloc_chrdev_region(&devt, 0, MINORMAX, name);
+	if (ret)
+		goto out1;
+
+	cdev->owner = THIS_MODULE;
+	cdev->ops = &perf_pmu_fops;
+	kobject_set_name(&cdev->kobj, "%s", name);
+	ret = cdev_add(cdev, devt, MINORMAX);
+	if (ret)
+		goto out2;
+
+	class = class_create(THIS_MODULE, name);
+	if (IS_ERR(class)) {
+		ret = PTR_ERR(class);
+		goto out3;
+	}
+	class->devnode = pmu_devnode;
+
+	pmu_sysfs.class = class;
+	pmu_sysfs.cdev = cdev;
+	pmu_sysfs.major = MAJOR(devt);
+out:
+	return ret;
+out3:
+	cdev_del(cdev);
+out2:
+	unregister_chrdev_region(devt, MINORMAX);
+out1:
+	kobject_put(&cdev->kobj);
+	goto out;
+}
+
 static int __init perf_event_sysfs_init(void)
 {
 	struct pmu *pmu;
@@ -6911,7 +7051,10 @@ static int __init perf_event_sysfs_init(void)
 
 	mutex_lock(&pmus_lock);
 
-	ret = bus_register(&pmu_bus);
+	ret = perf_event_chrdev_init();
+	WARN(ret, "Unable to create pmu char device, reason %d\n", ret);
+
+	ret = bus_register(&pmu_sysfs.bus);
 	if (ret)
 		goto unlock;
 
@@ -6922,7 +7065,7 @@ static int __init perf_event_sysfs_init(void)
 		ret = pmu_dev_alloc(pmu);
 		WARN(ret, "Failed to register pmu: %s, reason %d\n", pmu->name, ret);
 	}
-	pmu_bus_running = 1;
+	pmu_sysfs.initialized = 1;
 	ret = 0;
 
 unlock:
diff --git a/tools/perf/Documentation/examples/proto.c b/tools/perf/Documentation/examples/proto.c
new file mode 100644
index 0000000..967260f
--- /dev/null
+++ b/tools/perf/Documentation/examples/proto.c
@@ -0,0 +1,51 @@
+/*
+ * Prototype to attach an event to a specific PMU
+ *
+ *  Copyright (C) 2011 Advanced Micro Devices, Inc., Robert Richter
+ *
+ * Sample code that attaches an event to a specified PMU.
+ *
+ *  # ls -l /dev/pmu/proto
+ *  crw-rw---- 1 root root 254, 6 Jul  8  2011 /dev/pmu/proto
+ *  # dmesg -c > /dev/null
+ *  # ./proto
+ *  # dmesg -c
+ *  Found event ffff88041de71c00 (config=0000000000f00ba2) for pmu proto (type=6) on cpu -1
+ *  Adding event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
+ *  Removing event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
+ *  Adding event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
+ *  Removing event ffff88041de71c00 (config=0000000000f00ba2) to pmu proto (type=6) on cpu 1
+ *
+ * Building:
+ *
+ *  $ cd linux         # Linux kernel source dir
+ *  $ make -C tools/perf/Documentation/examples CFLAGS=-I../.. proto
+ */
+
+#include <fcntl.h>
+#include <err.h>
+
+#include "perf.h"
+
+int main (int argc, char *argv[])
+{
+	int pmu, event;
+	struct perf_event_attr attr = { 0 };
+
+	pmu = open("/dev/pmu/proto", O_RDONLY);
+	if (pmu == -1)
+		err(1, "pmu not found");
+
+	attr.config = 0xf00ba2;
+
+	event = sys_perf_event_open(&attr, 0, -1, pmu, 0);
+	if (event == -1) {
+		close(pmu);
+		err(1, "event creation failed");
+	}
+
+	close(event);
+	close(pmu);
+
+	exit(0);
+}
-- 
1.7.5.3


-- 
Advanced Micro Devices, Inc.
Operating System Research Center

