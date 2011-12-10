Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1LJHQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 02:16:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1LJHQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 02:16:06 -0500
Date: Sat, 10 Dec 2011 18:15:46 +1100
From: NeilBrown <neilb@suse.de>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>, Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Message-ID: <20111210181546.6da7099a@notabene.brown>
In-Reply-To: <CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
	<20111206060654.0e8bebe0@notabene.brown>
	<CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4DCbDIBysedxIQgizrkm_4B"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4DCbDIBysedxIQgizrkm_4B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Dec 2011 21:37:07 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:

> On Mon, Dec 5, 2011 at 9:06 PM, NeilBrown <neilb@suse.de> wrote:
> > Challenge accepted.
>=20
> cool :)
>=20
> > Even if I don't find a better solution, this seems backwards. =C2=A0Sur=
e the
> > default should be that PM is enabled, but individual board can request =
no
> > PM on MMC interfaces where it is a problem.
>=20
> I somewhat tend to pick a white listing approach, so we don't keep on
> inflicting further pain on random sdio users (at least until we learn
> more about the issues at hand), but I wouldn't object black listing.
>=20
> > The chip has a requirement that the reset line is held down during powe=
r-on,
> > and raised shortly after (I don't know exactly how short). =C2=A0So if =
you just
> > remove power and give it back, the chip doesn't come up properly.
>=20
> Well, not according to Bing Zhao from Marvell:
>=20
> http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg08257.html
>=20
> Though I agree that if we do find this reset line helping (and get it
> to work cleanly with the help of some regulator code), the solution
> might be much more robust.
>=20
> > "It *should be* perfectly fine ..." :-)
>=20
> heh, yeah :)
>=20
> > We just have to make sure the bug powers up the card properly.
> > Maybe I need to create a virtual regulator that powers on the real regu=
lator,
> > then raises the reset line. =C2=A0I wonder how hard that is.
>=20
> Btw did you try toggling the reset line manually and see if it really hel=
ps ?
>=20
> > I'll spend some more time on this and get back to you - probably next w=
eek.
>=20
> Very cool, thanks a lot.
>=20
> Ohad.

Well... I've got something to report.
=20

Firstly, this has nothing to do with power-supply to the chip.  The regulat=
or
stays on the whole time and I still need to reset as some point.  However
there is no difference between:
  - power on with reset high
  - power on with reset low, then raise reset.
So what I thought about reset before is wrong as you say.

Secondly, there are two ways that I can get the wifi to work.

1/ If I keep the device from suspending until the functions have been probe=
d,
   it works.

 To expand on this a bit: when I allow it to sleep early I see messages lik=
e:

[  315.347930] bus: 'sdio': driver_probe_device: matched device mmc1:0001:1=
 with driver libertas_sdio
[  315.368713] bus: 'sdio': really_probe: probing driver libertas_sdio with=
 device mmc1:0001:1
[  315.380859] mmc1: mmc_power_restore_host: powering up
[  315.478668] libertas_sdio: probe of mmc1:0001:1 failed with error -16

This error is ultimately caused by mmc_send_io_op_cond called from
mmc_sdio_power_restore returning -110.

When I force it to hold off suspend for a little while I see (starting at t=
he
same place):

[  656.189697] bus: 'sdio': driver_probe_device: matched device mmc1:0001:1=
 with driver libertas_sdio
[  656.212768] bus: 'sdio': really_probe: probing driver libertas_sdio with=
 device mmc1:0001:1
[  656.247741] libertas_sdio mmc1:0001:1: firmware: requesting libertas/sd8=
686_v9_helper.bin
[  656.257537] device: 'mmc1:0001:1': device_add
[  656.263580] PM: Adding info for No Bus:mmc1:0001:1
[  656.298187] device: 'mmc1:0001:1': device_unregister
[  656.303375] PM: Removing info for No Bus:mmc1:0001:1
[  656.322967] libertas_sdio mmc1:0001:1: firmware: requesting libertas/sd8=
686_v8_helper.bin
[  656.344207] device: 'mmc1:0001:1': device_add
[  656.357147] PM: Adding info for No Bus:mmc1:0001:1
[  656.395782] device: 'mmc1:0001:1': device_unregister
[  656.407409] PM: Removing info for No Bus:mmc1:0001:1
[  656.418579] libertas_sdio mmc1:0001:1: firmware: requesting sd8686_helpe=
r.bin
[  656.435699] device: 'mmc1:0001:1': device_add
[  656.446655] PM: Adding info for No Bus:mmc1:0001:1
[  656.504974] device: 'mmc1:0001:1': device_unregister
[  656.511749] PM: Removing info for No Bus:mmc1:0001:1
[  656.521148] libertas_sdio mmc1:0001:1: firmware: requesting sd8686.bin
[  656.529205] device: 'mmc1:0001:1': device_add
[  656.535095] PM: Adding info for No Bus:mmc1:0001:1
[  656.584625] device: 'mmc1:0001:1': device_unregister
[  656.591369] PM: Removing info for No Bus:mmc1:0001:1
[  657.384063] libertas_sdio mmc1:0001:1: (unregistered net_device): 00:19:=
88:3d:ff:f0, fw 9.70.3p24, cap 0x00000303
[  657.454467] libertas_sdio mmc1:0001:1: (unregistered net_device): PREP_C=
MD: command 0x00a3 failed: 2
[  657.464080] device: 'phy0': device_add


 But shortly there after the extra tracing I put in shows that mmc_power_off
 is called, then mmc_sdio_power_restore calls mmc_send_io_op_cond which aga=
