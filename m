Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2AQNWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:22:10 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:42929 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab2AQNWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:08 -0500
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 08:22:06 EST
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 29/50] ACPI, APEI, GHES,
 Distinguish interleaved error report in kernel log
Date: Tue, 17 Jan 2012 07:21:21 -0500
Message-id: <5ba82ab534a325d310fe02af1c149f1072792c7b.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 511b971..9dcb2d8 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -506,16 +506,22 @@ static void __ghes_print_estatus(const char *pfx,
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
@@ -798,7 +804,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
-		__ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global->generic,
+		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
 				     ghes_global->estatus);
 		/* reboot to log the error! */
 		if (panic_timeout == 0)
-- 
1.7.9.rc1

