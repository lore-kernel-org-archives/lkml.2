Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1BUF4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:56:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:60137 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083Ab1BUFy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:54:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,198,1297065600"; 
   d="scan'208";a="889598838"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: [PATCH 4/7] PCIe, AER, use pre-generated prefix in error information printing
Date: Mon, 21 Feb 2011 13:54:42 +0800
Message-Id: <1298267685-7357-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298267685-7357-1-git-send-email-ying.huang@intel.com>
References: <1298267685-7357-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When printing PCIe AER error information, each line is prefixed with
PCIe device and driver information.  In original implementation, the
prefix is generated when each line is printed.  In fact, all lines
share the same prefix.  So this patch pre-generated the prefix, and
use that one when each line is printed.

In addition to common prefix can be pre-generated, the trailing white
spaces in string constants and NULLs in char * array constants can be
removed too.  These can reduce the object file size further.

The size of object file before and after changing is as follow:

           text    data     bss     dec
before:    3038       0       0    3038
after:     2118       0       0    2118

Signed-off-by: Huang Ying <ying.huang@intel.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Zhang Yanmin <yanmin.zhang@intel.com>
---
 drivers/pci/pcie/aer/aerdrv_errprint.c |  123 ++++++++++++---------------------
 1 file changed, 48 insertions(+), 75 deletions(-)

--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -57,86 +57,44 @@
 	(e & AER_DATA_LINK_LAYER_ERROR_MASK(t)) ? AER_DATA_LINK_LAYER_ERROR : \
 	AER_TRANSACTION_LAYER_ERROR)
 
