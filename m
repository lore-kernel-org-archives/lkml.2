Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0IRTBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:10 -0400
Received: from kroah.org ([198.145.64.141]:51064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab0IRTBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:08 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:52 2010
Message-Id: <20100918185952.886135496@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rudolf Marek <r.marek@assembler.cz>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [001/123] hwmon: (k8temp) Differentiate between AM2 and ASB1
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=hwmon-k8temp-differentiate-between-am2-and-asb1.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/k8temp.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -143,6 +143,37 @@ static struct pci_device_id k8temp_ids[]
 
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
@@ -179,9 +210,7 @@ static int __devinit k8temp_probe(struct
 				 "wrong - check erratum #141\n");
 		}
 
-		if ((model >= 0x69) &&
-		    !(model == 0xc1 || model == 0x6c || model == 0x7c ||
-		      model == 0x6b || model == 0x6f || model == 0x7f)) {
+		if (is_rev_g_desktop(model)) {
 			/*
 			 * RevG desktop CPUs (i.e. no socket S1G1 or
 			 * ASB1 parts) need additional offset,


