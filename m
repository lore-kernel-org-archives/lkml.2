Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2H0MqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:46:17 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40408 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab2H0MqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:46:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,320,1344204000"; 
   d="scan'208";a="170936283"
Date: Mon, 27 Aug 2012 14:46:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Ulf Hansson <ulf.hansson@linaro.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Chris Ball <cjb@laptop.org>,
        kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/13] drivers/mmc/host/mmci.c: use clk_prepare_enable
 and clk_disable_unprepare
In-Reply-To: <CAPDyKFpf+PzMspT7CECpd=ZVdmp=7i4-pr-6StK8N1aRczNryw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1208271442120.2079@hadrien>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr> <1345996865-32082-8-git-send-email-Julia.Lawall@lip6.fr> <CAPDyKFpf+PzMspT7CECpd=ZVdmp=7i4-pr-6StK8N1aRczNryw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Ulf Hansson wrote:

> Hi Julia,
>
> Patches for mmci should normally be sent on the arm list as well. mmci
> is maintained by Russell King, even if the MAINTAINER file does not
> say so.

Would it be possible to update the MAINTAINER file?

> Some minor comment below.
>
> On 26 August 2012 18:00, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
>
> I think can simplify the commit msg a lot. Just say something with
> "simplify clock code in probe".

OK, I wasn't familiar with these functions before, so I wanted to explain
my rationale for making the change, in case I was totally off base.

> > Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> > clk_enable, and clk_disable and clk_unprepare.  They make the code more
> > concise, and ensure that clk_unprepare is called when clk_enable fails.
> >
> > A simplified version of the semantic patch that introduces calls to these
> > functions is as follows: (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > expression e;
> > @@
> >
> > - clk_prepare(e);
> > - clk_enable(e);
> > + clk_prepare_enable(e);
> >
> > @@
> > expression e;
> > @@
> >
> > - clk_disable(e);
> > - clk_unprepare(e);
> > + clk_disable_unprepare(e);
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/mmc/host/mmci.c |   13 +++----------
> >  1 file changed, 3 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> > index 50ff19a..edc3e9b 100644
> > --- a/drivers/mmc/host/mmci.c
> > +++ b/drivers/mmc/host/mmci.c
> > @@ -1309,14 +1309,10 @@ static int __devinit mmci_probe(struct amba_device *dev,
> >                 goto host_free;
> >         }
> >
> > -       ret = clk_prepare(host->clk);
> > +       ret = clk_prepare_enable(host->clk);
>
> white space? Did you run checkpatch?

Yes, I did.  And I did so again just now:

palace:linux-next: scripts/checkpatch.pl ~/patches/prepare2/send7
total: 0 errors, 0 warnings, 34 lines checked

/home/julia/patches/prepare2/send7 has no obvious style problems and is
ready for submission.  I can see that in your reply there are no tabs,
only space.  If you received it that way, perhaps it is a mailer problem
on my side, although I didn't do anything unusual for this patch.

I will try again.

julia


> >         if (ret)
> >                 goto clk_free;
> >
> > -       ret = clk_enable(host->clk);
> > -       if (ret)
> > -               goto clk_unprep;
> > -
> >         host->plat = plat;
> >         host->variant = variant;
> >         host->mclk = clk_get_rate(host->clk);
> > @@ -1515,9 +1511,7 @@ static int __devinit mmci_probe(struct amba_device *dev,
> >   err_gpio_cd:
> >         iounmap(host->base);
> >   clk_disable:
> > -       clk_disable(host->clk);
> > - clk_unprep:
> > -       clk_unprepare(host->clk);
> > +       clk_disable_unprepare(host->clk);
>
> white space? Did you run checkpatch?
>
> >   clk_free:
> >         clk_put(host->clk);
> >   host_free:
> > @@ -1564,8 +1558,7 @@ static int __devexit mmci_remove(struct amba_device *dev)
> >                         gpio_free(host->gpio_cd);
> >
> >                 iounmap(host->base);
> > -               clk_disable(host->clk);
> > -               clk_unprepare(host->clk);
> > +               clk_disable_unprepare(host->clk);
>
> white space? Did you run checkpatch?
>
> >                 clk_put(host->clk);
> >
> >                 if (host->vcc)
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Kind regards
> Ulf Hansson
>
