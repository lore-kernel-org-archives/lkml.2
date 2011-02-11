Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1BKVZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:25:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1BKVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:25:04 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/2] intel-iommu: Fix get_domain_for_dev() error path
To: dwmw2@infradead.org, iommu@lists.linux-foundation.org
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, ddutile@redhat.com, chrisw@redhat.com
Date: Fri, 11 Feb 2011 14:24:59 -0700
Message-ID: <20110211212452.21983.24518.stgit@s20.home>
In-Reply-To: <20110211211314.21983.83660.stgit@s20.home>
References: <20110211211314.21983.83660.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we run out of domain_ids and fail iommu_attach_domain(), we
fall into domain_exit() without having setup enough of the
domain structure for this to do anything useful.  In fact, it
typically runs off into the weeds walking the bogus domain->devices
list.  Just free the domain.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/intel-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8bc56c1..21690a5 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1835,7 +1835,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
-		domain_exit(domain);
+		free_domain_mem(domain);
 		goto error;
 	}
 

