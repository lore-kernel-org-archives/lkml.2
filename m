Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2LCV0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:26:11 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44334 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2LCV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:26:08 -0500
From: Lance Ortiz <lance.ortiz@hp.com>
Subject: [PATCH v5 3/3] aerdrv: Cleanup log output for CPER based AER
To: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 14:21:00 -0700
Message-ID: <20121203212059.24373.7804.stgit@grignak.americas.hpqcorp.net>
In-Reply-To: <20121203212047.24373.8646.stgit@grignak.americas.hpqcorp.net>
References: <20121203212047.24373.8646.stgit@grignak.americas.hpqcorp.net>
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
and the device's slot location.  From the callers the value of prefix
is never assigned and is NULL, so when cper_print_aer prints data the
initial string does not get printed.  This string is important because
it identifies the device that the error is on.

v1-v2 fix some compile errors withinn the #ifdef
v3-v4 remove agent id stuff and kept print the same to avoid
compatibility issues

Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_errprint.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 34d96e4..58ff4c0 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -228,9 +228,14 @@ void cper_print_aer(struct pci_dev *dev, int cper_severity,
 	int aer_severity, layer, agent, status_strs_size, tlp_header_valid = 0;
 	u32 status, mask;
 	const char **status_strs;
-	char *prefix = NULL;
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

