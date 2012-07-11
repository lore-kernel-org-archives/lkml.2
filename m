Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2GKRMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:12:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab2GKRMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:12:00 -0400
Date: Wed, 11 Jul 2012 10:11:53 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Tim Sally <tsally@atomicpeace.com>
Cc: dustin.kirkland@gazzang.com, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eCryptfs: check for eCryptfs cipher support at mount
Message-ID: <20120711171152.GA16475@boyd>
References: <1341968751-28331-1-git-send-email-tsally@atomicpeace.com>
 <1341968751-28331-2-git-send-email-tsally@atomicpeace.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <1341968751-28331-2-git-send-email-tsally@atomicpeace.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-07-10 21:05:51, Tim Sally wrote:
> The issue occurs when eCryptfs is mounted with a cipher supported by
> the crypto subsystem but not by eCryptfs. The mount succeeds and an
> error does not occur until a write. This change checks for eCryptfs
> cipher support at mount time.
>=20
> Resolves Launchpad issue #338914, reported by Tyler Hicks in 03/2009.
> https://bugs.launchpad.net/ecryptfs/+bug/338914

Hey Tim - Thanks for digging this one out of the bug tracker. :)

>=20
> Signed-off-by: Tim Sally <tsally@atomicpeace.com>
> ---
>  fs/ecryptfs/main.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>=20
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index df217dc..4eb1fc6 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -279,6 +279,8 @@ static int ecryptfs_parse_options(struct ecryptfs_sb_=
info *sbi, char *options,
>  	char *fnek_src;
>  	char *cipher_key_bytes_src;
>  	char *fn_cipher_key_bytes_src;
> +	struct ecryptfs_key_tfm *key_tfm =3D NULL;
> +	u8 cipher_code;
> =20
>  	*check_ruid =3D 0;
> =20
> @@ -456,6 +458,28 @@ static int ecryptfs_parse_options(struct ecryptfs_sb=
_info *sbi, char *options,
>  			goto out;
>  		}
>  	}
> +
> +	if (!ecryptfs_tfm_exists(mount_crypt_stat->global_default_cipher_name,
> +					&key_tfm)) {
> +		ecryptfs_printk(KERN_ERR,
> +				"Cipher %s was not initalized correctly.\n",
> +				mount_crypt_stat->global_default_cipher_name);
> +		rc =3D -EINVAL;
> +		mutex_unlock(&key_tfm_list_mutex);
> +		goto out;
> +	}

We already know that the tfm exists because we already checked for its
existence and added it if it didn't exist. We shouldn't need to do it
again here.

> +
> +	cipher_code =3D ecryptfs_code_for_cipher_string(key_tfm->cipher_name,
> +						key_tfm->key_size);
> +	if (!cipher_code) {
> +		ecryptfs_printk(KERN_ERR,
> +				"eCryptfs doesn't support: %s blocksize %zu.\n",
> +				key_tfm->cipher_name, key_tfm->key_size);
> +		rc =3D -EINVAL;
> +		mutex_unlock(&key_tfm_list_mutex);
> +		goto out;
> +	}

How about just calling

ecryptfs_code_for_cipher_string(mount_crypt_stat->global_default_cipher_nam=
e,
			mount_crypt_stat->global_default_cipher_key_size);

even before we lock the key_tfm_list_mutex a little above here? If that
fails, we don't even need to check for the tfm's existence or do
anything else besides error out.

Tyler

> +
>  	mutex_unlock(&key_tfm_list_mutex);
>  	rc =3D ecryptfs_init_global_auth_toks(mount_crypt_stat);
>  	if (rc)
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJP/bPYAAoJENaSAD2qAscKF5gP/itU4IMP5rD2OWaTrmuPMbST
PAwQJvkdMfiN2luUeRF5VMbEaY/smiZWbki9DyGNfXW843cVKwkv3RdIvKFmQR4b
SZ0hF2/gOoKrKyfwtU5hFRRNcEcFUJrXgDspIZEgpiv2cPE7geW4Vr9EqzF3rfOR
5ePUi7YDj/pLudcFGpUQutq5erR1gjxKOx9vm7/oE+Wb7D08iFGY/Iq2WAYHCUGB
ftQgra7u0LTans2XGbTVRKOdmOXqMsv/TS+3JaCHgyrshc6w/HC6R1FAw4CcPSFV
pq/AGICB/juZVtEaAeUWoszjXaZGXxFZv/i/AKTZ+JaAhuqxli9aulovKl0W8FAs
qMUPPLnQBgzYtWq9i9AujcA/GDMo3An8YlwTfnBpoy/rquYyxsd18ZqTRrYZTTtB
FE9l+1T+YUjB2GdrdeDSVJvn2MCzYIUVa0rH05FwI1fl5ttGUSz3tnX5P7raGz7Q
YNdBaxKpMWOt+yGoVbH/xkYwMbWTVRyG9Sk+se9ExC90wU9Ti+nPp/sB1PgFegXU
0ceLuAoUsCgHQtcwt3uUnkMYHHbi6L+jifdsHxaNC9vYedtpOlDj4fcxwWo6sgJW
dSPTEewyxzWcPSKzOAiSZCVTHU29Fxn3p7fmEHTUkH8GjukYJn8s7dqGagDI+dSO
WJ32VhsmLDusJNEEHT4e
=16Kr
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
