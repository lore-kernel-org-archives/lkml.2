Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1DNDhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 23:37:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab1DNDhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 23:37:08 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110413155148.974006996@clark.kroah.org>
References: <20110413155148.974006996@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-iOB4xwVUE8buGoHwxAJw"
Date: Thu, 14 Apr 2011 04:37:03 +0100
Message-ID: <1302752223.5282.674.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [56/74] x86, microcode, AMD: Extend ucode size
 verification
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iOB4xwVUE8buGoHwxAJw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-13 at 08:51 -0700, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
>=20
> From: Borislav Petkov <borislav.petkov@amd.com>
>=20
> Upstream commit: 44d60c0f5c58c2168f31df9a481761451840eb54
>=20
> The different families have a different max size for the ucode patch,
> adjust size checking to the family we're running on. Also, do not
> vzalloc the max size of the ucode but only the actual size that is
> passed on from the firmware loader.
[...]
> @@ -125,6 +124,37 @@ static int get_matching_microcode(int cp
>  	return 1;
>  }
> =20
> +static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned i=
nt size)
> +{
> +	struct cpuinfo_x86 *c =3D &cpu_data(cpu);
> +	unsigned int max_size, actual_size;
> +
> +#define F1XH_MPB_MAX_SIZE 2048
> +#define F14H_MPB_MAX_SIZE 1824
> +#define F15H_MPB_MAX_SIZE 4096
> +
> +	switch (c->x86) {
> +	case 0x14:
> +		max_size =3D F14H_MPB_MAX_SIZE;
> +		break;
> +	case 0x15:
> +		max_size =3D F15H_MPB_MAX_SIZE;
> +		break;
> +	default:
> +		max_size =3D F1XH_MPB_MAX_SIZE;
> +		break;
> +	}
> +
> +	actual_size =3D buf[4] + (buf[5] << 8);
> +
> +	if (actual_size > size || actual_size > max_size) {

Surely:

	if (actual_size + UCODE_CONTAINER_SECTION_HDR > size || ...

> +		pr_err("section size mismatch\n");
> +		return 0;
> +	}
> +
> +	return actual_size;
> +}
> +
>  static int apply_microcode_amd(int cpu)
>  {
>  	u32 rev, dummy;
> @@ -164,11 +194,11 @@ static int get_ucode_data(void *to, cons
>  }
> =20
>  static void *
> -get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
> +get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *=
mc_size)
>  {
> -	unsigned int total_size;
> +	unsigned int actual_size =3D 0;
>  	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
> -	void *mc;
> +	void *mc =3D NULL;

Dummy initialisations mean the compiler won't warn if you fail to
properly initialise them later.

>  	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
>  		return NULL;
> @@ -179,23 +209,18 @@ get_next_ucode(const u8 *buf, unsigned i
>  		return NULL;
>  	}
> =20
> -	total_size =3D (unsigned long) (section_hdr[4] + (section_hdr[5] << 8))=
;
> +	actual_size =3D verify_ucode_size(cpu, buf, size);
> +	if (!actual_size)
> +		return NULL;
> =20
> -	if (total_size > size || total_size > UCODE_MAX_SIZE) {
> -		printk(KERN_ERR "microcode: error: size mismatch\n");
> +	mc =3D vmalloc(actual_size);
> +	if (!mc)
>  		return NULL;
> -	}
> =20
> -	mc =3D vmalloc(UCODE_MAX_SIZE);
> -	if (mc) {
> -		memset(mc, 0, UCODE_MAX_SIZE);
> -		if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR,
> -				   total_size)) {
> -			vfree(mc);
> -			mc =3D NULL;
> -		} else
> -			*mc_size =3D total_size + UCODE_CONTAINER_SECTION_HDR;
> -	}
> +	memset(mc, 0, actual_size);
> +	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
[...]

So I wondered why the result of get_ucode_data() is no longer being
checked.  And the answer is: because it's a trivial wrapper for
memcpy(), but with a 'return 0'.  So the memset() is redundant.

Good thing nothing important depends on this validation, oh wait...

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-iOB4xwVUE8buGoHwxAJw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaZr2ue/yOyVhhEJAQqF7Q//UjVXDRk17azahUnfgDWAMXDxgAKxXhMf
UmCz3dUuFrsczk0V82dV1jnk/uBmK1IBk7UOFWWBogGGlM6OPcXMqxKJejJJrlEf
UJ4sIMu+vvYjvLfZcvmNaG9dO/q5IMCp5QMtnKWd2fU6zUmOh9/VFzs1tPJnxm2y
U0trgYG7ztnUJh5IV835IPGk9OwRatWVuBy9fj9hSVHa5cH6KX5mnWmS/NxVtgKX
ERvFf5kzCqfrkW6j7ZnXdTRniMBKzej78/x7x4NFoY+0hmoJwaJa9Lfd0b1qmH1u
VUD3av88jxbR9ddLlNo392eFBc0xQ+QMaMSyRLlF4aKjM2jHqp3qyBIKxBdzJ7nD
suQVGEccnS1/0gTlG/q4mEFnCeVRhnUMXPiyjG+xpjPehDxqNa0/cAr34+Xz2F4N
yfSm+G3OmH4MBDd9OBZ3n7DXbZl8SbvGGnuGWw/SqJsUJy7n32eBOwKBnwZ6JWyW
eRQP0QYk4hxKsd8RFgWo9aINPFixh/fx8N0s1XX/CpQa+MwN4FYOLpS/2M8t/PlF
1O7n5vx6dtXGjeSlwkjgbFUT89HIQNFtt3LsfOHoz/ZfZncMucdWUArDLums2bJ5
EfOuKSt5gG3VUb//7wEcMYAUoa2pNtpBwH2Ti8gMdRy02fP0d7nXXpkr/qdse59c
xkyiOnUCAoY=
=OBDO
-----END PGP SIGNATURE-----

--=-iOB4xwVUE8buGoHwxAJw--
