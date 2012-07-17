Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2GQIvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:51:51 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:38943 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2GQIvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:51:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Rajeev kumar <rajeev-dlh.kumar@st.com>
Subject: Re: [alsa-devel] [PATCH] snd-opti9xx: Implement suspend/resume
Date: Tue, 17 Jul 2012 10:51:01 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201207170916.44277.linux@rainbow-software.org> <50052470.4060604@st.com>
In-Reply-To: <50052470.4060604@st.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201207171051.01687.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012, Rajeev kumar wrote:
> Hello Ondrej,
>
> On 7/17/2012 12:46 PM, Ondrej Zary wrote:
> > Implement suspend/resume support for Opti 92x and 93x chips.
> > Tested with Opti 929A+AD1848 and Opti 931.
> >
> > Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>
> <snip...>
>
> > +#ifdef CONFIG_PM
> > +static int snd_opti9xx_suspend(struct snd_card *card)
> > +{
> > +	struct snd_opti9xx *chip = card->private_data;
> > +
> > +	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
> > +	chip->codec->suspend(chip->codec);
> > +	return 0;
> > +}
> > +
> > +static int snd_opti9xx_resume(struct snd_card *card)
> > +{
> > +	struct snd_opti9xx *chip = card->private_data;
> > +	int error, xdma2;
> > +#if defined(CS4231) || defined(OPTi93X)
> > +	xdma2 = dma2;
> > +#else
> > +	xdma2 = -1;
> > +#endif
> > +
> > +	error = snd_opti9xx_configure(chip, port, irq, dma1, xdma2,
> > +				      mpu_port, mpu_irq);
>
> dma1??

What's wrong with that? It's a global variable. The driver is old and only 
supports one card.

> > +	if (error)
> > +		return error;
>
> Variable name is not convincing. You are assuming that the function is
> returning error.

This is consistent with other code in the driver.
>
> > +	chip->codec->resume(chip->codec);
> > +	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
>
> blank line required.

This is consistent with other code in the driver.

> > +	return 0;
> > +}
> > +
> > +static int snd_opti9xx_isa_suspend(struct device *dev, unsigned int n,
> > +				   pm_message_t state)
> > +{
> > +	return snd_opti9xx_suspend(dev_get_drvdata(dev));
> > +}
> > +
> > +static int snd_opti9xx_isa_resume(struct device *dev, unsigned int n)
> > +{
> > +	return snd_opti9xx_resume(dev_get_drvdata(dev));
> > +}
> > +#endif
> > +
> >   static struct isa_driver snd_opti9xx_driver = {
> >   	.match		= snd_opti9xx_isa_match,
> >   	.probe		= snd_opti9xx_isa_probe,
> >   	.remove		= __devexit_p(snd_opti9xx_isa_remove),
> > -	/* FIXME: suspend/resume */
> > +#ifdef CONFIG_PM
> > +	.suspend	= snd_opti9xx_isa_suspend,
> > +	.resume		= snd_opti9xx_isa_resume,
> > +#endif
> >   	.driver		= {
> >   		.name	= DEV_NAME
> >   	},
> > @@ -1123,12 +1165,29 @@ static void __devexit
> > snd_opti9xx_pnp_remove(struct pnp_card_link * pcard)
> > snd_opti9xx_pnp_is_probed = 0;
> >   }
> >
> > +#ifdef CONFIG_PM
> > +static int snd_opti9xx_pnp_suspend(struct pnp_card_link *pcard,
> > +				   pm_message_t state)
> > +{
> > +	return snd_opti9xx_suspend(pnp_get_card_drvdata(pcard));
> > +}
> > +
> > +static int snd_opti9xx_pnp_resume(struct pnp_card_link *pcard)
> > +{
> > +	return snd_opti9xx_resume(pnp_get_card_drvdata(pcard));
> > +}
> > +#endif
> > +
> >   static struct pnp_card_driver opti9xx_pnpc_driver = {
> >   	.flags		= PNP_DRIVER_RES_DISABLE,
> >   	.name		= "opti9xx",
>
> Why this is opti why not OPTi

It's not my code. This patch is just adding suspend/resume and not changing 
anything else.

> ~Rajeev
>
> >   	.id_table	= snd_opti9xx_pnpids,
> >   	.probe		= snd_opti9xx_pnp_probe,
> >   	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
> > +#ifdef CONFIG_PM
> > +	.suspend	= snd_opti9xx_pnp_suspend,
> > +	.resume		= snd_opti9xx_pnp_resume,
> > +#endif
> >   };
> >   #endif


-- 
Ondrej Zary
