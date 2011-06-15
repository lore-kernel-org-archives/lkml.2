Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1FONAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:00:16 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:39638 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab1FONAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:00:15 -0400
Date: Wed, 15 Jun 2011 16:00:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Message-ID: <20110615130005.GM471@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <201106070316.41099.jkrzyszt@tis.icnet.pl>
 <20110614114848.GS3352@atomide.com>
 <20110614115959.GI2353@legolas.emea.dhcp.ti.com>
 <201106151453.07945.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Content-Disposition: inline
In-Reply-To: <201106151453.07945.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 15, 2011 at 02:53:01PM +0200, Janusz Krzysztofik wrote:
> > to me it sounds like missing __init/__exit annotations on the driver.
> > See ams-delta-leds for instance:
> >=20
> > static int ams_delta_led_probe(struct platform_device *pdev)
> > static int ams_delta_led_remove(struct platform_device *pdev)
> >=20
> > which means those drivers will have probe sitting outside or
> > .init.text and trying to reference name which sits in .init.text ???
> > Could that be the case here ?
>=20
> Missing or not, addig them didn't help.

ok...

> > But it could also be that the platform_device shouldn't be marked
> > __initdata.
>=20
> After either reverting one of commits mentioned, or applying my patch,=20
> a read from /sys/devices/platform/ams-delta-led/uevent, for example,=20
> returns:
>=20
> DRIVER=3Dams-delta-led
> MODALIAS=3Dplatform:ams-delta-led
>=20
> The code responsible for returning these strings can be found in=20
> drivers/base/core.c:
>=20
> static int dev_uevent(struct kset *kset, struct kobject *kobj,
> 		struct kobj_uevent_env *env)
> {
> 	struct device *dev =3D to_dev(kobj);
> ...
> 	if (dev->driver)
> 		add_uevent_var(env, "DRIVER=3D%s", dev->driver->name);
>=20
> 	/* have the bus specific function add its stuff */
> 	if (dev->bus && dev->bus->uevent) {
>                 retval =3D dev->bus->uevent(dev, env);
> ...
>=20
> The dev->bus->uevent for a platform device happens to sit in=20
> drivers/base/platform.c:
>=20
> static int platform_uevent(struct device *dev, struct kobj_uevent_env *en=
v)
> {
> 	struct platform_device  *pdev =3D to_platform_device(dev);
> ...
> 	add_uevent_var(env, "MODALIAS=3D%s%s", PLATFORM_MODULE_PREFIX,
> 		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> ...
>=20
> For me, it looks like struct kobject, pointed to by kobj, being a member=
=20
> of struct device, which in turn happens to be a member of struct=20
> platform_device.
>=20
> AFAICU, there exist two sorts of platform devices from memory allocation=
=20
> point of view: those created with platform_device_alloc(), which=20
> allocates a memory where struct platform_device is kept, and those=20
> created with platfrom_device_add(), which is provided with a pointer to=
=20
> an already allocated platform device structure.
>=20
> I can't find any piece of code which makes a copy of a platfrom deivce=20
> structure content pointed to while platform_device_add() is called from=
=20
> a board or machine file, either directly or indirectly via=20
> platform_device_register() or platform_add_devices().
> Why should it be actually copied after all?.

true, it makes sense to remove __initdata from the platform_device
structures.

> Searching for an example usage of _initdata similiar to that introduced=
=20
> by commit bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a=20
> bunch of section mismatches", I can find the following:
>=20
> $ grep -r "struct .* platform_device .* =3D {" .|grep "__initdata"|grep -=
v '*'
> ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams=
_delta_kp_device __initdata =3D {
> ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams=
_delta_lcd_device __initdata =3D {
> ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams=
_delta_led_device __initdata =3D {
> ./arch/arm/mach-omap1/board-ams-delta.c:static struct platform_device ams=
_delta_camera_device __initdata =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_mpu_gpio =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio1 =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio2 =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio3 =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio4 =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio5 =3D {
> ./arch/arm/mach-omap1/gpio7xx.c:static struct __initdata platform_device =
omap7xx_gpio6 =3D {
> ./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device=
 omap15xx_mpu_gpio =3D {
> ./arch/arm/mach-omap1/gpio15xx.c:static struct __initdata platform_device=
 omap15xx_gpio =3D {
> ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device=
 omap16xx_mpu_gpio =3D {
> ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device=
 omap16xx_gpio1 =3D {
> ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device=
 omap16xx_gpio2 =3D {
> ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device=
 omap16xx_gpio3 =3D {
> ./arch/arm/mach-omap1/gpio16xx.c:static struct __initdata platform_device=
 omap16xx_gpio4 =3D {
> ./arch/arm/mach-omap2/board-rx51-peripherals.c:static struct platform_dev=
ice rx51_si4713_dev __initdata_or_module =3D {
>=20
> So, there is no single exact pattern found in the whole tree, and a few=
=20
> instances of similiar patterns of two kinds found only inside omap. If I=
=20
> follow any of the two, either moving '__initdata' in front of=20
> 'platform_device' or using '__initdata_or_module' instead, the problem=20
> no longer hits me (using my custom defconfig). However, the former seems=
=20
> not conformant to what one can learn from include/linux/init.h, so I=20
> suspect that placing __initdata like this can be a noop, while the=20
> latter means "can be init if no module support", which would probably=20
> still exhibit the problem if so configured.
>=20
> How would you like to have this corrected then?

I guess removing __initdata from all platoform_device structures is the
way to go. We need to find another way to silent the section mismatch
warnings.

--=20
balbi

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+KzVAAoJEAv8Txj19kN19MEH/iZtPlXxfG2n/mRqEf+c3SCb
XAVxEFgeY6PYfJjnZST/8wD8bzw/We4eKub35NVbRMqZN8bUB5syjD3uFRYS3reR
W3BIvrIkKXetBlXue8T6O/Ro+Puaem/dndeSZXtVWqbLd2uTNj2Db5grTJPVcosv
SO8DMIvTO0CVQbbj9cn5RYaT/OBsTUagYoMwEJoFmMqU6RAk9ZlnDdcOfogvY4RE
PvqxTpNEU8xH0TO/mHW+Y2RbtH0E4gFXvFdgr+otPF6Wc65wl9KhC3UT4d5h1dmv
cVQyrMYdMDcpuDilKu/ikzq3L7o1wzOG20X7xHiO5/y6PxMGTq7BetHb8B4bfeU=
=K3l3
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
