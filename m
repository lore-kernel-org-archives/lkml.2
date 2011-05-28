Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1E1SPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:15:14 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38241 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755255Ab1E1SPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:05 -0400
Message-Id: <20110528181502.763327319@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:07 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Intel pci: Add domain check in domain_remove_one_dev_info
Content-Disposition: inline; filename=fix-domain_remove_one_dev_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The comment in domain_remove_one_dev_info() states "No need
	to compare PCI domain; it has to be the same".	But for the
	si_domain that isn't going to be true, as it consists of all the
	PCI devices that are identity mapped thus multiple PCI domains can
	be in si_domain.  The code needs to validate the PCI domain too.

From: Mike Habeck <habeck@sgi.com>
Signed-off-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: stable@kernel.org
---
 drivers/pci/intel-iommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -3395,8 +3395,8 @@ static void domain_remove_one_dev_info(s
 	spin_lock_irqsave(&device_domain_lock, flags);
 	list_for_each_safe(entry, tmp, &domain->devices) {
 		info = list_entry(entry, struct device_domain_info, link);
-		/* No need to compare PCI domain; it has to be the same */
-		if (info->bus == pdev->bus->number &&
+		if (info->segment == pci_domain_nr(pdev->bus) &&
+		    info->bus == pdev->bus->number &&
 		    info->devfn == pdev->devfn) {
 			list_del(&info->link);
 			list_del(&info->global);

-- 
