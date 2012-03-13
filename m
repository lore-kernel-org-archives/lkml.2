Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab2CMAWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:47866 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693Ab2CMAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 089/196] intel-iommu: Fix get_domain_for_dev() error path
Date: Mon, 12 Mar 2012 20:20:02 -0400
Message-Id: <1331598109-31424-44-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2fe9723df8e45fd247782adea244a5e653c30bf4 upstream.

If we run out of domain_ids and fail iommu_attach_domain(), we
fall into domain_exit() without having setup enough of the
domain structure for this to do anything useful.  In fact, it
typically runs off into the weeds walking the bogus domain->devices
list.  Just free the domain.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 62e92e5..2b985b9 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1848,7 +1848,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
-		domain_exit(domain);
+		free_domain_mem(domain);
 		goto error;
 	}
 
-- 
1.7.9.3

