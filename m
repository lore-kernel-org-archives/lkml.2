Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0HUN6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 09:58:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51646 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0HUN6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 09:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N+0S27eT1W6pvQzEWrBkRr+K7oxuuZsT7IyTWKRKNwcBZ2p94uwiPKIFsKyqNKOIcO
         ugnk+zb4fqkPrwDqSLz3VaMjkRMoAL9XnDv+ONnL35D7FAUHw6jfu0Z5pMAXwyuvFpVg
         jeR/RXekt1ssy05mQ4N8ZFjFUIjpU/H7pEi5c=
MIME-Version: 1.0
In-Reply-To: <20100821100855.GA5545@opensource.wolfsonmicro.com>
References: <1282321028-32196-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<AANLkTimggbZqgv=eKe+wx8YvUX5vOppDfmwpLwTgxJFM@mail.gmail.com>
	<20100821100855.GA5545@opensource.wolfsonmicro.com>
Date: Sat, 21 Aug 2010 22:58:36 +0900
Message-ID: <AANLkTikbGR4wWUEHjR74UFu8P-w9us3ZpKgmG+yDukfC@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 1/2] spi/spi_s3c64xx: Make probe more
 robust against missing board config
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 7:08 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sat, Aug 21, 2010 at 10:45:56AM +0900, Jassi Brar wrote:
>> On Sat, Aug 21, 2010 at 1:17 AM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>> > The S3C64xx SPI driver requires the machine to call s3c64xx_spi_set_info()
>> > to select a few options, including the clock to use for the SPI controller.
>> > If this is not done then a NULL will be passed as the clock name for
>> > clk_get(), causing an obscure crash. Guard against this and other missing
>> > configuration by validating that the clock name has been filled in in
>> > the platform data that ets passed in.
>
>>      The movement of sci assignment and check doesn't make any
>> difference because
>>       we already check for presence of platform_data and DMA-Tx,Rx and
>> IO base is
>>       set irrespective of calling s3c64xx_spi_set_info()
>
> While it does check for those things for at least the 6410 they're all
> unconditionally set up by dev-spi.c so the tests all pass and we make it
> down into to the clk_get() which then falls over horribly.
Those parameters are SoC specific and hence will be always available to
platform devices.
Clock selection and num_cs(number of slaves attached to the SPI bus) are
machine specific and hence responsibility of the machine developer to
set appropriately via s3c64xx_spi_set_info()


>>     Also, I think !sci->num_cs might be an even better check because
>> the samsung clock
>>    api might be changed (IIRC Ben was already working it out) to make
>> it redundant
>>    to pass clock name strings to clk_get. If that is the case, we might end up
>>    adding another foolproof check like !sci->num_cs
>
> The problem with num_cs is that it gets interpreted by a custom function
> provided by the board driver so we really can't say anything about what
> it does.
num_cs is passed on as such to the SPI core to master->num_chipselect
which is strictly checked for before a master is created.

>  If the clock API gets enhanced then we can always cope with
> things then, but given the pace of development there I'd expect that
> we'd need to continue checking for a while.
yes, so do i think.

> TBH I'm a bit surprised that the driver has to do custom stuff to
> support gpiolib chip selects - my first thought when I saw that stuff
> was that it seemed like something that lots of SPI controllers would be
> able to share but I didn't look at the overall SPI code for long enough
> to figure out what was going on there.
we have common spi bitbanging driver that takes only four gpio pins
and work like a charm.
In order to enable users use multiple CS per master, in spi_s3c64xx.c
the single CS feature provided by the controller is deliberately left unused
and the driver accepts a gpio per slave and manually controls it. Though
the callbacks and arguments are designed so that a simple gpio number
and gpio_set can be assigned by the machine code.

Anyways, I think we can keep the patch as it is, if it's already
applied in Grant's
tree.
