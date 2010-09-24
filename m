Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0IXATa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:19:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59793 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0IXAT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XjyIXTzi6n3VGZZDiIHPRSqbR/j3XL/AIxg0UC/kEs4PtxXfTW3DpFTwm37mfgetdu
         BHnPCJBNjdId7cI6WPIhkB1sPM9SoDH50nmvDz/PFiJCUMZkK/FoLNRw5XmKUBtl2RbR
         cZqYvxSmbMbxnsgIQ0DZ24guMhsCOIPAGo9f8=
MIME-Version: 1.0
In-Reply-To: <20100923232005.GB25888@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
	<AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
	<20100923201239.GA24391@ovro.caltech.edu>
	<AANLkTik1R-ZPpG5QibWuT1OhUPZr3i_Hr0LMW7D7s6zm@mail.gmail.com>
	<20100923232005.GB25888@ovro.caltech.edu>
Date: Thu, 23 Sep 2010 17:19:27 -0700
X-Google-Sender-Auth: InoUvWIPSvkeXg_KfbJjQT0ZbRM
Message-ID: <AANLkTi=tKQBCH6MyftMx_2JMhc+tyX22pnzxpexWm01T@mail.gmail.com>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ copying Linus on this usage of slave_config ]

On Thu, Sep 23, 2010 at 4:20 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> On Thu, Sep 23, 2010 at 02:58:06PM -0700, Dan Williams wrote:
[snip discussion of external slave driver]
>> Yes, thanks now I recall, and I remember saying something about how
>> this passes the "Voyager test".  That said it seems odd to carry
>> symbol exports for something like this.  Instead of exporting can we
>> exploit the fact that the fpga driver already knows it has a
>> fsldma_device pointer and do something like:
>>
>> struct fsldma_device *fdev = container_of(dma, typeof(fdev), common);
>>
>> fdev->slave_alloc();
>>
>> This keeps it contained to the fsldma driver.
>>
>
> I agree that it sucks to have exports for this. I'm happy with the
> static inlines in a header, but AKPM didn't like them.
>
> I think the solution above would actually need to be a struct
> fsldma_chan instead of a struct fsldma_device, but otherwise would work.
>
> The caveat with your solution above is that (parts of)
> drivers/dma/fsldma.h need to be copied into
> arch/powerpc/include/asm/fsldma.h for the type information. It seems a
> bit awkward as well.
>
> I'd like to propose another possible solution:
> 1) add an external_control member to struct dma_slave_config

Will you be using the other slave_config fields, or would it be better
to have a new dma_crtl_cmd?

> 2) remove the list_head from struct fsl_dma_slave
> 3) remove all of the functions from arch/powerpc/include/asm/fsldma.h
> 4) add dma_async_memcpy_sg_to_sg()
>
> dma_cookie_t dma_async_memcpy_sg_to_sg(struct dma_chan *chan,
>                                       struct *dst_sg, int dst_nents,
>                                       struct *src_sg, int src_nents,
>                                       dma_async_tx_callback cb,
>                                       void *cb_param);
>
> This function would do most of the current work that the current fsldma
> device_prep_slave_sg() does: setting up a DMA chain to transfer between
> two scatterlists.

Ok just wrap it in an ifdef CONFIG_DMAENGINE_SG_TO_SG so it compiles
away on platforms that don't care about it.  I carried an out-of-tree
config option CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL for a driver that
eventually made it upstream, so there is precedent for such a thing.

I assume it will implement this as a series of calls to prep_slave_sg
or prep_memcpy and be compatible with other dma drivers?

>
> I'm willing to do an ugly hack to make a fake scatterlist with my fixed
> non-incrementing hardware addresses for the dst_sg. Like this:
>
> sg_dma_address(sg) = MY_FIXED_ADDRESS_1;
> sg_dma_len(sg) = MY_FIXED_LENGTH_1;
> sg = sg_next(sg);
> sg_dma_address(sg) = MY_FIXED_ADDRESS_2;
> sg_dma_len(sg) = MY_FIXED_LENGTH_2;
>
> Now my driver would look like this:
>
> struct dma_slave_config dsc;
> dsc.external_control = true;
>
> /* allocate and fill my dst_sg with the fake data, like above */
> /* DO NOT use dma_map_sg() on the fake scatterlist */
> /* allocate and fill my src_sg with pages + data */
> src_nents = dma_map_sg(..., src_sg, DMA_TO_DEVICE);
>
> /* sets up the DMA transfer, but doesn't start it */
> cookie = dma_async_memcpy_sg_to_sg(chan, dst_sg, dst_nents,
>                                   src_sg, src_nents,
>                                   my_cb, my_cb_param);
>
> /* puts the DMA engine into external control mode */
> ret = chan->device_control(chan, DMA_SLAVE_CONFIG, (unsigned long)dsc);
>
> /* "start" the transfer */
> dma_async_memcpy_issue_pending(chan);
>
> /*
>  * start the system controller FPGA programmer, which will toggle the
>  * DMA engine's external control pins appropriately.
>  *
>  * Wait until my callback is called, which will wake up and continue
>  * the function. Using wait_for_completion_timeout(), etc. Which is
>  * exactly what I do now.
>  */
>
>
> The freescale DMA engine must have the external control bit set on every
> new transaction. It is automatically cleared after a transaction
> completes.

I think this meets the spirit of upstream inclusion (documents and
provides a tested usage model for a piece of hardware), does so using
common (ish) interfaces, and has intrinsic value outside of enabling
an out-of-tree driver.

--
Dan
