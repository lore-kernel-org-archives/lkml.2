Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1BADW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:22:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50916 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1BADW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mezClprY5qVfzrNBL3SuWcAqt8ZkGaDsRl5CSmXp5zFdTNjn9eLqKJk4zbGH8r3oky
         YgGKmpIBM7khe9FUkrCL2SY1qQiNmGebh98GnCrp7psoaDATRzIF9NRFNuVWNB6NTo/V
         RecwehYvxTP0L4p8xZdjDmGaRSaGhxnkPppB8=
Message-ID: <4D477C6F.8000906@gmail.com>
Date: Mon, 31 Jan 2011 21:22:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: ak@linux.intel.com, cebbert@redhat.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
References: <20110131105412.7252a09c@katamari>	<20110131163639.GA32095@tassilo.jf.intel.com>	<4D4759BD.2000006@gmail.com> <20110201102707C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110201102707C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:28 PM, FUJITA Tomonori wrote:
> On Mon, 31 Jan 2011 18:54:21 -0600
> Robert Hancock<hancockrwd@gmail.com>  wrote:
>
>> On 01/31/2011 10:36 AM, Andi Kleen wrote:
>>> On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
>>>> The b44 driver is triggering this panic in swiotlb_map_page():
>>>>
>>>>           if (!dma_capable(dev, dev_addr, size))
>>>>                   panic("map_single: bounce buffer is not DMA'ble");
>>>>
>>>> The kernel log says the bounce buffers are at 0xdb400000, but b44 can
>>>> only do DMA to the first 1GB of memory:
>>>
>>> b44 needs to use GFP_DMA then and do its own custom bouncing.
>>> The standard pci_map_* bounce buffering is only designed for at least
>>> 32bit capable devices.
>>
>> That seems wrong - it's a documented API and that restriction isn't
>> documented. Either it should comply with the request or return a failure
>> if it can't accomodate it, not just blow up internally. There's no
>> reason the driver should have to deal with this on its own.
>>
>> In this case the DMA mapping code  should really be falling back to
>> GFP_DMA automatically if the IOMMU aperture is outside the DMA mask of
>> the device.
>
> swiotlb allocates the bounce buffer when a system boots up. We can't
> allocate much in GFP_DMA. swiotlb uses somewhere under 4GB. So it
> can't help devices that have odd dma_mask (that is, except for 4GB).
>
> Unfortunately, Such device needs to do own custom bouncing or needs
> their subsystem to does that.
>
> Some ideas to implement something that works for such device were
> discussed. Seems that the conclusion is that it's doesn't worth making
> the common code complicated for such minor and insane devices.

I don't think this is the only device that has sub-32-bit DMA 
restrictions, this will just lead to a bunch of duplicated code. In 
particular, how is LPC DMA supposed to work?

At the very least we should be allowing the driver to deal with the 
failure instead of panicing the system. Otherwise we are just leaving a 
land mine for people to trip over.