-#define AER_PR(info, pdev, fmt, args...)				\
-	printk("%s%s %s: " fmt, (info->severity == AER_CORRECTABLE) ?	\
-		KERN_WARNING : KERN_ERR, dev_driver_string(&pdev->dev),	\
-		dev_name(&pdev->dev), ## args)
-
 /*
  * AER error strings
  */
-static char *aer_error_severity_string[] = {
+static const char *aer_error_severity_string[] = {
 	"Uncorrected (Non-Fatal)",
 	"Uncorrected (Fatal)",
 	"Corrected"
 };
 
-static char *aer_error_layer[] = {
+static const char *aer_error_layer[] = {
 	"Physical Layer",
 	"Data Link Layer",
 	"Transaction Layer"
 };
-static char *aer_correctable_error_string[] = {
-	"Receiver Error        ",	/* Bit Position 0	*/
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Bad TLP               ",	/* Bit Position 6	*/
-	"Bad DLLP              ",	/* Bit Position 7	*/
-	"RELAY_NUM Rollover    ",	/* Bit Position 8	*/
-	NULL,
-	NULL,
-	NULL,
-	"Replay Timer Timeout  ",	/* Bit Position 12	*/
-	"Advisory Non-Fatal    ",	/* Bit Position 13	*/
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
+
+static const char *aer_correctable_error_string[] = {
+	"Receiver Error",		/* Bit Position 0	*/
 	NULL,
 	NULL,
 	NULL,
 	NULL,
 	NULL,
+	"Bad TLP",			/* Bit Position 6	*/
+	"Bad DLLP",			/* Bit Position 7	*/
+	"RELAY_NUM Rollover",		/* Bit Position 8	*/
 	NULL,
 	NULL,
 	NULL,
+	"Replay Timer Timeout",		/* Bit Position 12	*/
+	"Advisory Non-Fatal",		/* Bit Position 13	*/
 };
 
-static char *aer_uncorrectable_error_string[] = {
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Data Link Protocol    ",	/* Bit Position 4	*/
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
-	"Poisoned TLP          ",	/* Bit Position 12	*/
-	"Flow Control Protocol ",	/* Bit Position 13	*/
-	"Completion Timeout    ",	/* Bit Position 14	*/
-	"Completer Abort       ",	/* Bit Position 15	*/
-	"Unexpected Completion ",	/* Bit Position 16	*/
-	"Receiver Overflow     ",	/* Bit Position 17	*/
-	"Malformed TLP         ",	/* Bit Position 18	*/
-	"ECRC                  ",	/* Bit Position 19	*/
-	"Unsupported Request   ",	/* Bit Position 20	*/
+static const char *aer_uncorrectable_error_string[] = {
 	NULL,
 	NULL,
 	NULL,
 	NULL,
+	"Data Link Protocol",		/* Bit Position 4	*/
 	NULL,
 	NULL,
 	NULL,
@@ -144,19 +102,29 @@ static char *aer_uncorrectable_error_str
 	NULL,
 	NULL,
 	NULL,
+	"Poisoned TLP",			/* Bit Position 12	*/
+	"Flow Control Protocol",	/* Bit Position 13	*/
+	"Completion Timeout",		/* Bit Position 14	*/
+	"Completer Abort",		/* Bit Position 15	*/
+	"Unexpected Completion",	/* Bit Position 16	*/
+	"Receiver Overflow",		/* Bit Position 17	*/
+	"Malformed TLP",		/* Bit Position 18	*/
+	"ECRC",				/* Bit Position 19	*/
+	"Unsupported Request",		/* Bit Position 20	*/
 };
 
-static char *aer_agent_string[] = {
+static const char *aer_agent_string[] = {
 	"Receiver ID",
 	"Requester ID",
 	"Completer ID",
 	"Transmitter ID"
 };
 
-static void __aer_print_error(struct aer_err_info *info, struct pci_dev *dev)
+static void __aer_print_error(const char *prefix,
+			      struct aer_err_info *info)
 {
 	int i, status;
-	char *errmsg = NULL;
+	const char *errmsg = NULL;
 
 	status = (info->status & ~info->mask);
 
@@ -165,15 +133,17 @@ static void __aer_print_error(struct aer
 			continue;
 
 		if (info->severity == AER_CORRECTABLE)
-			errmsg = aer_correctable_error_string[i];
+			errmsg = i < ARRAY_SIZE(aer_correctable_error_string) ?
+				aer_correctable_error_string[i] : NULL;
 		else
-			errmsg = aer_uncorrectable_error_string[i];
+			errmsg = i < ARRAY_SIZE(aer_uncorrectable_error_string) ?
+				aer_uncorrectable_error_string[i] : NULL;
 
 		if (errmsg)
-			AER_PR(info, dev, "   [%2d] %s%s\n", i, errmsg,
+			printk("%s""   [%2d] %-22s%s\n", prefix, i, errmsg,
 				info->first_error == i ? " (First)" : "");
 		else
-			AER_PR(info, dev, "   [%2d] Unknown Error Bit%s\n", i,
+			printk("%s""   [%2d] Unknown Error Bit%s\n", prefix, i,
 				info->first_error == i ? " (First)" : "");
 	}
 }
@@ -181,11 +151,15 @@ static void __aer_print_error(struct aer
 void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 {
 	int id = ((dev->bus->number << 8) | dev->devfn);
+	char prefix[44];
+
+	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
+		 (info->severity == AER_CORRECTABLE) ? KERN_WARNING : KERN_ERR,
+		 dev_driver_string(&dev->dev), dev_name(&dev->dev));
 
 	if (info->status == 0) {
-		AER_PR(info, dev,
-			"PCIe Bus Error: severity=%s, type=Unaccessible, "
-			"id=%04x(Unregistered Agent ID)\n",
+		printk("%s""PCIe Bus Error: severity=%s, type=Unaccessible, "
+			"id=%04x(Unregistered Agent ID)\n", prefix,
 			aer_error_severity_string[info->severity], id);
 	} else {
 		int layer, agent;
@@ -193,23 +167,22 @@ void aer_print_error(struct pci_dev *dev
 		layer = AER_GET_LAYER_ERROR(info->severity, info->status);
 		agent = AER_GET_AGENT(info->severity, info->status);
 
-		AER_PR(info, dev,
-			"PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
-			aer_error_severity_string[info->severity],
+		printk("%s""PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
+			prefix, aer_error_severity_string[info->severity],
 			aer_error_layer[layer], id, aer_agent_string[agent]);
 
-		AER_PR(info, dev,
-			"  device [%04x:%04x] error status/mask=%08x/%08x\n",
-			dev->vendor, dev->device, info->status, info->mask);
+		printk("%s""  device [%04x:%04x] error status/mask=%08x/%08x\n",
+			prefix, dev->vendor, dev->device,
+			info->status, info->mask);
 
-		__aer_print_error(info, dev);
+		__aer_print_error(prefix, info);
 
 		if (info->tlp_header_valid) {
 			unsigned char *tlp = (unsigned char *) &info->tlp;
-			AER_PR(info, dev, "  TLP Header:"
+			printk("%s""  TLP Header:"
 				" %02x%02x%02x%02x %02x%02x%02x%02x"
 				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
-				*(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
+				prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
 				*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
 				*(tlp + 11), *(tlp + 10), *(tlp + 9),
 				*(tlp + 8), *(tlp + 15), *(tlp + 14),
@@ -218,8 +191,8 @@ void aer_print_error(struct pci_dev *dev
 	}
 
 	if (info->id && info->error_dev_num > 1 && info->id == id)
-		AER_PR(info, dev,
-			"  Error of this Agent(%04x) is reported first\n", id);
+		printk("%s""  Error of this Agent(%04x) is reported first\n",
+			prefix, id);
 }
 
 void aer_print_port_info(struct pci_dev *dev, struct aer_err_info *info)
