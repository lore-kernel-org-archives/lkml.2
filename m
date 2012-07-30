Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2G3Gs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:48:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab2G3Gs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:48:27 -0400
Date: Mon, 30 Jul 2012 16:48:10 +1000
From: NeilBrown <neilb@suse.de>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC/omap_hsmmc: handle failure of regulator_get better.
Message-ID: <20120730164810.5b43c020@notabene.brown>
In-Reply-To: <50162B95.3070502@ti.com>
References: <20120730101245.7dbe72b0@notabene.brown>
	<501619A4.50906@ti.com>
	<20120730162414.3818bded@notabene.brown>
	<50162B95.3070502@ti.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OG+Pnmsx0SuRTle3W8r/OX0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OG+Pnmsx0SuRTle3W8r/OX0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jul 2012 12:07:09 +0530 Rajendra Nayak <rnayak@ti.com> wrote:

> On Monday 30 July 2012 11:54 AM, NeilBrown wrote:
> > On Mon, 30 Jul 2012 10:50:36 +0530 Rajendra Nayak<rnayak@ti.com>  wrote:
> >
> >> On Monday 30 July 2012 05:42 AM, NeilBrown wrote:
> >>>
> >>> 1/ if regulator_get fails, return an error.  This is important
> >>>      if it failed with EPROBE_DEFER, as the probe needs to be
> >>>      deferred.
> >>>
> >>> 2/ Don't set .set_power until the regulator has been found, or
> >>>      the deferred probe will not bother calling omap_hsmmc_reg_get().
> >>
> >> I am not very sure, but aren't the data structures re-allocated on a
> >> re-probe (after it was deferred) causing .set_power to be lost anyway?
> >>
> >
> > Apparently not - as I needed to make that change before the re-probe wo=
uld
> > work.
> >
> > Looking at the code to remind myself:
> >
> > #define mmc_slot(host)		(host->pdata->slots[host->slot_id])
> >
> > so the slot is inside the platform data which is allocated in
> > omap_hsmmc_init_one, called from omap_hsmmc_init.
> > This is all prior to the probing of the device.
> >
> > So no: once set_power is set, it stays set.
>=20
> Thanks for the explanation, makes sense.
>=20
> Acked-by: Rajendra Nayak <rnayak@ti.com>

Thanks.

>=20
> Btw, is the support for re-probe/deferred probe already merged
> now? or are you testing this with some out of tree patches.

deferred-probe works in 3.5.=20

commit 04bf30115f4ba2beda1efb6cfbae49cdc757f3a9
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Sun Mar 11 13:07:56 2012 +0000

    regulator: Support driver probe deferral
=20
makes it work for regulators.

commit d1c3414c2a9d10ef7f0f7665f5d2947cd088c093
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Mon Mar 5 08:47:41 2012 -0700

    drivercore: Add driver probe deferral mechanism

added the basic mechanism.

GPIOs are also supported in 3.6-rc thanks to

commit e93545763021988def06fbda28fe5da133589a96
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Mon Jul 9 12:22:56 2012 +0100

    gpiolib: Defer failed gpio requests by default

so the omap_hsmmc_late_init() stuff can probably be removed, though I haven=
't
tried and there might be some subtlety in there that isn't covered by
EPROBE_DEFER

NeilBrown


>=20
> >
> > Thanks,
> > NeilBrown
> >
> >>>
> >>> Signed-off-by: NeilBrown<neilb@suse.de>
> >>>
> >>> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hs=
mmc.c
> >>> index 389a3ee..f052c29 100644
> >>> --- a/drivers/mmc/host/omap_hsmmc.c
> >>> +++ b/drivers/mmc/host/omap_hsmmc.c
> >>> @@ -299,12 +299,12 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc=
_host *host)
> >>>    	struct regulator *reg;
> >>>    	int ocr_value =3D 0;
> >>>
> >>> -	mmc_slot(host).set_power =3D omap_hsmmc_set_power;
> >>> -
> >>>    	reg =3D regulator_get(host->dev, "vmmc");
> >>>    	if (IS_ERR(reg)) {
> >>>    		dev_dbg(host->dev, "vmmc regulator missing\n");
> >>> +		return PTR_ERR(reg);
> >>>    	} else {
> >>> +		mmc_slot(host).set_power =3D omap_hsmmc_set_power;
> >>>    		host->vcc =3D reg;
> >>>    		ocr_value =3D mmc_regulator_get_ocrmask(reg);
> >>>    		if (!mmc_slot(host).ocr_mask) {
> >


--Sig_/OG+Pnmsx0SuRTle3W8r/OX0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBYuKjnsnt1WYoG5AQIcDQ//T+ZJThREwNR702BdPQMIg1pZD6s/kFeC
K6cfVXAsFw0xfCY+/h6ICsHh08kKuxdOjcPWWR4+viucR1mQJvStDLaJ3JHTimPh
nYXFPFxmSoIHAPcqeuzLtei3v5iwVevxiZcB6N/n1DQKefGYkh87EsIkDJIazpOJ
h3joDZEY6PiVA7s/fLUdUi6INCQpV9k16LrcwXFqDUuzyHvi+7h4SqVd6tgiZaNW
MluychRcDVrSO7xzh/bds75TGBOcGptTgWl8XDu2eBW8et43kLQCxB2EWlJrIPJM
4yYNgi21M8LtUoNBsZhHSYiPGb43eTNs8+Mm/Hi3E+sTZ7hTCA6A/RBTfvYLYnV3
DC/X6Gmyw6YQ1YtZ3L7hsjWXrovIgwHOL4VGQDkVBNJ7q87OPWDWW3foae4NbYnL
NOqheLIKbMx4e0xJuwnr/OMtxVfl27kw98FG4NslITcnBPzqG1l7aKU0LTtVAwYn
5H56U3bcKLuDWKgXE7XIOwgePps9guSndofwQZE+eR/maNgFj/widNvM5aO8iX2w
F2oUc4dzAGgLdLUCcaJeHdjqomndyH0ogsJPYlXxeghpPRO/kd19er5jmfexy+sc
pVa28N0noBHH4sXgP9ljaunyHMzvE+FBUAg9d3TkrlmWl0Pie8vjjq/NoqGAUzk6
EH+zYr2ac1M=
=h8TC
-----END PGP SIGNATURE-----

--Sig_/OG+Pnmsx0SuRTle3W8r/OX0--
