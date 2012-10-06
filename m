Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2JFPgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:36:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55513 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2JFPgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:36:43 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v3 28/28] ACPI/processor: serialize call to acpi_map/unmap_lsapic
Date: Sat,  6 Oct 2012 23:27:36 +0800
Message-Id: <1349537256-21670-29-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a mutex to serialize call to acpi_map/unmap_lsapic.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/processor_driver.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 2346b81..9fc20b4 100644
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
 
@@ -702,7 +705,9 @@ static int acpi_processor_pre_configure(struct acpi_device *device,
 	if (pr->id == -1) {
 		if (pr->apic_id == -1)
 			goto out;
+		mutex_lock(&acpi_processor_mutex);
 		result = acpi_map_lsapic(device->handle, pr->apic_id, &pr->id);
+		mutex_unlock(&acpi_processor_mutex);
 		if (result)
 			goto out;
 		BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
@@ -722,7 +727,9 @@ static int acpi_processor_pre_configure(struct acpi_device *device,
 	return 0;
 
 out_unmap:
+	mutex_lock(&acpi_processor_mutex);
 	acpi_unmap_lsapic(pr->id);
+	mutex_unlock(&acpi_processor_mutex);
 	pr->id = -1;
 out:
 
-- 
1.7.9.5

