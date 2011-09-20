Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1ITPAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:00:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1ITPAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:00:40 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: syed rafiuddin <rafiuddin.sayed@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        vimal.newwork@gmail.com
Subject: Re: [PATCH] bq27x00: Addition of POWER_SUPPLY_PROP_HEALTH property
Date: Tue, 20 Sep 2011 17:00:18 +0200
Message-ID: <1455061.7xDtPo7THF@pali-elitebook>
User-Agent: KMail/4.7.0  (Linux/3.0.0-11-generic; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAF5reFh7-eroTCfN5MBKjmH4W7S_K-Z3MXoKU93sdtsNo0hxCA@mail.gmail.com>
References: <CAF5reFh7-eroTCfN5MBKjmH4W7S_K-Z3MXoKU93sdtsNo0hxCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1504826.hbWeiynDt7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1504826.hbWeiynDt7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday 24 August 2011 12:51:38 syed rafiuddin wrote:
> This patch adds POWER_SUPPLY_PROP_HEALTH property which reports
> the battery state as good or dead.
>=20
> Signed-off-by: syed rafiuddin <rafiudidn.29@gmail.com>
> Reviewed-by: Pali Roh=E1r <pali.rohar@gmail.com>
> Reviewed-by: vimal singh <vimal.newwork@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |   37
> +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/power/bq27x00_battery.c
> b/drivers/power/bq27x00_battery.c
> index bb16f5b..2aeb1c2 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -54,13 +54,16 @@
>=20
>  #define BQ27000_REG_RSOC 0x0B /* Relative State-of-Charge */
>  #define BQ27000_REG_ILMD 0x76 /* Initial last measured discharge */
> +#define BQ27000_FLAG_EDVF BIT(0)
>  #define BQ27000_FLAG_CHGS BIT(7)
>  #define BQ27000_FLAG_FC BIT(5)
>=20
>  #define BQ27500_REG_SOC 0x2C
>  #define BQ27500_REG_DCAP 0x3C /* Design capacity */
>  #define BQ27500_FLAG_DSC BIT(0)
> +#define BQ27500_FLAG_SOCF BIT(1)
>  #define BQ27500_FLAG_FC BIT(9)
> +#define BQ27500_FLAG_OTC BIT(15)
>=20
>  #define BQ27000_RS 20 /* Resistor sense */
>=20
> @@ -118,6 +121,7 @@ static enum power_supply_property
> bq27x00_battery_props[] =3D {
>   POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
>   POWER_SUPPLY_PROP_CYCLE_COUNT,
>   POWER_SUPPLY_PROP_ENERGY_NOW,
> + POWER_SUPPLY_PROP_HEALTH,
>  };
>=20
>  static unsigned int poll_interval =3D 360;
> @@ -437,6 +441,36 @@ static int bq27x00_simple_value(int value,
>   return 0;
>  }
>=20
> +static int bq27x00_battery_health(struct bq27x00_device_info *di,
> + union power_supply_propval *val)
> +{
> + int ret;
> + int status;
> +
> + ret =3D bq27x00_read(di, BQ27x00_REG_FLAGS, false);
> + if (ret < 0)
> + return ret;
> +
> + if (di->chip =3D=3D BQ27500) {
> + if (ret & BQ27500_FLAG_SOCF)
> + status =3D POWER_SUPPLY_HEALTH_DEAD;
> + else if (ret & BQ27500_FLAG_OTC)
> + status =3D POWER_SUPPLY_HEALTH_OVERHEAT;
> + else
> + status =3D POWER_SUPPLY_HEALTH_GOOD;
> +
> + val->intval =3D status;
> + } else {
> + if (ret & BQ27000_FLAG_EDVF)
> + status =3D POWER_SUPPLY_HEALTH_DEAD;
> + else
> + status =3D POWER_SUPPLY_HEALTH_GOOD;
> +
> + val->intval =3D status;
> + }
> + return 0;
> +}
> +
>  #define to_bq27x00_device_info(x) container_of((x), \
>   struct bq27x00_device_info, bat);
>=20
> @@ -503,6 +537,9 @@ static int bq27x00_battery_get_property(struct
> power_supply *psy,
>   case POWER_SUPPLY_PROP_ENERGY_NOW:
>   ret =3D bq27x00_battery_energy(di, val);
>   break;
> + case POWER_SUPPLY_PROP_HEALTH:
> + ret =3D bq27x00_battery_health(di, val);
> + break;
>   default:
>   return -EINVAL;
>   }

Hello,

sorry for late comment, but

I looked into datasheet properly again and this patch does not do what =
is in=20
head message.

For bq27000/27200 battery:
BQ27000_FLAG_EDVF bit is set when battery is discharged to empty capaci=
ty=20
treshold. So I think that BQ27000_FLAG_EDVF can be used in power_supply=
 for=20
POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL flag.

For bq27500 battery:
BQ27500_FLAG_SOCF bit indicate final discharge capacity warning. So it =
is=20
similar as EDVF bit for bq27000 battery.

BQ27500_FLAG_OTC bit is set when detected overtemperature in charging m=
ode. So=20
I think only this flag can be used for POWER_SUPPLY_HEALTH property. Al=
so in=20
datasheet is bit OTD which is set when detedted overtemperature in disc=
harging=20
mode. So it could be set to POWER_SUPPLY_HEALTH_OVERHEAT too.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1504826.hbWeiynDt7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk54qoIACgkQi/DJPQPkQ1LqPACeI1QZ5nXtStbiQQH/9ZF58gju
h1gAn1XirksyjsJ2KXn3+BWNbX2dpZlI
=fw31
-----END PGP SIGNATURE-----

--nextPart1504826.hbWeiynDt7--

