Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1CaAd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 20:33:57 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49504 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755236Ab1CaAdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 20:33:55 -0400
Message-ID: <4D93CBEE.5020201@sgi.com>
Date: Wed, 30 Mar 2011 17:33:50 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Intel iommu: Speed up processing of the identity_mapping
 function v2
References: <20110329233602.272459647@gulag1.americas.sgi.com> <20110329233602.585251738@gulag1.americas.sgi.com> <20110330191902.GT18712@sequoia.sous-sol.org>
In-Reply-To: <20110330191902.GT18712@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Intel iommu: Speed up processing of the identity_mapping function

    When there are a large count of PCI devices, and the pass
    through option for iommu is set, much time is spent in the
    identity_mapping function hunting though the iommu domains to
    check if a specific device is "identity mapped".

    Speed up the function by checking the cached info to see if
    it's mapped to the static identity domain.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/pci/intel-iommu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/drivers/pci/intel-iommu.c
+++ linux-2.6.32/drivers/pci/intel-iommu.c
@@ -2124,10 +2124,10 @@ static int identity_mapping(struct pci_d
 	if (likely(!iommu_identity_mapping))
 		return 0;
 
+	info = pdev->dev.archdata.iommu;
+	if (info && info != DUMMY_DEVICE_DOMAIN_INFO)
+		return (info->domain == si_domain);
 
-	list_for_each_entry(info, &si_domain->devices, link)
-		if (info->dev == pdev)
-			return 1;
 	return 0;
 }
 

