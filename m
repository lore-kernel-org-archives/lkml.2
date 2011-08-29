Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1H2IQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:16:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60575 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1H2IQE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110829080047.GJ31809@linux-sh.org>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
	<1308916071.1536.4.camel@vkoul-udesk3>
	<20110829080047.GJ31809@linux-sh.org>
Date: Mon, 29 Aug 2011 17:16:03 +0900
Message-ID: <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 5:00 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, Jun 24, 2011 at 05:17:51PM +0530, Koul, Vinod wrote:
>> On Fri, 2011-06-24 at 13:56 +0200, Guennadi Liakhovetski wrote:
>> > On some sh-mobile systems there are more than one DMA controllers, that
>> > can be used for serial ports. Specifying a DMA device in sh-sci platform
>> > data unnecessarily restricts the driver to only use one DMA controller.
>> >
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> >  drivers/tty/serial/sh-sci.c |   25 ++++++++-----------------
>> >  include/linux/serial_sci.h  |    2 --
>> >  2 files changed, 8 insertions(+), 19 deletions(-)
>> >
>> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
>> > index ebd8629..8711f4e 100644
>> > --- a/drivers/tty/serial/sh-sci.c
>> > +++ b/drivers/tty/serial/sh-sci.c
>> > @@ -1295,12 +1295,8 @@ static bool filter(struct dma_chan *chan, void *slave)
>> >     dev_dbg(chan->device->dev, "%s: slave ID %d\n", __func__,
>> >             param->slave_id);
>> >
>> > -   if (param->dma_dev == chan->device->dev) {
>> > -           chan->private = param;
>> > -           return true;
>> > -   } else {
>> > -           return false;
>> > -   }
>> > +   chan->private = param;
>> > +   return true;
>> You should not assign chan->private.
>> Please move this  to dma_slave_control API
>
> I haven't seen any reply to this comment and this patch seems to still be
> outstanding, is there an updated version of this patch that I've missed?

This patch is simply making the SCIF driver behave as other drivers
that support DMA Engine like for instance:
MMCIF - drivers/mmc/host/sh_mmcif.c
SDHI - drivers/mmc/host/tmio_mmc_dma.c
USBHS - drivers/usb/renesas_usbhs/fifo.c

The SIU driver is still acting like the SCIF driver though:
SIU - sound/soc/sh/siu_pcm.c

If possible I would prefer if the drivers for the SCIF and the SIU
first could be cleaned up to behave like MMCIF/SDHI/USBHS and then we
can move to make use of the dma_slave_control API after that.

Any thoughs?

Thanks,

/ magnus
