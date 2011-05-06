Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1EFBGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:06:08 -0400
Received: from kroah.org ([198.145.64.141]:36515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab1EFAYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:05 2011
Message-Id: <20110506002205.455808582@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Donald Dutile <ddutile@redhat.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [004/143] intel-iommu: Unlink domain from iommu
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit a97590e56d0d58e1dd262353f7cbd84e81d8e600 upstream.

When we remove a device, we unlink the iommu from the domain, but
we never do the reverse unlinking of the domain from the iommu.
This means that we never clear iommu->domain_ids, eventually leading
to resource exhaustion if we repeatedly bind and unbind a device
to a driver.  Also free empty domains to avoid a resource leak.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Donald Dutile <ddutile@redhat.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3244,9 +3244,15 @@ static int device_notifier(struct notifi
 	if (!domain)
 		return 0;
 
-	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through)
+	if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
 		domain_remove_one_dev_info(domain, pdev);
 
+		if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) &&
+		    !(domain->flags & DOMAIN_FLAG_STATIC_IDENTITY) &&
+		    list_empty(&domain->devices))
+			domain_exit(domain);
+	}
+
 	return 0;
 }
 
@@ -3393,6 +3399,11 @@ static void domain_remove_one_dev_info(s
 		domain->iommu_count--;
 		domain_update_iommu_cap(domain);
 		spin_unlock_irqrestore(&domain->iommu_lock, tmp_flags);
+
+		spin_lock_irqsave(&iommu->lock, tmp_flags);
+		clear_bit(domain->id, iommu->domain_ids);
+		iommu->domains[domain->id] = NULL;
+		spin_unlock_irqrestore(&iommu->lock, tmp_flags);
 	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);


