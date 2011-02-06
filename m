Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1BFUMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:12:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21741 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1BFUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:12:49 -0500
Date: Sun, 6 Feb 2011 21:11:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, Ashok Raj <ashok.raj@intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH][RFC] Intel IOMMU: get_domain_for_dev() leaks a bit of mem
 if dmar_find_matched_drhd_unit() fails.
Message-ID: <alpine.LNX.2.00.1102062102390.13593@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe that there's a small memory leak in 
drivers/pci/intel-iommu.c:get_domain_for_dev().

If the call to alloc_domain() succeeds but the subsequent call to 
dmar_find_matched_drhd_unit() fails, then the current code will return 
NULL without calling domain_exit(domain) which will leak the memory that 
alloc_domain() allocated.

The easy fix for that is to simply move the call to alloc_domain() below 
the call to dmar_find_matched_drhd_unit() since the latter does not depend 
on the former.

I also made the change of moving the assignment to local variable 'iommu' 
below both calls since there is no point in doing that work if either of 
those those calls fail.

I also changed the 'return NULL' in the dmar_find_matched_drhd_unit() 
failure case to a 'goto error' since I figured that if rechecking 
'find_domain(pdev)' makes sense after a alloc_domain() failure then it 
would also make sense after a dmar_find_matched_drhd_unit() failure.

Patch is only compile tested and I'm not very familliar with this code at 
all, so please review carefully before applying and please feel free to 
provide feedback if this patch is somehow not making sense.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 intel-iommu.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4789f8e..dfbdb08 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1820,19 +1820,18 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		}
 	}
 
-	domain = alloc_domain();
-	if (!domain)
-		goto error;
-
 	/* Allocate new domain for the device */
 	drhd = dmar_find_matched_drhd_unit(pdev);
 	if (!drhd) {
 		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
 			pci_name(pdev));
-		return NULL;
+		goto error;
 	}
-	iommu = drhd->iommu;
+	domain = alloc_domain();
+	if (!domain)
+		goto error;
 
+	iommu = drhd->iommu;
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
 		domain_exit(domain);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

