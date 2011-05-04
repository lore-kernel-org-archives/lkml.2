Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1EDQYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:24:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61487 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1EDQX7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lZDcTu/kEj8eJraPeox7pZ4/tl94Pl2siaJEd2Rt1gQYS9I/vXqala781nQ6LvTtQZ
         SRbIN4uLjUDwp+ebfUuUq6hkCxwuk2/79NjPcBcHCD1wiHE5TRYlKSJbiIf2TTVoxHMs
         en6ou/G98cFULLwuwwEFe2fq3XdKd5Vvc/j14=
MIME-Version: 1.0
In-Reply-To: <1304525161-14448-2-git-send-email-per.forlin@linaro.org>
References: <1304525161-14448-1-git-send-email-per.forlin@linaro.org> <1304525161-14448-2-git-send-email-per.forlin@linaro.org>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 4 May 2011 18:23:38 +0200
Message-ID: <BANLkTi=LsmSepyUMbO7q2hG5-HWbRduO+Q@mail.gmail.com>
Subject: Re: [PATCH v2] sdio: optimized SDIO IRQ handling for single irq
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/4 Per Forlin <per.forlin@linaro.org>:
> From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
>
> If there is only 1 function registered it is possible to
> improve performance by directly calling the irq handler
> and avoiding the overhead of reading the CCCR registers.
>
[...]
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -32,6 +32,16 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
>        int i, ret, count;
>        unsigned char pending;
>
> +       /*
> +        * Optimization, if there is only 1 function registered
> +        * call irq handler directly
> +        */
> +       if (card->sdio_single_irq && card->sdio_single_irq->irq_handler) {
> +               struct sdio_func *func = card->sdio_single_irq;
> +               func->irq_handler(func);
> +               return 1;
> +       }
[...]

The second condition can be avoided:

in process_sdio_pending_irqs():

if (card->sdio_irq_func)
   call handler and return

in sdio_claim_irq():

  card->func->irq_handler = ...
  if (host->sdio_irqs == 1)
    card->sdio_irq_func = func;
  else
    card->sdio_irq_func = NULL;

in sdio_release_irq():

  card->sdio_irq_func = NULL;
  card->func->irq_handler = ...
  sdio_card_irq_put();
  if (host->sdio_irqs == 1)
    sdio_single_irq_set(func->card);

in struct mmc_card:
  struct sdio_func        *sdio_irq_func;

Best Regards,
Micha³ Miros³aw
