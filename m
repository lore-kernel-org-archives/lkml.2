Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab1D1Uzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:55:39 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:59221 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab1D1Uzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:55:37 -0400
X-Spam-ASN: 
Date: Fri, 29 Apr 2011 00:55:24 +0400
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: James Nuss <jamesnuss@nanometrics.ca>
Cc: Rodolfo Giometti <rodolfo.giometti@enneenne.com>,
        Ricardo Martins <rasm@fe.up.pt>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
Message-ID: <20110429005524.67600139@apollo.gnet>
In-Reply-To: <BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca>
	<20110428152222.0271163f@apollo.gnet>
	<BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/6tKc/MYop7JibDODm3ohHrx"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6tKc/MYop7JibDODm3ohHrx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Thu, 28 Apr 2011 16:03:59 -0400
James Nuss <jamesnuss@nanometrics.ca> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> Hi Alexander,
>=20
> Thanks for reviewing the code.
>=20
> On Thu, Apr 28, 2011 at 7:22 AM, Alexander Gordeev
> <lasaine@lvk.cs.msu.su> wrote:
> > Hi James,
> >
> > =D0=92 Wed, 27 Apr 2011 14:14:14 -0400
> > James Nuss <jamesnuss@nanometrics.ca> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> >
> >> This client driver allows you to use raw IRQs as a source for PPS
> >> signals.
> >>
> >> This driver is based on the work by Ricardo Martins <rasm@fe.up.pt> who
> >> submitted an initial implementation [1] of a PPS IRQ client driver to
> >> the linuxpps mailing-list on Dec 3 2010.
> >>
> >> [1] http://ml.enneenne.com/pipermail/linuxpps/2010-December/004155.html
> >>
> >> Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
> >> Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>
> >> CC: Ricardo Martins <rasm@fe.up.pt>
> >> ---
> >> NOTE: drivers/pps/clients/Kconfig does not have the obligatory stateme=
nts
> >> regarding building the drivers as modules, even though they are all tr=
istates.
> >> This was purposefully omitted from the new config item for consistency.
> >> This could be addressed in a separate patch.
> >>
> >> =C2=A0drivers/pps/clients/Kconfig =C2=A0 | =C2=A0 =C2=A08 ++
> >> =C2=A0drivers/pps/clients/Makefile =C2=A0| =C2=A0 =C2=A01 +
> >> =C2=A0drivers/pps/clients/pps-irq.c | =C2=A0169 ++++++++++++++++++++++=
+++++++++++++++++++
> >> =C2=A03 files changed, 178 insertions(+), 0 deletions(-)
> >> =C2=A0create mode 100644 drivers/pps/clients/pps-irq.c
> >>
> >> diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
> >> index 8520a7f..94b2cc6 100644
> >> --- a/drivers/pps/clients/Kconfig
> >> +++ b/drivers/pps/clients/Kconfig
> >> @@ -29,4 +29,12 @@ config PPS_CLIENT_PARPORT
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 If you say yes here you get support for a =
PPS source connected
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 with the interrupt pin of your parallel po=
rt.
> >>
> >> +config PPS_CLIENT_IRQ
> >> + =C2=A0 =C2=A0 tristate "PPS client based on raw IRQs"
> >> + =C2=A0 =C2=A0 depends on PPS
> >> + =C2=A0 =C2=A0 help
> >> + =C2=A0 =C2=A0 =C2=A0 If you say yes here you get support for a PPS s=
ource based
> >> + =C2=A0 =C2=A0 =C2=A0 on raw IRQs. To be useful, you must also regist=
er a platform
> >> + =C2=A0 =C2=A0 =C2=A0 device with an IRQ resource, usually in your bo=
ard setup.
> >> +
> >> =C2=A0endif
> >> diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefi=
le
> >> index 42517da..609a332 100644
> >> --- a/drivers/pps/clients/Makefile
> >> +++ b/drivers/pps/clients/Makefile
> >> @@ -5,6 +5,7 @@
> >> =C2=A0obj-$(CONFIG_PPS_CLIENT_KTIMER) =C2=A0 =C2=A0 =C2=A0+=3D pps-kti=
mer.o
> >> =C2=A0obj-$(CONFIG_PPS_CLIENT_LDISC) =C2=A0 =C2=A0 =C2=A0 +=3D pps-ldi=
sc.o
> >> =C2=A0obj-$(CONFIG_PPS_CLIENT_PARPORT) +=3D pps_parport.o
> >> +obj-$(CONFIG_PPS_CLIENT_IRQ) +=3D pps-irq.o
> >>
> >> =C2=A0ifeq ($(CONFIG_PPS_DEBUG),y)
> >> =C2=A0EXTRA_CFLAGS +=3D -DDEBUG
> >> diff --git a/drivers/pps/clients/pps-irq.c b/drivers/pps/clients/pps-i=
rq.c
> >> new file mode 100644
> >> index 0000000..33c1bf4
> >> --- /dev/null
> >> +++ b/drivers/pps/clients/pps-irq.c
> >> @@ -0,0 +1,169 @@
> >> +/*
> >> + * pps-irq.c -- PPS IRQ client
> >> + *
> >> + *
> >> + * Copyright (C) 2010 Ricardo Martins <rasm@fe.up.pt>
> >> + * Copyright (C) 2011 James Nuss <jamesnuss@nanometrics.ca>
> >> + *
> >> + * =C2=A0 This program is free software; you can redistribute it and/=
or modify
> >> + * =C2=A0 it under the terms of the GNU General Public License as pub=
lished by
> >> + * =C2=A0 the Free Software Foundation; either version 2 of the Licen=
se, or
> >> + * =C2=A0 (at your option) any later version.
> >> + *
> >> + * =C2=A0 This program is distributed in the hope that it will be use=
ful,
> >> + * =C2=A0 but WITHOUT ANY WARRANTY; without even the implied warranty=
 of
> >> + * =C2=A0 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =C2=A0=
See the
> >> + * =C2=A0 GNU General Public License for more details.
> >> + *
> >> + * =C2=A0 You should have received a copy of the GNU General Public L=
icense
> >> + * =C2=A0 along with this program; if not, write to the Free Software
> >> + * =C2=A0 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> >> + */
> >> +
> >> +#include <linux/init.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/module.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/pps_kernel.h>
> >> +#include <linux/gpio.h>
> >> +#include <linux/list.h>
> >> +
> >> +#define PPS_IRQ_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0"pps-ir=
q"
> >> +#define PPS_IRQ_VERSION =C2=A0 =C2=A0 =C2=A0 =C2=A0 "1.1.0"
> >> +
> >> +/* Info for each registered platform device */
> >> +struct pps_irq_data {
> >> + =C2=A0 =C2=A0 int irq; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* IRQ used as PPS source */
> >> + =C2=A0 =C2=A0 struct pps_device *pps; =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*=
 PPS source device */
> >> + =C2=A0 =C2=A0 struct pps_source_info info; =C2=A0 =C2=A0/* PPS sourc=
e information */
> >> +};
> >> +
> >> +/*
> >> + * Report the PPS event
> >> + */
> >> +
> >> +static irqreturn_t pps_irq_irq_handler(int irq, void *data)
> >> +{
> >> + =C2=A0 =C2=A0 struct pps_irq_data *info;
> >> + =C2=A0 =C2=A0 struct pps_event_time ts;
> >> +
> >> + =C2=A0 =C2=A0 /* Get the time stamp first */
> >> + =C2=A0 =C2=A0 pps_get_ts(&ts);
> >> +
> >> + =C2=A0 =C2=A0 info =3D (struct pps_irq_data *)data;
> >> + =C2=A0 =C2=A0 pps_event(info->pps, &ts, PPS_CAPTUREASSERT, NULL);
> >> +
> >> + =C2=A0 =C2=A0 return IRQ_HANDLED;
> >> +}
> >> +
> >> +static int pps_irq_probe(struct platform_device *pdev)
> >> +{
> >> + =C2=A0 =C2=A0 struct pps_irq_data *data;
> >> + =C2=A0 =C2=A0 struct resource *res;
> >> + =C2=A0 =C2=A0 int irq;
> >> + =C2=A0 =C2=A0 int ret;
> >> +
> >> + =C2=A0 =C2=A0 /* Validate resource. */
> >> + =C2=A0 =C2=A0 if (pdev->num_resources !=3D 1) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": thi=
s driver handles only one IRQ resource");
> >
> > Shouldn't the format string in pr_*/dev_* call be ended with a '\n' or I
> > missed something?
> > Also I suggest you what I was once suggested: to define pr_fmt() macro
> > with a module name as in drivers/pps/clients/pps_parport.c to omit
> > it's use in every pr_* call. :)
>=20
> You are right with the '\n'. My mistake.
> Good suggestion on the pr_fmt() macro - that's much cleaner.

Ok, good.

> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 res =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> + =C2=A0 =C2=A0 if (res =3D=3D NULL) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": no =
IRQ resource was given");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER=
_FALLING))) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": giv=
en IRQ resource must be edge triggered");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EINVAL;
> >> + =C2=A0 =C2=A0 }
> >
> > I think it doesn't actually expect that both flags are set because it
> > always treats it as assert in the irq handler. What does your signal
> > look like?
>=20
> The conditional logic is that one of either IRQF_TRIGGER_RISING or
> IRQF_TRIGGER_FALLING must be set. It doesn't make much sense to have
> neither set for PPS signals.
> My intention is that the driver is generic enough so you can register
> an IRQ resource with either IRQF_TRIGGER_RISING or
> IRQF_TRIGGER_FALLING and you will get and assert event for that edge.
> Clear events are not generated as you suggest but I believe this is
> OK.
> My signal is a simple low-to-high transition indicating the PPS. But I
> believe you could register a device using this driver referencing the
> other edge if required.

