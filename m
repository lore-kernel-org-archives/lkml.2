Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2IDIiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:38:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:47310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2IDIiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:38:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,366,1344236400"; 
   d="asc'?scan'208";a="188498061"
Message-ID: <1346748171.12610.22.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] drivers/mtd/nand/mpc5121_nfc.c: some devm_ cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 11:42:51 +0300
In-Reply-To: <1346517191-8794-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1346517191-8794-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tdXTmw5a0pc+y+6PPrfQ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tdXTmw5a0pc+y+6PPrfQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Aiaiai! :-) [1] [2]

I've build-tested this using aiaiai and it reports that this change breaks =
the build:

dedekind@blue:~/git/maintaining$ ./verify ../l2-mtd/ mpc5121_nfc < ~/tmp/ju=
lia2.mbox=20
Tested the patch(es) on top of the following commits:
ba64756 Quick fixes - applied by aiaiai
651c6fa JFFS2: don't fail on bitflips in OOB
e22ac84 mtd: autcpu12-nvram: drop frees of devm_ alloc'd data
ea9d312 mtd: cmdlinepart: minor cleanups

---------------------------------------------------------------------------=
-----
Failed to build the following commit for configuration "powerpc-mpc512x_def=
config" (architecture powerpc)":

0fe13ab drivers/mtd/nand/mpc5121_nfc.c: some devm_ cleanups

...
drivers/mtd/nand/mpc5121_nfc.c: In function 'mpc5121_nfc_probe':
drivers/mtd/nand/mpc5121_nfc.c:622:28: warning: variable 'regs_size' set bu=
t not used [-Wunused-but-set-variable]
drivers/mtd/nand/mpc5121_nfc.c:622:16: warning: variable 'regs_paddr' set b=
ut not used [-Wunused-but-set-variable]
drivers/built-in.o: In function `mpc5121_nfc_probe':
mpc5121_nfc.c:(.devinit.text+0x2a14): undefined reference to `devm_clk_get'
make[1]: *** [vmlinux] Error 1

---------------------------------------------------------------------------=
-----

I do not really know why, but it seems that clock framework is not supporte=
d for powerpc. CCing the PPC mailing list. Preserved the context below for =
the PPC people.

So, not taking this patch.

References:

1. http://git.infradead.org/users/dedekind/aiaiai.git
2. http://git.infradead.org/users/dedekind/maintaining.git

