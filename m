Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1D2FvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 01:51:15 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:24428 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab1D2FvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 01:51:14 -0400
Message-ID: <4DBA5194.7080609@vmware.com>
Date: Fri, 29 Apr 2011 07:50:12 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jerome Glisse <j.glisse@gmail.com>, linaro-mm-sig@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
References: <201104212129.17013.arnd@arndb.de>	<201104281428.56780.arnd@arndb.de>	<20110428131531.GK17290@n2100.arm.linux.org.uk>	<201104281629.52863.arnd@arndb.de>	<20110428143440.GP17290@n2100.arm.linux.org.uk>	<BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com> <1304036962.2513.202.camel@pasglop>
In-Reply-To: <1304036962.2513.202.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 02:29 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2011-04-28 at 15:37 -0400, Jerome Glisse wrote:
>    
>> Jesse also pointed out space exhaustion inside the iommu and i believe
>> this should also be considered. This is why i believe the dma_* api is
>> not well suited. In DRM/TTM we use  pci_dma_mapping* and we also play
>> with with page set_page*_uc|wc|wb.
>>      
> Which are yet another set of completely x86-centric APIs that have not
> been thought in the context of other architectures and are probably
> mostly unimplementables on half of them :-)
>
> Cheers,
> Ben.
>
>
>    

I've been doing some thinking over the years on how we could extend that 
functionality to other architectures. The reason we need those is 
because some x86 processors (early AMDs and, I think VIA c3) dislike 
multiple mappings of the same pages with conflicting caching attributes.

What we really want to be able to do is to unmap pages from the linear 
kernel map, to avoid having to transition the linear kernel map every 
time we change other mappings.

The reason we need to do this in the first place is that AGP and modern 
GPUs has a fast mode where snooping is turned off.

However, we should be able to construct a completely generic api around 
these operations, and for architectures that don't support them we need 
to determine

a)  Whether we want to support them anyway (IIRC the problem with PPC is 
that the linear kernel map has huge tlb entries that are very 
inefficient to break up?)

b)  Whether they are needed at all on the particular architecture. The 
Intel x86 spec is, (according to AMD), supposed to forbid conflicting 
caching attributes, but the Intel graphics guys use them for GEM. PPC 
appears not to need it.

c)  If neither of the above applies, we might be able to either use 
explicit cache flushes (which will require a TTM cache sync API), or 
require the device to use snooping mode. The architecture may also 
perhaps have a pool of write-combined pages that we can use. This should 
be indicated by defines in the api header.

/Thomas




> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>    

