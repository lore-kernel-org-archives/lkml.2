Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab0CaJIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:08:46 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39844 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943Ab0CaJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:08:42 -0400
Date: Wed, 31 Mar 2010 11:08:36 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit
 transfers
Message-ID: <20100331090836.GA30801@buzzloop.caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
 <x2ve2d7436a1003310207t16a7d1d6r7853de2dfa647c6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x2ve2d7436a1003310207t16a7d1d6r7853de2dfa647c6c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 11:07:06AM +0200, Michał Mirosław wrote:
> 2010/3/30 Daniel Mack <daniel@caiaq.de>:
> [...]
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
> 
> You should probably just use mmc_io_rw_direct() in this case instead
> of abusing func->num.

Hmm, that function isn't exported, and I didn't want to change this. You
say you'd prefer that? I can cook up something that does it, no problem.


Daniel
