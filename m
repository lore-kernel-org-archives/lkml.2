Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1ALJMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:12:23 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:20855 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab1ALJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:12:21 -0500
Message-ID: <4D2D706E.5000508@shipmail.org>
Date: Wed, 12 Jan 2011 10:12:14 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com> <4D2B16F3.1070105@shipmail.org> <20110110152135.GA9732@dumpdata.com> <4D2B2CC1.2050203@shipmail.org> <20110110164519.GA27066@dumpdata.com> <4D2B70FB.3000504@shipmail.org> <20110111155545.GD10897@dumpdata.com>
In-Reply-To: <20110111155545.GD10897@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Konrad.

This discussion has become a bit lenghty. I'll filter out the sorted-out 
stuff, which leaves me with two remaining issues:


On 01/11/2011 04:55 PM, Konrad Rzeszutek Wilk wrote:
>
> So at the end we have 16GB taken from 8GB->24GB, and 320MB taken from
> 0->4GB. When you start allocating coherent memory from each guest
> (and yeah, say we use 2GB each), we end up with the first guest getting
> the 2GB, the second getting 1.7GB, and then the next two getting zil.
>
> You still have GFP_KERNEL memory in each guest - the first one has 2GB left
> , then second 2.3, the next two have each 4GB.
>
> > From the hyprevisor pool perspective, the 0-4GB zone is exhausted, so
> is the 8GB->24GB, but it still has 4GB->8GB free - so it can launch one more
> guest (but without PCI passthrough devices).
>
>    
>> On a 4GB machine or less, that would be the same as kernel memory.
>> Now, if 4 guests think they can allocate 2GB of coherent memory
>> each, you might run out of kernel memory on the host?
>>      
> So host in this case refers to the Hypervisor and it does not care
> about the DMA or what - it does not have any device drivers(*) or such.
> The first guest (dom0) is the one that deals with the device drivers.
>
> *: It has one: the serial port, but that is not really that important
> for this discussion.
>    

Let's assume we're at where the hypervisor (or host) has exhausted the 
0-4GB zone, due to guests coherent memory allocations, and that the 
physical machine has 4GB of memory, all in the 0-4GB zone. Now if the 
hypervisor was running on a Linux kernel, there would be no more 
GFP_KERNEL memory available on the *host* (hypervisor), and the 
hypervisor would crash. Now I don't know much about Xen, but it might be 
that this is not a problem with Xen at all?


>>
>> Another thing that I was thinking of is what happens if you have a
>> huge gart and allocate a lot of coherent memory. Could that
>> potentially exhaust IOMMU resources?
>>      
> <scratches his head>
>    

I need to be more specific. Let's assume we're on "bare metal", and we 
want to allocate 4GB of coherent memory. For most IOMMUs that would mean 
as you previously state, that we actually allocate GFP_DMA32 memory. But 
for some IOMMUs that would perhaps mean that we allocate *any* memory 
and set up a permanent DMA mapping in the IOMMU for the coherent pages. 
What if, in such a case, the IOMMU can only set up 2GB of coherent memory?

Or in short, can there *ever* be "bare metal" cases where the amount of 
coherent memory available is less than DMA32 memory available?

Thanks,
Thomas


