Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab1LPEIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:08:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1LPEIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:08:42 -0500
Date: Fri, 16 Dec 2011 15:08:12 +1100
From: NeilBrown <neilb@suse.de>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>, Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Message-ID: <20111216150812.1ab91f03@notabene.brown>
In-Reply-To: <CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
	<20111206060654.0e8bebe0@notabene.brown>
	<CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
	<20111210181546.6da7099a@notabene.brown>
	<CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ePni/_4k.AcyM+kBOIFh4lx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ePni/_4k.AcyM+kBOIFh4lx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Dec 2011 09:30:48 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:

> On Sat, Dec 10, 2011 at 9:15 AM, NeilBrown <neilb@suse.de> wrote:
> > When I force it to hold off suspend for a little while I see (starting =
at the
> > same place):
> >
> > [ =C2=A0656.189697] bus: 'sdio': driver_probe_device: matched device mm=
c1:0001:1 with driver libertas_sdio
> > [ =C2=A0656.212768] bus: 'sdio': really_probe: probing driver libertas_=
sdio with device mmc1:0001:1
> > [ =C2=A0656.247741] libertas_sdio mmc1:0001:1: firmware: requesting lib=
ertas/sd8686_v9_helper.bin
> > [ =C2=A0656.257537] device: 'mmc1:0001:1': device_add
> > [ =C2=A0656.263580] PM: Adding info for No Bus:mmc1:0001:1
> > [ =C2=A0656.298187] device: 'mmc1:0001:1': device_unregister
> > [ =C2=A0656.303375] PM: Removing info for No Bus:mmc1:0001:1
> > [ =C2=A0656.322967] libertas_sdio mmc1:0001:1: firmware: requesting lib=
ertas/sd8686_v8_helper.bin
> > [ =C2=A0656.344207] device: 'mmc1:0001:1': device_add
> > [ =C2=A0656.357147] PM: Adding info for No Bus:mmc1:0001:1
> > [ =C2=A0656.395782] device: 'mmc1:0001:1': device_unregister
> > [ =C2=A0656.407409] PM: Removing info for No Bus:mmc1:0001:1
> > [ =C2=A0656.418579] libertas_sdio mmc1:0001:1: firmware: requesting sd8=
686_helper.bin
> > [ =C2=A0656.435699] device: 'mmc1:0001:1': device_add
> > [ =C2=A0656.446655] PM: Adding info for No Bus:mmc1:0001:1
> > [ =C2=A0656.504974] device: 'mmc1:0001:1': device_unregister
> > [ =C2=A0656.511749] PM: Removing info for No Bus:mmc1:0001:1
> > [ =C2=A0656.521148] libertas_sdio mmc1:0001:1: firmware: requesting sd8=
686.bin
> > [ =C2=A0656.529205] device: 'mmc1:0001:1': device_add
> > [ =C2=A0656.535095] PM: Adding info for No Bus:mmc1:0001:1
> > [ =C2=A0656.584625] device: 'mmc1:0001:1': device_unregister
> > [ =C2=A0656.591369] PM: Removing info for No Bus:mmc1:0001:1
> > [ =C2=A0657.384063] libertas_sdio mmc1:0001:1: (unregistered net_device=
): 00:19:88:3d:ff:f0, fw 9.70.3p24, cap 0x00000303
> > [ =C2=A0657.454467] libertas_sdio mmc1:0001:1: (unregistered net_device=
): PREP_CMD: command 0x00a3 failed: 2
> > [ =C2=A0657.464080] device: 'phy0': device_add
> >
> >
> > =C2=A0But shortly there after the extra tracing I put in shows that mmc=
_power_off
> > =C2=A0is called,
>=20
> Probably right after libertas' if_sdio_probe() returns ?

Sort-of.  It is actually called from pm_runtime_work so it is an async
pm_suspend.

It is triggered by the pm_runtime_put_sync() call in driver_probe_device()
just after really_probe() is called, and it was really_probe() that ultimat=
ely
called if_sdio_probe().  So depending on what you mean by "right after"
exactly, that might describe when it happened.

>=20
> > then mmc_sdio_power_restore calls mmc_send_io_op_cond
>=20
> Is that as a result of libertas' if_sdio_power_restore() being called
> (i.e. someone/something called 'ifconfig up') ?

Probably.  It is definitely if_sdio_power_restore() being called because
something did an ioctl, and that was probably wpa_supplicant trying to
configure the device.

>=20
> > which again
> > =C2=A0returns -110, but now it isn't a problem and the wifi chip keeps =
working.
>=20
> if_sdio_power_restore doesn't check the return value of
> pm_runtime_get_sync, so it won't error out, but I wonder how come the
> chip still works.

