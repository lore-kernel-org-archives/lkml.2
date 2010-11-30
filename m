Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0K3CwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:52:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:23185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0K3Cvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:51:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="354765030"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v2 3/3] ACPI, APEI, report GHES error information via printk
Date: Tue, 30 Nov 2010 10:51:41 +0800
Message-Id: <1291085501-31494-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk is one of the methods to report hardware errors to user space.
This patch implements hardware error reporting for GHES via printk.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -255,11 +255,23 @@ static void ghes_do_proc(struct ghes *gh
 		}
 #endif
 	}
+}
 
-	if (!processed && printk_ratelimit())
-		pr_warning(GHES_PFX
-		"Unknown error record from generic hardware error source: %d\n",
-			   ghes->generic->header.source_id);
+static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
+{
+	if (pfx == NULL) {
+		if (ghes_severity(ghes->estatus->error_severity) <=
+		    GHES_SEV_CORRECTED)
+			pfx = KERN_WARNING HW_ERR;
+		else
+			pfx = KERN_ERR HW_ERR;
+	}
+	if (printk_ratelimit()) {
+		printk(
+	"%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
+	pfx, ghes->generic->header.source_id);
+		apei_estatus_print(pfx, ghes->estatus);
+	}
 }
 
 static int ghes_proc(struct ghes *ghes)
@@ -269,6 +281,7 @@ static int ghes_proc(struct ghes *ghes)
 	rc = ghes_read_estatus(ghes, 0);
 	if (rc)
 		goto out;
+	ghes_print_estatus(NULL, ghes);
 	ghes_do_proc(ghes);
 
 out:
