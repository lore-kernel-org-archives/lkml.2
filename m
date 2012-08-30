Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2H3OjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:39:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56365 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2H3OjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:39:00 -0400
Date: Thu, 30 Aug 2012 09:38:41 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] tpm: fix tpm_acpi sparse warning on different address spaces
Message-ID: <20120830143839.GA9589@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083014-2398-0000-0000-000009E7DE84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_os_map_memory expects its return value to be in the __iomem address
space. Cast it back later when used in a memcpy to avoid the same sparse
warning there.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_acpi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_acpi.c b/drivers/char/tpm/tpm_acpi.c
index fe3fa94..36bdcfa 100644
--- a/drivers/char/tpm/tpm_acpi.c
+++ b/drivers/char/tpm/tpm_acpi.c
@@ -49,7 +49,7 @@ int read_log(struct tpm_bios_log *log)
 {
 	struct acpi_tcpa *buff;
 	acpi_status status;
-	struct acpi_table_header *virt;
+	void __iomem *virt;
 	u64 len, start;
 
 	if (log->bios_event_log != NULL) {
@@ -102,7 +102,7 @@ int read_log(struct tpm_bios_log *log)
 		return -EIO;
 	}
 
-	memcpy(log->bios_event_log, virt, len);
+	memcpy(log->bios_event_log, (void *)virt, len);
 
 	acpi_os_unmap_memory(virt, len);
 	return 0;
-- 
1.7.5.4

