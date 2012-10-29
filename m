Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab2J2MVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:21:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57562 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861Ab2J2MVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:21:06 -0400
Subject: Re: [PATCH v5 3/4] misc: sram: Add optional clock
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CAP=VYLpwahaxVssP1bXmp+ttM_eArF9B2DX1auiOmterdHHUGw@mail.gmail.com>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
	 <1350570453-24546-4-git-send-email-p.zabel@pengutronix.de>
	 <CAP=VYLpwahaxVssP1bXmp+ttM_eArF9B2DX1auiOmterdHHUGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 13:20:57 +0100
Message-ID: <1351513257.5872.104.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 26.10.2012, 12:17 -0400 schrieb Paul Gortmaker:
> On Thu, Oct 18, 2012 at 10:27 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > On some platforms the SRAM needs a clock to be enabled explicitly.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/misc/sram.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> > index 7a363f2..0cc2e75 100644
> > --- a/drivers/misc/sram.c
> > +++ b/drivers/misc/sram.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> > +#include <linux/clk.h>
> > +#include <linux/err.h>
> >  #include <linux/io.h>
> >  #include <linux/of.h>
> >  #include <linux/platform_device.h>
> > @@ -29,6 +31,7 @@
> >
> >  struct sram_dev {
> >         struct gen_pool *pool;
> > +       struct clk *clk;
> >  };
> 
> I see another field gets added to the struct here.  (yet another
> reason to have it folded into the original)   But you still
> really don't need to create a sram_dev for this, because...
> 
> >
> >  static int __devinit sram_probe(struct platform_device *pdev)
> > @@ -53,6 +56,10 @@ static int __devinit sram_probe(struct platform_device *pdev)
> >         if (!sram)
> >                 return -ENOMEM;
> >
> > +       sram->clk = devm_clk_get(&pdev->dev, NULL);
> > +       if (!IS_ERR(sram->clk))
> > +               clk_prepare_enable(sram->clk);
> > +
> >         sram->pool = gen_pool_create(PAGE_SHIFT, -1);
> >         if (!sram->pool)
> >                 return -ENOMEM;
> > @@ -80,6 +87,9 @@ static int __devexit sram_remove(struct platform_device *pdev)
> >
> >         gen_pool_destroy(sram->pool);
> >
> > +       if (!IS_ERR(sram->clk))
> > +               clk_disable_unprepare(sram->clk);
> > +
> 
> ...here, this looks confusing with the use of IS_ERR on
> an entity that was not recently assigned to.

Right.
How about I set sram->clk = NULL in sram_probe if devm_clk_get returns
an error value?

> Instead, just
> put a "struct clk *clk;" on the stack and do the
> 
>    clk = devm_clk_get(&pdev->dev, NULL);
> 
> in both the init and the teardown.  Then the code will be
> more readable.

Calling devm_clk_get on the same clock twice seems a bit weird.
I expect that eventually someone will want to disable clocks during
suspend, so I'd prefer to keep the clk pointer around.

regards
Philipp

