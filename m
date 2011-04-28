Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab1D1LbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:31:23 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:33726 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab1D1LbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:31:22 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 07:31:21 EDT
X-Spam-ASN: 
Date: Thu, 28 Apr 2011 15:22:22 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: James Nuss <jamesnuss@nanometrics.ca>
Cc: Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        Ricardo Martins <rasm@fe.up.pt>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
Message-ID: <20110428152222.0271163f@apollo.gnet>
In-Reply-To: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
Organization: LVK
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/7r6nwwfGTO_W.gm78YCCgJR"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7r6nwwfGTO_W.gm78YCCgJR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi James,

=D0=92 Wed, 27 Apr 2011 14:14:14 -0400
James Nuss <jamesnuss@nanometrics.ca> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> This client driver allows you to use raw IRQs as a source for PPS
> signals.
>=20
> This driver is based on the work by Ricardo Martins <rasm@fe.up.pt> who
> submitted an initial implementation [1] of a PPS IRQ client driver to
> the linuxpps mailing-list on Dec 3 2010.
>=20
> [1] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html
>=20
> Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
> Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
> CC: Ricardo Martins <rasm@fe.up.pt>
> ---
> NOTE: drivers/pps/clients/Kconfig does not have the obligatory statements
> regarding building the drivers as modules, even though they are all trist=
ates.
> This was purposefully omitted from the new config item for consistency.
> This could be addressed in a separate patch.
>=20
>  drivers/pps/clients/Kconfig   |    8 ++
>  drivers/pps/clients/Makefile  |    1 +
>  drivers/pps/clients/pps-irq.c |  169 +++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 178 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pps/clients/pps-irq.c
>=20
> diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
> index 8520a7f..94b2cc6 100644
> --- a/drivers/pps/clients/Kconfig
> +++ b/drivers/pps/clients/Kconfig
> @@ -29,4 +29,12 @@ config PPS_CLIENT_PARPORT
>  	  If you say yes here you get support for a PPS source connected
>  	  with the interrupt pin of your parallel port.
> =20
> +config PPS_CLIENT_IRQ
> +	tristate "PPS client based on raw IRQs"
> +	depends on PPS
> +	help
> +	  If you say yes here you get support for a PPS source based
> +	  on raw IRQs. To be useful, you must also register a platform
> +	  device with an IRQ resource, usually in your board setup.
> +
>  endif
> diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
> index 42517da..609a332 100644
> --- a/drivers/pps/clients/Makefile
> +++ b/drivers/pps/clients/Makefile
> @@ -5,6 +5,7 @@
>  obj-$(CONFIG_PPS_CLIENT_KTIMER)	+=3D pps-ktimer.o
>  obj-$(CONFIG_PPS_CLIENT_LDISC)	+=3D pps-ldisc.o
>  obj-$(CONFIG_PPS_CLIENT_PARPORT) +=3D pps_parport.o
> +obj-$(CONFIG_PPS_CLIENT_IRQ)	+=3D pps-irq.o
> =20
>  ifeq ($(CONFIG_PPS_DEBUG),y)
>  EXTRA_CFLAGS +=3D -DDEBUG
> diff --git a/drivers/pps/clients/pps-irq.c b/drivers/pps/clients/pps-irq.c
> new file mode 100644
> index 0000000..33c1bf4
> --- /dev/null
> +++ b/drivers/pps/clients/pps-irq.c
> @@ -0,0 +1,169 @@
> +/*
> + * pps-irq.c -- PPS IRQ client
> + *
> + *
> + * Copyright (C) 2010 Ricardo Martins <rasm@fe.up.pt>
> + * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/pps_kernel.h>
> +#include <linux/gpio.h>
> +#include <linux/list.h>
> +
> +#define PPS_IRQ_NAME            "pps-irq"
> +#define PPS_IRQ_VERSION         "1.1.0"
> +
> +/* Info for each registered platform device */
> +struct pps_irq_data {
> +	int irq;			/* IRQ used as PPS source */
> +	struct pps_device *pps;		/* PPS source device */
> +	struct pps_source_info info;	/* PPS source information */
> +};
> +
> +/*
> + * Report the PPS event
> + */
> +
> +static irqreturn_t pps_irq_irq_handler(int irq, void *data)
> +{
> +	struct pps_irq_data *info;
> +	struct pps_event_time ts;
> +
> +	/* Get the time stamp first */
> +	pps_get_ts(&ts);
> +
> +	info =3D (struct pps_irq_data *)data;
> +	pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int pps_irq_probe(struct platform_device *pdev)
> +{
> +	struct pps_irq_data *data;
> +	struct resource *res;
> +	int irq;
> +	int ret;
> +
> +	/* Validate resource. */
> +	if (pdev->num_resources !=3D 1) {
> +		pr_err(PPS_IRQ_NAME ": this driver handles only one IRQ resource");

Shouldn't the format string in pr_*/dev_* call be ended with a '\n' or I
missed something?
Also I suggest you what I was once suggested: to define pr_fmt() macro
with a module name as in drivers/pps/clients/pps_parport.c to omit
it's use in every pr_* call. :)

> +		return -EINVAL;
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res =3D=3D NULL) {
> +		pr_err(PPS_IRQ_NAME ": no IRQ resource was given");
> +		return -EINVAL;
> +	}
> +
> +	if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
> +		pr_err(PPS_IRQ_NAME ": given IRQ resource must be edge triggered");
> +		return -EINVAL;
> +	}

I think it doesn't actually expect that both flags are set because it
always treats it as assert in the irq handler. What does your signal
look like?

> +	/* Allocate space for device info */
> +	data =3D kzalloc(sizeof(struct pps_irq_data), GFP_KERNEL);
> +	if (data =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	/* Initialize PPS specific parts of the bookkeeping data structure. */
> +	data->info.mode =3D PPS_CAPTUREASSERT | PPS_OFFSETASSERT |
> +			PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
> +	data->info.owner =3D THIS_MODULE;
> +	snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d",
> +		 pdev->name, pdev->id);
> +
> +	/* Register PPS source. */
> +	irq =3D platform_get_irq(pdev, 0);
> +	pr_info(PPS_IRQ_NAME ": registering IRQ %d as PPS source", irq);
> +	data->pps =3D pps_register_source(&data->info, PPS_CAPTUREASSERT
> +					| PPS_OFFSETASSERT);
> +	if (data->pps =3D=3D NULL) {
> +		kfree(data);
> +		pr_err(PPS_IRQ_NAME ": failed to register IRQ %d as PPS source",
> +				irq);
> +		return -1;
> +	}
> +
> +	/* Request IRQ. */
> +	pr_info(PPS_IRQ_NAME ": requesting IRQ %d", irq);
> +	ret =3D request_irq(irq, pps_irq_irq_handler,
> +			 res->flags & IRQF_TRIGGER_MASK,
> +			 data->info.name, data);
> +	if (ret) {
> +		pps_unregister_source(data->pps);
> +		kfree(data);
> +		pr_err(PPS_IRQ_NAME ": failed to acquire IRQ %d\n", irq);
> +		return ret;
> +	}
> +	data->irq =3D irq;
> +
> +	platform_set_drvdata(pdev, data);
> +	dev_info(data->pps->dev, "Registered IRQ %d as PPS source", data->irq);
> +
> +	return 0;
> +}
> +
> +static int pps_irq_remove(struct platform_device *pdev)
> +{
> +	struct pps_irq_data *data =3D platform_get_drvdata(pdev);
> +	platform_set_drvdata(pdev, NULL);
> +	free_irq(data->irq, data);
> +	pps_unregister_source(data->pps);
> +	pr_info(PPS_IRQ_NAME ": removed IRQ %d as PPS source", data->irq);
> +	kfree(data);
> +	return 0;
> +}
> +
> +static struct platform_driver pps_irq_driver =3D {
> +	.probe		=3D pps_irq_probe,
> +	.remove		=3D  __devexit_p(pps_irq_remove),
> +	.driver		=3D {
> +		.name	=3D PPS_IRQ_NAME,
> +		.owner	=3D THIS_MODULE
> +	},
> +};
> +
> +static int __init pps_irq_init(void)
> +{
> +	int ret =3D platform_driver_register(&pps_irq_driver);
> +	if (ret < 0)
> +		pr_err(PPS_IRQ_NAME ": failed to register platform driver");
> +	return ret;
> +}
> +
> +static void __exit pps_irq_exit(void)
> +{
> +	platform_driver_unregister(&pps_irq_driver);
> +	pr_debug(PPS_IRQ_NAME ": unregistered platform driver");
> +}
> +
> +module_init(pps_irq_init);
> +module_exit(pps_irq_exit);
> +
> +MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
> +MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
> +MODULE_DESCRIPTION("Use raw IRQs as PPS source");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(PPS_IRQ_VERSION);


--=20
  Alexander

--Sig_/7r6nwwfGTO_W.gm78YCCgJR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJNuU3vAAoJEElrwznyooJbSmsH/j+jitX1M5PNxk8K0UjXuHNj
4miDavKGoD3xAL1TjvkvY2gyb+Ap9IbUhBZ9cfnRVxTn1LFHdi5FSQuelHWK+2z2
DjMnElZc75HbB75D9Sw/mgKIdGi2gM14x+FgnfNCDoOj1S/fLsn1SpONkyamhrCV
nRC5eXU/HbyS/WjsIsMA0Z3BgNohFF7dYwapwCqM34YCAzMFNBPe93gocLBzoQ3K
5mZrBRvi5brsyfqL6iqxfKZvEnV288yKjtwP0lZC8byCjAz++BvoFZNY++m3YqeY
johfBLAZaGpbQNTWGixUUVTT8i/RcOu0DpApim8+cgIkMuazhVaHgIyq0TgURTM=
=qv00
-----END PGP SIGNATURE-----

--Sig_/7r6nwwfGTO_W.gm78YCCgJR--
