Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1GEMJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:09:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48913 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1GEMJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:09:21 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH 1/5] MFD: twl6040: Add irq variable for slave devices
Date: Tue, 5 Jul 2011 15:09:06 +0300
Message-ID: <3328261.Ltcx4CEcHA@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110705112245.GA2820@legolas.emea.dhcp.ti.com>
References: <1309857266-3663-1-git-send-email-peter.ujfalusi@ti.com> <1309857266-3663-2-git-send-email-peter.ujfalusi@ti.com> <20110705112245.GA2820@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011 13:22:46 Balbi, Felipe wrote:
> Hi,
> 
> On Tue, Jul 05, 2011 at 12:14:22PM +0300, Peter Ujfalusi wrote:
> > Add new variable to pass the irq number for the slaves
> > devices of twl6040.
> > The irq number configuration is done in the twl6040-core
> > at probe time, so machine drivers do not need to be
> > modified.
> > 
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > ---
> > 
> >  drivers/mfd/twl6040-core.c |    2 ++
> >  include/linux/i2c/twl.h    |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> > index cfaedb5..8607793 100644
> > --- a/drivers/mfd/twl6040-core.c
> > +++ b/drivers/mfd/twl6040-core.c
> > @@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct
> > platform_device *pdev)
> > 
> >  	if (pdata->codec) {
> >  	
> >  		cell = &twl6040->cells[children];
> >  		cell->name = "twl6040-codec";
> > 
> > +		pdata->codec->plug_irq = twl6040->irq_base + TWL6040_IRQ_PLUG;
> 
> are the slave devices platform_devices ?? If so, you could use struct
> resource to pass IRQs as that's the "approved" way to do so. Then, on
> child driver, you could either rely on a particular order of the
> resources or assign them names and use platform_get_irq_byname() to
> fetch the correct one (if you have more than one, that is).

You mean something like this:

static struct resource twl6040_codec_rsrc[] = {
	{
		.flags = IORESOURCE_IRQ,
	},
};

...

@@ -501,6 +501,7 @@ static int __devinit twl6040_probe(struct platform_device 
*pdev)
		if (pdata->codec) {
			cell = &twl6040->cells[children];
			cell->name = "twl6040-codec";
+			twl6040_codec_rsrc[0].start = twl6040->irq_base + TWL6040_IRQ_PLUG;
+			twl6040_codec_rsrc[0].end = twl6040->irq_base + TWL6040_IRQ_PLUG;
+			cell->resource = twl6040_codec_rsrc;
+			cell->num_resources = ARRAY_SIZE(twl6040_codec_rsrc);
			cell->platform_data = pdata->codec;
			cell->pdata_size = sizeof(*pdata->codec);
			children++;


-- 
Péter
