Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0CQRfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:35:11 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:2037 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab0CQRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:35:06 -0400
Subject: [PATCH 2/3] hpet: pass physical address, not entire hpet_data,
	to hpet_is_known()
To: Clemens Ladisch <clemens@ladisch.de>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org,
       "Venkatesh Pallipadi \(Venki\)" <venkatesh.pallipadi@intel.com>
Date: Wed, 17 Mar 2010 11:35:05 -0600
Message-ID: <20100317173505.31124.74595.stgit@bob.kio>
In-Reply-To: <20100317173329.31124.69795.stgit@bob.kio>
References: <20100317173329.31124.69795.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; hpet_is_known() only needs the physical address,
so supplying that instead of the whole struct hpet_data makes the callers
a little simpler.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/char/hpet.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 65a9aa8..4c508df 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -662,12 +662,12 @@ static const struct file_operations hpet_fops = {
 	.mmap = hpet_mmap,
 };
 
-static int hpet_is_known(struct hpet_data *hdp)
+static int hpet_is_known(unsigned long phys_address)
 {
 	struct hpets *hpetp;
 
 	for (hpetp = hpets; hpetp; hpetp = hpetp->hp_next)
-		if (hpetp->hp_hpet_phys == hdp->hd_phys_address)
+		if (hpetp->hp_hpet_phys == phys_address)
 			return 1;
 
 	return 0;
@@ -788,7 +788,7 @@ int hpet_alloc(struct hpet_data *hdp)
 	 * If platform dependent code has allocated the hpet that
 	 * ACPI has also reported, then we catch it here.
 	 */
-	if (hpet_is_known(hdp)) {
+	if (hpet_is_known(hdp->hd_phys_address)) {
 		printk(KERN_DEBUG "%s: duplicate HPET ignored\n",
 			__func__);
 		return 0;
@@ -911,9 +911,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	if (!mem)
 		return -ENODEV;
 
-	data.hd_phys_address = mem->start;
-
-	if (hpet_is_known(&data))
+	if (hpet_is_known(mem->start))
 		return -EBUSY;
 
 	i = 0;
@@ -925,6 +923,7 @@ static int hpet_pnp_add(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	if (!data.hd_nirqs)
 		return -ENODEV;
 
+	data.hd_phys_address = mem->start;
 	data.hd_address = ioremap(mem->start, resource_size(mem));
 
 	return hpet_alloc(&data);

