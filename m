Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab0CaJHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:07:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44723 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab0CaJHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M+OpYtSCUtraES3z82EYtTVj4NDMsUVslM4MrF1H71wxw9Gb7Fy/GQ2ifQbgwvB92T
         4pI8fezpeD4e9tlJ8mjPBOR5svRci+8cqdqp/mZmJYGR0ujoOmlQ59ngXdFh7AQb+tR3
         5XEohoIHWj7qpZltUcWRIfET32EvAnpRyXw7o=
MIME-Version: 1.0
In-Reply-To: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
References: <1269970733-24681-1-git-send-email-daniel@caiaq.de>
Date: Wed, 31 Mar 2010 11:07:06 +0200
Message-ID: <x2ve2d7436a1003310207t16a7d1d6r7853de2dfa647c6c@mail.gmail.com>
Subject: Re: [PATCH] libertas/sdio: set ECSI and SCSI bits for 1-bit transfers
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Alagu Sankar <alagusankar@embwise.com>,
       Volker Ernst <volker.ernst@txtr.com>, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>,
       Bing Zhao <bzhao@marvell.com>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/30 Daniel Mack <daniel@caiaq.de>:
[...]
> @@ -1022,6 +1025,27 @@ static int if_sdio_probe(struct sdio_func *func,
>        if (ret)
>                goto disable;
>
> +       /* For 1-bit transfers, we need to enable the interrupt flags in
> +        * the CCCR register. Temporarily set the function number to 0
> +        * for that. */
> +       if ((host->caps & MMC_CAP_SDIO_IRQ) &&
> +           (host->ios.bus_width == MMC_BUS_WIDTH_1)) {
> +               unsigned int num = func->num;
> +               u8 reg;
> +
> +               func->num = 0;
> +               reg = sdio_readb(func, SDIO_CCCR_IF, &ret);
> +               if (ret)
> +                       goto release_int;
> +
> +               reg |= SDIO_BUS_ECSI | SDIO_BUS_SCSI;
> +               sdio_writeb(func, reg, SDIO_CCCR_IF, &ret);
> +               if (ret)
> +                       goto release_int;
> +
> +               func->num = num;
> +       }
> +
>        card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
>        if (ret)
>                goto release_int;

You should probably just use mmc_io_rw_direct() in this case instead
of abusing func->num.

Best Regards,
Micha³ Miros³aw
