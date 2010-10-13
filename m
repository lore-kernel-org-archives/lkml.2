Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0JMUA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:00:58 -0400
Received: from relais.videotron.ca ([24.201.245.36]:14614 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0JMUA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:00:56 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_kD9Z/OuJ5rQCTcIQggTcaQ)"
Date: Wed, 13 Oct 2010 16:00:55 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-mmc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        libertas-dev@lists.infradead.org,
        Sven Neumann <s.neumann@raumfeld.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        stable@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sdio: fix suspend/resume regression
In-reply-to: <AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1010131559580.2764@xanadu.home>
References: <1286788315.3101.11.camel@sven>
 <1286955116-22793-1-git-send-email-ohad@wizery.com>
 <AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_kD9Z/OuJ5rQCTcIQggTcaQ)
Content-type: TEXT/PLAIN; charset=ISO-8859-1
Content-transfer-encoding: 8BIT

On Wed, 13 Oct 2010, Vitaly Wool wrote:

> Hi Ohad,
> 
> On Wed, Oct 13, 2010 at 9:31 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> 
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index c94565d..515ff39 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -1682,6 +1682,19 @@ int mmc_suspend_host(struct mmc_host *host)
> >        if (host->bus_ops && !host->bus_dead) {
> >                if (host->bus_ops->suspend)
> >                        err = host->bus_ops->suspend(host);
> > +               if (err == -ENOSYS || !host->bus_ops->resume) {
> > +                       /*
> > +                        * We simply "remove" the card in this case.
> > +                        * It will be redetected on resume.
> > +                        */
> > +                       if (host->bus_ops->remove)
> > +                               host->bus_ops->remove(host);
> > +                       mmc_claim_host(host);
> > +                       mmc_detach_bus(host);
> > +                       mmc_release_host(host);
> > +                       host->pm_flags = 0;
> > +                       err = 0;
> > +               }
> >        }
> >        mmc_bus_put(host);
> >
> 
> what about moving this logic to sdio bus_ops as this seems to be
> completely specific to sdio right now?

It doesn't have to.


Nicolas

--Boundary_(ID_kD9Z/OuJ5rQCTcIQggTcaQ)--
