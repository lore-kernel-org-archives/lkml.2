Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1KHCkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:40:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:25706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab1KHCjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288639"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 9/9] ACPI, APEI, GHES, Distinguish interleaved error report in kernel log
Date: Tue,  8 Nov 2011 10:39:34 +0800
Message-Id: <1320719974-3598-10-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
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
+	int curr_seqno;
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
+	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%d}" HW_ERR, pfx, curr_seqno);
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
