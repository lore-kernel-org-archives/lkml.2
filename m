Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab2EBDzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:55:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679Ab2EBDzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:55:20 -0400
Message-ID: <1335930906.8274.97.camel@deadeye>
Subject: Re: [PATCH 2/2] efi: Validate UEFI boot variables
From: Ben Hutchings <ben@decadent.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Wed, 02 May 2012 04:55:06 +0100
In-Reply-To: <1335816690-26019-2-git-send-email-mjg@redhat.com>
References: <1335816690-26019-1-git-send-email-mjg@redhat.com>
	 <1335816690-26019-2-git-send-email-mjg@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QQXkxVxHJEbFnC6xUG9I"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QQXkxVxHJEbFnC6xUG9I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-30 at 16:11 -0400, Matthew Garrett wrote:
> A common flaw in UEFI systems is a refusal to POST triggered by a malform=
ed
> boot variable. Once in this state, machines may only be restored by
> reflashing their firmware with an external hardware device. While this is
> obviously a firmware bug, the serious nature of the outcome suggests that
> operating systems should filter their variable writes in order to prevent
> a malicious user from rendering the machine unusable.
[...]
> +static bool
> +validate_device_path(struct efi_variable *var, int match, u8 *buffer,
> int len)
> +{
> +       struct efi_generic_dev_path *node;
> +       int offset =3D 0;
> +
> +       node =3D (struct efi_generic_dev_path *)buffer;
> +
> +       while (offset < len) {
> +               offset +=3D node->length;
> +
> +               if (offset > len)
> +                       return false;
> +
> +               if ((node->type =3D=3D EFI_DEV_END_PATH ||
> +                    node->type =3D=3D EFI_DEV_END_PATH2) &&
> +                   node->sub_type =3D=3D EFI_DEV_END_ENTIRE)
> +                       return true;
> +
> +               node =3D (struct efi_generic_dev_path *)(buffer + offset)=
;
> +       }

This validation is crap; you're not accounting for the size of the node
or invalid lengths.  Try:

	while (offset <=3D len - sizeof(*node) &&
	       node->length >=3D sizeof(*node) &&
	       node->length <=3D len - offset) {
		offset +=3D node->length;

		if ((node->type =3D=3D EFI_DEV_END_PATH ||
		     node->type =3D=3D EFI_DEV_END_PATH2) &&
		    node->sub_type =3D=3D EFI_DEV_END_ENTIRE)
			return true;

		node =3D (struct efi_generic_dev_path *)(buffer + offset);
	}

[...]
> +static bool
> +validate_load_option(struct efi_variable *var, int match, u8 *buffer, in=
t len)
> +{
> +	u16 filepathlength;
> +	int i, desclength =3D 0;
> +
> +	/* Either "Boot" or "Driver" followed by four digits of hex */
> +	for (i =3D match; i < match+4; i++) {
> +		if (hex_to_bin(var->VariableName[i] & 0xff) < 0)
> +			return true;
> +	}

Isn't this slightly too restrictive?  The '& 0xff' results in many
non-ASCII characters aliasing hex digits and potentially causes a
variable to be validated as if it was special.  I would think the
correct condition is:

		if (var->VariableName[i] > 127 ||
		    hex_to_bin(var->VariableName[i]) < 0)

Presumably the variable should also be ignored if there are any more
characters after the 4 hex digits?

> +	/* A valid entry must be at least 6 bytes */
> +	if (len < 6)
> +		return false;

Surely 8 bytes - otherwise you don't even have space for the
description's null terminator.

> +	filepathlength =3D buffer[4] | buffer[5] << 8;
> +
> +	/*
> +	 * There's no stored length for the description, so it has to be
> +	 * found by hand
> +	 */
> +	desclength =3D utf16_strsize((efi_char16_t *)(buffer + 6), len) + 2;
[...]

Second argument should be len - 6.

Ben.

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

--=-QQXkxVxHJEbFnC6xUG9I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6CwGue/yOyVhhEJAQqWshAAmMAdx/eaxR4O8w+ZHyqTM57g3dFFot1Z
sQByOFVI/H8IXfhNDhc3ydZ8QiCCQfJeU5DFP1E0FjToOHipkLK9noot+dzR2/De
m9OssROeOdyYsUPauWkkAOnM+vNtUOK2GM2Zj1MTaxs916i6MngtQg5hAoxa5BDw
TNQs/hKmsaTNhZQQNvuGvXRCNn52T1InfBkGeq82tGmBQURegmA8rJK8hjmX/9Bi
bvgvq6vTBMTc12ameAF+L0j9TQovZW0Qzc4ss0dOBMM/49+m9sFKib1Ng7ndPhLm
tV08kT+ZbO34Nyxi8wE9F3qcAfccNw/PjV9T4tUWXsHWzVajcnqEMVKfoCTIEN08
cr81LuseWXAnilUT9NutZwF94/Rv3PmF4PHY76ZuOg5uRAoR7h4wtzdu7AGxGjUD
OqlXUbnIix2OtS8yFx5XoTmUOvI9WTbyQQe4+KjC6RSTKdk8iF2kPbIQT2k5QKA2
g0P/ZqWJMwsydWfmUIhe9qmi76GmfrBfOH1Oa1H+dMyj9n6H7VoJA33UMRwnB7n0
5zJg51fah/G/tk0kvnHHvIJgKme1iyYGNnNV81UovBkktarJbs02rFXZfiMn63Of
4xXN329VZXuyzblirdypoSRrOE3wRG7/OnUpJJ6b/ssgIqHf5gjG7sJ+UinvUPJd
8mRaaSU0WMY=
=X7nU
-----END PGP SIGNATURE-----

--=-QQXkxVxHJEbFnC6xUG9I--
