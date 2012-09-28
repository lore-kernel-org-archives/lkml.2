Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab2I1N6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:58:40 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13340
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756714Ab2I1N6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:58:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MB2C5F-02-3OL-02
X-M-MSG: 
Date: Fri, 28 Sep 2012 15:58:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Florian Dazinger <florian@dazinger.net>,
        iommu <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120928135824.GB4009@amd.com>
References: <20120924210348.5f50677b@brain.lan>
 <1348597970.28860.114.camel@bling.home>
 <20120925205420.0a07dea2@brain.lan>
 <1348602226.28860.132.camel@bling.home>
 <20120926132050.GB10549@amd.com>
 <1348670159.28860.183.camel@bling.home>
 <20120926151044.GE10549@amd.com>
 <1348676470.28860.197.camel@bling.home>
 <1348689013.28860.220.camel@bling.home>
 <1348697043.28860.235.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348697043.28860.235.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 04:04:03PM -0600, Alex Williamson wrote:

> Here's a lockdep clean version of it:
> 
> amd_iommu: Handle aliases not backed by devices
> 
> Aliases sometimes don't have a struct pci_dev backing them.  This breaks
> our attempt to figure out the topology and device quirks that may effect
> IOMMU grouping.  When this happens, allocate an IOMMU group on the
> dev_data for the alias and make use of it for all devices referencing
> this alias.

Yes, this is the real fix. But it is too big for v3.6 at this time, so
I'll would take this for 3.7 and use my small fix for 3.6.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index b64502d..4eacb17 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -71,6 +71,7 @@ static DEFINE_SPINLOCK(iommu_pd_list_lock);
>  /* List of all available dev_data structures */
>  static LIST_HEAD(dev_data_list);
>  static DEFINE_SPINLOCK(dev_data_list_lock);
> +static DEFINE_MUTEX(dev_data_iommu_group_lock);

I think this lock is not necessary. The iommu_init_device routine does
not run multiple times in parallel for the same device. So we should be
safe on that side.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

