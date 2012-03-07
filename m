Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2CGQbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:31:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2CGQbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120307124620.GT17370@n2100.arm.linux.org.uk>
References: <1331022623.24656.191.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203060935460.9300@axis700.grange>
	<1331035739.24656.201.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203061339330.9300@axis700.grange>
	<1331101687.24656.319.camel@vkoul-udesk3>
	<Pine.LNX.4.64.1203070917380.19595@axis700.grange>
	<20120307093026.GM17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071041030.19595@axis700.grange>
	<20120307103112.GP17370@n2100.arm.linux.org.uk>
	<Pine.LNX.4.64.1203071149190.19595@axis700.grange>
	<20120307124620.GT17370@n2100.arm.linux.org.uk>
Date: Wed, 7 Mar 2012 17:31:45 +0100
Message-ID: <CACRpkdYiLw3577oGwgtM81ROwR6spzaxxY9O+tv99UJs8ZZ8Vw@mail.gmail.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 1:46 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> The call to dmaengine_slave_config() actually simplifies the DMA engine
> support for some drivers though, so eliminating it doesn't help.  What
> would be useful is to have a helper function along these lines:
>
> struct dma_chan *dma_request_channel_config(mask, fn, data, config)
> {
>        struct dma_chan *c = dma_request_channel(mask, fn, data);
>
>        if (c) {
>                if (dmaengine_slave_config(c, config)) {
>                        dma_release_channel(c);
>                        c = NULL;
>                }
>        }
>        return c;
> }
>
> which would simplify some of the DMA engine users.

Yes that will cut down some overhead from some drivers.

[Russell]
> There'll still be
> some though which would want to call dmaengine_slave_config() to change
> the channels configuration when the mode of the device switches.

[Guennadi]
> Cannot dmaengine_slave_config() be used for that?

It is already used for that.

The PL022 SPI driver does this using different word sizes on the wire,
so if the same controller talks to chips with different word width
it reconfigures the size of unit picked from memory. Basically
the width (not depth) of the FIFO is adjustable run-time.
The words have to be fetched from memory with the same
width.
drivers/spi/amba-pl022.c

Yours,
Linus Walleij
