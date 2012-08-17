Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2HQISc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:18:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:14490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab2HQIS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:18:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="asc'?scan'208";a="209720945"
Message-ID: <1345191768.27859.26.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] UBI: replace MTD_UBI_BEB_LIMIT with module parameter
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 11:22:48 +0300
In-Reply-To: <1345128723-13582-2-git-send-email-richard.genoud@gmail.com>
References: <1345042639.3393.150.camel@sauron.fi.intel.com>
	 <1345128723-13582-2-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NrXK2V9Xd7MFmAm4i+Oq"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NrXK2V9Xd7MFmAm4i+Oq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Richard, would you please split this series differently:

1. Separate out the calculations to the get_bad_peb_limit() func.
2. Invent=20
2. Add the module parameter
3. Extends the ioctl
4. Removes the Kconfig option

This will be much easier to review.

See also some comments below.

> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -46,6 +46,8 @@
>  /* Maximum length of the 'mtd=3D' parameter */
>  #define MTD_PARAM_LEN_MAX 64
> =20
> +#define MTD_PARAM_NB_MAX 3

Please, make it to be

/* Maximum number of comma-separated items in ht 'mtd=3D' parameter */
#define MTD_PARAM_MAX_COUNT 3

instead.

> @@ -57,10 +59,12 @@
>   * @name: MTD character device node path, MTD device name, or MTD device=
 number
>   *        string
>   * @vid_hdr_offs: VID header offset
> + * @max_beb_per1024: maximum expected number of bad blocks per 1024 eras=
e blocks
>   */
>  struct mtd_dev_param {
>  	char name[MTD_PARAM_LEN_MAX];
>  	int vid_hdr_offs;
> +	unsigned int max_beb_per1024;
>  };

Please, make it to be just 'int' here and everywhere, just for
consistency with other parameters, which are 'int' (no other stronger
reason).

>  MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
> -		      "mtd=3D<name|num|path>[,<vid_hdr_offs>].\n"
> +		      "mtd=3D<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]].\n"
>  		      "Multiple \"mtd\" parameters may be specified.\n"
>  		      "MTD devices may be specified by their number, name, or "
>  		      "path to the MTD character device node.\n"
>  		      "Optional \"vid_hdr_offs\" parameter specifies UBI VID "
>  		      "header position to be used by UBI.\n"

This comment needs improvement. Consider a situation when I do not want
to specify vid_hdr_offs (want to use the default), but want to specify
max_beb_per1024. I think I can put 0 here which means "default". Would
you please verify this and add a comment about this in this help output.
Also, please, verify that the output looks OK using 'modinfo ubi'.

> +		      "Optional \"max_beb_per1024\" parameter specifies the "
> +		      "maximum expected bad eraseblock per 1024 eraseblocks."
> +		      "(default " __stringify(MTD_UBI_DEFAULT_BEB_LIMIT)
> +		      " if 0 or not set)\n"

Yeah, something like "if 0 or not set" is needed for 'vid_hdr_offs' as
well.

>  		      "Example 1: mtd=3D/dev/mtd0 - attach MTD device "
>  		      "/dev/mtd0.\n"
>  		      "Example 2: mtd=3Dcontent,1984 mtd=3D4 - attach MTD device "

Could you also modify one of the examples and add "max_beb_per1024"
there?

--=20
Best Regards,
Artem Bityutskiy

--=-NrXK2V9Xd7MFmAm4i+Oq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLf9YAAoJECmIfjd9wqK08fkP/iCxbieHAACO69N0p1Zfs69R
ntKds8NTlQJSXl8WWy205/Noi10M+0cz7m1jaJMRVwciR+FY5RAsDaq4wFtYeB0H
r6Nps3oiEgtHx7ShDNmvYJq854bghtU880uzsvDqKzp5A9EW05w70WjohTGMVCm7
Gs0TuaeLXLD8sPo+UL9B79b1OR6iN2qYaQILeLOVkrxEhNWnazhbfgTIAzbLbmqv
iU1jufWm+pJxaaqqr4mFbfrXmF46lgRO8+QKAAVtD1ijnN9oph9n230/w4z5jvWd
RTvlWmdflaXgav9+xhFfSIvg4BnYE4Iw4AAQYTSmHx+QB/4Qp0JWnoWGlMTnVDa1
KRuaU+DwYcObnXAYE77uFEONRzktjQ6etLIvMO6GI+ypCr+rEIRdKQcoe+JluzKV
2zm2ts01pkb4ECQg+S/A9YwoAiFGdiWvMHtpj40wh+EBGyQAWp+PYJkA+7G7ecp1
shmnYR7WHnJ4B9oIqzYmATy3HBnLVBtrAyIbK1ESXyadGYqJp/8THdna7jmxZwN2
sgX2HGFX0YWtxAdfrJmCuEWspy6e+pvbNt93oXVHzX632eelAkc5SHeHhkejvTxa
ql2+fasEovlaCxjCMnBl77ZlEbALyLMZjhNuM6kekhgBanPEnL0GOEweX5x/xOnk
L3RUutqwRGumLAm/VacP
=GaNz
-----END PGP SIGNATURE-----

--=-NrXK2V9Xd7MFmAm4i+Oq--

