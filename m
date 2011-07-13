Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1GMFOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:14:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:9791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1GMFOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:14:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="27048176"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 04/17] ACPI, APEI, GHES, Do not ratelimit fatal error printk before panic
Date: Wed, 13 Jul 2011 13:14:15 +0800
Message-Id: <1310534068-30547-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk is used by GHES to report hardware errors.  Normally, the
printk will be ratelimited to avoid too many hardware error reports in
kernel log.  Because there may be thousands or even millions of
corrected hardware errors during system running.

That is different for fatal hardware error, because system will go
panic as soon as possible, there will be no more than several error
records.  And these error records are valuable for system fault
diagnosis, so they should not be ratelimited.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/ghes.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -360,11 +360,8 @@ static void ghes_do_proc(struct ghes *gh
 	}
 }
 
-static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
+static void __ghes_print_estatus(const char *pfx, struct ghes *ghes)
 {
-	/* Not more than 2 messages every 5 seconds */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 5*HZ, 2);
-
 	if (pfx == NULL) {
 		if (ghes_severity(ghes->estatus->error_severity) <=
 		    GHES_SEV_CORRECTED)
@@ -372,12 +369,18 @@ static void ghes_print_estatus(const cha
 		else
 			pfx = KERN_ERR HW_ERR;
 	}
-	if (__ratelimit(&ratelimit)) {
-		printk(
-	"%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
-	pfx, ghes->generic->header.source_id);
-		apei_estatus_print(pfx, ghes->estatus);
-	}
+	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
+	       pfx, ghes->generic->header.source_id);
+	apei_estatus_print(pfx, ghes->estatus);
+}
+
+static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
+{
+	/* Not more than 2 messages every 5 seconds */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5*HZ, 2);
+
+	if (__ratelimit(&ratelimit))
+		__ghes_print_estatus(pfx, ghes);
 }
 
 static int ghes_proc(struct ghes *ghes)
@@ -476,7 +479,7 @@ static int ghes_notify_nmi(struct notifi
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
-		ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global);
+		__ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global);
 		/* reboot to log the error! */
 		if (panic_timeout == 0)
 			panic_timeout = ghes_panic_timeout;
