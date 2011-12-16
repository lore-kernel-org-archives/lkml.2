Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab1LPFVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:21:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1LPFVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:21:54 -0500
Date: Fri, 16 Dec 2011 16:21:39 +1100
From: NeilBrown <neilb@suse.de>
To: Bing Zhao <bzhao@marvell.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Joe Woodward <jw@terrafix.co.uk>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Message-ID: <20111216162139.5a6c3751@notabene.brown>
In-Reply-To: <477F20668A386D41ADCC57781B1F704308185E3505@SC-VEXCH1.marvell.com>
References: <20111205125416.6093ecd8@notabene.brown>
	<CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
	<20111206060654.0e8bebe0@notabene.brown>
	<CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
	<20111210181546.6da7099a@notabene.brown>
	<CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
	<20111216150812.1ab91f03@notabene.brown>
	<477F20668A386D41ADCC57781B1F704308185E3505@SC-VEXCH1.marvell.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/O+.Uex/1R.4oujyPDH9jaW2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O+.Uex/1R.4oujyPDH9jaW2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011 20:39:28 -0800 Bing Zhao <bzhao@marvell.com> wrote:

> Hi Neil,
>=20
> > In the other case where I do let it suspend early (And it never recovers
> > without the reset line being toggled) I see:
> >=20
> > [ 2170.100982] mmc_wait_for_cmd 52 -> -110
> > [ 2170.105407] mmc_wait_for_cmd 52 -> -110
> > [ 2170.110260] mmc_wait_for_cmd 0 -> 0
> > [ 2170.115509] mmc_wait_for_cmd 8 -> -110
> > [ 2170.119842] mmc_wait_for_cmd 5 -> 0
> > [ 2170.123901] mmc_wait_for_cmd 5 -> 0
> > [ 2170.127929] mmc_wait_for_cmd 3 -> 0
> > [ 2170.131958] mmc_wait_for_cmd 7 -> 0
>=20
> This works when reset line toggling was applied.

Yep.

>=20
> > [ 2170.135986] mmc_wait_for_cmd 52 -> 0
> > [ 2170.140136] mmc_wait_for_cmd 52 -> 0
> > [ 2170.144226] mmc_wait_for_cmd 52 -> 0
> > [ 2170.148376] mmc_wait_for_cmd 52 -> 0
> > [ 2170.152465] mmc_wait_for_cmd 52 -> 0
> >=20
> >=20
> > which is much the same but then one second later:
> >=20
> > [ 2171.166656] mmc_wait_for_cmd 52 -> 0
> > [ 2171.170806] mmc_wait_for_cmd 52 -> 0
> > [ 2171.175384] mmc_wait_for_cmd 0 -> 0
> > [ 2171.180603] mmc_wait_for_cmd 8 -> -110
> > [ 2171.185943] mmc_wait_for_cmd 5 -> -110
>=20
> Here the CMD5 timeout is expected because SD8686 has already been initial=
ized with CMD5,5,3,7.
> If you are able to skip re-initialization at this point, like what "power=
ed_resume" does, you will probably get SD8686 continue to run.
>=20

OK... I think we are nearly there.

If I configure the regulator to turn off on suspend and back on for resume,=
 I
don't need to toggle the reset line.  I just works.
Previously I had the regulator permanently on.
So it seems we need one of:
  - remove/restore power
  - toggle reset
  - don't sent the CMD5,5,3,7 sequence again

I can neither guarantee that the regulator will be powered off or
that it will stay on.  That regulator is shared with bluetooth (on the same
package and wired together) so if the bluetooth is inactive the regulator
will drop-out when the wifi is suspended, but if bluetooth is active it won=
't.

What I could do is create a 'gpio-regulator' which is feed by the real
regulator and give it the reset line as its gpio.
Then when the wifi enters pm_suspend it will reset the wifi chip and release
the regulator which will power down if bluetooth is inactive.  When it
pm_resumes the regulator will be powered up and the reset line released.
(at least, that is the  theory).

So that will work for me, but I suspect more people will fall into this tra=
p.
Is there some way would could detect this particular situation from the
libertas driver and print a message about needing a hard reset or a power o=
ff,
and pointing to documentation.

Or maybe the mmc layer could somehow ask if a reset is needed and not bother
if the device doesn't seem to have been powered down.
Just guessing here.


Thanks,
NeilBrown


--Sig_/O+.Uex/1R.4oujyPDH9jaW2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTurVYznsnt1WYoG5AQKnmxAAgCxaWpN4GDyE8nxazwBs0Ud+QlO4AuHG
dbAqC85bqIsiUSrweQzztInDeO1HctoFtZH0Sss2DlC9RyVmzhWpsXn+TraN+SdD
khq5JYc9rkeQuD+m56sUpoEVCVZgYbiIsU6imvR5d8zsZ418zYKoxR9T6b659nh/
8pxwwGm2RXlI1lLFvcIbjWbBt61tkKd7y7m71ZZ0XxiR9UhTrYHLuqg6xls5n3Au
tXz1nBvAsQPA30frD651h6tStYNwbzG7PJM1klBddfhVX4oEBtcSouBjrY492KS4
zf0cxozWyQfRPWhw6AlEjdHCquRjs5wZwoRtmNLgYMw6j0D+ag1FnNzv+FdRjhVQ
oQy5JQTeOp6OafbbEHSli5YkxC2gLDuazFCzhBvyJK4V9pAVTmZdeCeZojowiPWx
xAJAotKNKTTfvKOnRZAsYO/Iyn1JGUbrrs3COfn5DUI/tzRag3kQfz+AxshkdhF9
RnQhlIHrA5NCV/+3JIF0C/bQPQ1DcuGRjZ01HR8197zmLw8o3sSupEescoIxIbXe
guNuBKVhFl9JNqk58ZVKS/I3yUBdrTI69Yf8vRSvwWUkkw0nSszAe4EOahLiftQ9
ziPpK1nbqwxz1o+JHuFVKFJZQd7gA736CqgYN8pO421c+M3quIE/iJUwQXeaNuXF
2plCDu1ANJ0=
=AhEQ
-----END PGP SIGNATURE-----

--Sig_/O+.Uex/1R.4oujyPDH9jaW2--
