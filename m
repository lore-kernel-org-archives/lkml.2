Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2KZSMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:12:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2KZRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 051/270] ACPI: EC: Make the GPE storm threshold a module parameter
Date: Mon, 26 Nov 2012 14:55:41 -0200
Message-Id: <1353949160-26803-52-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit a520d52e99b14ba7db135e916348f12f2a6e09be upstream.

The Linux EC driver includes a mechanism to detect GPE storms,
and switch from interrupt-mode to polling mode.  However, polling
mode sometimes doesn't work, so the workaround is problematic.
Also, different systems seem to need the threshold for detecting
the GPE storm at different levels.

ACPI_EC_STORM_THRESHOLD was initially 20 when it's created, and
was changed to 8 in 2.6.28 commit 06cf7d3c7 "ACPI: EC: lower interrupt storm
threshold" to fix kernel bug 11892 by forcing the laptop in that bug to
work in polling mode. However in bug 45151, it works fine in interrupt
mode if we lift the threshold back to 20.

This patch makes the threshold a module parameter so that user has a
flexible option to debug/workaround this issue.

The default is unchanged.

This is also a preparation patch to fix specific systems:
	https://bugzilla.kernel.org/show_bug.cgi?id=45151

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/acpi/ec.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7edaccc..615264c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -71,9 +71,6 @@ enum ec_command {
 #define ACPI_EC_UDELAY_GLK	1000	/* Wait 1ms max. to get global lock */
 #define ACPI_EC_MSI_UDELAY	550	/* Wait 550us for MSI EC */
 
-#define ACPI_EC_STORM_THRESHOLD 8	/* number of false interrupts
-					   per one transaction */
-
 enum {
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
 	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
@@ -87,6 +84,15 @@ static unsigned int ec_delay __read_mostly = ACPI_EC_DELAY;
 module_param(ec_delay, uint, 0644);
 MODULE_PARM_DESC(ec_delay, "Timeout(ms) waited until an EC command completes");
 
+/*
+ * If the number of false interrupts per one transaction exceeds
+ * this threshold, will think there is a GPE storm happened and
+ * will disable the GPE for normal transaction.
+ */
+static unsigned int ec_storm_threshold  __read_mostly = 8;
+module_param(ec_storm_threshold, uint, 0644);
+MODULE_PARM_DESC(ec_storm_threshold, "Maxim false GPE numbers not considered as GPE storm");
+
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
 /* External interfaces use first EC only, so remember */
 typedef int (*acpi_ec_query_func) (void *data);
@@ -319,7 +325,7 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		msleep(1);
 		/* It is safe to enable the GPE outside of the transaction. */
 		acpi_enable_gpe(NULL, ec->gpe);
-	} else if (t->irq_count > ACPI_EC_STORM_THRESHOLD) {
+	} else if (t->irq_count > ec_storm_threshold) {
 		pr_info(PREFIX "GPE storm detected, "
 			"transactions will use polling mode\n");
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
-- 
1.7.9.5

