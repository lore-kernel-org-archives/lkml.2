Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0G1AUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 20:20:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0G1AUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 20:20:35 -0400
Message-ID: <4C4F779D.9060908@zytor.com>
Date: Tue, 27 Jul 2010 17:19:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: konrad.wilk@oracle.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
References: <1280250002-20279-10-git-send-email-konrad.wilk@oracle.com>	<4C4F2D9C.4020303@zytor.com>	<20100727194105.GA18647@phenom.dumpdata.com> <20100728083526J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100728083526J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 04:36 PM, FUJITA Tomonori wrote:
>>>
>>> Is there any way we can abstract this out a bit more instead of crapping
>>> on generic code?
> 
> I don't like this change much too, however I think that this is the
> most simple and straightforward.
> 
> Basically, Xen's swiotlb works like a new IOMMU implementation so we
> need to initialize it like other IOMMU implementations (call the
> detect and init functions in order).
> 

Even mentioning "xen" in generic code should be considered a bug.  I
think we *do* need to driverize the iommu stuff, and yes, Xen's swiotlb
should just be handled like one in the list.

> 
>> I was toying with something like this:
>>
>> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
>> index 9f07cfc..e0cd388 100644
>> --- a/arch/x86/kernel/pci-dma.c
>> +++ b/arch/x86/kernel/pci-dma.c
>> @@ -45,6 +45,25 @@ int iommu_detected __read_mostly = 0;
>>   */
>>  int iommu_pass_through __read_mostly;
>>  
>> +initcall_t __swiotlb_initcall_detect[] =
>> +	{pci_xen_swiotlb_detect,
>> +	 pci_swiotlb_detect,
>> +	NULL};
>> +
>> +initcall_t __swiotlb_initcall_init[] = {
>> +	pci_xen_swiotlb_init,
>> +	pci_swiotlb_init,
>> +	NULL};
>> +
>> +
>> +initcall_t __iommu_initcall_detect[] = {
>> +	gart_iommu_hole_init,
>> +	detect_calgary,
>> +	detect_intel_iommu,
>> +	/* needs to be called after gart_iommu_hole_init */
>> +	amd_iommu_detect,
>> +	NULL};
> 
> I really don't think that this makes the code better. I prefer the
> current simple (dumb) code.
> 

The special handling of swiotlb here really looks wrong, but otherwise I
think it's the right idea.

> btw, this comment is wrong. We check if we are forced to use SWIOTLB
> by kernel command line here.
> 
> Even if SWIOTLB works, we see if hardware IOMMU is available. SWIOTLB
> is a last resort. We prefer hardware IOMMU.

Any reason to not just handle swiotlb like any of the other iommus, at
the bottom of the list?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

