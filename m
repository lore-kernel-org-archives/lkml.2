Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2LLX2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:28:08 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7656 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2LLX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:27:35 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, lenb@kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 10/11] cpu: Update sysfs cpu/online for hotplug framework
Date: Wed, 12 Dec 2012 16:17:22 -0700
Message-Id: <1355354243-18657-11-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed store_online() to request a cpu online or offline
operation by calling hp_submit_req().  It sets a target cpu
device information with hp_add_dev_info() before making the
request.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/base/cpu.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 3870231..dc50d17 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -41,27 +41,43 @@ static ssize_t __ref store_online(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
-	ssize_t ret;
+	struct hp_request *hp_req;
+	struct hp_device *hp_dev;
+	enum hp_operation operation;
+	ssize_t ret = count;
 
-	cpu_hotplug_driver_lock();
 	switch (buf[0]) {
 	case '0':
-		ret = cpu_down(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
+		operation = HP_ONLINE_DEL;
 		break;
 	case '1':
-		ret = cpu_up(cpu->dev.id);
-		if (!ret)
-			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
+		operation = HP_ONLINE_ADD;
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
+	}
+
+	hp_req = hp_alloc_request(operation);
+	if (!hp_req)
+		return -ENOMEM;
+
+	hp_dev = kzalloc(sizeof(*hp_dev), GFP_KERNEL);
+	if (!hp_dev) {
+		kfree(hp_req);
+		return -ENOMEM;
+	}
+
+	hp_dev->device = dev;
+	hp_dev->class = HP_CLS_CPU;
+	hp_dev->data.cpu.cpu_id = cpu->dev.id;
+	hp_add_dev_info(hp_req, hp_dev);
+
+	if (hp_submit_req(hp_req)) {
+		kfree(hp_dev);
+		kfree(hp_req);
+		return -EINVAL;
 	}
-	cpu_hotplug_driver_unlock();
 
-	if (ret >= 0)
-		ret = count;
 	return ret;
 }
 static DEVICE_ATTR(online, 0644, show_online, store_online);
-- 
1.7.11.7

