Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2GBILS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:11:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2GBILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:11:15 -0400
Date: Mon, 2 Jul 2012 10:10:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: always save error codes in mmc_regulator_get_supply()
In-Reply-To: <CADTbHxrQtkm_WyMfJvnKtNJi=sjgf46EmWOp6g8053C4R_v7hQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207021003370.15365@axis700.grange>
References: <Pine.LNX.4.64.1206271714270.24173@axis700.grange>
 <CADTbHxrQtkm_WyMfJvnKtNJi=sjgf46EmWOp6g8053C4R_v7hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:PSKE46jkVnZwaUaHn0WfwYuWW6qO++TcJ5X4JkRHOmE
 C7vL03f/8KjsipwiSDxLDLViq023kF2+odbOn/X6AMDIwWEWPf
 oe91vk/aDPySO2Pgugu/53tejFySA35WN/mlYvkn+ek//k4M4N
 00ZTI4+rlBCeX9YgZVdkl6NQDd4n0HUNkQr363QeJYqD6fxjQ4
 x9CHsxw+xMtBoRRCyA2ok9zFOtHXPkGXfETpDXYfaLGf0AnHvf
 jCJU7Z4Hs0Dv6ePEGI0MDrEM3ig2hrz6qxdHWeeKrN+pb0rbIq
 1T4hCStlFpvYC5TiHv+7G8nlTAuf3eQSNJDlIcApaqR7yIPzY8
 8zNx/dNf6d0nZGQG0vIZBpz+QtZwp9GQ5T5HDxU/tkV7NZDwnU
 PdbCC2nEyLvcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 2 Jul 2012, Pankaj Jangra wrote:

> Hi,
> 
> On Wed, Jun 27, 2012 at 8:48 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > If mmc_regulator_get_supply() fails to obtain any of the regulators, store
> > the error codes in struct mmc_host to unify error reporting to the host
> > driver.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > Chris, if you don't mind rebasing your mmc-next branch, feel free to roll
> > this patch into the original "mmc: add a function to get regulators,
> > supplying card's power". Otherwise, committing it as an incremental patch
> > is also ok.
> >
> >  drivers/mmc/core/core.c |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index 385cadf..d0f17d8 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -1020,13 +1020,12 @@ int mmc_regulator_get_supply(struct mmc_host *mmc)
> >         int ret;
> >
> >         supply = devm_regulator_get(dev, "vmmc");
> > +       mmc->supply.vmmc = supply;
> > +       mmc->supply.vqmmc = devm_regulator_get(dev, "vqmmc");
> >
> >         if (IS_ERR(supply))
> >                 return PTR_ERR(supply);
> >
> > -       mmc->supply.vmmc = supply;
> > -       mmc->supply.vqmmc = devm_regulator_get(dev, "vqmmc");
> > -
> 
> I have a doubt here. Though  i am not much know to mmc code, but could
> you please explain what is the benefit of moving these
> statements above the error checking. I mean if you are not able to get
> "vmmc" supply then why do you care to get the supply "vqmmc"

I'm not sure about this. I moving those assignments I achieve two goals:

1. consistency: upon return from that function both supply struct members 
contain either a pointer to the respective regulator, or an error code, 
and both regulators have been tried.
2. maximum flexibility: we try both regulators in any case and let 
individual drivers decide what is acceptable to them. It does seem more 
natural to rely more on the "vmmc" supply than on "vqmmc," but if a driver 
decides to go only with the latter one - why should we prohibit that?

Thanks
Guennadi

> while by this error check you want to bail out from here ASAP and also
> by doing this you are unnecessarily increasing the consumer
> for "vqmmc" supply.  Please let me know if i am missing something here.
> 
> Also if you want to save the error code only you may want to move the
> statement "mmc->supply.vmmc = supply"  only above the error
> checking right?
> 
> >         ret = mmc_regulator_get_ocrmask(supply);
> >         if (ret > 0)
> >                 mmc->ocr_avail = ret;
> > --
> 
> Regards,
> Pankaj Jangra
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
