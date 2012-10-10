Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2JJNcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:32:54 -0400
Received: from 8bytes.org ([85.214.48.195]:33626 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2JJNcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:32:51 -0400
Date: Wed, 10 Oct 2012 15:32:49 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Oakley <andrew@ado.is-a-geek.net>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] IOMMU Updates for v3.7-rc1
Message-ID: <20121010133249.GC16151@8bytes.org>
References: <20121005152312.GA4649@8bytes.org>
 <20121009224532.1e515664@ado-amd-gentoo.moore.slainvet.net>
 <20121010073022.GB16151@8bytes.org>
 <20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010095823.140fdd98@ado-amd-gentoo.moore.slainvet.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Oct 10 15:32:50 2012
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5075790222978377910210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 09:58:23AM +0100, Andrew Oakley wrote:
> On Wed, 10 Oct 2012 09:30:22 +0200
> Joerg Roedel <joro@8bytes.org> wrote:

> AMD-Vi:   DEV_SPECIAL(IOAPIC[2])		devid: 00:00.1

Okay, got it. This is the problem. The device id seems to be wrong. The
BIOS should configure your IOAPIC as device id 00:14.0 and not 00:00.1.
The current checking code does not check for this particular situation.
But the attached diff should change that. Can you please test it and
reports if the machine boots for you? Interrupt remapping will be
disabled automatically, though.

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 18b0d99..81837b0 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1599,21 +1599,46 @@ static void __init free_on_init_error(void)
 #endif
 }
 
+/* SB IOAPIC is always on this device in AMD systems */
+#define IOAPIC_SB_DEVID		((0x00 << 8) | PCI_DEVFN(0x14, 0))
+
 static bool __init check_ioapic_information(void)
 {
+	bool ret, has_sb_ioapic;
 	int idx;
 
-	for (idx = 0; idx < nr_ioapics; idx++) {
-		int id = mpc_ioapic_id(idx);
+	has_sb_ioapic = false;
+	ret           = false;
 
-		if (get_ioapic_devid(id) < 0) {
-			pr_err(FW_BUG "AMD-Vi: IO-APIC[%d] not in IVRS table\n", id);
-			pr_err("AMD-Vi: Disabling interrupt remapping due to BIOS Bug\n");
-			return false;
+	for (idx = 0; idx < nr_ioapics; idx++) {
+		int devid, id = mpc_ioapic_id(idx);
+
+		devid = get_ioapic_devid(id);
+		if (devid < 0) {
+			pr_err(FW_BUG "AMD-Vi: IOAPIC[%d] not in IVRS table\n", id);
+			ret = false;
+		} else if (devid == IOAPIC_SB_DEVID) {
+			has_sb_ioapic = true;
+			ret           = true;
 		}
 	}
 
-	return true;
+	if (!has_sb_ioapic) {
+		/*
+		 * We expect the SB IOAPIC to be listed in the IVRS
+		 * table. The system timer is connected to the SB IOAPIC
+		 * and if we don't have it in the list the system will
+		 * panic at boot time.  This situation usually happens
+		 * when the BIOS is buggy and provides us the wrong
+		 * device id for the IOAPIC in the system.
+		 */
+		pr_err(FW_BUG "AMD-Vi: No southbridge IOAPIC found in IVRS table\n");
+	}
+
+	if (!ret)
+		pr_err("AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)\n");
+
+	return ret;
 }
 
 static void __init free_dma_resources(void)

