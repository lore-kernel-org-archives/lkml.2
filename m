Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab1IHCjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:39:23 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:57684 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485Ab1IHCjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:39:21 -0400
Date: Thu, 08 Sep 2011 10:39:04 +0800
From: "canquan.shen" <shencanquan@huawei.com>
Subject: [PATCH v2] acpi: Fix CPU hot removal problem
X-Originating-IP: [10.166.80.171]
To: "lenb@kernel.org" <lenb@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
        "xiaowei.yang@huawei.com" <xiaowei.yang@huawei.com>,
        hanweidong <hanweidong@huawei.com>, linqiangmin@huawei.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Message-id: <4E682AC8.7040302@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.2) Gecko/20110902
 Thunderbird/6.0.2
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We run Linux as a guest in Xen environment. When used xen tools
(xm vcpu-set <n>) to hot add and remove vcpu to and from the guest,
  we encountered the failure on vcpu removal. We found the reason is
that it didn't go to really remove cpu in the cpu removal code path.

This patch adds acpi_bus_trim in acpi_process_hotplug_notify to fix
this issue. With this patch, it works fine for us.

Signed-off-by: Canquan Shen <shencanquan@huawei.com>
---
  drivers/acpi/processor_driver.c |    5 +++++
  1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c 
b/drivers/acpi/processor_driver.c
index a1c564f..114592f 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -678,7 +678,11 @@ static void 
acpi_processor_hotplug_notify(acpi_handle handle,
              return;
          }

+        if (acpi_bus_trim(device, 1)) {
+            printk(KERN_ERR PREFIX
+                    "Removing device failed\n");
+            return;
+        }
          break;
      default:
          ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-- 
1.7.6

