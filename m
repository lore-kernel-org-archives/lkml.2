Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab1FFStC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:49:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38887 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1FFSs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SAndRCR7hduESRrIT3po8WJ8i7R99iKIYqjxlddxbI9T8lUxk2vsK4a7PVyd/BdrtJ
         Z8DOYALD6uEFwK8TicAyNyJq1O2OFs+bG2xgWO7zYq3FTMS4wMBTxrDdbWZ8aByORCzb
         2x3I+QZtKM1se94PmQK4XJExTX8F3yC0RQlNg=
MIME-Version: 1.0
In-Reply-To: <20110606191041U.fujita.tomonori@lab.ntt.co.jp>
References: <20110606091410.GB10508@n2100.arm.linux.org.uk>
	<20110606183925D.fujita.tomonori@lab.ntt.co.jp>
	<20110606094751.GC10508@n2100.arm.linux.org.uk>
	<20110606191041U.fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 6 Jun 2011 11:48:56 -0700
X-Google-Sender-Auth: 6XDCzQrxwUWNPX5Yl0PPyFyf4ak
Message-ID: <BANLkTin7mqqTsosPHbztaPfL7s_TUGT1qg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dmaengine: add new dma API for max_segment_number
From: Dan Williams <dan.j.williams@intel.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, cjb@laptop.org, patches@linaro.org,
        vinod.koul@intel.com, gregkh@suse.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 3:12 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Mon, 6 Jun 2011 10:47:51 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> On Mon, Jun 06, 2011 at 06:41:09PM +0900, FUJITA Tomonori wrote:
>> > On Mon, 6 Jun 2011 10:14:10 +0100
>> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>> >
>> > > On Mon, Jun 06, 2011 at 05:06:03PM +0900, FUJITA Tomonori wrote:
>> > > > max_segs isn't unrelated with the dma mapping API. I explained above,
>> > > > IOMMUs doesn't increase the number of segments (could decrease the
>> > > > number of segments by merging).
>> > > >
>> > > > The limitation about the number of segment already lives elsewhere
>> > > > (e.g. queue's limits.max_segments).
>> > >
>> > > I think you're missing the point entirely.
>> > >
>> > > Lets take the problem at hand: you have two devices.  One of them is
>> > > handled by the DMA engine code.  One of them is a block device.
>> > >
>> > > The block layer needs to know the various parameters of what is
>> > > allowable for DMA, including such things as the maximum size of a
>> > > segment, and the _number_ of segments that can be placed into any
>> > > one request.
>> > >
>> > > As the DMA provider is _entirely_ separate and unknown to the block
>> > > device driver, the block device driver has no way to sanely provide
>> > > these parameters to the block layer - they are not a property of the
>> > > block device driver, but of the DMA provider.
>> >
>> > struct device_dma_parameters is used for a property of the block
>> > device drivers (and scsi HBA drivers, etc). Not DMA provider. Right?
>>
>> Wrong.  struct device_dma_parameters is a property of the _DMA_ _provider_.
>> It has to be.  Read what I said above and think about it.
>
> I think that it's up to your definition of DMA provider.
>
>> In many cases, it so happens that the DMA provider and the block device
>> driver are the same entity, and so it may appear that device_dma_parameters
>
> But could be the different entities, right? If so, the value should be
> smaller one? Who is responsible for setting the correct value? The
> proposed API blindly set the value (just overwrite). The API would be
> better to set a new value only when the new value is smaller? Or
> having a separate structure and selecting the smallest value?
>
> struct device_dma_parameters assumes that the DMA provider and the
> block (and SCSI, etc) device driver are the same entity.
>
>> is a property of the block device driver.  As soon as you have to start
>> dealing with DMA providers being separate from the block device driver
>> then your eyes will be opened and you'll see that it can't work the way
>> you seem to want it to.
>>
>> The DMA parameters have to come from the DMA provider or they're a total
>> nonsense.
>
> I don't think that I claim that the DMA parameters don't come from the
> DMA provider. It depends on the definition of the DMA provider,
> though.

dmaengine expands the class of dma providers to include standalone dma
agents on a host bus (or elsewhere) in addition to the traditional bus
mastering host-bus-adapters that the existing api understands.  So in
the case of slave dma the dma capabilities of the block-device are
irrelevant because another agent will do the transfer on behalf of the
block-device driver.  So the value should be whatever the dma device
driver says it is.

--
Dan