On Sat, 2012-09-01 at 18:33 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> devm free functions should not have to be explicitly used.
>=20
> The only thing left that is useful in the function mpc5121_nfc_free is th=
e
> call to clk_disable, which is moved to the call sites.
>=20
> This function also incorrectly called iounmap on devm_ioremap allocated
> data.
>=20
> Use devm_request_and_ioremap in place of devm_request_mem_region and
> devm_ioremap.
>=20
> Use devm_clk_get.
>=20
> A semantic match that finds the first problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> @@
>=20
> (
> * devm_kfree(...);
> |
> * devm_free_irq(...);
> |
> * devm_iounmap(...);
> |
> * devm_release_region(...);
> |
> * devm_release_mem_region(...);
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/mtd/nand/mpc5121_nfc.c |   35 +++++-----------------------------=
-
>  1 file changed, 5 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nf=
c.c
> index c259c24..45183ba 100644
> --- a/drivers/mtd/nand/mpc5121_nfc.c
> +++ b/drivers/mtd/nand/mpc5121_nfc.c
> @@ -632,21 +632,6 @@ out:
>  	return ret;
>  }
> =20
> -/* Free driver resources */
> -static void mpc5121_nfc_free(struct device *dev, struct mtd_info *mtd)
> -{
> -	struct nand_chip *chip =3D mtd->priv;
> -	struct mpc5121_nfc_prv *prv =3D chip->priv;
> -
> -	if (prv->clk) {
> -		clk_disable(prv->clk);
> -		clk_put(prv->clk);
> -	}
> -
> -	if (prv->csreg)
> -		iounmap(prv->csreg);
> -}
> -
>  static int __devinit mpc5121_nfc_probe(struct platform_device *op)
>  {
>  	struct device_node *rootnode, *dn =3D op->dev.of_node;
> @@ -713,12 +698,7 @@ static int __devinit mpc5121_nfc_probe(struct platfo=
rm_device *op)
>  	regs_paddr =3D res.start;
>  	regs_size =3D resource_size(&res);
> =20
> -	if (!devm_request_mem_region(dev, regs_paddr, regs_size, DRV_NAME)) {
> -		dev_err(dev, "Error requesting memory region!\n");
> -		return -EBUSY;
> -	}
> -
> -	prv->regs =3D devm_ioremap(dev, regs_paddr, regs_size);
> +	prv->regs =3D devm_request_and_ioremap(dev, &res);
>  	if (!prv->regs) {
>  		dev_err(dev, "Error mapping memory region!\n");
>  		return -ENOMEM;
> @@ -752,11 +732,10 @@ static int __devinit mpc5121_nfc_probe(struct platf=
orm_device *op)
>  	of_node_put(rootnode);
> =20
>  	/* Enable NFC clock */
> -	prv->clk =3D clk_get(dev, "nfc_clk");
> +	prv->clk =3D devm_clk_get(dev, "nfc_clk");
>  	if (IS_ERR(prv->clk)) {
>  		dev_err(dev, "Unable to acquire NFC clock!\n");
> -		retval =3D PTR_ERR(prv->clk);
> -		goto error;
> +		return PTR_ERR(prv->clk);
>  	}
> =20
>  	clk_enable(prv->clk);
> @@ -803,7 +782,6 @@ static int __devinit mpc5121_nfc_probe(struct platfor=
m_device *op)
>  	/* Detect NAND chips */
>  	if (nand_scan(mtd, be32_to_cpup(chips_no))) {
>  		dev_err(dev, "NAND Flash not found !\n");
> -		devm_free_irq(dev, prv->irq, mtd);
>  		retval =3D -ENXIO;
>  		goto error;
>  	}
> @@ -828,7 +806,6 @@ static int __devinit mpc5121_nfc_probe(struct platfor=
m_device *op)
> =20
>  	default:
>  		dev_err(dev, "Unsupported NAND flash!\n");
> -		devm_free_irq(dev, prv->irq, mtd);
>  		retval =3D -ENXIO;
>  		goto error;
>  	}
> @@ -839,13 +816,12 @@ static int __devinit mpc5121_nfc_probe(struct platf=
orm_device *op)
>  	retval =3D mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
>  	if (retval) {
>  		dev_err(dev, "Error adding MTD device!\n");
> -		devm_free_irq(dev, prv->irq, mtd);
>  		goto error;
>  	}
> =20
>  	return 0;
>  error:
> -	mpc5121_nfc_free(dev, mtd);
> +	clk_disable(prv->clk);
>  	return retval;
>  }
> =20
> @@ -857,8 +833,7 @@ static int __devexit mpc5121_nfc_remove(struct platfo=
rm_device *op)
>  	struct mpc5121_nfc_prv *prv =3D chip->priv;
> =20
>  	nand_release(mtd);
> -	devm_free_irq(dev, prv->irq, mtd);
> -	mpc5121_nfc_free(dev, mtd);
> +	clk_disable(prv->clk);
> =20
>  	return 0;
>  }
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Best Regards,
Artem Bityutskiy

--=-tdXTmw5a0pc+y+6PPrfQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRb8LAAoJECmIfjd9wqK0PMIQAIjgE8mRU2wujDAd3dv7Mea7
G3Vzxd1ibEAGRZFmTNdXHOjRIpjYi5vCoK0x+rbzzqD59z7h996htnws2wtKDEqZ
gMmeFUFzqXSx1cUFmcOcmnVb3Swz4JGYK3bfvanvdz2YOwdAJKjsxxrqXm9CdEvl
ygjC7J6Aowc5/bRqn4g3d92yJX4TidBwbwWxnHIZ1ekrnPUKNdrKh0rTvAN6NcMD
V9sFKIj6wyqwnHTIRRgIZ8Q2XApAF+1A3kTobRhEEHeg3omPbhx9+idWis70cGwE
56wAEQ9eijQYiZQEJhfC6Dacnm7AoWvPWWkLj+Bs2aX79Dtr2a46Lb/MZHOd3617
UKhVpfYqW2v4aOERrnUZneS1ntY8pROZVU+95Vf+w8bzfybSC0xS2l58caNSFXCl
eaG7Zrd9uARKquvEBLKXbBOiUk0DIHEtorSfhMVsCiliMEohzzD0hAOnlnBFa8VO
zV7xeL7AuJUOmNE4CD299vMBywJMdniEI2lu2cZvMiYIPNL9V0rh3ODqfM/VnUl3
noWy8JAirenLDwZZ5p4weEBLNbuHidRutIakw9NINAAvKOHdGUFAfRP2JQEmiNXw
dkilHY3lzQZJUudkkl3TP1MAH1aA8ydF0UkcLzB/g6Taot9oe0trgkRTvLKyXCB8
QbQmRQChRaTV0f6CNz4V
=+6xP
-----END PGP SIGNATURE-----

--=-tdXTmw5a0pc+y+6PPrfQ--

