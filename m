Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab2EXJLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:11:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2EXJLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:11:47 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Shawn Guo <shawn.guo@freescale.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Date: Thu, 24 May 2012 19:08:37 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201205221053.21792.marc@cpdesign.com.au> <20120524064635.GP3710@pengutronix.de> <20120524073315.GE7843@S2100-06.ap.freescale.net>
In-Reply-To: <20120524073315.GE7843@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205241908.38278.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, May 24, 2012 05:33:16 PM Shawn Guo wrote:
> On Thu, May 24, 2012 at 08:46:35AM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > On Thu, May 24, 2012 at 02:39:00PM +0800, Shawn Guo wrote:
> > > On Thu, May 24, 2012 at 01:07:43AM -0300, Fabio Estevam wrote:
> > > > I am trying to understand why mx31pdk still fails.
> > > 
> > > So different from imx51-babbage which uses MC13892, mx31pdk uses
> > > MC13783?  But both chips should have the same regmap, right?
> > 
> > They are similar. One difference is the protocol used. MC13783 only
> > speaks spi, MC13892 can do both, spi and i2c. Does someone has a working
> > MC13892 that uses spi?
> 
> I do.  With the following patch applied on top of linux-next, it works
> on my imx51-babbage board.
> 
> Regards,
> Shawn
> 
> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 3fcdab3..5d1969f 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
>         .reg_bits = 7,
>         .pad_bits = 1,
>         .val_bits = 24,
> +       .write_flag_mask = 0x80,

Should probably have .read_flag_mask = 0x00, here too. If either are non zero, 
both are set.

I guess this is the problem, regmap's default read_flag_mask for the spi bus 
is 0x80, and the write mask defaults to 0. The mc13xxx works the opposite way 
though! aarg. My bad for not noticing. So setting the write_flag_mask to 0x80 
also sets the read mask to 0 correctly also.

 
>         .max_register = MC13XXX_NUMREGS,
> 
> @@ -73,7 +74,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
> 
>         dev_set_drvdata(&spi->dev, mc13xxx);
>         spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
> -       spi->bits_per_word = 32;

My bad here too. Because I had no hardware to test with I tried to preserve as 
much of the old code as I could.

Sorry about the stuff ups. I owe each of you a beer (unfortunately I'll have 
to exclude the list in general from that offer :) ).

I'm wondering about regmap_init where the buf_size is set up. I think it will 
only end up being 3 bytes. I think line 249 should be something like:

	map->format.buf_size = (config->reg_bits 
                          + config->val_bits 
					         + (config->pad_bits % 8)) / 8;

or perhaps better:
	map->reg_shift = config->pad_bits % 8;
	map->format.buf_size = (config->reg_bits 
                          + config->val_bits 
					         + map->reg_shift) / 8;

Am I right here or just confused?

Cheers,
Marc


