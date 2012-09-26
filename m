Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2IZOn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:43:57 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:12810
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab2IZOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:43:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dId6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAYOWZ-02-2VC-02
X-M-MSG: 
Date: Wed, 26 Sep 2012 16:43:45 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Florian Dazinger <florian@dazinger.net>
CC: Alex Williamson <alex.williamson@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120926144345.GC10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
 <1348597970.28860.114.camel@bling.home>
 <20120925205420.0a07dea2@brain.lan>
 <1348602226.28860.132.camel@bling.home>
 <20120926010154.49cc2588@brain.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120926010154.49cc2588@brain.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian,

On Wed, Sep 26, 2012 at 01:01:54AM +0200, Florian Dazinger wrote:
> you're right, either "amd_iommu=off" or removing the audio card makes
> the failure disappear. I will test the new BIOS rev. tomorrow.

Can you please test this diff and report if it fixes the problem for
you?

Thanks.

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index b64502d..e89daf1 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -266,7 +266,7 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
 
 static int iommu_init_device(struct device *dev)
 {
-	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
+	struct pci_dev *dma_pdev = NULL, *pdev = to_pci_dev(dev);
 	struct iommu_dev_data *dev_data;
 	struct iommu_group *group;
 	u16 alias;
@@ -293,7 +293,9 @@ static int iommu_init_device(struct device *dev)
 		dev_data->alias_data = alias_data;
 
 		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
-	} else
+	}
+
+	if (dma_pdev == NULL)
 		dma_pdev = pci_dev_get(pdev);
 
 	/* Account for quirked devices */

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

