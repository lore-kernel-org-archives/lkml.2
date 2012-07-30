Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2G3GYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 02:24:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab2G3GYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 02:24:31 -0400
Date: Mon, 30 Jul 2012 16:24:14 +1000
From: NeilBrown <neilb@suse.de>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC/omap_hsmmc: handle failure of regulator_get better.
Message-ID: <20120730162414.3818bded@notabene.brown>
In-Reply-To: <501619A4.50906@ti.com>
References: <20120730101245.7dbe72b0@notabene.brown>
	<501619A4.50906@ti.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_hiEnjXhKGm/vR5S54ZzZvF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_hiEnjXhKGm/vR5S54ZzZvF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jul 2012 10:50:36 +0530 Rajendra Nayak <rnayak@ti.com> wrote:

> On Monday 30 July 2012 05:42 AM, NeilBrown wrote:
> >
> > 1/ if regulator_get fails, return an error.  This is important
> >     if it failed with EPROBE_DEFER, as the probe needs to be
> >     deferred.
> >
> > 2/ Don't set .set_power until the regulator has been found, or
> >     the deferred probe will not bother calling omap_hsmmc_reg_get().
>=20
> I am not very sure, but aren't the data structures re-allocated on a
> re-probe (after it was deferred) causing .set_power to be lost anyway?
>=20

Apparently not - as I needed to make that change before the re-probe would
work.

Looking at the code to remind myself:

#define mmc_slot(host)		(host->pdata->slots[host->slot_id])

so the slot is inside the platform data which is allocated in
omap_hsmmc_init_one, called from omap_hsmmc_init.
This is all prior to the probing of the device.

So no: once set_power is set, it stays set.

Thanks,
NeilBrown

> >
> > Signed-off-by: NeilBrown<neilb@suse.de>
> >
> > diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmm=
c.c
> > index 389a3ee..f052c29 100644
> > --- a/drivers/mmc/host/omap_hsmmc.c
> > +++ b/drivers/mmc/host/omap_hsmmc.c
> > @@ -299,12 +299,12 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_h=
ost *host)
> >   	struct regulator *reg;
> >   	int ocr_value =3D 0;
> >
> > -	mmc_slot(host).set_power =3D omap_hsmmc_set_power;
> > -
> >   	reg =3D regulator_get(host->dev, "vmmc");
> >   	if (IS_ERR(reg)) {
> >   		dev_dbg(host->dev, "vmmc regulator missing\n");
> > +		return PTR_ERR(reg);
> >   	} else {
> > +		mmc_slot(host).set_power =3D omap_hsmmc_set_power;
> >   		host->vcc =3D reg;
> >   		ocr_value =3D mmc_regulator_get_ocrmask(reg);
> >   		if (!mmc_slot(host).ocr_mask) {


--Sig_/_hiEnjXhKGm/vR5S54ZzZvF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBYojjnsnt1WYoG5AQLblA//SAJ9viMGjt7K9T160nUwpHBxjDREjlOT
V46y8Hn12hAme6vgxpdLRpXwXdaYTLeL7dxw6bciyXy4iPLQbg/leywbBDJuqRVL
N3y4/hS48ERb6FIhI8Lfp0Aw0Mq7Tu9jLVC5KWhiffSoYKk3CTleFzlXSqV66nTu
xx5/zmcVRjecqyhatVVpVGrLxu2u+5T7US/Sid2T8rkfw/mi7fY7Y1wh0Iq1JpE9
WS+nQePAc1ZlRpiM0gyAa4zvFTNtR5tq3RdktaaP28Vs/EKvd1v7PVjz8VFCXUPk
g3Ko/FgERzUb9c54U8e+hP52ZylQ7tksn0YkuxDh3k4DMrbs/wZ9XTUvF4mC3S/4
ePrSfY+hqRFNhDHVh2tKDWupf3f/yS9mM6rszxR6ffVUiWR40rt/h7mz/kf3a28h
yYqQ4iPZPQQCNcgETy6FqzxU4ZOhezHL2YtEReShY/DNaYLUeclF+5o/bC991vzB
HsnqjjUnCF6v5b9Aqu6n+DIJdUmFfolHWDCNShFQOMjJuKCegcSZuB7H95azSawL
DVkgZljZBxhotyOUjb7ZdIPCYI2DPVarznJ5DaP3BigzVaiNXkjaUmyBnJgd1z2B
DsYmEla6OxS457lq6ihephtb/xhvYkhRekTYo1wLjbi4btD4KHiXXApaYk7ceVvs
xlDeNhXQvnY=
=xRB9
-----END PGP SIGNATURE-----

--Sig_/_hiEnjXhKGm/vR5S54ZzZvF--
