Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1ABIEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:04:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:34691 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1ABHWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Rudolf Marek <r.marek@assembler.cz>, Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 029/260] hwmon: (k8temp) Differentiate between AM2 and ASB1
Date: Sun,  2 Jan 2011 02:15:25 -0500
Message-Id: <1293952756-15010-30-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:37.0866 (UTC) FILETIME=[8DD0B4A0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit a05e93f3b3fc2f53c1d0de3b17019e207c482349 upstream.

Commit 8bf0223ed515be24de0c671eedaff49e78bebc9c (hwmon, k8temp: Fix
temperature reporting for ASB1 processor revisions) fixed temperature
reporting for ASB1 CPUs. But those CPU models (model 0x6b, 0x6f, 0x7f)
were packaged both as AM2 (desktop) and ASB1 (mobile). Thus the commit
leads to wrong temperature reporting for AM2 CPU parts.

The solution is to determine the package type for models 0x6b, 0x6f,
0x7f.

This is done using BrandId from CPUID Fn8000_0001_EBX[15:0]. See
"Constructing the processor Name String" in "Revision Guide for AMD
NPT Family 0Fh Processors" (Rev. 3.46).

Cc: Rudolf Marek <r.marek@assembler.cz>
Reported-by: Vladislav Guberinic <neosisani@gmail.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/k8temp.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index 8bdf80d..8364932 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -143,6 +143,37 @@ static const struct pci_device_id k8temp_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, k8temp_ids);
 
+static int __devinit is_rev_g_desktop(u8 model)
+{
+	u32 brandidx;
+
+	if (model < 0x69)
+		return 0;
+
+	if (model == 0xc1 || model == 0x6c || model == 0x7c)
+		return 0;
+
+	/*
+	 * Differentiate between AM2 and ASB1.
+	 * See "Constructing the processor Name String" in "Revision
+	 * Guide for AMD NPT Family 0Fh Processors" (33610).
+	 */
+	brandidx = cpuid_ebx(0x80000001);
+	brandidx = (brandidx >> 9) & 0x1f;
+
+	/* Single core */
+	if ((model == 0x6f || model == 0x7f) &&
+	    (brandidx == 0x7 || brandidx == 0x9 || brandidx == 0xc))
+		return 0;
+
+	/* Dual core */
+	if (model == 0x6b &&
+	    (brandidx == 0xb || brandidx == 0xc))
+		return 0;
+
+	return 1;
+}
+
 static int __devinit k8temp_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
@@ -179,9 +210,7 @@ static int __devinit k8temp_probe(struct pci_dev *pdev,
 				 "wrong - check erratum #141\n");
 		}
 
-		if ((model >= 0x69) &&
-		    !(model == 0xc1 || model == 0x6c || model == 0x7c ||
-		      model == 0x6b || model == 0x6f || model == 0x7f)) {
+		if (is_rev_g_desktop(model)) {
 			/*
 			 * RevG desktop CPUs (i.e. no socket S1G1 or
 			 * ASB1 parts) need additional offset,
-- 
1.7.3.3

