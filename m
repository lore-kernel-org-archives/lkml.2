Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1HBWPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:15:41 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:47033 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1HBWPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:15:23 -0400
From: Len Brown <lenb@kernel.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 03/19] ACPI, APEI, GHES,
 Do not ratelimit fatal error printk before panic
Date: Tue, 02 Aug 2011 18:14:36 -0400
Message-id: <5588340d46a484da53bbce8136184d9c7fbc259c.1312323131.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.6.396.ge0613
In-reply-to: <1312323292-2986-1-git-send-email-lenb@kernel.org>
References: <1312323292-2986-1-git-send-email-lenb@kernel.org>
In-reply-to: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
References: <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

printk is used by GHES to report hardware errors.  Normally, the
printk will be ratelimited to avoid too many hardware error reports in
kernel log.  Because there may be thousands or even millions of
corrected hardware errors during system running.

That is different for fatal hardware error, because system will go
panic as soon as possible, there will be no more than several error
records.  And these error records are valuable for system fault
diagnosis, so they should not be ratelimited.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f703b28..f339c0f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -360,11 +360,8 @@ static void ghes_do_proc(struct ghes *ghes)
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
@@ -372,12 +369,18 @@ static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
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
@@ -476,7 +479,7 @@ static int ghes_notify_nmi(struct notifier_block *this,
 
 	if (sev_global >= GHES_SEV_PANIC) {
 		oops_begin();
-		ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global);
+		__ghes_print_estatus(KERN_EMERG HW_ERR, ghes_global);
 		/* reboot to log the error! */
 		if (panic_timeout == 0)
 			panic_timeout = ghes_panic_timeout;
-- 
1.7.6.396.ge0613

