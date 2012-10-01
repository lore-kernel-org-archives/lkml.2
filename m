Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2JADkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 23:40:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab2JADkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 23:40:10 -0400
Date: Sun, 30 Sep 2012 20:39:54 -0700
From: tip-bot for Thomas Renninger <trenn@suse.de>
Message-ID: <tip-325a8d36035f0623950e38e9cf7a47a48e72df11@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, lenb@kernel.org, eric.piel@tremplin-utc.net,
        tglx@linutronix.de, trenn@suse.de, hpa@linux.intel.com,
        robert.moore@intel.com
In-Reply-To: <1349043837-22659-6-git-send-email-trenn@suse.de>
References: <1349043837-22659-6-git-send-email-trenn@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] ACPI: Create acpi_table_taint()
  function to avoid code duplication
Git-Commit-ID: 325a8d36035f0623950e38e9cf7a47a48e72df11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 30 Sep 2012 20:40:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  325a8d36035f0623950e38e9cf7a47a48e72df11
Gitweb:     http://git.kernel.org/tip/325a8d36035f0623950e38e9cf7a47a48e72df11
Author:     Thomas Renninger <trenn@suse.de>
AuthorDate: Mon, 1 Oct 2012 00:23:56 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 30 Sep 2012 18:03:35 -0700

ACPI: Create acpi_table_taint() function to avoid code duplication

There are two ways of overriding ACPI tables now, both need to taint the
the kernel.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/1349043837-22659-6-git-send-email-trenn@suse.de
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/acpi/osl.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 007224b..a2845ff 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -656,6 +656,15 @@ void __init acpi_initrd_override(void *data, size_t size)
 }
 #endif /* CONFIG_ACPI_INITRD_TABLE_OVERRIDE */
 
+static void acpi_table_taint(struct acpi_table_header *table)
+{
+	pr_warn(PREFIX
+		"Override [%4.4s-%8.8s], this is unsafe: tainting kernel\n",
+		table->signature, table->oem_table_id);
+	add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
+}
+
+
 acpi_status
 acpi_os_table_override(struct acpi_table_header * existing_table,
 		       struct acpi_table_header ** new_table)
@@ -669,13 +678,8 @@ acpi_os_table_override(struct acpi_table_header * existing_table,
 	if (strncmp(existing_table->signature, "DSDT", 4) == 0)
 		*new_table = (struct acpi_table_header *)AmlCode;
 #endif
-	if (*new_table != NULL) {
-		printk(KERN_WARNING PREFIX "Override [%4.4s-%8.8s], "
-			   "this is unsafe: tainting kernel\n",
-		       existing_table->signature,
-		       existing_table->oem_table_id);
-		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);
-	}
+	if (*new_table != NULL)
+		acpi_table_taint(existing_table);
 	return AE_OK;
 }
 
@@ -736,6 +740,8 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
 		break;
 	} while (table_offset + ACPI_HEADER_SIZE < all_tables_size);
 
+	if (*address != 0)
+		acpi_table_taint(existing_table);
 	return AE_OK;
 #endif
 }
