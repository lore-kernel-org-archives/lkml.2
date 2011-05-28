Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1E1SQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:16:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33865 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755332Ab1E1SPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:06 -0400
Message-Id: <20110528181502.896824782@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:08 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Intel pci: Provide option to enable 64-bit IOMMU pass through mode
Content-Disposition: inline; filename=indicate-iommu-fixed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Use kernel option to implement pass through mode based on this
feedback from David Woodhouse <dwmw2@infradead.org>:

	Alternatively, let your version check just be '>=2.6.40', and
	your backports to the archaeological trees can include a *new*
	kernel command line parameter like 'iommu=pt64' which unfixed
	kernels won't understand and will ignore. So your SCU will provide
	'iommu=pt' for 2.6.40 or newer, and 'iommu=pt64' for older
	kernels. Then at least your hack doesn't affect the *current*
	kernels, and will eventually be lost in the mists of time.

    Prior to these IOMMU patches, the pass through option could not
    be used because it would cause the kernel to panic in certain
    circumstances (primarily having devices with more than 32 bits of
    DMA addressing, but not enough to handle the system's address range).
    In addition, the "force double address cycle" was required to work
    around similar issues which causes a significant reduction in DMA
    performance.

    This patch provides an option to enable the 64bit pass through mode if
    the kernel has the capability of enabling that mode without panicing.
    It also disables "forcedac" unless that option follows the "pt64" option.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: stable@kernel.org
---
 Documentation/kernel-parameters.txt |    8 +++++++-
 drivers/pci/intel-iommu.c           |    5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -988,13 +988,19 @@ bytes respectively. Such letter suffixes
 			bypassed by not enabling DMAR with this option. In
 			this case, gfx device will use physical address for
 			DMA.
+		pt64 [Default Off]
+			Enable 64 bit pass through mode if the kernel has the
+			capability.  Also disables forcedac, unless that option
+			follows this option.
 		forcedac [x86_64]
 			With this option iommu will not optimize to look
 			for io virtual address below 32 bit forcing dual
 			address cycle on pci bus for cards supporting greater
 			than 32 bit addressing. The default is to look
 			for translation below 32 bit and if not available
-			then look in the higher range.
+			then look in the higher range.  Note that pt64 disables
+			this option, so this must follow that option to be
+			effective.
 		strict [Default Off]
 			With this option on every unmap_single operation will
 			result in a hardware IOTLB flush operation as opposed
--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -419,6 +419,11 @@ static int __init intel_iommu_setup(char
 			printk(KERN_INFO
 				"Intel-IOMMU: disable batched IOTLB flush\n");
 			intel_iommu_strict = 1;
+		} else if (!strncmp(str, "pt64", 6)) {
+			pr_info("Intel-IOMMU: enable 64bit passthrough mode, "
+				"disable Forcing DAC for PCI devices\n");
+			iommu_pass_through = 1;
+			dmar_forcedac = 0;
 		}
 
 		str += strcspn(str, ",");

-- 
