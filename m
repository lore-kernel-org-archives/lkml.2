Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0F3Vou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:44:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:43586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0F3Vot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,515,1272870000"; 
   d="scan'208";a="294954171"
Message-ID: <4C2BBACF.3080405@intel.com>
Date: Wed, 30 Jun 2010 14:44:47 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	 <4C29420D.2010406@intel.com>	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	 <4C2A8879.8010000@intel.com>	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>	 <4C2AC55E.3040303@intel.com>	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>	 <1277923422.16256.8.camel@localhost>  <4C2B9DAC.1030806@intel.com> <1277928125.18854.0.camel@localhost>
In-Reply-To: <1277928125.18854.0.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2010 1:02 PM, Woodhouse, David wrote:
> On Wed, 2010-06-30 at 20:40 +0100, Williams, Dan J wrote:
>>    From the dmesg:
>>> IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
>>> DMAR: DRHD base: 0x000000fe714000 flags: 0x0
>>> IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
>>> DMAR: DRHD base: 0x000000fe719000 flags: 0x0
>>> IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
>>> DMAR: DRHD base: 0x000000fe718000 flags: 0x1
>>> IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01
>>
>> Where we expect bit 54 to be set for the DMA iommu, and it does not
>> appear to show up.
>
> So the BIOS is lying to us about which PCI devices are attached to which
> IOMMU?
>

It certainly looks that way, or it is at least ignoring any iommu that 
is not associated with a root port.  I have a supermicro x7dwn+ board 
here with the same 5400 series chipset that "does the right thing (TM)":

> [    0.052101] DMAR: Host address width 38
> [    0.053004] DMAR: DRHD base: 0x000000fe710000 flags: 0x0
> [    0.054008] IOMMU fe710000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.055003] DMAR: DRHD base: 0x000000fe712000 flags: 0x0
> [    0.056012] IOMMU fe712000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.057003] DMAR: DRHD base: 0x000000fe714000 flags: 0x0
> [    0.058007] IOMMU fe714000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.059003] DMAR: DRHD base: 0x000000fe716000 flags: 0x0
> [    0.060006] IOMMU fe716000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.061003] DMAR: DRHD base: 0x000000fe719000 flags: 0x0
> [    0.062007] IOMMU fe719000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.063003] DMAR: DRHD base: 0x000000fe71a000 flags: 0x0
> [    0.064011] IOMMU fe71a000: ver 1:0 cap 4900800c2f0462 ecap e01

Here is our DMA iommu.

> [    0.065003] DMAR: DRHD base: 0x000000fe718000 flags: 0x1
> [    0.066007] IOMMU fe718000: ver 1:0 cap 900800c2f0462 ecap e01
> [    0.067003] DMAR: RMRR base: 0x000000bff6b000 end: 0x000000bff72fff
> [    0.068003] DMAR: No ATSR found
[..]
> # modprobe ioatdma
> [   36.311819] dca service started, version 1.12.1
> [   36.334934] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [   36.341245]   alloc irq_desc for 57 on node -1
> [   36.342154]   alloc kstat_irqs on node -1
> [   36.350418] ioatdma 0000:00:0f.0: PCI INT A -> GSI 57 (level, low) -> IRQ 57
> [   36.357916] ioatdma 0000:00:0f.0: setting latency timer to 64
> [   36.364091]   alloc irq_desc for 104 on node -1
> [   36.365056]   alloc kstat_irqs on node -1
> [   36.373334] ioatdma 0000:00:0f.0: irq 104 for MSI/MSI-X
> [   36.378957]   alloc irq_desc for 105 on node -1
> [   36.379954]   alloc kstat_irqs on node -1
> [   36.388203] ioatdma 0000:00:0f.0: irq 105 for MSI/MSI-X
> [   36.400150]   alloc irq_desc for 106 on node -1
> [   36.401147]   alloc kstat_irqs on node -1
> [   36.409417] ioatdma 0000:00:0f.0: irq 106 for MSI/MSI-X
> [   36.415036]   alloc irq_desc for 107 on node -1
> [   36.416032]   alloc kstat_irqs on node -1
> [   36.424304] ioatdma 0000:00:0f.0: irq 107 for MSI/MSI-X
> [   36.430263] ioatdma 0000:00:0f.0: APICID_TAG_MAP set incorrectly by BIOS, disabling DCA

...and here is the ioatdma driver coming up correctly (albeit with a dca 
misconfiguration)

I don't see a way around this beyond blacklisting this (platform, vt-d 
setting, driver) combination.  Is there a quirk infrastructure for this 
sort of problem?

Chris, is there a BIOS update available for your platform?

--
Dan
