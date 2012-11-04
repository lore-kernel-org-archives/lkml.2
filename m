Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2KDPZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:25:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52244 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2KDPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:25:03 -0500
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
Subject: [ACPIHP PATCH part4 8/9] ACPI/processor: serialize call to acpi_map/unmap_lsapic
Date: Sun,  4 Nov 2012 23:24:01 +0800
Message-Id: <1352042642-7306-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352042642-7306-1-git-send-email-jiang.liu@huawei.com>
References: <1352042642-7306-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function acpi_map_lsapic() is used to allocate CPU id for hot-added
CPUs and acpi_unmap_lsapic() is used to free CPU id for hot-removed
CPUs. But currently there's no mechanism to serialze the CPU id
allocation/free process, which may cause wrong CPU id assignment
when handling concurrent CPU online/offline operations. So introuce
a mutex to serialize CPU id allocation/free.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/processor_driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 9a02210..6dbce2f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -108,6 +108,7 @@ static struct acpi_driver acpi_processor_driver = {
 	.drv.pm = &acpi_processor_pm,
 };
 
+static DEFINE_MUTEX(acpi_processor_mutex);
 static DEFINE_PER_CPU(void *, processor_device_array);
 
 DEFINE_PER_CPU(struct acpi_processor *, processors);
@@ -668,7 +669,9 @@ static void acpi_processor_reset(struct acpi_device *device, struct acpi_process
 	acpi_processor_unlink(device, pr);
 	put_online_cpus();
 	arch_unregister_cpu(pr->id);
+	mutex_lock(&acpi_processor_mutex);
 	acpi_unmap_lsapic(pr->id);
+	mutex_unlock(&acpi_processor_mutex);
 	pr->id = -1;
 }
 
@@ -703,14 +706,18 @@ static int acpi_processor_pre_configure(struct acpi_device *device,
 		if (pr->apic_id == -1)
 			return result;
 
+		mutex_lock(&acpi_processor_mutex);
 		result = acpi_map_lsapic(device->handle, pr->apic_id, &pr->id);
+		mutex_unlock(&acpi_processor_mutex);
 		if (result)
 			return result;
 		BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
 
 		result = arch_register_cpu(pr->id, 1);
 		if (result) {
+			mutex_lock(&acpi_processor_mutex);
 			acpi_unmap_lsapic(pr->id);
+			mutex_unlock(&acpi_processor_mutex);
 			pr->id = -1;
 			return result;
 		}
-- 
1.7.9.5

