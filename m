Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1FPHAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:53462 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab1FPHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:05 -0400
X-Sasl-enc: FLRgi/9Q/s0EOFO+64FYkY8N1S/3IM08d5GfEfXCsTMd 1308207604
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.296909765@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [03/89] intel-iommu: Only unlink device domains from iommu
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 9b4554b21ed07e8556405510638171f0c787742a upstream.

Commit a97590e5 added unlinking domains from iommus to reciprocate the
iommu from domains unlinking that was already done.  We actually want
to only do this for device domains and never for the static
identity map domain or VM domains.  The SI domain is special and
never freed, while VM domain->id lives in their own special address
space, separate from iommu->domain_ids.

In the current code, a VM can get domain->id zero, then mark that
domain unused when unbound from pci-stub.  This leads to DMAR
write faults when the device is re-bound to the host driver.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3422,10 +3422,13 @@ static void domain_remove_one_dev_info(s
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
 
-		spin_lock_irqsave(&iommu->lock, tmp_flags);
-		clear_bit(domain->id, iommu->domain_ids);
-		iommu->domains[domain->id] = NULL;
-		spin_unlock_irqrestore(&iommu->lock, tmp_flags);
+		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY)) {
+			spin_lock_irqsave(&iommu->lock, tmp_flags);
+			clear_bit(domain->id, iommu->domain_ids);
+			iommu->domains[domain->id] = NULL;
+			spin_unlock_irqrestore(&iommu->lock, tmp_flags);
+		}
 	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);


