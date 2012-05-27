Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453Ab2E0BNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:13:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965428Ab2E0BM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:12:59 -0400
Message-Id: <20120527010436.030362554@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xudong Hao <xudong.hao@intel.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Chris Wright <chrisw@sous-sol.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 87/94] intel-iommu: Add device info into list before doing context mapping
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit e2ad23d04c1304431ab5176c89b7b476ded2d995 upstream.

Add device info into list before doing context mapping, because device
info will be used by iommu_enable_dev_iotlb(). Without it, ATS won't get
enabled as it should be.

ATS, while a dubious decision from a security point of view, can be very
important for performance.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2280,12 +2280,6 @@ static int domain_add_dev_info(struct dm
 	if (!info)
 		return -ENOMEM;
 
-	ret = domain_context_mapping(domain, pdev, translation);
-	if (ret) {
-		free_devinfo_mem(info);
-		return ret;
-	}
-
 	info->segment = pci_domain_nr(pdev->bus);
 	info->bus = pdev->bus->number;
 	info->devfn = pdev->devfn;
@@ -2298,6 +2292,17 @@ static int domain_add_dev_info(struct dm
 	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	ret = domain_context_mapping(domain, pdev, translation);
+	if (ret) {
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_del(&info->link);
+		list_del(&info->global);
+		pdev->dev.archdata.iommu = NULL;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		free_devinfo_mem(info);
+		return ret;
+	}
+
 	return 0;
 }
 


