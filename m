Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2KDPYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:24:41 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40017 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2KDPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:24:34 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-mm@kvack.org
Subject: [ACPIHP PATCH part4 3/9] ACPIHP/processor: protect accesses to device->driver_data
Date: Sun,  4 Nov 2012 23:23:56 +0800
Message-Id: <1352042642-7306-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352042642-7306-1-git-send-email-jiang.liu@huawei.com>
References: <1352042642-7306-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU hotplug notification handler acpi_cpu_soft_notify() and driver
unbind method acpi_processor_remove() may be concurrently called.
acpi_cpu_soft_notify() will access device->driver_data, but that
data structure may be destroyed by acpi_processor_remove().

On the other hand, acpi_cpu_soft_notify() is always called under
protection of get_online_cpus(), so use get_online_cpus() to serialize
all accesses and modifications to device->driver_data.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/processor_driver.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 28add34..7d6d794 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -616,6 +616,8 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		return 0;
 	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
+	/* block CPU online/offline operations */
+	get_online_cpus();
 	result = acpi_processor_link(device, pr);
 	if (result)
 		goto err_unlock;
@@ -624,6 +626,7 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
 		if (result)
 			goto err_unlink;
 	}
+	put_online_cpus();
 
 	return 0;
 
@@ -654,8 +657,10 @@ static int acpi_processor_remove(struct acpi_device *device, int type)
 			return -EINVAL;
 	}
 
+	get_online_cpus();
 	acpi_processor_stop(device, pr);
 	acpi_processor_unlink(device, pr);
+	put_online_cpus();
 
 free:
 	device->driver_data = NULL;
-- 
1.7.9.5

