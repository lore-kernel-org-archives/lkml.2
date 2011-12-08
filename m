Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab1LHD1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:27:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:14032 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab1LHD0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:26:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="45071360"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 05/11] ACPI, APEI, GHES, Distinguish interleaved error report in kernel log
Date: Thu,  8 Dec 2011 11:25:44 +0800
Message-Id: <1323314750-8185-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
References: <1323314750-8185-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In most cases, printk only guarantees messages from different printk
calling will not be interleaved between each other.  But, one APEI
GHES hardware error report will involve multiple printk calling,
normally each for one line.  So it is possible that the hardware error
report comes from different generic hardware error source will be
interleaved.

In this patch, a sequence number is prefixed to each line of error
report.  So that, even if they are interleaved, they still can be
distinguished by the prefixed sequence number.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -506,16 +506,22 @@ static void __ghes_print_estatus(const c
 				 const struct acpi_hest_generic *generic,
 				 const struct acpi_hest_generic_status *estatus)
 {
+	static atomic_t seqno;
+	unsigned int curr_seqno;
+	char pfx_seq[64];
+
 	if (pfx == NULL) {
 		if (ghes_severity(estatus->error_severity) <=
 		    GHES_SEV_CORRECTED)
-			pfx = KERN_WARNING HW_ERR;
+			pfx = KERN_WARNING;
 		else
-			pfx = KERN_ERR HW_ERR;
+			pfx = KERN_ERR;
 	}
+	curr_seqno = atomic_inc_return(&seqno);
+	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}" HW_ERR, pfx, curr_seqno);
 	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
-	       pfx, generic->header.source_id);
-	apei_estatus_print(pfx, estatus);
+	       pfx_seq, generic->header.source_id);
+	apei_estatus_print(pfx_seq, estatus);
 }
 
 static int ghes_print_estatus(const char *pfx,
@@ -798,7 +804,7 @@ static int ghes_notify_nmi(unsigned int
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
-		__ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global->generic,
+		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
 				     ghes_global->estatus);
 		/* reboot to log the error! */
 		if (panic_timeout == 0)
