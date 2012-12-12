Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2LLX1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:27:12 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:1613 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2LLX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:27:10 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, lenb@kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 03/11] cpu: Add cpu hotplug handlers
Date: Wed, 12 Dec 2012 16:17:15 -0700
Message-Id: <1355354243-18657-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added cpu hotplug handlers.  cpu_add_execute() onlines requested
cpus for hot-add and online operations, and cpu_del_execute() 
offlines them for hot-delete and offline operations.  They are
also used for rollback as well.

cpu_del_validate() fails a request if cpu0 is requested to delete.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/base/cpu.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6345294..3870231 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -13,6 +13,8 @@
 #include <linux/gfp.h>
 #include <linux/slab.h>
 #include <linux/percpu.h>
+#include <linux/list.h>
+#include <linux/hotplug.h>
 
 #include "base.h"
 
@@ -324,10 +326,103 @@ static void __init cpu_dev_register_generic(void)
 #endif
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static int cpu_del_execute(struct hp_request *req, int rollback);
+
+static int cpu_add_execute(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+	u32 cpu;
+	int ret;
+
+	if (rollback)
+		return cpu_del_execute(req, 0);
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_CPU)
+			continue;
+
+		cpu = hp_dev->data.cpu.cpu_id;
+
+		if (cpu_online(cpu))
+			continue;
+
+		ret = cpu_up(cpu);
+		/* REVISIT: need a way to set a cpu dev for hot-plug op */
+		if (!ret && hp_is_online_op(req->operation))
+			kobject_uevent(&hp_dev->device->kobj, KOBJ_ONLINE);
+	}
+
+	return 0;
+}
+
+static int cpu_del_validate(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+
+	if (rollback)
+		return 0;
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_CPU)
+			continue;
+
+		/*
+		 * cpu 0 cannot be offlined.  This check can be removed when
+		 * cpu 0 offline is supported.
+		 */
+		if (hp_dev->data.cpu.cpu_id == 0)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cpu_del_execute(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+	u32 cpu;
+	int ret;
+
+	if (rollback)
+		return cpu_add_execute(req, 0);
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_CPU)
+			continue;
+
+		cpu = hp_dev->data.cpu.cpu_id;
+
+		if (!cpu_online(cpu))
+			continue;
+
+		ret = cpu_down(cpu);
+		/* REVISIT: need a way to set a cpu dev for hot-plug op */
+		if (!ret && hp_is_online_op(req->operation))
+			kobject_uevent(&hp_dev->device->kobj, KOBJ_OFFLINE);
+	}
+
+	return 0;
+}
+
+static void __init cpu_hp_init(void)
+{
+	hp_register_handler(HP_ADD_EXECUTE, cpu_add_execute,
+				HP_CPU_ADD_EXECUTE_ORDER);
+	hp_register_handler(HP_DEL_VALIDATE, cpu_del_validate,
+				HP_CPU_DEL_VALIDATE_ORDER);
+	hp_register_handler(HP_DEL_EXECUTE, cpu_del_execute,
+				HP_CPU_DEL_EXECUTE_ORDER);
+}
+#endif	/* CONFIG_HOTPLUG_CPU */
+
 void __init cpu_dev_init(void)
 {
 	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
 		panic("Failed to register CPU subsystem");
 
 	cpu_dev_register_generic();
+#ifdef CONFIG_HOTPLUG_CPU
+	cpu_hp_init();
+#endif
 }
-- 
1.7.11.7

