Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2HFMUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:20:53 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:45423
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab2HFMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:20:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI179dNzz1202hzz8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M8C2AM-01-3SL-02
X-M-MSG: 
Date: Mon, 6 Aug 2012 14:20:53 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <linux-pci@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>
Subject: Re: [PATCH 0/2] Fix ACS path checking
Message-ID: <20120806122053.GL1996@amd.com>
References: <20120804180155.6144.83332.stgit@bling.home>
 <20120806105010.GK1996@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120806105010.GK1996@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 12:50:10PM +0200, Joerg Roedel wrote:
> On Sat, Aug 04, 2012 at 12:08:46PM -0600, Alex Williamson wrote:
> Hmm, tried it here, At least pci_request_acs() still gets called. How do
> you detect if ACS is really enabled?

Okay, I found a problem. pci_request_acs needs to be called before PCI
probing. Does the attached patch help?

>From 87a4363be30d5d015a984a60769f29b0607fc5fb Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 6 Aug 2012 14:18:42 +0200
Subject: [PATCH] iommu/amd: Fix pci_request_acs() call-place

The pci_request_acs() function needs to be called before PCI
probing to be effective. So move it to another call-place to
ensure that.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 500e7f1..0a2ea31 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1131,9 +1131,6 @@ static int __init amd_iommu_init_pci(void)
 			break;
 	}
 
-	/* Make sure ACS will be enabled */
-	pci_request_acs();
-
 	ret = amd_iommu_init_devices();
 
 	print_iommu_info();
@@ -1652,6 +1649,9 @@ static bool detect_ivrs(void)
 
 	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
 
+	/* Make sure ACS will be enabled during PCI probe */
+	pci_request_acs();
+
 	return true;
 }
 
-- 
1.7.9.5


