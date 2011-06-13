Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1FMONU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:13:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42243 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1FMONQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110610133338.GD24636@n2100.arm.linux.org.uk>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	<20110609124723.GA24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	<20110609163206.GB24636@n2100.arm.linux.org.uk>
	<1307686397.10976.116.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com>
	<20110610104318.GC24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
	<20110610133338.GD24636@n2100.arm.linux.org.uk>
Date: Mon, 13 Jun 2011 16:13:15 +0200
Message-ID: <BANLkTimZ=v4W1hFJ7hvZRmyHMSU_3MmZEA@mail.gmail.com>
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
From: Linus Walleij <linus.walleij@linaro.org>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Koul, Vinod" <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 3:33 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jun 10, 2011 at 05:18:46PM +0530, Raju, Sundaram wrote:
>> Now DMACs capable of 3D transfer, do transfer of the whole 1D
>> buffer per sync received or even whole 2D buffer per sync received
>> (based on the sync rate programmed in the DMAC).
>
> The only issue which I see that we don't cover is the case where you want
> to describe a single buffer which is organised as N bytes to be transferred,
> M following bytes to be skipped, N bytes to be transferred, M bytes to be
> skipped.  I doubt there are many controllers which can be programmed with
> both 'N' and 'M' parameters directly.

Sundaram is this how your controller works?
I mean the hardware can skip over sequences like this?

When we added the config interface to DMAengine I originally included
a "custom config" call, but Dan wanted me to keep it out until we
had some specific usecase for it. FSLDMA recently started
to use it.

Notice how dmaengine_slave_config() is implemented:

static inline int dmaengine_slave_config(struct dma_chan *chan,
					  struct dma_slave_config *config)
{
	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
			(unsigned long)config);
}

So what is passed to the driver is just an unsigned long.

This is actually modeled to be ioctl()-like so you can pass in a
custom config to the same callback on the device driver,
just use some other enumerator than DMA_SLAVE_CONFIG,
say like FSLDMA already does with FSLDMA_EXTERNAL_START.

Just put some enumerator in enum dma_ctrl_cmd in
dmaengine.h such as SDMA_TEXAS_STRIDE_CONFIG and call
like this:

/* However that config struct needs to look, basically */
static struct sdma_ti_stride_cgf = {
     take = M,
     skip = N,
};

ret = chan->device->device_control(chan, SDMA_TEXAS_STRIDE_CONFIG,
&sdma_ti_stride_cfg);

Or something like this.

Thanks,
Linus Walleij
