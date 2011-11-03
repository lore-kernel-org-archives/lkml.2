Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1KCHqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:46:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58552 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1KCHq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:46:29 -0400
Date: Thu, 3 Nov 2011 08:46:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, David Anderson <danders.dev@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtc: ds1307: generalise ram size and offset
Message-ID: <20111103074623.GA14390@pengutronix.de>
References: <1320276834.3000.26.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <1320276834.3000.26.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2011 at 12:33:54PM +1300, Austin Boyle wrote:
> From: Austin Boyle <Austin.Boyle@aviatnet.com>
>=20
> This patch generalises NVRAM to support RAM with other size and offset, s=
uch
> as the 64 bytes of SRAM on the mcp7941x.

Thanks! This made the patch much more readable, so I saw another optimizati=
on.
And one question.

>=20
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: David Anderson <danders.dev@gmail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
> ---
> this patch is based on Wolfram Sang's tree:
> git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307
>=20
> patch depends on:
> rtc: ds1307: comment and format cleanup 21af5f7bd6
> rtc: ds1307: simplify irq setup code  8c63e03627
> rtc: ds1307: refactor chip_desc table e246db081d
> rtc: add initial support for mcp7941x parts e69bba2d3a
>=20
> --- a/drivers/rtc/rtc-ds1307.c	2011-10-10 11:22:22.674690998 +1300
> +++ b/drivers/rtc/rtc-ds1307.c	2011-11-03 12:17:40.777642801 +1300
> @@ -104,6 +104,8 @@ enum ds_type {
> =20
>  struct ds1307 {
>  	u8			offset; /* register's offset */
> +	u16			nvram_offset;
> +	u16			nvram_size;
>  	u8			regs[11];
>  	enum ds_type		type;
>  	unsigned long		flags;
> @@ -119,19 +121,19 @@ struct ds1307 {
>  };
> =20
>  struct chip_desc {
> -	unsigned		nvram56:1;
> +	unsigned		nvram:1;

What about removing this field...

>  	unsigned		alarm:1;
>  };
> =20
>  static const struct chip_desc chips[last_ds_type] =3D {
>  	[ds_1307] =3D {
> -		.nvram56	=3D 1,
> +		.nvram		=3D 1,
>  	},
>  	[ds_1337] =3D {
>  		.alarm		=3D 1,
>  	},
>  	[ds_1338] =3D {
> -		.nvram56	=3D 1,
> +		.nvram		=3D 1,
>  	},
>  	[ds_1339] =3D {
>  		.alarm		=3D 1,
> @@ -139,6 +141,9 @@ static const struct chip_desc chips[last
>  	[ds_3231] =3D {
>  		.alarm		=3D 1,
>  	},
> +	[mcp7941x] =3D {
> +		.nvram		=3D 1,
> +	},
>  };
> =20
>  static const struct i2c_device_id ds1307_id[] =3D {
> @@ -543,8 +548,6 @@ static const struct rtc_class_ops ds13xx
> =20
>  /*----------------------------------------------------------------------=
*/
> =20
> -#define NVRAM_SIZE	56
> -
>  static ssize_t
>  ds1307_nvram_read(struct file *filp, struct kobject *kobj,
>  		struct bin_attribute *attr,
> @@ -557,14 +560,15 @@ ds1307_nvram_read(struct file *filp, str
>  	client =3D kobj_to_i2c_client(kobj);
>  	ds1307 =3D i2c_get_clientdata(client);
> =20
> -	if (unlikely(off >=3D NVRAM_SIZE))
> +	if (unlikely(off >=3D ds1307->nvram_size))
>  		return 0;
> -	if ((off + count) > NVRAM_SIZE)
> -		count =3D NVRAM_SIZE - off;
> +	if ((off + count) > ds1307->nvram_size)
> +		count =3D ds1307->nvram_size - off;
>  	if (unlikely(!count))
>  		return count;
> =20
> -	result =3D ds1307->read_block_data(client, 8 + off, count, buf);
> +	result =3D ds1307->read_block_data(client, ds1307->nvram_offset + off,
> +								count, buf);
>  	if (result < 0)
>  		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
>  	return result;
> @@ -582,14 +586,15 @@ ds1307_nvram_write(struct file *filp, st
>  	client =3D kobj_to_i2c_client(kobj);
>  	ds1307 =3D i2c_get_clientdata(client);
> =20
> -	if (unlikely(off >=3D NVRAM_SIZE))
> +	if (unlikely(off >=3D ds1307->nvram_size))
>  		return -EFBIG;
> -	if ((off + count) > NVRAM_SIZE)
> -		count =3D NVRAM_SIZE - off;
> +	if ((off + count) > ds1307->nvram_size)
> +		count =3D ds1307->nvram_size - off;
>  	if (unlikely(!count))
>  		return count;
> =20
> -	result =3D ds1307->write_block_data(client, 8 + off, count, buf);
> +	result =3D ds1307->write_block_data(client, ds1307->nvram_offset + off,
> +								count, buf);
>  	if (result < 0) {
>  		dev_err(&client->dev, "%s error %d\n", "nvram write", result);
>  		return result;
> @@ -605,7 +610,6 @@ static struct bin_attribute nvram =3D {
> =20
>  	.read	=3D ds1307_nvram_read,
>  	.write	=3D ds1307_nvram_write,
> -	.size	=3D NVRAM_SIZE,
>  };
> =20
>  /*----------------------------------------------------------------------=
*/
> @@ -692,6 +696,9 @@ static int __devinit ds1307_probe(struct
>  		break;
> =20
>  	case rx_8025:
> +		ds1307->nvram_size =3D 64; /* 64 bytes SRAM */
> +		ds1307->nvram_offset =3D 0x20;
> +

Question: Why are you adding this code here and not to the mcp7941x related
code?

>  		tmp =3D i2c_smbus_read_i2c_block_data(ds1307->client,
>  				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
>  		if (tmp !=3D 2) {
> @@ -758,6 +765,8 @@ static int __devinit ds1307_probe(struct
>  		break;
>  	case ds_1388:
>  		ds1307->offset =3D 1; /* Seconds starts at 1 */
> +		ds1307->nvram_size =3D 56; /* 56 bytes NVRAM */
> +		ds1307->nvram_offset =3D 8;

Is this the right place to enable it for the 1307/1338?

>  		break;
>  	default:
>  		break;
> @@ -893,11 +902,12 @@ read_rtc:
>  		dev_dbg(&client->dev, "got IRQ %d\n", client->irq);
>  	}
> =20
> -	if (chip && chip->nvram56) {
> +	if (chip && chip->nvram) {

If we removed the nvram field above, then we could simply use
ds1307->nvram_size here. If that turns out to be too messy to set up, we co=
uld
also put nvram_size and nvram_offset to the chip_desc instead.

> +		nvram.size =3D ds1307->nvram_size;
>  		err =3D sysfs_create_bin_file(&client->dev.kobj, &nvram);
>  		if (err =3D=3D 0) {
>  			set_bit(HAS_NVRAM, &ds1307->flags);
> -			dev_info(&client->dev, "56 bytes nvram\n");
> +			dev_info(&client->dev, "%zd bytes nvram\n", nvram.size);
>  		}
>  	}
> =20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6yRs8ACgkQD27XaX1/VRtbvACfbupWp2rbsz+h9CJWzzvWXdUE
l8AAoLWeKLpGGEks+mPRTdb8qI8xNqhS
=qBrp
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
