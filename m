Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2LOUnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:43:53 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35103 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2LOUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:43:51 -0500
MIME-Version: 1.0
Date: Sun, 16 Dec 2012 02:13:50 +0530
Message-ID: <CAA_L+UNv8duQfoVjgReOmN3jmwV_icJGayFXB2BE55y8sYwjGQ@mail.gmail.com>
Subject: [PATCH 3.7.0 6/9] i82975x_edac: unmap pcibar after init
From: Arvind R <arvino55@gmail.com>
To: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.7.0 6/9] i82975x_edac: unmap pcibar after init

Remove the unnecessary mapped window in private data structure.
Then the window can be unmapped right after driver initialisation
is done.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2012-12-16 00:09:23.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2012-12-16 00:08:52.000000000 +0530
@@ -205,11 +205,11 @@ NOTE: Only ONE of the three must be enab
 #define I82975X_DRC_CH1M1		0x1A4

 enum i82975x_chips {
-	I82975X = 0,
+	I82975X_chip = 0,
 };

 struct i82975x_pvt {
-	void __iomem *mch_window;
+	enum i82975x_chips chip;
 };

 struct i82975x_dev_info {
@@ -227,7 +227,7 @@ struct i82975x_error_info {
 };

 static const struct i82975x_dev_info i82975x_devs[] = {
-	[I82975X] = {
+	[I82975X_chip] = {
 		.ctl_name = "i82975x"
 	},
 };
@@ -588,7 +588,7 @@ static int i82975x_probe1(struct pci_dev
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
-	pvt->mch_window = mch_window;
+	pvt->chip = dev_idx;
 	i82975x_init_csrows(mci, pdev, mch_window);
 	mci->scrub_mode = SCRUB_HW_SRC;
 	i82975x_get_error_info(mci, &discard);  /* clear counters */
@@ -596,15 +596,13 @@ static int i82975x_probe1(struct pci_dev
 	/* finalize this instance of memory controller with edac core */
 	if (edac_mc_add_mc(mci)) {
 		edac_dbg(0, "MC%d failed add_mc()\n", dev_idx);
-		goto fail2;
+		edac_mc_free(mci);
+		goto fail1;
 	}

 	/* get this far and it's successful */
 	edac_dbg(3, "MC%d success\n", dev_idx);
-	return 0;
-
-fail2:
-	edac_mc_free(mci);
+	rc = 0;

 fail1:
 	iounmap(mch_window);
@@ -632,23 +630,17 @@ static int __devinit i82975x_init_one(st
 static void __devexit i82975x_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
-	struct i82975x_pvt *pvt;

 	mci = edac_mc_del_mc(&pdev->dev);
 	if (mci  == NULL)
 		return;
-
-	pvt = mci->pvt_info;
-	if (pvt->mch_window)
-		iounmap( pvt->mch_window );
-
 	edac_mc_free(mci);
 }

 static DEFINE_PCI_DEVICE_TABLE(i82975x_pci_tbl) = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82975X
+		I82975X_chip
 	},
 	{
 		0,
