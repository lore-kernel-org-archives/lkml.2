Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab0I0RfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:35:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781Ab0I0RfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nxjCAJjWwjRia63EHm1OFe5Kmrx7C8n1TwxEks/mkCC8yv52oVuTpGk7SfBuumZ5fJ
         hfjLTHw8864Hg6JkquEFFUy64UvLBEAb4Cfz3vX9hReVHPBx2yuM8kN1scD9+SIOri2i
         0EJyBm4s9IStMzcqICH5Zz+XjaFyYmNhBhQVY=
MIME-Version: 1.0
In-Reply-To: <20100927172356.GA805@ovro.caltech.edu>
References: <1285370032-16937-1-git-send-email-iws@ovro.caltech.edu>
	<1285370032-16937-2-git-send-email-iws@ovro.caltech.edu>
	<AANLkTimzdEhAZ=oXbbB3Ge5=YY7OXq3fjaRH4roPNB-k@mail.gmail.com>
	<20100927172356.GA805@ovro.caltech.edu>
Date: Mon, 27 Sep 2010 10:35:09 -0700
X-Google-Sender-Auth: piQsjhfHKgoVbyy0wfDcbSy7TVk
Message-ID: <AANLkTikyyyGW9WXK3d6m6b26vcZ47Lj6-d0fN+b+LvRS@mail.gmail.com>
Subject: Re: [PATCH RFCv2 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        =?ISO-8859-1?Q?Per_Frid=E9n?= <per.friden@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:23 AM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> On Mon, Sep 27, 2010 at 05:23:34PM +0200, Linus Walleij wrote:
>> 2010/9/25 Ira W. Snyder <iws@ovro.caltech.edu>:
>>
>> > This adds support for scatterlist to scatterlist DMA transfers.
>>
>> This is a good idea, we have a local function to do this in DMA40 already,
>> stedma40_memcpy_sg().
>>
>
> I think that having two devices that want to implement this
> functionality as part of the DMAEngine API is a good argument for making
> it available as part of the core API. I think it would be good to add
> this to struct dma_device, and add a capability (DMA_SG?) for it as
> well.
>
> I have looked at the stedma40_memcpy_sg() function, and I think we would
> want to extend it slightly for the generic API. Is there any good reason
> to prohibit scatterlists with different numbers of elements?
>
> For example:
> src scatterlist: 10 elements, each with 4K length (40K total)
> dst scatterlist: 40 elements, each with 1K length (40K total)
>
> The total length of both scatterlists is equal, but the number of
> scatterlist entries is different. The freescale DMA controller can
> handle this just fine.
>
> I'm proposing this function signature:
> struct dma_async_tx_descriptor *
> dma_memcpy_sg(struct dma_chan *chan,
>              struct scatterlist *dst_sg, unsigned int dst_nents,
>              struct scatterlist *src_sg, unsigned int src_nents,
>              unsigned long flags);
>
>> > This is
>> > currently hidden behind a configuration option, which will allow drivers
>> > which need this functionality to select it individually.
>>
>> Why? Isn't it better to add this as a new capability flag
>> if you don't want to announce it? Or is the intent to save
>> memory footprint?
>>
>
> Dan wanted this, probably for memory footprint. If >1 driver is using
> it,

Yes, I did not see a reason to increment the size of dmaengine.o for
everyone if only one out-of-tree user of the function existed.

> I would rather have it as part of struct dma_device along with a
> capability.

I think having this as a dma_device method makes sense now that more
than one driver would implement it, and let's drivers see the entirety
of the transaction in one call.

--
Dan
