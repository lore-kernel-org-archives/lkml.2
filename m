Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab0GBJf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:35:59 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:29165 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab0GBJf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:35:57 -0400
X-SpamScore: -36
X-BigFish: VPS-36(z21eRz1432N98dN936eMzz1202hzz15d4Rz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L4XBKJ-02-1YS-02
X-M-MSG: 
Date: Fri, 2 Jul 2010 11:26:46 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Tom Lyon <pugs@cisco.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "mst@redhat.com" <mst@redhat.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "aafabbri@cisco.com" <aafabbri@cisco.com>,
       "scofeldm@cisco.com" <scofeldm@cisco.com>
Subject: Re: [PATCH V2] 2.6.34: simple IOMMU API extension to check safe
 interrupt remapping
Message-ID: <20100702092646.GF24084@amd.com>
References: <4c2d0790.Bi9FugC8c/QW1Ike%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c2d0790.Bi9FugC8c/QW1Ike%pugs@cisco.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:24:32PM -0400, Tom Lyon wrote:
> This patch allows IOMMU users to determine whether the hardware and software
> support safe, isolated interrupt remapping.  Not all Intel IOMMUs have the
> hardware, and the software for AMD is not there yet.
> 	Signed-off-by: Tom Lyon <pugs@cisco.com>

It does not make a lot of sense to check for this feature in the
IOMMU-API currently because there is no support for intr-remapping in
there. But it will be there when intr-remapping support for AMD IOMMU is
implemented. So this change can be considered as a first step in that
direction. Please repost with the change requested below an I'll add
this one to my tree.

> Version 2: previous ifdefs not needed.
> 
> MST has convinced me that any user level driver for PCI master devices can't 
> be safe unless there is an IOMMU protecting the APIC MSI/MSI-X interrupt 
> addresses from device writes.  This interrupt remapping is not present in all
> Intel IOMMUs and the code for the interrupt mapping in the AMD IOMMUs is not
> implemented yet.
> 
> Needed by not-yet-accepted VFIO driver.
> 
> diff -uprN linux-2.6.34/drivers/pci/intel-iommu.c iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c
> --- linux-2.6.34/drivers/pci/intel-iommu.c	2010-05-16 14:17:36.000000000 -0700
> +++ iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c	2010-06-30 15:47:10.000000000 -0700
> @@ -3705,6 +3705,10 @@ static int intel_iommu_domain_has_cap(st
>  
>  	if (cap == IOMMU_CAP_CACHE_COHERENCY)
>  		return dmar_domain->iommu_snooping;
> +	if (cap == IOMMU_CAP_SAFE_INTR_REMAP)
> +		return intr_remapping_enabled;
>  
>  	return 0;
>  }
> diff -uprN linux-2.6.34/include/linux/iommu.h iommuapi-linux-2.6.34/include/linux/iommu.h
> --- linux-2.6.34/include/linux/iommu.h	2010-05-16 14:17:36.000000000 -0700
> +++ iommuapi-linux-2.6.34/include/linux/iommu.h	2010-06-30 15:47:34.000000000 -0700
> @@ -30,6 +30,7 @@ struct iommu_domain {
>  };
>  
>  #define IOMMU_CAP_CACHE_COHERENCY	0x1
> +#define IOMMU_CAP_SAFE_INTR_REMAP	0x2	/* isolates device intrs */

I think the SAFE_ is not necessary in the name. It is misleading because
it indicates that there is an unsafe variant of intr-remapping available
when this capability is not set. Just call it IOMMU_CAP_INTR_REMAPPING.


	Joerg

-- 
Joerg Roedel - AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

