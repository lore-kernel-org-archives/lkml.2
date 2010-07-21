Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0GURNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:13:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:33334 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab0GURNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:13:34 -0400
Subject: Re: swiotlb detection should be memory hotplug aware ?
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>
In-Reply-To: <20100721135750Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100316124556.GA25340@phenom.dumpdata.com>
	 <1268866113.20507.26.camel@ank32>
	 <1279664097.21596.43.camel@ank32.eng.vmware.com>
	 <20100721135750Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 21 Jul 2010 10:13:34 -0700
Message-Id: <1279732414.10874.6.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2010-07-20 at 21:58 -0700, FUJITA Tomonori wrote:
> On Tue, 20 Jul 2010 15:14:57 -0700
> Alok Kataria <akataria@vmware.com> wrote:
> 
> > Reviving a 4 month old thread. 
> > I am still waiting for any clues on this question below. 
> 
> Basically, you want to add hot-plug memory and enable swiotlb, right?

Not really, I am planning to do something like this, 

@@ -52,7 +52,7 @@ int __init pci_swiotlb_detect(void)
 
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
 #ifdef CONFIG_X86_64
-	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
+	if (!no_iommu && (max_pfn > MAX_DMA32_PFN || hotplug_possible()))
 		swiotlb = 1;
 #endif
 	if (swiotlb_force)

BUT, I don't know how that hotplug_possible function will look like or
if such an interface already exists in the kernel (my search didn't turn
up any) ?

IMO, it should be possible to go read the SRAT to see if this system has
support for hotplug memory and then enable swiotlb if it does.

Sounds right ?

Thanks,
Alok

> 
> We can't start swiotlb reliably after a system starts.
> 
> See dma32_reserve_boatmen() and dma32_free_bootmem(). What we do is
> reserving huge memory in DMA32 zone for swiotlb and releasing it if we
> find that we don't need swiotlb. We can't find enough memory for
> swiotlb in dma32 after a system starts.

