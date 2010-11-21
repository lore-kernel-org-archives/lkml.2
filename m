Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0KUANQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:13:16 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:42376 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab0KUANP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:13:15 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 03:13:05 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 10/17] pps: use BUG_ON for kernel API safety checks
Message-ID: <20101121031305.6f233c80@apollo.gnet>
In-Reply-To: <20101120161351.GC13356@enneenne.com>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
	<20101120161351.GC13356@enneenne.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/O2Jd+8u=zJ.xYvB3SL015kB"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/O2Jd+8u=zJ.xYvB3SL015kB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 17:13:51 +0100
Rodolfo Giometti <giometti@enneenne.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Thu, Nov 18, 2010 at 07:01:03PM +0300, Alexander Gordeev wrote:
> > This way less overhead is involved when running production kernel.
> > If you want to debug a pps client module please define DEBUG to enable
> > the checks.
> >=20
> > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > ---
> >  drivers/pps/kapi.c |   33 ++++++++++-----------------------
> >  1 files changed, 10 insertions(+), 23 deletions(-)
> >=20
> > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > index fe832aa..54261c4 100644
> > --- a/drivers/pps/kapi.c
> > +++ b/drivers/pps/kapi.c
> > @@ -81,25 +81,14 @@ struct pps_device *pps_register_source(struct pps_s=
ource_info *info,
> >  	int err;
> > =20
> >  	/* Sanity checks */
> > -	if ((info->mode & default_params) !=3D default_params) {
> > -		pr_err("pps: %s: unsupported default parameters\n",
> > -					info->name);
> > -		err =3D -EINVAL;
> > -		goto pps_register_source_exit;
> > -	}
> > -	if ((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) !=3D 0 &&
> > -			info->echo =3D=3D NULL) {
> > -		pr_err("pps: %s: echo function is not defined\n",
> > -					info->name);
> > -		err =3D -EINVAL;
> > -		goto pps_register_source_exit;
> > -	}
> > -	if ((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) =3D=3D 0) {
> > -		pr_err("pps: %s: unspecified time format\n",
> > -					info->name);
> > -		err =3D -EINVAL;
> > -		goto pps_register_source_exit;
> > -	}
> > +
> > +	/* default_params should be supported */
> > +	BUG_ON((info->mode & default_params) !=3D default_params);
> > +	/* echo function should be defined if we are asked to call it */
> > +	BUG_ON((info->mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)) !=3D 0 &&
> > +			info->echo =3D=3D NULL);
> > +	/* time format should be specified */
> > +	BUG_ON((info->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) =3D=3D 0);
>=20
> Nack.
>=20
> If the userland gives us some wrong parameters this is not the same of
> a kernel bug (which BUG_ON is used for). The userland must be notified
> about the wrong input.

I agree with what you said completely but this is not a user-space API.
pps_register_source() can only be called from other kernel code.

> >  	/* Allocate memory for the new PPS source struct */
> >  	pps =3D kzalloc(sizeof(struct pps_device), GFP_KERNEL);
> > @@ -179,10 +168,8 @@ void pps_event(struct pps_device *pps, struct pps_=
event_time *ts, int event,
> >  	int captured =3D 0;
> >  	struct pps_ktime ts_real;
> > =20
> > -	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) =3D=3D 0) {
> > -		dev_err(pps->dev, "unknown event (%x)\n", event);
> > -		return;
> > -	}
> > +	/* check event type */
> > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) =3D=3D 0);
>=20
> Ack.
>=20
> This is a correct usage of BUG_ON. :)
>=20
> >  	dev_dbg(pps->dev, "PPS event at %ld.%09ld\n",
> >  			ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
> > --=20
> > 1.7.2.3
> >=20
>=20
> Ciao,
>=20
> Rodolfo
>=20


--=20
  Alexander

--Sig_/O2Jd+8u=zJ.xYvB3SL015kB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6GQRAAoJEElrwznyooJbZVoH/2GvBzJfu30NZiwXPiWiEo+M
PKVAu7iT234B1u+rr4x5b6Ixusa0CmN+8yELckK3Zy2pSm8g0S8CSHkqgcWrES5M
E95ellSufiuiIaSokBKkS47lqGqeUY0tALmvkHpVKfUTdzzolLyvzZK19zb1J8ez
mnO2T+oGcvAw7W3rMIJtqjgawEZEzru2rFrbGDdYWsBvE9wQY/2hOQxegxmdVX9A
8G3taE2ryZv+60Xb91gBHLN8GYhz9qcIt9R2bUJ9mXGou+9jdqyfOCbHUUKthpOA
iOHiOJg/K2XQbIw+i8hCcnCThTYxzbQVb4v3zByNKRxrWPoGtXGp6tBgp0MSNws=
=zE/t
-----END PGP SIGNATURE-----

--Sig_/O2Jd+8u=zJ.xYvB3SL015kB--
