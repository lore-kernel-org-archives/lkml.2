Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1KUXq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:46:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45164 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1KUXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:46:56 -0500
Date: Mon, 21 Nov 2011 17:46:49 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: torvalds@linux-foundation.org, Michael Halcrow <mhalcrow@google.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org, thieule@google.com
Subject: Re: [PATCH] eCryptfs: Check array bounds for filename characters
Message-ID: <20111121234649.GC9205@boyd>
References: <20111121233258.GA18466@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <20111121233258.GA18466@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011-11-21 15:32:58, Michael Halcrow wrote:
> Characters with ASCII values greater than the size of
> filename_rev_map[] are valid filename
> characters. ecryptfs_decode_from_filename() will access kernel memory
> beyond that array, and ecryptfs_parse_tag_70_packet() will then
> decrypt those characters. The attacker, using the FNEK of the crafted
> file, can then re-encrypt the characters to reveal the kernel memory
> past the end of the filename_rev_map[] array. I expect low security
> impact since this array is statically allocated in the text area, and
> the amount of memory past the array that is accessible is limited by
> the largest possible ASCII filename character.
>=20
> This change verifies that the offset into filename_rev_map[] is within
> bounds. If any one character is not, then eCryptfs will consider the
> filename to not be a valid encrypted filename and will copy it
> verbatim rather than try to decode/decrypt it.
>=20
> Signed-off-by: Mike Halcrow <mhalcrow@google.com>

Linus - This is a pretty low security risk, but I figure that it is
probably best if you apply it directly to your tree. I don't think there
is much need for it to go through my tree. If you do take it in, feel
free to add the following tags:

Cc: <stable@kernel.org>
Acked-by: Tyler Hicks <tyhicks@canonical.com>

BTW, I reviewed and tested this patch before Mike sent it out to the
list.

Tyler

>=20
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index 58609bd..d2d2b9e 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -2032,11 +2032,14 @@ out:
>   * @dst_size: Set to the size of the decoded string.
>   * @src: The encoded set of octets to decode.
>   * @src_size: The size of the encoded set of octets to decode.
> + *
> + * Returns zero on success; non-zero otherwise
>   */
> -static void
> +static int
>  ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
>  			      const unsigned char *src, size_t src_size)
>  {
> +	int rc =3D 0;
>  	u8 current_bit_offset =3D 0;
>  	size_t src_byte_offset =3D 0;
>  	size_t dst_byte_offset =3D 0;
> @@ -2052,9 +2055,13 @@ ecryptfs_decode_from_filename(unsigned char *dst, =
size_t *dst_size,
>  		goto out;
>  	}
>  	while (src_byte_offset < src_size) {
> -		unsigned char src_byte =3D
> -				filename_rev_map[(int)src[src_byte_offset]];
> -
> +		int rev_map_offset =3D (int)src[src_byte_offset];
> +		unsigned char src_byte;
> +		if (rev_map_offset > (ARRAY_SIZE(filename_rev_map) - 1)) {
> +			rc =3D -EINVAL;
> +			goto out;
> +		}
> +		src_byte =3D filename_rev_map[rev_map_offset];
>  		switch (current_bit_offset) {
>  		case 0:
>  			dst[dst_byte_offset] =3D (src_byte << 2);
> @@ -2081,7 +2088,7 @@ ecryptfs_decode_from_filename(unsigned char *dst, s=
ize_t *dst_size,
>  	}
>  	(*dst_size) =3D dst_byte_offset;
>  out:
> -	return;
> +	return rc;
>  }
> =20
>  /**
> @@ -2235,8 +2242,14 @@ int ecryptfs_decode_and_decrypt_filename(char **pl=
aintext_name,
> =20
>  		name +=3D ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
>  		name_size -=3D ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
> -		ecryptfs_decode_from_filename(NULL, &decoded_name_size,
> -					      name, name_size);
> +		rc =3D ecryptfs_decode_from_filename(NULL, &decoded_name_size,
> +						   name, name_size);
> +		if (rc) {
> +			rc =3D ecryptfs_copy_filename(plaintext_name,
> +						    plaintext_name_size,
> +						    orig_name, orig_name_size);
> +			goto out;
> +		}
>  		decoded_name =3D kmalloc(decoded_name_size, GFP_KERNEL);
>  		if (!decoded_name) {
>  			printk(KERN_ERR "%s: Out of memory whilst attempting "
> @@ -2245,8 +2258,16 @@ int ecryptfs_decode_and_decrypt_filename(char **pl=
aintext_name,
>  			rc =3D -ENOMEM;
>  			goto out;
>  		}
> -		ecryptfs_decode_from_filename(decoded_name, &decoded_name_size,
> -					      name, name_size);
> +		rc =3D ecryptfs_decode_from_filename(decoded_name,
> +						   &decoded_name_size,
> +						   name,
> +						   name_size);
> +		if (rc) {
> +			rc =3D ecryptfs_copy_filename(plaintext_name,
> +						    plaintext_name_size,
> +						    orig_name, orig_name_size);
> +			goto out_free;
> +		}
>  		rc =3D ecryptfs_parse_tag_70_packet(plaintext_name,
>  						  plaintext_name_size,
>  						  &packet_size,

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJOyuLpAAoJENaSAD2qAscKHBEP/3dUrhU54Nl2xhfaRXiRD/WK
UdyZ9VwsUL7RBVgSIHWoVXG+QFQMqgB0RIuQigYRh/2UoNk2X72GZQVevM53YVgu
/I8yDShm+Wp5btoKAIXAHG8YzOsVIxVfI2UAQRK8f5n5Kkfxf+K2aVT9jYb3MTpF
A7IwwPcWUi1ufqg6zOy5BHKynyzoantOn3bV0zXM/1ApIBMrIwgFd9H/qqsFiSIk
B/Ux3dohpVwXn0SPu/9dJ/LrYvU68afHNPiORHhXDf4HLdmWRe7OARNxVO5pkUHA
E4xyjWZj64qZyKfr3vuVfNsAS3smlglPerQwWIJs3YjNEP2GtA0vxHTdtKf/O+LZ
+/WQojBEdDNeHjLDYEZ7Fgsp7MYV0sbe7hopHhQolD8KDVO6gF06XnmBpowE9UBH
HwMtQhNo2v5Z929hFySlVLkki9cIjo2uDf0lYujR48YhputXq2L6pE7wOQPcKm3B
UmxXZWQ/fEzoKoGcTR1s2eKlNH0Sn8RyL9pWyBIQB0lfswjlFO6Q5ElRavHlr4qx
M3oSIk3kdObtmKLb65Hfrl6mTdO2EQIEMpPDF7+9EqSDuwrHoJ1fXpaGsZNPm2xH
bas9iAE+ccyFGaFYd+NWVIC/oqinec8ptWStTD8xDGFH920+XuJTAibd7zqidur9
cRDcKRfQ6cql36crsm39
=5LS0
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
