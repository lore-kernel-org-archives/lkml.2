Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1F2ViL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:38:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41333 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1F2ViI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:38:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: balbi@ti.com
Subject: Re: [PATCH 1/2] MMC: PM: add suspend/resume in atmel-mci
Date: Wed, 29 Jun 2011 23:39:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org, hans-christian.egtvedt@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@avr32linux.org,
        "Uwe =?iso-8859-2?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
References: <1ef60c032bc39531302c1603bfcb841d2d437ccc.1309366360.git.nicolas.ferre@atmel.com> <20110629160110.GD2760@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110629160110.GD2760@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106292339.12402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 29, 2011, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jun 29, 2011 at 06:54:19PM +0200, Nicolas Ferre wrote:
> > Take care of slots while going to suspend state.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/mmc/host/atmel-mci.c |   51 ++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 51 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> > index aa8039f..c414ebe 100644
> > --- a/drivers/mmc/host/atmel-mci.c
> > +++ b/drivers/mmc/host/atmel-mci.c
> > @@ -1878,8 +1878,59 @@ static int __exit atmci_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM
> > +static int atmci_suspend(struct platform_device *pdev, pm_message_t mesg)
> > +{
> > +	struct atmel_mci *host = platform_get_drvdata(pdev);
> > +	struct atmel_mci_slot *slot;
> > +	int i, ret;
> > +
> > +	 for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> > +		slot = host->slot[i];
> > +		if (!slot)
> > +			continue;
> > +		ret = mmc_suspend_host(slot->mmc);
> > +		if (ret < 0) {
> > +			while (--i >= 0) {
> > +				slot = host->slot[i];
> > +				if (slot)
> > +					mmc_resume_host(host->slot[i]->mmc);
> > +			}
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int atmci_resume(struct platform_device *pdev)
> > +{
> > +	struct atmel_mci *host = platform_get_drvdata(pdev);
> > +	struct atmel_mci_slot *slot;
> > +	int i, ret;
> > +
> > +	for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> > +		slot = host->slot[i];
> > +		if (!slot)
> > +			continue;
> > +		ret = mmc_resume_host(slot->mmc);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +#else
> > +#define atmci_suspend	NULL
> > +#define atmci_resume	NULL
> > +#endif
> > +
> > +
> > +
> >  static struct platform_driver atmci_driver = {
> >  	.remove		= __exit_p(atmci_remove),
> > +	.suspend	= atmci_suspend,
> > +	.resume		= atmci_resume,
> 
> should this be using dev_pm_ops instead ?

It should.  Also, please remember to initialize the hibernate callback
pointers too, e.g. via the SIMPLE_DEV_PM_OPS() macro.

Thanks,
Rafael
