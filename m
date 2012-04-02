Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2DBOd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:33:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:50946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab2DBOd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="136609066"
Message-ID: <1333377383.22146.14.camel@sauron.fi.intel.com>
Subject: Re: [patch] UBIFS: Add cryptographic functionality when a key is
 passed to the compress / decompress functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Mon, 02 Apr 2012 17:36:23 +0300
In-Reply-To: <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	     <alpine.DEB.2.00.1202202112220.21022@eristoteles.iwoars.net>
	    <1330531826.3545.128.camel@sauron.fi.intel.com>
	    <alpine.DEB.2.00.1203191635030.22256@eristoteles.iwoars.net>
	   <1332511796.18717.72.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1203231739330.22944@eristoteles.iwoars.net>
	  <1332521515.22278.2.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203252302310.5527@eristoteles.iwoars.net>
	  <alpine.DEB.2.00.1203252325100.5527@eristoteles.iwoars.net>
	 <1332837188.31549.14.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203291639200.912@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qvz89XWxp7QBZ6T+HkL8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qvz89XWxp7QBZ6T+HkL8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-29 at 16:39 +0200, Joel Reardon wrote:
>  /* Fake description object for the "none" compressor */
>  static struct ubifs_compressor none_compr =3D {
>  	.compr_type =3D UBIFS_COMPR_NONE,
> @@ -75,6 +78,55 @@ static struct ubifs_compressor zlib_compr =3D {
>  struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];
>=20
>  /**
> + * ubifs_aes_crypt - encrypt / decrypt data.
> + * @str: data to crypt
> + * @len: length of the data
> + * @crypto_key: the cryptographic key to use to crypt the data
> + * @crypto_key_len: the length of the crypto_key
> + * @iv: the initialization vector to use
> + * @ivlen: the length of the initialization vector
> + *
> + * This function applies aes encryption to the data. It is done in count=
er
> + * mode, which means that encryption and decryption are the same operati=
on,
> + * i.e., it XORs the same generated bitstream, so it can be used both fo=
r
> + * encryption / decryption. The operation is done in-place, so str mutat=
es.
> + */
> +int ubifs_aes_crypt(void *str, int len, u8 *crypto_key,
> +		    int crypto_key_len, u8 *iv, int ivlen)

You support only one length - please, kill ivlen parameter.

Also, should ubifs_aes_crypt be static? I do not see any users outside
of compress.c. In this case remove the "ubifs_" prefix. But a
non-written convention, in UBIFS we _tend_ to prefix only non-static
functions with "ubifs_" and avoid having it for static functions.

> +{
> +	struct crypto_blkcipher *tfm;
> +	struct blkcipher_desc desc;
> +	struct scatterlist sg;
> +	int err =3D 0;
> +
> +	tfm =3D crypto_alloc_blkcipher(UBIFS_CRYPTO_ALGORITHM, 0, 0);
> +

Unnecessary empty line.

> +	if (IS_ERR(tfm)) {
> +		ubifs_err("failed to load transform for aes: %ld",
> +			  PTR_ERR(tfm));
> +		return err;
> +	}
> +
> +	err =3D crypto_blkcipher_setkey(tfm, crypto_key, crypto_key_len);
> +	desc.tfm =3D tfm;
> +	desc.flags =3D 0;
> +	if (err) {
> +		ubifs_err("crypto_blkcipher_setkey() failed  flags=3D%#x",
> +			  crypto_blkcipher_get_flags(tfm));
> +		return err;
> +	}
> +	memset(&sg, 0, sizeof(struct scatterlist));
> +

Empty lines mean grouping, and I think this memeset should be grouped
with sg_set_buf instead.


>  no_compr:
>  	memcpy(out_buf, in_buf, in_len);
>  	*out_len =3D in_len;
>  	*compr_type =3D UBIFS_COMPR_NONE;
> +	goto encrypt;
> +
> +encrypt:

I guess the above goto is redundant?

> +	if (crypto_key) {
> +		u8 iv[UBIFS_CRYPTO_KEYSIZE];
> +
> +		memset(iv, 0, UBIFS_CRYPTO_KEYSIZE);
> +		ubifs_aes_crypt(out_buf, *out_len, crypto_key,
> +				UBIFS_CRYPTO_KEYSIZE, iv, UBIFS_CRYPTO_KEYSIZE);
> +	}
>  }
>=20
>  /**
> @@ -149,7 +211,7 @@ no_compr:
>   * The length of the uncompressed data is returned in @out_len. This fun=
ctions
>   * returns %0 on success or a negative error code on failure.
>   */
> -int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
> +int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
>  		     int *out_len, int compr_type, u8 *crypto_key)

Please, write a fat "WARNING" note in the comment and tell that this
function modifies the input buffer.

> +/* Size of 128 bits in bytes */
> +#define AES_KEYSIZE_128 16

If you have no plans to support keys larger than 128 just kill this
constant please.

--=20
Best Regards,
Artem Bityutskiy

--=-qvz89XWxp7QBZ6T+HkL8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPeblnAAoJECmIfjd9wqK0lZMQAMMjW5FqBajDqto/0Y8ExCcX
tnjz2ZT6+T96gwer7ZDbkgt5Eh6V3z1JOSSB6oZoqJ8UgM5rKffV6n//7aXypebO
e7lDF6Hcs/9YRWSR6j8nFOWpmNiQBa4eNWrp9j9XGMeyt4Joa/lvoDpbFVLU9tRs
vSv5nZg2tLFVt5xaIQLBflXCUg4goyId3odixtSrEChfK/2iVS+9vzyp/tjuAYdF
UH/xWMkclNp9n/1CkVJ3NdJREKUngAnLsy6PSX+aab959/FKvMA43iQXKMsTfgSV
meWpyuKut+zWI30FngPcArLqa3Opb2KVl1MEapZrvjYoz9zPuAA1FOY59bWEATiQ
0EdxYLAHOz1kBq3PVdNN6WuHVt14WcA/bx0ImAbld0lk78Os3fa0TzqwpW/VrmE+
fOnmSngM+apanFnATzOoj15ZI3m8usZ9e6WQaNGXl7PCzOvLTvL3R73TDDmebINU
Gk4o+NmkeBaOJSFiU+ej2Mqv/bnzcS1raSkXXxMGdmTrV2WnjyOdAgQ56bw+s1Mt
oYnm+kFkm0Dadj8t9K3rbvVzFOoDSEzy1IJBIDPqqC0syeXOWZrCZMWdX/pkeqYv
grSNG5jLsQpKfX8bUGmIOPdg4Ei/+ydEz4tS6TCIOztiwcZiIZAPAEePFJui8761
RUEQbMOJMp48m8IWUjEn
=MeXg
-----END PGP SIGNATURE-----

--=-qvz89XWxp7QBZ6T+HkL8--

