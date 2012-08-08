Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2HHKql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:46:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2HHKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:46:40 -0400
Date: Wed, 8 Aug 2012 12:46:29 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Grant Likely <grant.likely@secretlab.ca>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20120808104629.GA20296@avionic-0098.mockup.avionic-design.de>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <20120806073811.GA3261@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20120806073811.GA3261@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Qd3zWtzJvTcY8rkS8OYYUDhP3X8T8BEDoAIGT79P5uU
 iy6WNJtVxGhrBbIZMPX2FockiqYSo52dTJWvfNHf4bbtMPJoWE
 GB3ZFlkutXyO0wLVSdXAaD6MW4M0EBVCw/yq2s/NiOmY8Wzg85
 rwNA1xuu/VhroDmTalnMwBMRbMtDvgviyyek29RHxaK9M4wZSJ
 UtRHwy4OQFzUHyZkydCVvOFsLc1HR60LDtwl4zliAM9CG6WyNT
 PR+hqQaz3R0Cu1wL43MYZbOdcmj/gq0z6d5BRAIs7uqM1/4r3L
 Xl8CKpB9uytuVRJ7ndRln4kaHCNGrz5rMPLF0uPTqlkbJgpqV8
 GKa+o9TE4xw4vlW1CtsLCTC90L62yRps7kJ5htJkHXLNdQ6MNk
 3tm61j6j1f12uBDniPJZpbMJ9j6MWJTJkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2012 at 09:38:11AM +0200, Sebastian Andrzej Siewior wrote:
> The former conversion to irq_domain_add_legacy() did not fully work
> since we miss the irq decs for NR_IRQS_LEGACY+.
> Ideally we could use irq_domain_add_simple() or the no-map variant (and
> program the virq <-> line mapping directly into ioapic) but this would
> require a different irq lookup in "do_IRQ()" and won't work with ACPI
> without changes. So this is probably easiest for everyone.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
>  arch/x86/kernel/devicetree.c |   52 ++++++++++++++++++++++++++++++++++--=
------
>  1 file changed, 43 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index 3ae2ced..df225fc 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -342,6 +342,48 @@ const struct irq_domain_ops ioapic_irq_domain_ops =
=3D {
>  	.xlate =3D ioapic_xlate,
>  };
> =20
> +static void dt_add_ioapic_domain(unsigned int ioapic_num,
> +		struct device_node *np)
> +{
> +	struct irq_domain *id;
> +	struct mp_ioapic_gsi *gsi_cfg;
> +	int ret;
> +	int num;
> +
> +	gsi_cfg =3D mp_ioapic_gsi_routing(ioapic_num);
> +	num =3D gsi_cfg->gsi_end - gsi_cfg->gsi_base + 1;
> +
> +	id =3D irq_domain_add_linear(np, num,
> +			&ioapic_irq_domain_ops,
> +			(void *)ioapic_num);

This fits on two lines instead of three.

> +	BUG_ON(!id);
> +	if (gsi_cfg->gsi_base =3D=3D 0) {
> +		/*
> +		 * The first NR_IRQS_LEGACY irq descs are allocated in
> +		 * early_irq_init() and need just a mapping. The
> +		 * remaining irqs need both. All of them are preallocated
> +		 * and assigned so we can keep the 1:1 mapping which the ioapic
> +		 * is having.
> +		 */
> +		ret =3D irq_domain_associate_many(id, 0, 0, NR_IRQS_LEGACY);
> +		if (ret)
> +			pr_err("Error mapping legacy irqs: %d\n", ret);
> +
> +		if (num > NR_IRQS_LEGACY) {
> +			ret =3D irq_create_strict_mappings(id, NR_IRQS_LEGACY,
> +					NR_IRQS_LEGACY, num - NR_IRQS_LEGACY);
> +			if (ret)
> +				pr_err("Error creating mapping for the "
> +						"remaining  irqs: %d\n", ret);

There's an extra space between "remaining" and "irqs". Also other places
use the spelling IRQ and IRQs respectively in strings, so it may be nice
to stay consistent.

> +		}
> +		irq_set_default_host(id);
> +	} else {
> +		ret =3D irq_create_strict_mappings(id, gsi_cfg->gsi_base, 0, num);
> +		if (ret)
> +			pr_err("Error creating irq mapping: %d\n", ret);
> +	}
> +}
> +
>  static void __init ioapic_add_ofnode(struct device_node *np)
>  {
>  	struct resource r;
> @@ -356,15 +398,7 @@ static void __init ioapic_add_ofnode(struct device_n=
ode *np)
> =20
>  	for (i =3D 0; i < nr_ioapics; i++) {
>  		if (r.start =3D=3D mpc_ioapic_addr(i)) {
> -			struct irq_domain *id;
> -			struct mp_ioapic_gsi *gsi_cfg;
> -
> -			gsi_cfg =3D mp_ioapic_gsi_routing(i);
> -
> -			id =3D irq_domain_add_legacy(np, 32, gsi_cfg->gsi_base, 0,
> -						   &ioapic_irq_domain_ops,
> -						   (void*)i);
> -			BUG_ON(!id);
> +			dt_add_ioapic_domain(i, np);
>  			return;
>  		}
>  	}

Besides the above nitpicks:

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Tested-by: Thierry Reding <thierry.reding@avionic-design.de>

On another note, I saw that you've used the "intel,ce4100" prefix in
various places and I wonder if it would be useful to replace them with
something more generic like "intel,hpet", "intel,lapic" and
"intel,ioapic" respectively. The hardware that I use is based on an Atom
N450 and works with the current code, so it really isn't ce4100-
specific.

Given that this is x86/devicetree only and fixes things that didn't work
before, can it go into 3.6? Backporting to stable is probably not worth
it because it depends on a number of other IRQ domain patches that are
only available in 3.6.

Thierry

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQIkOFAAoJEN0jrNd/PrOhDD4P/2n/vpTIYVkWteqUro4c8f8b
0kjrCgizSr8Q/ey8HY0JlcnIReUUUjj5JsNeBm9+2chA9yEkCvnnYQDWiboD8GhL
DXUJWUYKaDhhccYR8vX1Bj9GnJjYBAE3uLO7DivGxzmPk8XquPld5MGHZ8GlcTQV
dl03cS6T8oE2M54tF/ibD5pHYVvXmR4oeGjqwmCc7EutXKt6RgSKL3QbukwY6F5b
ItM7N2IG4dt2O2/lIwgblsoVaQQB0gxVX5sxCveqijX+FiZ4WHuQV0FOoiVcSdLB
J+mW4UIKdlN9OeAfCkRB4PBujrZsbLfHpWmmiQnFbl++oCXjatXwwJb0MwwgPL41
2MfYPNChtYJ8gwLvckEPbduemCrBcnWQKIOXHs8hs+HvyxyNka1g8McMK+YUg5iy
U3yUuQDk8RWel7EnVRFRy1qpnh4Mj1k8uQkxn2gZYbGgcMvNy065tC+5mKaEsKJD
pPDCK3dyJyrD7p3/teotH1I0FuPmztSxvw6ACJ25ktTzEHzMT/41fXhNxD/6tKXg
mNwV9MJDSlT8dmu125+zJTtIvjU3DbHS/mnbZgPK2LiQspOUwfLF64UHvdgICLAt
Sz7J6U9Z7EGq7rc08TljV2tDlR4BEDACPyL91bJ2C3dO77mmmEboy8qb47J0DKHm
XAMbWd/X+DYwcx6TkYwx
=w2JO
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
