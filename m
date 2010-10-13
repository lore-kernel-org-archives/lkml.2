Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0JMHyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:54:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62264 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0JMHya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UWUuwVlVCEgNtKO03q6epBAV2cF95pZWb9yDkTpw4pNtgYrSeciWYvn/K76Ox48+7D
         jC8jS3atRvAr+3ic29SBikRBNGafZLFtUMp5Cb5YiZO/GZm6EURKcPiuT64bmJ+4z7kj
         mLDyjf3EMEoyQvJPdH4qOPfQ41xbWJnuHy0pU=
MIME-Version: 1.0
In-Reply-To: <1286955116-22793-1-git-send-email-ohad@wizery.com>
References: <1286788315.3101.11.camel@sven>
	<1286955116-22793-1-git-send-email-ohad@wizery.com>
Date: Wed, 13 Oct 2010 09:54:29 +0200
Message-ID: <AANLkTiki_Sky6pry+vWAoTtJ5ctVUpawAH6iRYV6L-+z@mail.gmail.com>
Subject: Re: [PATCH] sdio: fix suspend/resume regression
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        libertas-dev@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>,
        Sven Neumann <s.neumann@raumfeld.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Chris Ball <cjb@laptop.org>,
        stable@kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Wed, Oct 13, 2010 at 9:31 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index c94565d..515ff39 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -1682,6 +1682,19 @@ int mmc_suspend_host(struct mmc_host *host)
>        if (host->bus_ops && !host->bus_dead) {
>                if (host->bus_ops->suspend)
>                        err = host->bus_ops->suspend(host);
> +               if (err == -ENOSYS || !host->bus_ops->resume) {
> +                       /*
> +                        * We simply "remove" the card in this case.
> +                        * It will be redetected on resume.
> +                        */
> +                       if (host->bus_ops->remove)
> +                               host->bus_ops->remove(host);
> +                       mmc_claim_host(host);
> +                       mmc_detach_bus(host);
> +                       mmc_release_host(host);
> +                       host->pm_flags = 0;
> +                       err = 0;
> +               }
>        }
>        mmc_bus_put(host);
>

what about moving this logic to sdio bus_ops as this seems to be
completely specific to sdio right now?

Thanks,
   Vitaly
