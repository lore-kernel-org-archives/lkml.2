Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2EARat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:30:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24802 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2EARar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:30:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/acpi: Execute _PDC on CPUs past the ones seen to the guest.
Date: Tue,  1 May 2012 13:24:54 -0400
Message-Id: <1335893094-6904-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1335893094-6904-1-git-send-email-konrad.wilk@oracle.com>
References: <1335893094-6904-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_early_processor_set_pdc does this (executes _PDC), but it
cannot do it for vCPUS that are past the currently available vCPUS
(so dom0_max_vcpus=X is used). We can easily find if that is
the case by seeing if we get the same failure as the generic code
and if so run _PDC ourselves. We also (by doing some other hypercalls)
know how many physical CPUs there are - which the acpi_get_cpuid
can't - as it bands the amount of CPUs up to 'cpu_possible()'
which has been influenced by 'dom0_max_vcpus=X' flag.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-processor.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 0b48579..bb9f711 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -323,7 +323,7 @@ static unsigned int __init get_max_acpi_id(void)
 /*
  * The read_acpi_id and check_acpi_ids are there to support the Xen
  * oddity of virtual CPUs != physical CPUs in the initial domain.
- * The user can supply 'xen_max_vcpus=X' on the Xen hypervisor line
+ * The user can supply 'dom0_max_vcps=X' on the Xen hypervisor line
  * which will band the amount of CPUs the initial domain can see.
  * In general that is OK, except it plays havoc with any of the
  * for_each_[present|online]_cpu macros which are banded to the virtual
@@ -374,6 +374,14 @@ read_acpi_id(acpi_handle handle, u32 lvl, void *context, void **rv)
 	pr_debug(DRV_NAME "ACPI CPU%u w/ PBLK:0x%lx\n", acpi_id,
 		 (unsigned long)pblk);
 
+	/* acpi_early_processor_set_pdc does this, but it cannot do it for vCPUS
+	 * that are past the currently available vCPUS (so dom0_max_vcpus=X is
+	 * used). We can easily find if that is the case by seeing if we get the
+	 * same failure as the generic code and if so run _PDC ourselves.
+	 */
+	if (acpi_get_cpuid(handle, (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0, acpi_id) == -1)
+		acpi_processor_set_pdc(handle);
+
 	status = acpi_evaluate_object(handle, "_CST", NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
 		if (!pblk)
-- 
1.7.7.5

