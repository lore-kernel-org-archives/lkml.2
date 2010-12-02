Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0LBIFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:05:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:47984 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0LBIFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:05:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="632307540"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v3 4/4] ACPI, APEI, Report GHES error information via printk
Date: Thu,  2 Dec 2010 16:05:05 +0800
Message-Id: <1291277105-31758-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
References: <1291277105-31758-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk is one of the methods to report hardware errors to user space.
This patch implements hardware error reporting for GHES via printk.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -43,6 +43,7 @@
 #include <linux/kdebug.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
@@ -255,11 +256,26 @@ static void ghes_do_proc(struct ghes *gh
 		}
 #endif
 	}
+}
+
+static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
+{
+	/* Not more than 2 messages every 5 seconds */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5*HZ, 2);
 
-	if (!processed && printk_ratelimit())
-		pr_warning(GHES_PFX
-		"Unknown error record from generic hardware error source: %d\n",
-			   ghes->generic->header.source_id);
+	if (pfx == NULL) {
+		if (ghes_severity(ghes->estatus->error_severity) <=
+		    GHES_SEV_CORRECTED)
+			pfx = KERN_WARNING HW_ERR;
+		else
+			pfx = KERN_ERR HW_ERR;
+	}
+	if (__ratelimit(&ratelimit)) {
+		printk(
+	"%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
+	pfx, ghes->generic->header.source_id);
+		apei_estatus_print(pfx, ghes->estatus);
+	}
 }
 
 static int ghes_proc(struct ghes *ghes)
@@ -269,6 +285,7 @@ static int ghes_proc(struct ghes *ghes)
 	rc = ghes_read_estatus(ghes, 0);
 	if (rc)
 		goto out;
+	ghes_print_estatus(NULL, ghes);
 	ghes_do_proc(ghes);
 
 out:
