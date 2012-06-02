Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966389Ab2FBHTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 03:19:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59228 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966240Ab2FBHTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 03:19:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [uclinux-dist-devel] [PATCH 2/2] crypto: bfin_crc: CRC hardware accelerator driver for BF60x family processors.
Date: Sat, 2 Jun 2012 03:19:12 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0; KDE/4.6.5; x86_64; ; )
Cc: Sonic Zhang <sonic.adi@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com> <1337939654-12222-2-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1337939654-12222-2-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4760448.rYs5TWBIB5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201206020319.14870.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4760448.rYs5TWBIB5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 25 May 2012 05:54:14 Sonic Zhang wrote:
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
>=20
> +config CRYPTO_DEV_BFIN_CRC
> +	tristate "Support for Blackfin CRC hareware accelerator"

hardware

> +	depends on BF60x
> +	help
> +	  Blackfin processors have CRC hardware accelerator.

Newer Blackfin processors have a CRC hardware accelerator.

> --- /dev/null
> +++ b/drivers/crypto/bfin_crc.c
>
> +struct bfin_crypto_crc_list {
> +	struct list_head	dev_list;
> +	spinlock_t		lock;
> +} crc_list;

static

> +	if (sg_count(req->src) > CRC_MAX_DMA_DESC) {
> +		dev_dbg(crc->dev, "init: requested sg list is too big > %d\n",
> +			CRC_MAX_DMA_DESC);
> +		return -EINVAL;
> +	}

do you need to do this ?  considering the crc is stream based, why can't yo=
u=20
fill up as many as possible, wait for it to finish, and then send more data=
 ?

> +	/* init crc results */
> +	*(__le32 *)req->result =3D
> +		cpu_to_le32p(&crc_ctx->key);

right handed casts are generally frowned upon if not banned.  plus, result =
is=20
a u8*, so it seems like a pretty bad idea to do this on a Blackfin (which=20
doesn't allow unaligned accesses).  isn't this what you want:
	put_unaligned_le32(crc_ctx->key, req->result);

> +		/* chop current sg dma len to multiply of 32 bits */

"multiply" -> "multiple"

> +		dma_count =3D (dma_count >> 2) << 2;

dma_count &=3D ~0x3;

> +	if (i =3D=3D 0)
> +		return ;

no space before the ;

> +#define MIN(x,y) ((x) < (y) ? x : y)

linux/kernel.h already provides min() macros for you

> +		/* Pack small data which is less than 32bit to buffer for next=20
update.*/

needs a space after the period

> +		/* punch crc buffer size to multiply of 32 bit */

i think you mean "chop" rather than "punch", and it should be "multiple"=20
rather than "multiply"

> +		ctx->sg_buflen =3D (ctx->sg_buflen >> 2) << 2;

ctx->sg_buflen &=3D ~0x3;

> +			memset(ctx->bufnext, 0,	CHKSUM_DIGEST_SIZE);

use a space after the , not a tab

> +			nextlen =3D ctx->bufnext_len;
> +			for (i =3D nsg - 1; i >=3D 0; i--) {
> +				sg =3D sg_get(ctx->sg, nsg, i);

this is the only place you use sg_get(), and it looks like it's extremely=20
inefficient.  i guess it's not possible to re-order the pointer walking tho=
ugh.

> +static int bfin_crypto_crc_setkey(struct crypto_ahash *tfm, const u8 *ke=
y,
> +		      unsigned int keylen)
> +{
> +	struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_ahash_ctx(tfm);
> +
> +	dev_dbg(crc_ctx->crc->dev, "crc_setkey\n");
> +        if (keylen !=3D CHKSUM_DIGEST_SIZE) {
> +                crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +                return -EINVAL;
> +        }

indentation seems to be off here.  suggest you run this through checkpatch.=
pl.

> +	crc_ctx->key =3D le32_to_cpu(*(__le32 *)key);

shouldn't this be get_unaligned_le32 ?

> +		/* prepare results */
> +		*(__le32 *)crc->req->result =3D
> +			cpu_to_le32p((u32 *)&crc->regs->result);

put_unaligned_le32()

> +static int bfin_crypto_crc_suspend(struct platform_device *pdev,
> pm_message_t state) +{
> +	struct bfin_crypto_crc *crc =3D platform_get_drvdata(pdev);
> +	int i =3D 100000;
> +
> +	while ((crc->regs->control & BLKEN) && --i)
> +		cpu_relax();
> +
> +	if (i =3D=3D 0)
> +		crc->regs->control &=3D ~BLKEN;
> +
> +	return 0;
> +}

should this return -EBUSY instead of clearing BLKEN ?

> +static int bfin_crypto_crc_resume(struct platform_device *pdev)
> +{
> +	return 0;
> +}

if there's nothing to resume, do you need to provide your own func ?

> +static int __devinit bfin_crypto_crc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +	struct bfin_crypto_crc *crc =3D NULL;

not much point in setting this to NULL considering the first thing you do i=
s=20
allocate it

> +	ret =3D request_irq(crc->irq, bfin_crypto_crc_handler, IRQF_SHARED,
> DRIVER_NAME, crc);

you could use dev_name() rather than DRIVER_NAME

> +	ret =3D request_dma(crc->dma_ch, DRIVER_NAME);

same here

> +	/* need at most CRC_MAX_DMA_DESC sg + CRC_MAX_DMA_DESC middle  +
> +	   1 last + 1 next dma descriptors
> +	 */

multiline comments look like:
	/*
	 * foo
	 * bar
	 */

> +	while (!(crc->regs->status & LUTDONE) && (--timeout) > 0)
> +		cpu_relax();

no need for paren around the timeout decrement, and this should be an actua=
l=20
timer based timeout rather than some big integer.  pretty easy to do with=20
wait_for_completion_timeout().

> +static int __devexit bfin_crypto_crc_remove(struct platform_device *pdev)
> +{
> +	struct bfin_crypto_crc *crc =3D platform_get_drvdata(pdev);
> +
> +	if (!crc)
> +		return -ENODEV;

is this even possible ?

> +static int __init bfin_crypto_crc_mod_init(void)
> +{
> +	int ret;
> +
> +	pr_info("Blackfin hardware CRC crypto driver\n");
> +
> +	INIT_LIST_HEAD(&crc_list.dev_list);
> +	spin_lock_init(&crc_list.lock);
> +
> +	ret =3D platform_driver_register(&bfin_crypto_crc_driver);
> +	if (ret) {
> +		pr_info(KERN_ERR "unable to register driver\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}

if you declare the list/spin_lock separately and not together in a structur=
e,=20
you could statically initialize them (rather than needing to do it at=20
runtime), and then you could drop the init/exit functions here and replace=
=20
them with a single module_platform_driver(bfin_crypto_crc_driver).
=2Dmike

--nextPart4760448.rYs5TWBIB5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPyb5yAAoJEEFjO5/oN/WBhYMP/RR09ljvwJiIlL0Z/yaj3ACC
dXMpFGtX/ebvhYosBzM0y79Ki+pyXC/Wbu+sk+OryPufknCObQdf1XA9hSVJbT1c
LNlNpbGFnxwp4qrfE69wLzV2DK5kOFO3HmqrGlJBVS7z9UdFkuqe/AeWra08p5qz
7qp3zynyLKYQi7pLRyLBmOLC38Rf9vDNn/RB0a9pLyzZvF9oy/WAQAwfmvzMb1TH
jDO09KOu0TCV6Ytx3FBvmf60avSz73gy8tWBfaDXGCTgYiMN/MeLhlNp7mzZNhZY
wE8v43uz+aeuqL6ACe4Rtucml3v8hOVAV7BA4FTZSy3rnSfxPXZNuxQFfwQvTY5J
D1ch6ZsQpElkJbvQLZ+MQuyeRUx6HIMOKKFRmBGttlrJFpKjaxDtW35EnUgVJUZ1
XlNIeqC8IZFEFGNlVQUKSdYzGgGurGUcJ3bepNAwHm5+6ZbKc7FdphoF6p4CyaY7
Rc6Fzx3HzV//GL/x94deF+Che9Jvt4QN4nwL1uxzbdtnW7QSqGDjjKS6HXX/nKvt
HLcYuA6PVwK6FmSg7D1hRER5MMcyNNAOPItAJn/vQ9hTTuLd2XLpeSBuN3+y7Ikf
h8UMoDfHjR7u5ftao2iNG6Q4p+iCCGRcbgdPUtv/3ACRzedYKdhPwkH44S4lq37Y
MNqPE4hfm38RejSjv4wb
=kF6g
-----END PGP SIGNATURE-----

--nextPart4760448.rYs5TWBIB5--
