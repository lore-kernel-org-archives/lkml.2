Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2K2V76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:59:58 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:32322 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2K2V74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:59:56 -0500
From: Lance Ortiz <lance.ortiz@hp.com>
Subject: [PATCH 3/3] aerdrv: Cleanup log output for CPER based AER
To: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 14:54:56 -0700
Message-ID: <20121129215456.5483.27026.stgit@grignak.americas.hpqcorp.net>
In-Reply-To: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes make cper_print_aer more consistent with aer_print_error
which is called in the AER interrupt case. The string in the variable
'prefix' is printed at the beginning of each print statement in
cper_print_aer(). The prefix is a string containing the driver name
and the device's path.  Looking up the call path, the value of prefix
is never assigned and is NULL, so when cper_print_aer prints data the
initial string does not get printed.  This string is important because
it identifies the device that the error is on. This patch adds code to
create the prefix and print it in the cper_print_aer function. This
patch also calculates the device's agent id so it can be printed.

Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_errprint.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 6354e50..bc0a091 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -229,7 +229,13 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
 	u32 status, mask;
 	const char **status_strs;
-	char *prefix = NULL;
+	int id = ((dev->bus->number << 8) | dev->devfn);
+	char prefix[44];
+
+	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
+		(info->severity == AER_CORRECTABLE) ?
+		KERN_WARNING : KERN_ERR,
+		dev_driver_string(&dev->dev), dev_name(&dev->dev));
 
 	aer_severity = cper_severity_to_aer(cper_severity);
 	if (aer_severity == AER_CORRECTABLE) {
@@ -249,8 +255,8 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
 	       prefix, status, mask);
 	cper_print_bits(prefix, status, status_strs, status_strs_size);
-	printk("%s""aer_layer=%s, aer_agent=%s\n", prefix,
-	       aer_error_layer[layer], aer_agent_string[agent]);
+	printk("%s""aer_layer=%s, %d=%04x(%s)\n", prefix,
+	       aer_error_layer[layer], id, aer_agent_string[agent]);
 	if (aer_severity != AER_CORRECTABLE)
 		printk("%s""aer_uncor_severity: 0x%08x\n",
 		       prefix, aer->uncor_severity);

