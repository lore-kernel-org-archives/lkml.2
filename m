Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0HBHtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:49:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:53447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0HBHsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,302,1278313200"; 
   d="scan'208";a="591970032"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH 3/4] ACPI, APEI, Manage GHES as platform devices
Date: Mon,  2 Aug 2010 15:48:24 +0800
Message-Id: <1280735305-15379-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
References: <1280735305-15379-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register GHES during HEST initialization as platform devices. And make
GHES driver into platform device driver. So that the GHES driver
module can be loaded automatically when there are GHES available.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/acpi/apei/ghes.c |  140 +++++++++++++++++++++++++----------------------
 drivers/acpi/apei/hest.c |   76 +++++++++++++++++++++++--
 2 files changed, 145 insertions(+), 71 deletions(-)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -41,6 +41,8 @@
 #include <linux/interrupt.h>
 #include <linux/cper.h>
 #include <linux/kdebug.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
 #include <acpi/apei.h>
 #include <acpi/atomicio.h>
 #include <acpi/hed.h>
@@ -87,6 +89,7 @@ struct ghes {
  * used for that.
  */
 static LIST_HEAD(ghes_sci);
+static DEFINE_MUTEX(ghes_list_mutex);
 
 static struct ghes *ghes_new(struct acpi_hest_generic *generic)
 {
@@ -293,18 +296,15 @@ static struct notifier_block ghes_notifi
 	.notifier_call = ghes_notify_sci,
 };
 
-static int hest_ghes_parse(struct acpi_hest_header *hest_hdr, void *data)
+static int __devinit ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
-	int rc = 0;
+	int rc = -EINVAL;
 
-	if (hest_hdr->type != ACPI_HEST_TYPE_GENERIC_ERROR)
-		return 0;
-
-	generic = (struct acpi_hest_generic *)hest_hdr;
+	generic = ghes_dev->dev.platform_data;
 	if (!generic->enabled)
-		return 0;
+		return -ENODEV;
 
 	if (generic->error_block_length <
 	    sizeof(struct acpi_hest_generic_status)) {
@@ -327,62 +327,91 @@ static int hest_ghes_parse(struct acpi_h
 		ghes = NULL;
 		goto err;
 	}
-	switch (generic->notify.type) {
-	case ACPI_HEST_NOTIFY_POLLED:
-		pr_warning(GHES_PFX
-"Generic hardware error source: %d notified via POLL is not supported!\n",
-			   generic->header.source_id);
-		break;
-	case ACPI_HEST_NOTIFY_EXTERNAL:
-	case ACPI_HEST_NOTIFY_LOCAL:
-		pr_warning(GHES_PFX
-"Generic hardware error source: %d notified via IRQ is not supported!\n",
-			   generic->header.source_id);
-		break;
-	case ACPI_HEST_NOTIFY_SCI:
+	if (generic->notify.type == ACPI_HEST_NOTIFY_SCI) {
+		mutex_lock(&ghes_list_mutex);
 		if (list_empty(&ghes_sci))
 			register_acpi_hed_notifier(&ghes_notifier_sci);
 		list_add_rcu(&ghes->list, &ghes_sci);
-		break;
-	case ACPI_HEST_NOTIFY_NMI:
-		pr_warning(GHES_PFX
-"Generic hardware error source: %d notified via NMI is not supported!\n",
-			   generic->header.source_id);
-		break;
-	default:
-		pr_warning(FW_WARN GHES_PFX
-	"Unknown notification type: %u for generic hardware error source: %d\n",
-			   generic->notify.type, generic->header.source_id);
-		break;
+		mutex_unlock(&ghes_list_mutex);
+	} else {
+		unsigned char *notify = NULL;
+
+		switch (generic->notify.type) {
+		case ACPI_HEST_NOTIFY_POLLED:
+			notify = "POLL";
+			break;
+		case ACPI_HEST_NOTIFY_EXTERNAL:
+		case ACPI_HEST_NOTIFY_LOCAL:
+			notify = "IRQ";
+			break;
+		case ACPI_HEST_NOTIFY_NMI:
+			notify = "NMI";
+			break;
+		}
+		if (notify) {
+			pr_warning(GHES_PFX
+"Generic hardware error source: %d notified via %s is not supported!\n",
+				   generic->header.source_id, notify);
+		} else {
+			pr_warning(FW_WARN GHES_PFX
+"Unknown notification type: %u for generic hardware error source: %d\n",
+			generic->notify.type, generic->header.source_id);
+		}
+		rc = -ENODEV;
+		goto err;
 	}
+	platform_set_drvdata(ghes_dev, ghes);
 
 	return 0;
 err:
-	if (ghes)
+	if (ghes) {
 		ghes_fini(ghes);
+		kfree(ghes);
+	}
 	return rc;
 }
 
-static void ghes_cleanup(void)
+static int __devexit ghes_remove(struct platform_device *ghes_dev)
 {
-	struct ghes *ghes, *nghes;
+	struct ghes *ghes;
+	struct acpi_hest_generic *generic;
 
-	if (!list_empty(&ghes_sci))
-		unregister_acpi_hed_notifier(&ghes_notifier_sci);
+	ghes = platform_get_drvdata(ghes_dev);
+	generic = ghes->generic;
+
+	switch (generic->notify.type) {
+	case ACPI_HEST_NOTIFY_SCI:
+		mutex_lock(&ghes_list_mutex);
+		list_del_rcu(&ghes->list);
+		if (list_empty(&ghes_sci))
+			unregister_acpi_hed_notifier(&ghes_notifier_sci);
+		mutex_unlock(&ghes_list_mutex);
+		break;
+	default:
+		BUG();
+		break;
+	}
 
 	synchronize_rcu();
+	ghes_fini(ghes);
+	kfree(ghes);
 
-	list_for_each_entry_safe(ghes, nghes, &ghes_sci, list) {
-		list_del(&ghes->list);
-		ghes_fini(ghes);
-		kfree(ghes);
-	}
+	platform_set_drvdata(ghes_dev, NULL);
+
+	return 0;
 }
 
+static struct platform_driver ghes_platform_driver = {
+	.driver		= {
+		.name	= "GHES",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ghes_probe,
+	.remove		= ghes_remove,
+};
+
 static int __init ghes_init(void)
 {
-	int rc;
-
 	if (acpi_disabled)
 		return -ENODEV;
 
@@ -391,32 +420,12 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	rc = apei_hest_parse(hest_ghes_parse, NULL);
-	if (rc) {
-		pr_err(GHES_PFX
-		"Error during parsing HEST generic hardware error sources.\n");
-		goto err_cleanup;
-	}
-
-	if (list_empty(&ghes_sci)) {
-		pr_info(GHES_PFX
-			"No functional generic hardware error sources.\n");
-		rc = -ENODEV;
-		goto err_cleanup;
-	}
-
-	pr_info(GHES_PFX
-		"Generic Hardware Error Source support is initialized.\n");
-
-	return 0;
-err_cleanup:
-	ghes_cleanup();
-	return rc;
+	return platform_driver_register(&ghes_platform_driver);
 }
 
 static void __exit ghes_exit(void)
 {
-	ghes_cleanup();
+	platform_driver_unregister(&ghes_platform_driver);
 }
 
 module_init(ghes_init);
@@ -425,3 +434,4 @@ module_exit(ghes_exit);
 MODULE_AUTHOR("Huang Ying");
 MODULE_DESCRIPTION("APEI Generic Hardware Error Source support");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:GHES");
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -34,6 +34,7 @@
 #include <linux/kdebug.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
@@ -47,11 +48,6 @@ EXPORT_SYMBOL_GPL(hest_disable);
 
 static struct acpi_table_hest *hest_tab;
 
-static int hest_void_parse(struct acpi_hest_header *hest_hdr, void *data)
-{
-	return 0;
-}
-
 static int hest_esrc_len_tab[ACPI_HEST_TYPE_RESERVED] = {
 	[ACPI_HEST_TYPE_IA32_CHECK] = -1,	/* need further calculation */
 	[ACPI_HEST_TYPE_IA32_CORRECTED_CHECK] = -1,
@@ -125,6 +121,69 @@ int apei_hest_parse(apei_hest_func_t fun
 }
 EXPORT_SYMBOL_GPL(apei_hest_parse);
 
+struct ghes_arr {
+	struct platform_device **ghes_devs;
+	unsigned int count;
+};
+
+static int hest_parse_ghes_count(struct acpi_hest_header *hest_hdr, void *data)
+{
+	int *count = data;
+
+	if (hest_hdr->type == ACPI_HEST_TYPE_GENERIC_ERROR)
+		(*count)++;
+	return 0;
+}
+
+static int hest_parse_ghes(struct acpi_hest_header *hest_hdr, void *data)
+{
+	struct acpi_hest_generic *generic;
+	struct platform_device *ghes_dev;
+	struct ghes_arr *ghes_arr = data;
+	int rc;
+
+	if (hest_hdr->type != ACPI_HEST_TYPE_GENERIC_ERROR)
+		return 0;
+	generic = (struct acpi_hest_generic *)hest_hdr;
+	if (!generic->enabled)
+		return 0;
+	ghes_dev = platform_device_alloc("GHES", hest_hdr->source_id);
+	if (!ghes_dev)
+		return -ENOMEM;
+	ghes_dev->dev.platform_data = generic;
+	rc = platform_device_add(ghes_dev);
+	if (rc)
+		goto err;
+	ghes_arr->ghes_devs[ghes_arr->count++] = ghes_dev;
+
+	return 0;
+err:
+	platform_device_put(ghes_dev);
+	return rc;
+}
+
+static int hest_ghes_dev_register(unsigned int ghes_count)
+{
+	int rc, i;
+	struct ghes_arr ghes_arr;
+
+	ghes_arr.count = 0;
+	ghes_arr.ghes_devs = kmalloc(sizeof(void *) * ghes_count, GFP_KERNEL);
+	if (!ghes_arr.ghes_devs)
+		return -ENOMEM;
+
+	rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
+	if (rc)
+		goto err;
+out:
+	kfree(ghes_arr.ghes_devs);
+	return rc;
+err:
+	for (i = 0; i < ghes_arr.count; i++)
+		platform_device_unregister(ghes_arr.ghes_devs[i]);
+	goto out;
+}
+
 static int __init setup_hest_disable(char *str)
 {
 	hest_disable = 1;
@@ -137,6 +196,7 @@ static int __init hest_init(void)
 {
 	acpi_status status;
 	int rc = -ENODEV;
+	unsigned int ghes_count = 0;
 
 	if (acpi_disabled)
 		goto err;
@@ -158,7 +218,11 @@ static int __init hest_init(void)
 		goto err;
 	}
 
-	rc = apei_hest_parse(hest_void_parse, NULL);
+	rc = apei_hest_parse(hest_parse_ghes_count, &ghes_count);
+	if (rc)
+		goto err;
+
+	rc = hest_ghes_dev_register(ghes_count);
 	if (rc)
 		goto err;
 
