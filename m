Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1DZVVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:21:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:1330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab1DZVO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748879"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: alex.williamson@redhat.com, ddutile@redhat.com, David.Woodhouse@intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [87/106] intel-iommu: Fix get_domain_for_dev() error path
Message-Id: <20110426211409.43AE13E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Williamson <alex.williamson@redhat.com>

commit 2fe9723df8e45fd247782adea244a5e653c30bf4 upstream.

If we run out of domain_ids and fail iommu_attach_domain(), we
fall into domain_exit() without having setup enough of the
domain structure for this to do anything useful.  In fact, it
typically runs off into the weeds walking the bogus domain->devices
list.  Just free the domain.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/pci/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/intel-iommu.c
+++ linux-2.6.35.y/drivers/pci/intel-iommu.c
@@ -1835,7 +1835,7 @@ static struct dmar_domain *get_domain_fo
 
 	ret = iommu_attach_domain(domain, iommu);
 	if (ret) {
-		domain_exit(domain);
+		free_domain_mem(domain);
 		goto error;
 	}
 
