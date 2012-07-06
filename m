Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab2GFDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:16:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43696 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2GFDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:16:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF65898.3000301@jp.fujitsu.com>
Date: Fri, 6 Jul 2012 12:16:40 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <lenb@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] acpi : cpu hot-remove returns error number when cpu_down()
 fails
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if cpu_down() fails, acpi_processor_remove() continues to remove the cpu.
But in this case, it should return error number since some process may run on
the cpu. If the cpu has a running process and the cpu is turned the power off,
the system cannot work well.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 drivers/acpi/processor_driver.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: linux-3.5-rc4/drivers/acpi/processor_driver.c
===================================================================
--- linux-3.5-rc4.orig/drivers/acpi/processor_driver.c	2012-06-25 04:53:04.000000000 +0900
+++ linux-3.5-rc4/drivers/acpi/processor_driver.c	2012-07-05 21:02:58.711285382 +0900
@@ -610,7 +610,7 @@ err_free_pr:
 static int acpi_processor_remove(struct acpi_device *device, int type)
 {
 	struct acpi_processor *pr = NULL;
-
+	int ret;

 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;
@@ -621,8 +621,9 @@ static int acpi_processor_remove(struct
 		goto free;

 	if (type == ACPI_BUS_REMOVAL_EJECT) {
-		if (acpi_processor_handle_eject(pr))
-			return -EINVAL;
+		ret = acpi_processor_handle_eject(pr);
+		if (ret)
+			return ret;
 	}

 	acpi_processor_power_exit(pr, device);
@@ -841,12 +842,17 @@ static acpi_status acpi_processor_hotadd

 static int acpi_processor_handle_eject(struct acpi_processor *pr)
 {
-	if (cpu_online(pr->id))
-		cpu_down(pr->id);
+	int ret;
+
+	if (cpu_online(pr->id)) {
+		ret = cpu_down(pr->id);
+		if (ret)
+			return ret;
+	}

 	arch_unregister_cpu(pr->id);
 	acpi_unmap_lsapic(pr->id);
-	return (0);
+	return ret;
 }
 #else
 static acpi_status acpi_processor_hotadd_init(struct acpi_processor *pr)

