Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2LDO4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:56:39 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57727 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2LDO4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <1354566504-17657-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1354566504-17657-1-git-send-email-vivien.didelot@savoirfairelinux.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 4 Dec 2012 14:56:15 +0000
X-Google-Sender-Auth: ZWjI594xgP2M_SLVW1WjPM_oj1E
Message-ID: <CACxGe6tgMFd8XujkK9qFdkXC_ASA0-2H=vFopkCp+oaFCyTg9A@mail.gmail.com>
Subject: Re: [PATCH RESEND] spi: erase pointer to drvdata on removal
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 8:28 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:
> Without this patch, a SPI device may keep its drvdata whereas it was unbound
> from its driver. This may result in accessing an invalid pointer.
>
> As for i2c-core, let the SPI core handle the removal of the device's drvdata,
> after a remove(), or a probe() failure.
>
> This is a resent of the previous patch https://lkml.org/lkml/2012/11/1/314
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Are you seeing a real bug without this patch? If so, then that is a
driver bug. I don't want to mask over bugs silently. The kernel should
complain.

There are actually lots of things that drivers should/should-not do
that could be checked by the probe/remove hooks, and not just in the
SPI code. spi_set_drvdata() is actually just a wrapper around
dev_set_drvdata().

Instead of clearing the pointer only in the spi code, perhaps the
checks should be in really_probe() and __device_release_driver() so it
covers all bus types. Also, don't clear the pointer. Just use
dev_err() to report on the driver bug so that it gets fixed properly.

g.

> ---
>  drivers/spi/spi.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 84c2861..fe636fe 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -233,15 +233,25 @@ EXPORT_SYMBOL_GPL(spi_bus_type);
>  static int spi_drv_probe(struct device *dev)
>  {
>         const struct spi_driver         *sdrv = to_spi_driver(dev->driver);
> +       struct spi_device               *sdev = to_spi_device(dev);
> +       int                             status;
>
> -       return sdrv->probe(to_spi_device(dev));
> +       status = sdrv->probe(sdev);
> +       if (status)
> +               spi_set_drvdata(sdev, NULL);
> +       return status;
>  }
>
>  static int spi_drv_remove(struct device *dev)
>  {
>         const struct spi_driver         *sdrv = to_spi_driver(dev->driver);
> +       struct spi_device               *sdev = to_spi_device(dev);
> +       int                             status;
>
> -       return sdrv->remove(to_spi_device(dev));
> +       status = sdrv->remove(sdev);
> +       if (status == 0)
> +               spi_set_drvdata(sdev, NULL);
> +       return status;
>  }
>
>  static void spi_drv_shutdown(struct device *dev)
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