That bit is still a mystery.  I don't think it always works, but certainly
does some times.

I put some tracing in mmc_wait_for_command and see:

[   69.939819] mmc_wait_for_cmd 52 -> -110
[   69.944274] mmc_wait_for_cmd 52 -> -110
[   69.949066] mmc_wait_for_cmd 0 -> 0
[   69.954254] mmc_wait_for_cmd 8 -> -110
[   69.958679] mmc_wait_for_cmd 5 -> 0
[   69.962707] mmc_wait_for_cmd 5 -> 0
[   69.966827] mmc_wait_for_cmd 3 -> 0
[   69.970886] mmc_wait_for_cmd 7 -> 0
[   69.974914] mmc_wait_for_cmd 52 -> 0
[   69.979064] mmc_wait_for_cmd 52 -> 0
[   69.983154] mmc_wait_for_cmd 52 -> 0
[   69.987274] mmc_wait_for_cmd 52 -> 0

When I first try to start the wifi (turn on the regulator and assert the
card-detect).

 	mmc_wait_for_req(host, &mrq);
+	if (host->index =3D=3D 1)
+		printk("mmc_wait_for_cmd %d -> %d\n", cmd->opcode, cmd->error);

That last line repeats every few millisecs until

[   79.444793] mmc_wait_for_cmd 52 -> 0

about 10 seconds later (1777 repeats) when it stops.

Then when I start up wpa_supplicant I see


[  132.313293] mmc_wait_for_cmd 52 -> 0
[  132.317443] mmc_wait_for_cmd 52 -> 0
[  132.321990] mmc_wait_for_cmd 0 -> 0
[  132.327239] mmc_wait_for_cmd 8 -> -110
[  132.332824] mmc_wait_for_cmd 5 -> -110
[  132.337280] mmc_wait_for_cmd 52 -> 0
[  132.341400] mmc_wait_for_cmd 52 -> 0
[  132.345520] mmc_wait_for_cmd 52 -> 0
[  132.349639] mmc_wait_for_cmd 52 -> 0
[  132.353759] mmc_wait_for_cmd 52 -> 0

And the "52 -> 0" repeats indefinitely until I reboot.  But at this point
wifi is working - I get a dhcp reply and can ping hosts.


In the other case where I do let it suspend early (And it never recovers
without the reset line being toggled) I see:

[ 2170.100982] mmc_wait_for_cmd 52 -> -110
[ 2170.105407] mmc_wait_for_cmd 52 -> -110
[ 2170.110260] mmc_wait_for_cmd 0 -> 0
[ 2170.115509] mmc_wait_for_cmd 8 -> -110
[ 2170.119842] mmc_wait_for_cmd 5 -> 0
[ 2170.123901] mmc_wait_for_cmd 5 -> 0
[ 2170.127929] mmc_wait_for_cmd 3 -> 0
[ 2170.131958] mmc_wait_for_cmd 7 -> 0
[ 2170.135986] mmc_wait_for_cmd 52 -> 0
[ 2170.140136] mmc_wait_for_cmd 52 -> 0
[ 2170.144226] mmc_wait_for_cmd 52 -> 0
[ 2170.148376] mmc_wait_for_cmd 52 -> 0
[ 2170.152465] mmc_wait_for_cmd 52 -> 0


which is much the same but then one second later:

[ 2171.166656] mmc_wait_for_cmd 52 -> 0
[ 2171.170806] mmc_wait_for_cmd 52 -> 0
[ 2171.175384] mmc_wait_for_cmd 0 -> 0
[ 2171.180603] mmc_wait_for_cmd 8 -> -110
[ 2171.185943] mmc_wait_for_cmd 5 -> -110
[ 2171.190093] libertas_sdio: probe of mmc1:0001:1 failed with error -16


So this answers Bing Zhao's question - it was CMD5 that timed out and caused
the failure.

If I just get mmc_wait_for_cmd to hide error -110 for cmd 5 it complains

[   26.420440] mmc1: host doesn't support card's voltages

so that isn't a simple solution :-)


>=20
> > =C2=A0So maybe the fact that we error-out in the first case is a proble=
m??
>=20
> It might be nice if Marvell could comment on this, though we can
> probably empirically deduce this too.
>=20
> > =C2=A0I found that if I pull the reset line down and then let it back u=
p then it
> > =C2=A0all works.
>=20
> Nice. Joe, did this work out for you too ?
>=20
> > So I have run out of ideas. =C2=A0I can make it work by reseting the ch=
ip during
> > mmc_power_up but I have no idea what is causing the chip to need a rese=
t.
>=20
> I wonder why the sdio reset command isn't helpful for you - it did
> seem to resolve some issues for Daniel. Maybe you have two different
> hardware revisions of the 8686 which behave differently in this
> respect ?
>=20
> > However for now I think I'll go with my 'remux' hack.
>=20
> Feel free to post it so we can take a look.
>=20
> Thanks,
> Ohad.

