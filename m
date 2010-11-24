Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0KXBRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:17:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:27535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0KXBRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:17:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,245,1288594800"; 
   d="scan'208";a="860781809"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH 3/3] ACPI, APEI, report GHES error information via printk
Date: Wed, 24 Nov 2010 09:16:54 +0800
Message-Id: <1290561414-13313-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290561414-13313-1-git-send-email-ying.huang@intel.com>
References: <1290561414-13313-1-git-send-email-ying.huang@intel.com>
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
+		"%sHardware error from Generic Hardware Error Source: %d\n",
+		pfx, ghes->generic->header.source_id);
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
