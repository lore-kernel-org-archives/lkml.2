Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1KHCjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:39:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:44114 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1KHCjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:39:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,473,1315206000"; 
   d="scan'208";a="34288584"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/9] ACPI, APEI, Print resource errors in conventional format
Date: Tue,  8 Nov 2011 10:39:26 +0800
Message-Id: <1320719974-3598-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Use the normal %pR-like format for MMIO and I/O port ranges.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |    8 ++++----
 drivers/acpi/apei/einj.c      |   11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -460,9 +460,9 @@ int apei_resources_request(struct apei_r
 				       desc);
 		if (!r) {
 			pr_err(APEI_PFX
-		"Can not request iomem region <%016llx-%016llx> for GARs.\n",
+		"Can not request [mem %#010llx-%#010llx] for %s registers\n",
 			       (unsigned long long)res->start,
-			       (unsigned long long)res->end);
+			       (unsigned long long)res->end - 1, desc);
 			res_bak = res;
 			goto err_unmap_iomem;
 		}
@@ -472,9 +472,9 @@ int apei_resources_request(struct apei_r
 		r = request_region(res->start, res->end - res->start, desc);
 		if (!r) {
 			pr_err(APEI_PFX
-		"Can not request ioport region <%016llx-%016llx> for GARs.\n",
+		"Can not request [io  %#06llx-%#06llx] for %s registers\n",
 			       (unsigned long long)res->start,
-			       (unsigned long long)res->end);
+			       (unsigned long long)res->end - 1, desc);
 			res_bak = res;
 			goto err_unmap_ioport;
 		}
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -209,9 +209,10 @@ static int __einj_error_trigger(u64 trig
 			       "APEI EINJ Trigger Table");
 	if (!r) {
 		pr_err(EINJ_PFX
-	"Can not request iomem region <%016llx-%016llx> for Trigger table.\n",
+	"Can not request [mem %#010llx-%#010llx] for Trigger table\n",
 		       (unsigned long long)trigger_paddr,
-		       (unsigned long long)trigger_paddr+sizeof(*trigger_tab));
+		       (unsigned long long)trigger_paddr +
+			    sizeof(*trigger_tab) - 1);
 		goto out;
 	}
 	trigger_tab = ioremap_cache(trigger_paddr, sizeof(*trigger_tab));
@@ -232,9 +233,9 @@ static int __einj_error_trigger(u64 trig
 			       "APEI EINJ Trigger Table");
 	if (!r) {
 		pr_err(EINJ_PFX
-"Can not request iomem region <%016llx-%016llx> for Trigger Table Entry.\n",
-		       (unsigned long long)trigger_paddr+sizeof(*trigger_tab),
-		       (unsigned long long)trigger_paddr + table_size);
+"Can not request [mem %#010llx-%#010llx] for Trigger Table Entry\n",
+		       (unsigned long long)trigger_paddr + sizeof(*trigger_tab),
+		       (unsigned long long)trigger_paddr + table_size - 1);
 		goto out_rel_header;
 	}
 	iounmap(trigger_tab);
