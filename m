Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0FUHQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:16:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63408 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0FUHP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T84vOWS84/QngUrtrNEo7+KhhTeN1ilgUAJFaq2Rz8NfsjOSSBpdhsHkLSjBkUQhyJ
         PDUr/HEmCnTWARWqCTDmrTDxSQKToKj8qZcw6AP/+EP9ONt3BYLKPVvc9GpRM1MaNv+K
         tlfbIBhlY16Jkg/I61U1t4WZCt7Kq7redQY8A=
Date: Mon, 21 Jun 2010 11:15:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: "Song, Barry" <Barry.Song@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80:
 Reworkprobing/JEDEC code
Message-ID: <20100621071551.GA16109@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
 <20090818214622.GA22651@oksana.dev.rtsoft.ru>
 <AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com>
 <20100618133212.GA5276@oksana.dev.rtsoft.ru>
 <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com>
 <AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:27:31AM +0800, Barry Song wrote:
[...]
> > How about we add a non_jedec flag in platform_data, if the flag is 1, we
> > let the detection pass even though the ID is 0? Otherwise, we need a
> > valid ID?
> Here i mean:

This will break at least OF-enabled platforms (e.g. PowerPC),
they assume that the driver will success for non-JEDEC flashes.
OF platforms don't pass platform data, and even if they did,
device tree doesn't specify if the flash is JEDEC or non-JEDEC.

Which is why I think that, by default, the driver should
successfully register the flash even if JEDEC probe fails. So,
instead of checking for "!non_jedec", I would recommend
"force_jedec" check.

> Index: drivers/mtd/devices/m25p80.c
> ===================================================================
> --- drivers/mtd/devices/m25p80.c	(revision 8927)
> +++ drivers/mtd/devices/m25p80.c	(revision 8929)
> @@ -795,8 +795,13 @@
> 
>  		jid = jedec_probe(spi);
>  		if (!jid) {
> -			dev_info(&spi->dev, "non-JEDEC variant of %s\n",
> -				 id->name);
> +			if (!data->non_jedec) {
> +				dev_err(&spi->dev, "fail to detect%s\n",
> +						id->name);
> +				return -ENODEV;
> +			} else
> +				dev_info(&spi->dev, "non-JEDEC variant of %s\n",
> +						id->name);
>  		} else if (jid != id) {

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