Ok, but is there a way one can register an IRQ resource with both flags
set? If yes, then it would be nice to have a stricter check here to
prevent two situations:
1. none flag is set (it is already in place)
2. both flags are set

The latter will definitely mess things up, right?

> >
> >> + =C2=A0 =C2=A0 /* Allocate space for device info */
> >> + =C2=A0 =C2=A0 data =3D kzalloc(sizeof(struct pps_irq_data), GFP_KERN=
EL);
> >> + =C2=A0 =C2=A0 if (data =3D=3D NULL)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >> +
> >> + =C2=A0 =C2=A0 /* Initialize PPS specific parts of the bookkeeping da=
ta structure. */
> >> + =C2=A0 =C2=A0 data->info.mode =3D PPS_CAPTUREASSERT | PPS_OFFSETASSE=
RT |
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 PPS_ECHOASSERT | PPS_CANWAIT | PPS_TSFMT_TSPEC;
> >> + =C2=A0 =C2=A0 data->info.owner =3D THIS_MODULE;
> >> + =C2=A0 =C2=A0 snprintf(data->info.name, PPS_MAX_NAME_LEN - 1, "%s.%d=
",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pdev->name, pdev->id=
);
> >> +
> >> + =C2=A0 =C2=A0 /* Register PPS source. */
> >> + =C2=A0 =C2=A0 irq =3D platform_get_irq(pdev, 0);
> >> + =C2=A0 =C2=A0 pr_info(PPS_IRQ_NAME ": registering IRQ %d as PPS sour=
ce", irq);
> >> + =C2=A0 =C2=A0 data->pps =3D pps_register_source(&data->info, PPS_CAP=
TUREASSERT
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | PPS_OFFSETASS=
ERT);
> >> + =C2=A0 =C2=A0 if (data->pps =3D=3D NULL) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(data);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": fai=
led to register IRQ %d as PPS source",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 irq);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 /* Request IRQ. */
> >> + =C2=A0 =C2=A0 pr_info(PPS_IRQ_NAME ": requesting IRQ %d", irq);
> >> + =C2=A0 =C2=A0 ret =3D request_irq(irq, pps_irq_irq_handler,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0res->flags & IRQF_TRIGGER_MASK,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0data->info.name, data);
> >> + =C2=A0 =C2=A0 if (ret) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pps_unregister_source(data=
->pps);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(data);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": fai=
led to acquire IRQ %d\n", irq);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> >> + =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 data->irq =3D irq;
> >> +
> >> + =C2=A0 =C2=A0 platform_set_drvdata(pdev, data);
> >> + =C2=A0 =C2=A0 dev_info(data->pps->dev, "Registered IRQ %d as PPS sou=
rce", data->irq);
> >> +
> >> + =C2=A0 =C2=A0 return 0;
> >> +}
> >> +
> >> +static int pps_irq_remove(struct platform_device *pdev)
> >> +{
> >> + =C2=A0 =C2=A0 struct pps_irq_data *data =3D platform_get_drvdata(pde=
v);
> >> + =C2=A0 =C2=A0 platform_set_drvdata(pdev, NULL);
> >> + =C2=A0 =C2=A0 free_irq(data->irq, data);
> >> + =C2=A0 =C2=A0 pps_unregister_source(data->pps);
> >> + =C2=A0 =C2=A0 pr_info(PPS_IRQ_NAME ": removed IRQ %d as PPS source",=
 data->irq);
> >> + =C2=A0 =C2=A0 kfree(data);
> >> + =C2=A0 =C2=A0 return 0;
> >> +}
> >> +
> >> +static struct platform_driver pps_irq_driver =3D {
> >> + =C2=A0 =C2=A0 .probe =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D pps_irq_p=
robe,
> >> + =C2=A0 =C2=A0 .remove =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0__devexi=
t_p(pps_irq_remove),
> >> + =C2=A0 =C2=A0 .driver =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .name =C2=A0 =3D PPS_IRQ_N=
AME,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .owner =C2=A0=3D THIS_MODU=
LE
> >> + =C2=A0 =C2=A0 },
> >> +};
> >> +
> >> +static int __init pps_irq_init(void)
> >> +{
> >> + =C2=A0 =C2=A0 int ret =3D platform_driver_register(&pps_irq_driver);
> >> + =C2=A0 =C2=A0 if (ret < 0)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pr_err(PPS_IRQ_NAME ": fai=
led to register platform driver");
> >> + =C2=A0 =C2=A0 return ret;
> >> +}
> >> +
> >> +static void __exit pps_irq_exit(void)
> >> +{
> >> + =C2=A0 =C2=A0 platform_driver_unregister(&pps_irq_driver);
> >> + =C2=A0 =C2=A0 pr_debug(PPS_IRQ_NAME ": unregistered platform driver"=
);
> >> +}
> >> +
> >> +module_init(pps_irq_init);
> >> +module_exit(pps_irq_exit);
> >> +
> >> +MODULE_AUTHOR("Ricardo Martins <rasm@fe.up.pt>");
> >> +MODULE_AUTHOR("James Nuss <jamesnuss@nanometrics.ca>");
> >> +MODULE_DESCRIPTION("Use raw IRQs as PPS source");
> >> +MODULE_LICENSE("GPL");
> >> +MODULE_VERSION(PPS_IRQ_VERSION);
> >
> >
> > --
> > =C2=A0Alexander
> >


--=20
  Alexander

--Sig_/6tKc/MYop7JibDODm3ohHrx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJNudQ8AAoJEElrwznyooJbpRUH/2jWwmCXOELL3NsPDmLNAC8K
PHG7Ll2PIhemsP+2nUSKH+VKdmpbH2L6zOlR0U7fsUc2pylN+5RNpR5MCpdOQlEL
VDSfKSGSG7IaQSlhT5e4tVF5p5+JovvxR929UucU7/Zt892e8buEanFFasPcpy8X
i+bkLplzvgfan9i3lbSa28sIHhX72lcOlyoQRM4vyWH3ni/734XuggVhu2E6G9j8
XepfLF4lEVPlV5Mkf0wgBNT96ax/3tXq0rukNCae+rzJG79g7Sju5MkoNRfwkz0G
X8LDiUsmJvR7+nuDOhM0HMW4BVa1va/+FjR4k2ZDy9unKvA3D+Y1EflxPns7tbo=
=/i54
-----END PGP SIGNATURE-----

--Sig_/6tKc/MYop7JibDODm3ohHrx--