It isn't very exciting but I include it below.

The change is entirely inside my 'board' file which isn't in mainline.

I define a 'remux' function  that lowers the reset line for 10msec and rais=
es
it again. (I don't know if the 10msec is needed).
tca_setup() is a callback from the driver that enables the gpio line (it is
one pin on an LED driver chip).

NeilBrown



diff --git a/arch/arm/mach-omap2/board-omap3gta04.c b/arch/arm/mach-omap2/b=
oard-omap3gta04.c
index 8a09b98..6a13822 100644
--- a/arch/arm/mach-omap2/board-omap3gta04.c
+++ b/arch/arm/mach-omap2/board-omap3gta04.c
@@ -357,6 +357,8 @@ static struct regulator_consumer_supply gta04_vdvi_supp=
ly =3D {
=20
 #include "sdram-micron-mt46h32m32lf-6.h"
=20
+static void wlan_reset(struct device *dev, int slow, int power_on);
+
 static struct omap2_hsmmc_info mmc[] =3D {
 	{
 		.mmc		=3D 1,
@@ -370,6 +372,7 @@ static struct omap2_hsmmc_info mmc[] =3D {
 		.gpio_cd	=3D -EINVAL, // virtual card detect
 		.gpio_wp	=3D -EINVAL,	// no write protect
 		.transceiver	=3D true,	// external transceiver
+		.remux		=3D wlan_reset,
 // 		.ocr_mask	=3D 0x00100000,	/* fixed 3.3V */
 	},
 	{}	/* Terminator */
@@ -769,11 +772,22 @@ struct bmp085_platform_data bmp085_info =3D {
 /* "+2" because TWL4030 adds 2 LED drives as gpio outputs */
 #define GPIO_WIFI_RESET (OMAP_MAX_GPIO_LINES + TWL4030_GPIO_MAX + 2)
=20
+static int reset_ready;
+static void wlan_reset(struct device *dev, int slow, int power_on)
+{
+	if (power_on && reset_ready) {
+		gpio_set_value(GPIO_WIFI_RESET, 0);
+		msleep(10);
+		gpio_set_value(GPIO_WIFI_RESET, 1);
+	}
+}
+
 void tca_setup(unsigned gpio_base, unsigned ngpio)
 {
 	gpio_request(GPIO_WIFI_RESET, "WIFI_RESET");
 	gpio_direction_output(GPIO_WIFI_RESET, true);
 	gpio_export(GPIO_WIFI_RESET, 0);
+	reset_ready =3D 1;
 }
=20
 static struct led_info tca6507_leds[] =3D {


--Sig_/ePni/_4k.AcyM+kBOIFh4lx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTurELDnsnt1WYoG5AQLuLA//VhQMG+lkxDHSL/n9Hx0xvlhKNLLBAECq
48YL9TXuSk16d1H/RZlKWJBH29CvrSTJDlSDUujrSq6rDVlqZ1chPhTN43YEGWJh
ryH19XEvusWsDn0nzgMBCiU418sQtZ2NOhJtvFguBsLKgz1VngHGQ9zzfGbtChji
m+hkNU15HQ9/dX+TY297ysFEVbf5Nxp5dahOfz0iaCed/bPBZfUw3UiC5xQP5RqA
XoSfScJfm6bzh8Hpcl2KuiPLxztq7VazSMAoW3VdhXOg5Q+Xef1XQR0ggOOimpSh
g9khaig2GJW7Xm98XsC7hwoni33/Ty1SWbkWlaMN7kuyueDMM1LnT2CZ3ZsmpPKm
6FU4YIixFAJM5PliIslsfv4hNE48eReRLG8YaY6V/MgPgRpuwXtnzSoYiAOnzQgX
SbS9aypKsHKt3PmcjoReleksSPJyyVHo2DkfX/5eSAVUYczGF8ejL1yaqvHL86lV
7HQE7AU0f36yk7z/BRfGcSTbDwlC2LaY6Xfsm4+pagHJva4UCXu3Irr5bcg55zXN
5qcgbNZFsYOWMr1j/qG5bgcvF8LcJAK6zYan2JMpu5OtvkrXmVdfZfI3zFjaR795
TMH+IfNPlmll2YNmXCBpQ5Qz+vJAy4ALcbPTkSDdYusT6xGutnLSGKuUsKiM8E+F
S/h1nEYVNfU=
=RPWI
-----END PGP SIGNATURE-----

--Sig_/ePni/_4k.AcyM+kBOIFh4lx--
