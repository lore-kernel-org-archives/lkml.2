Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0IWV6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:58:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32960 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab0IWV6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j5T4X/uc95nDdycuiTyjUChUIFB9i4j4UZhITGqs2ArVjDkF2o2AcZNs8RoiVgAHxL
         bdOWXMI8Akl9V1qqAW/zCJaVfTxB8cCv2T/EMGtTOMRjyN4XkaGA7kCqq8oVYVLs+mwR
         whdxLeiC3HmVWepnTOi5wXeg5KOdclNnaHosU=
MIME-Version: 1.0
In-Reply-To: <20100923201239.GA24391@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
	<AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
	<20100923201239.GA24391@ovro.caltech.edu>
Date: Thu, 23 Sep 2010 14:58:06 -0700
X-Google-Sender-Auth: 7xk-VvEElinQ1ZRLb8-2JiQ18yo
Message-ID: <AANLkTik1R-ZPpG5QibWuT1OhUPZr3i_Hr0LMW7D7s6zm@mail.gmail.com>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 1:12 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> On Thu, Sep 23, 2010 at 11:31:11AM -0700, Dan Williams wrote:
>> On Tue, Sep 7, 2010 at 1:45 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
>> > The DMA_SLAVE support functions all existed as static inlines in the
>> > driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
>> > of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.
>> >
>> > At the same time, add the missing linux/list.h header.
>> >
>> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
>> > ---
>> >
>> > Hello AKPM, Dan,
>>
>> Hi, I'm back from paternity leave.
>>
>> >
>> > At AKPM's request, I moved these static inline'd functions into the driver
>> > code itself, and then EXPORT_SYMBOL_GPL()'d them. I also added a gfp
>> > parameter to the fsl_dma_slave_alloc() function. And included the
>> > linux/list.h header.
>> >
>> > If you'd like three separate patches, I can do that. The changes were so
>> > trivial that I lumped all of them into a single patch.
>> >
>> > Thanks,
>> > Ira
>> >
>> >  arch/powerpc/include/asm/fsldma.h |   70 +++------------------------------
>> >  drivers/dma/fsldma.c              |   77 +++++++++++++++++++++++++++++++++++++
>>
>> Remind me why we need this header file and these routines again?  git
>> grep says nothing in-tree is using these?
>>
>> I also do not want to proliferate driver specific interfaces.  It
>> defeats the purpose of having a common dmaengine structure.  Along
>> these lines Linus W. added the new device_control() method (first
>> added in commit c3635c78, later tweaked in 05827630).  Could that be
>> massaged for your needs?
>>
>
> These routines are used by a (currently out of tree) driver that I
> maintain. Please see the LKML and linuxppc-dev ML post titled:
> [PATCH RFCv2 0/5] CARMA Board Support
>
> The FPGA programming driver uses these interfaces. Past a few initial
> comments (which I promptly fixed!), it seems that nobody wants to look
> at this driver. I don't know how to move it towards mainline other than
> spam people, which I would prefer to avoid doing.
>
> The new device_control() method doesn't have enough information for this
> purpose. I also don't know of any other DMA controllers that have the
> feature I'm using (described below).
>
> The fsldma controller has the option of being controlled by an external
> device, via some pins. This is leveraged by our system controller to
> properly program some big data processing FPGAs.
>
> Basically, the fsldma controller must be told:
> 1) descriptors (src, dst, len tuples)
> 2) use the external-start feature (external control)
> 3) go
>
> Now #3's "go" doesn't actually start the transfer. It just starts
> listening on the external pins for the correct sequence for each
> transaction.
>
> Also, the descriptors must be set up such that they form a single chain,
> without interruptions between segments. Back at the beginning of the
> year, I did a lot of work on the fsldma driver. It *should* be able to
> chain DMA transfers appropriately for this mode using the existing
> device_prep_dma_memcpy() routine.
>
> This means that it would be possible to move some of the functionality
> of fsldma's device_prep_slave_sg() into core DMAEngine code, and
> implement something like dma_memcpy_sg_to_sg(). This would take two
> scatterlists and call device_prep_slave_sg() enough times to setup a DMA
> operation that will move all data appropriately.
>
> This is exactly what fsldma's device_prep_slave_sg() actually does. It
> was non-trivial to get the triply nested loops correct.
>
> As an example from my driver, I have this scenario:
> 1) a scatterlist of kernel memory pages (this is my data payload)
> 2) a fixed set of non-incrementing physical addresses I need to send that data to
>
> Other than the fsldma device_prep_slave_sg(), this is difficult to do.
>
> I hope that helps to explain the problem.

Yes, thanks now I recall, and I remember saying something about how
this passes the "Voyager test".  That said it seems odd to carry
symbol exports for something like this.  Instead of exporting can we
exploit the fact that the fpga driver already knows it has a
fsldma_device pointer and do something like:

struct fsldma_device *fdev = container_of(dma, typeof(fdev), common);

fdev->slave_alloc();

This keeps it contained to the fsldma driver.

--
Dan
