Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2BXMX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 07:23:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41152 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2BXMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 07:23:57 -0500
Date: Fri, 24 Feb 2012 13:23:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-isch: Add module parameter which actually set
 the clock divider
Message-ID: <20120224122348.GF2479@pengutronix.de>
References: <1329316609-14570-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Content-Disposition: inline
In-Reply-To: <1329316609-14570-1-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2012 at 03:36:49PM +0100, Alexander Stein wrote:
> It was observed the Host Clock Divider was not written by the driver. It
> was still set to (default) 0, if not already set by BIOS, which caused
> garbage on SMBus.
> This driver adds 2 parameters which are used to calculate the divider
> appropriately. This new divider is only applied if the clock divider is
> still default 0.
>=20
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> Tested-by: Adam Pribyl <pribyl@lowlevel.cz>
> ---

I don't know the hardware: Can it have multiple SmBusses? Then, a module
parameter would force all of them to the selected mode. Do you really
need the parameter? Maybe defaulting to 100Kbps is sane enough?

@Jean: Is this an embedded driver? :)

> Changes in v2:
> * HSTCLK register is 16 Bit, not 8 Bit. Thanks to Adam for detecting
>=20
>  drivers/i2c/busses/i2c-isch.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-isch.c b/drivers/i2c/busses/i2c-isch.c
> index 6561d27..bdfddf8 100644
> --- a/drivers/i2c/busses/i2c-isch.c
> +++ b/drivers/i2c/busses/i2c-isch.c
> @@ -40,6 +40,7 @@
>  /* SCH SMBus address offsets */
>  #define SMBHSTCNT	(0 + sch_smba)
>  #define SMBHSTSTS	(1 + sch_smba)
> +#define SMBHSTCLK	(2 + sch_smba)
>  #define SMBHSTADD	(4 + sch_smba) /* TSA */
>  #define SMBHSTCMD	(5 + sch_smba)
>  #define SMBHSTDAT0	(6 + sch_smba)
> @@ -58,6 +59,8 @@
> =20
>  static unsigned short sch_smba;
>  static struct i2c_adapter sch_adapter;
> +static int smbus_speed =3D 100; /* SMBus bus speed in Kbps */
> +static int backbone_speed =3D 33000; /* backbone speed in KHz */
> =20
>  /*
>   * Start the i2c transaction -- the i2c_access will prepare the transact=
ion
> @@ -156,6 +159,13 @@ static s32 sch_access(struct i2c_adapter *adap, u16 =
addr,
>  		dev_dbg(&sch_adapter.dev, "SMBus busy (%02x)\n", temp);
>  		return -EAGAIN;
>  	}
> +	temp =3D inw(SMBHSTCLK);
> +	if (!temp) {
> +		dev_notice(&sch_adapter.dev, "clock divider unitialized. Setting modul=
e defaults\n");
> +		dev_dbg(&sch_adapter.dev, "access speed: %d KHz\n", smbus_speed);
> +		outw((backbone_speed / 4) / smbus_speed, SMBHSTCLK);
> +	}
> +
>  	dev_dbg(&sch_adapter.dev, "access size: %d %s\n", size,
>  		(read_write)?"READ":"WRITE");
>  	switch (size) {
> @@ -312,3 +322,5 @@ MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@intel.com>");
>  MODULE_DESCRIPTION("Intel SCH SMBus driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:isch_smbus");
> +module_param(smbus_speed, int, (S_IRUSR | S_IWUSR));
> +module_param(backbone_speed, int, (S_IRUSR | S_IWUSR));
> --=20
> 1.7.3.4
>=20

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9HgVQACgkQD27XaX1/VRvoWwCgxtngr1igPkFM1SfDqV7iW7zM
r4IAnRFzWXeOigfSE6pZkg3Wigawfqbx
=4Dw5
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
