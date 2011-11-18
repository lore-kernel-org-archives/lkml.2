Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1KRTSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:18:55 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48957 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab1KRTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:18:54 -0500
Date: Fri, 18 Nov 2011 21:18:50 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, linux-omap@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        "Govindraj.R" <govindraj.raja@ti.com>,
        "Avinash.H.M" <avinashhm@ti.com>, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv9 06/18] mfd: omap-prm: added chain interrupt handler
Message-ID: <20111118191849.GB11736@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
 <1316781986-30642-7-git-send-email-t-kristo@ti.com>
 <87aa7u1ipl.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <87aa7u1ipl.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 17, 2011 at 02:34:46PM -0800, Kevin Hilman wrote:
> Tero Kristo <t-kristo@ti.com> writes:
>=20
> > Introduce a chained interrupt handler mechanism for the PRCM
> > interrupt, so that individual PRCM event can cleanly be handled by
> > handlers in separate drivers. We do this by introducing PRCM event
> > names, which are then matched to the particular PRCM interrupt bit
> > depending on the specific OMAP SoC being used.
> >
> > PRCM interrupts have two priority levels, high or normal. High priority
> > is needed for IO event handling, so that we can be sure that IO events
> > are processed before other events. This reduces latency for IO event
> > customers and also prevents incorrect ack sequence on OMAP3.
> >
> > Signed-off-by: Tero Kristo <t-kristo@ti.com>
> > Cc: Paul Walmsley <paul@pwsan.com>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Avinash.H.M <avinashhm@ti.com>
> > Cc: Cousson, Benoit <b-cousson@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Govindraj.R <govindraj.raja@ti.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  drivers/mfd/omap-prm-common.c |  239 +++++++++++++++++++++++++++++++++=
++++++++
> >  drivers/mfd/omap-prm.h        |   40 +++++++
> >  drivers/mfd/omap3xxx-prm.c    |   29 +++++-
> >  drivers/mfd/omap4xxx-prm.c    |   28 +++++-
> >  4 files changed, 334 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/mfd/omap-prm.h
> >
> > diff --git a/drivers/mfd/omap-prm-common.c b/drivers/mfd/omap-prm-commo=
n.c
> > index 39b199c8..2886eb2 100644
> > --- a/drivers/mfd/omap-prm-common.c
> > +++ b/drivers/mfd/omap-prm-common.c
> > @@ -15,10 +15,249 @@
> >  #include <linux/ctype.h>
> >  #include <linux/module.h>
> >  #include <linux/io.h>
> > +#include <linux/irq.h>
> > +#include <linux/interrupt.h>
> >  #include <linux/slab.h>
> >  #include <linux/init.h>
> >  #include <linux/err.h>
> > =20
> > +#include "omap-prm.h"
> > +
> > +#define OMAP_PRCM_MAX_NR_PENDING_REG 2
> > +
> > +struct omap_prm_device {
> > +	const struct omap_prcm_irq_setup *irq_setup;
> > +	const struct omap_prcm_irq *irqs;
> > +	struct irq_chip_generic **irq_chips;
> > +	int nr_irqs;
> > +	u32 *saved_mask;
> > +	u32 *priority_mask;
> > +	int base_irq;
> > +	int irq;
> > +	void __iomem *base;
> > +};
> > +
> > +static struct omap_prm_device prm_dev;
>=20
> This shouldn't be statically allocated, and needlessly forces us to
> assume a single, global PRM (which is the case today, but who knows...)
>=20
> Instead, it should be allocated at init time and associated with the
> instance (using set_drvdata or somthing.)=20
>=20
> > +static inline u32 prm_read_reg(int offset)
> > +{
> > +	return __raw_readl(prm_dev.base + offset);
> > +}
> > +
> > +static inline void prm_write_reg(u32 value, int offset)
> > +{
> > +	__raw_writel(value, prm_dev.base + offset);
> > +}
>=20
> This doesn't seem right either.
>=20
> The register layout/access parts are what are are different between the
> OMAP3 and OMAP4 versions, so I would expect anything that accesses
> registers to be going through the SoC specific code.
>=20
> I'm having some second thoughts about the split of common and SoC
> specific code here.  Currently the SoC specific code is basically
> identical (ignoring the s/omap3/omap4/ throughout.)
>=20
> I think we need to discuss this further, but what seems to me that the
> current design is to have 2 separate drivers, with some common helper
> functions.  I'm starting to think that what we need instead is a single,
> common driver with a set of SoC-specific functions that implement the
> SoC-specific details.   This latter approach follows what is done in the
> powerdomain code today for example: common code in powerdomain.c and SoC
> specific implementation of all the "ops" in powerdomain2xxx_3xxx.c and
> powerdomain4xxx.c.

Is it so that only register layout is different ? In that case isn't it
better to use driver_data field of the id_table structure to pass
different register offsets based on the e.g. driver name ? Something
like below:

static const struct platform_device_id omap_prm_id_table[] __devinitconst =
=3D {
	{
		.name	=3D "omap3-prm",
		.driver_data =3D (kernel_ulong_t) &omap3_prm_data,
	},
	{
		.name	=3D "omap4-prm",
		.driver_data =3D (kernel_ulong_t) &omap4_prm_data,
	},
};
MODULE_DEVICE_TABLE(platform, omap_prm_id_table);

struct platform_driver omap_prm_driver =3D {
	.probe		=3D omap_prm_probe,
	.remove		=3D omap_prm_remove,
	.id_table	=3D omap_prm_id_table,
};

then on probe you get your id, copy id->driver_data to your own
structure and use that to access your registers. Works for you ?

--=20
balbi

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxq+YAAoJEIaOsuA1yqREFI4P/j2N33k//7eg8in4YTg6B3UO
j+EJIYvOrOu3J6w+e3Y0CdJkwXdl8MNkeAzGdpkdwPfpYAK5Ewqvlbp6WAwwsml2
2AyrMfa9myPnUILtVqNYhI+h9bbeqyo7t4aTnEuzcssg4z2yUOUZVk3ds85T2qzK
jYEBUCd60suc9NsjHntOS+oQwAF2I1+4r4GztznVSr00gAWdmuEKcRh+q+J9jSWq
yURKOFBE1oVLdqV5WZY/UKkl01wFi4j3s+6Tg5MroZXDJz1h7sNl2v8ZIFglLPO9
yZvhfvIdcpkpy8oGy+2nVE2ePPMrGgJCc99yWQnLTxd67dHwQxY0U+VoFTPWC8JP
lz49LkYsOsLTLPwqFkB1x/saq8bwcjFtC5tEa3Eji34hRzJqMgVLCIRJ6AyuWQg9
Offjie3YkaFfvGzAjLYSRsz6owF1E2tg4+5pZaj9S7O8UI6RHek049/fmxmx5fdQ
dmVxvnS50qLjD7LEiOouGDE9OU8QCWX4SDL5QPzqgsKWa6QQNw1jNzvr1TULCrk9
FyRt4Hmx0rHjfXP82YDbFvhG6wX6BJGq9gdFtOGBhPGzrKS9l4tYCIY8sUZ9Zokz
kWXEsReTl7pDlWyDEdk5wLRJt+F24gUprZX6zyxtWlRWU+Fq0YPU/kTTwh3qdOFe
MNQvZXfHEmPERVfux05k
=AN49
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
