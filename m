Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2GXOQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:16:11 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:64686
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab2GXOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:16:10 -0400
X-IronPort-AV: E=Sophos;i="4.77,646,1336341600"; 
   d="scan'208";a="151568300"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH] drivers/iommu/intel-iommu.c: add missing free_domain_mem
Date: Tue, 24 Jul 2012 16:16:04 +0200
Message-Id: <1343139364-26936-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add missing free_domain_mem on failure path after alloc_domain.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@km exists@
local idexpression e;
expression e1,e2,e3;
type T,T1;
identifier f;
@@

* e = alloc_domain(...)
... when any
    when != e = e1
    when != e1 = (T)e
    when != e1(...,(T)e,...)
    when != &e->f
if(...) { ... when != e2(...,(T1)e,...)
                 when != e3 = e
                 when forall
(
             return <+...e...+>;
|
*             return ...;
) }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/iommu/intel-iommu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 7469b53..0204b62 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2008,6 +2008,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	if (!drhd) {
 		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
 			pci_name(pdev));
+		free_domain_mem(domain);
 		return NULL;
 	}
 	iommu = drhd->iommu;