in
 returns -110, but now it isn't a problem and the wifi chip keeps working.
 So maybe the fact that we error-out in the first case is a problem??


 I found that if I pull the reset line down and then let it back up then it
 all works.  mmc_send_io_op_cond never returns -110.
 Specifically I first put the reset (
	gpio_set_value_cansleep(212, 0);
	mmc_delay(10);
	gpio_set_value_cansleep(212, 1);
	mmc_delay(10);

  ) in mmc_power_up just before the final "mmc_host_clk_release(host);"
  That worked.

  I then tried to be clever and defined a 'remux' routine (called=20
  from hsmmc23_before_set_reg
  from omap_hsmmc_235_set_power
  from omap_hsmmc_set_io
  from mmc_power_up), and that works too.

  So that allows me to reset the wifi chip at the right time with only
  changes to my 'board' file.

  However I don't think a reset was the intention of 'remux' so this soluti=
on
  feels a little dirty.

My thought is that something in the suspend/resume sequence is confusing the
wifi chip and it needs a reset to get out of it.
However if I just make mmc_power_off a no-op (insert an early 'return') it
still fails.  I tried poking around and commenting out other function calls
but only ever manage to break it more, never to fix it :-(

So I have run out of ideas.  I can make it work by reseting the chip during
mmc_power_up but I have no idea what is causing the chip to need a reset.
All I know is that it isn't the power-supply being removed.

If you or anyone would like to suggest anything else I could test, or
any interesting information that I could extract that might be helpful, then
I'm happy to give that a go (with the understanding that the turn-around ti=
me
could easily be a week or more).

However for now I think I'll go with my 'remux' hack.

Thanks,
NeilBrown



--Sig_/4DCbDIBysedxIQgizrkm_4B
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuMHIjnsnt1WYoG5AQIDsw//Q5rW8/mRNd8382eXwhzLPVDbKhhYc3Ew
hsyfY7VeXB6jbWTjJHo2YvZFceB9hz2g1rrG0csN8Na4f2KLyWZy7WTTmmDD2Kg/
T0L9OWzeScbfmyuehc4hLCCrOrD32vFnCrDnPzUHWxqIDyOZlokGKbKzavUX9UQu
B0ovs14qXNTrmo3wevg7nETsqO4N/aywcIPDRw060B57lQmRy8jOURWjoo4ibOGE
PQlFUfya76VfqQJ3irD1q7fxR1vFOyfJz0Mzdk3adcumpQRu4xAROIiQSTvLWSNe
GUlQvBpf4PXjOjCpR6XWy/yfGQLEN9JaNkeMPMJzAFAlhdxb6mTcqtJA/LN5BABd
6P1hvzdL9x2AtzOh69AamvZOLtTzVWisv8ldmjefep/A9uRYU9z7WgSoVTXMd4w/
mP9ewZaiAVQECQTBfGsOlgYVQ1ZxG5/iv97mzOrG1s+hIOuxWIX/vVEQ+53AQdb3
dYGZHv56tc8bhqDlrXNADS9/0H0mmsseVw3eNhF6x9VkxvyAHnQJK/emqS3FTyGy
Zl4PfsYyIx0pwMLFgGT7LBqjOWwcKjLtzkooiAgJLImRZ4MUrA2QvNegvKMAqUEq
7SWwR+HthsADwx9kb4QutthAiuyUXCp1GU6aDzCUDOSY3q4YnsaMhbaeVsJJ0L4w
Tk/ypGjiZ7c=
=ID1Z
-----END PGP SIGNATURE-----

--Sig_/4DCbDIBysedxIQgizrkm_4B--
