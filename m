Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab0CaNeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 09:34:21 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43594 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab0CaNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 09:34:19 -0400
Date: Wed, 31 Mar 2010 15:34:14 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alagu Sankar Vellaichamy <alagusankar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Volker Ernst <volker.ernst@txtr.com>,
       Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit
 transfers
Message-ID: <20100331133414.GI30807@buzzloop.caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
 <y2q703729f11003310123w505134f8y61efb0c9f7168a30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <y2q703729f11003310123w505134f8y61efb0c9f7168a30@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:53:21PM +0530, Alagu Sankar Vellaichamy wrote:
> SCSI is read-only.  We ideally should be checking this bit and then
> set the ECSI accordingly, rather than setting both ECSI and SCSI.

Thanks for noticing. However, the libertas chip does not set SCSI, so we
have to do it unconditionally. New patch has just been sent.

Daniel




> On Tue, Mar 30, 2010 at 11:08 PM, Daniel Mack <daniel@caiaq.de> wrote:
> > When operating in 1-bit mode, SDAT1 is used as dedicated interrupt line.
> > However, the 8686 will only drive this line when the ECSI and SCSI bits
> > are set in the CCCR_IF register.
> >
> > Thanks to Alagu Sankar for pointing me in the right direction.
> >
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Alagu Sankar <alagusankar@embwise.com>
> > Cc: Volker Ernst <volker.ernst@txtr.com>
> > Cc: Dan Williams <dcbw@redhat.com>
> > Cc: John W. Linville <linville@tuxdriver.com>
> > Cc: Holger Schurig <hs4233@mail.mn-solutions.de>
> > Cc: Bing Zhao <bzhao@marvell.com>
> > Cc: libertas-dev@lists.infradead.org
> > Cc: linux-wireless@vger.kernel.org
> > Cc: linux-mmc@vger.kernel.org
> > ---
> >  drivers/net/wireless/libertas/if_sdio.c |   24 ++++++++++++++++++++++++
> >  include/linux/mmc/sdio.h                |    2 ++
> >  2 files changed, 26 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> > index 7a73f62..d3170f2 100644
> > --- a/drivers/net/wireless/libertas/if_sdio.c
> > +++ b/drivers/net/wireless/libertas/if_sdio.c
> > @@ -34,6 +34,8 @@
> >  #include <linux/mmc/card.h>
> >  #include <linux/mmc/sdio_func.h>
> >  #include <linux/mmc/sdio_ids.h>
> > +#include <linux/mmc/sdio.h>
> > +#include <linux/mmc/host.h>
> >
> >  #include "host.h"
> >  #include "decl.h"
> > @@ -942,6 +944,7 @@ static int if_sdio_probe(struct sdio_func *func,
> >        int ret, i;
> >        unsigned int model;
> >        struct if_sdio_packet *packet;
> > +       struct mmc_host *host = func->card->host;
> >
> >        lbs_deb_enter(LBS_DEB_SDIO);
> >
> > @@ -1022,6 +1025,27 @@ static int if_sdio_probe(struct sdio_func *func,
> >        if (ret)
> >                goto disable;
> >
> > +       /* For 1-bit transfers, we need to enable the interrupt flags in
> > +        * the CCCR register. Temporarily set the function number to 0
> > +        * for that. */
> > +       if ((host->caps & MMC_CAP_SDIO_IRQ) &&
> > +           (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
> > +               unsigned int num = func->num;
> > +               u8 reg;
> > +
> > +               func->num = 0;
> > +               reg = sdio_readb(func, SDIO_CCCR_IF, &ret);
> > +               if (ret)
> > +                       goto release_int;
> > +
> > +               reg |= SDIO_BUS_ECSI | SDIO_BUS_SCSI;
> > +               sdio_writeb(func, reg, SDIO_CCCR_IF, &ret);
> > +               if (ret)
> > +                       goto release_int;
> > +
> > +               func->num = num;
> > +       }
> > +
> >        card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
> >        if (ret)
> >                goto release_int;
> > diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
> > index 0ebaef5..329a8fa 100644
> > --- a/include/linux/mmc/sdio.h
> > +++ b/include/linux/mmc/sdio.h
> > @@ -94,6 +94,8 @@
> >
> >  #define  SDIO_BUS_WIDTH_1BIT   0x00
> >  #define  SDIO_BUS_WIDTH_4BIT   0x02
> > +#define  SDIO_BUS_ECSI         0x20    /* Enable continuous SPI interrupt */
> > +#define  SDIO_BUS_SCSI         0x40    /* Support continuous SPI interrupt */
> >
> >  #define  SDIO_BUS_ASYNC_INT    0x20
> >
> > --
> > 1.7.0
> >
> >
