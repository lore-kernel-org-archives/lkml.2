Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031773Ab2K3UpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:45:11 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:26811 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030302Ab2K3UpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:45:08 -0500
From: Lance Ortiz <lance.ortiz@hp.com>
Subject: [PATCH v2 3/3] aerdrv: Cleanup log output for CPER based AER
To: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 13:40:05 -0700
Message-ID: <20121130204005.31945.49964.stgit@grignak.americas.hpqcorp.net>
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
index 34d96e4..5050891 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -228,9 +228,15 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
 	u32 status, mask;
 	const char **status_strs;
-	char *prefix = NULL;
+	int id = ((dev->bus->number << 8) | dev->devfn);
+	char prefix[44];
 
 	aer_severity = cper_severity_to_aer(cper_severity);
+	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
+		(aer_severity == AER_CORRECTABLE) ?
+		KERN_WARNING : KERN_ERR,
+		dev_driver_string(&dev->dev), dev_name(&dev->dev));
+
 	if (aer_severity == AER_CORRECTABLE) {
 		status = aer->cor_status;
 		mask = aer->cor_mask;
@@ -248,8 +254,8 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
 	       prefix, status, mask);
 	cper_print_bits(prefix, status, status_strs, status_strs_size);
-	printk("%s""aer_layer=%s, aer_agent=%s\n", prefix,
-	       aer_error_layer[layer], aer_agent_string[agent]);
+	printk("%s""aer_layer=%s, id=%04x(%s)\n", prefix,
+	       aer_error_layer[layer], id, aer_agent_string[agent]);
 	if (aer_severity != AER_CORRECTABLE)
 		printk("%s""aer_uncor_severity: 0x%08x\n",
 		       prefix, aer->uncor_severity);

