Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2LSVm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:42:27 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:45491 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2LSVmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:42:18 -0500
Date: Wed, 19 Dec 2012 22:42:10 +0100
From: Christophe TORDEUX <christophe@tordeux.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tai-hwa Liang <avatar@sentelic.com>, Oskari Saarenmaa <os@ohmu.fi>,
        Paul Fox <pgf@laptop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 01/01] Input multitouch: fix horizontal
 two-finger-scrolling on Sentelic touchpads
Message-ID: <20121219214210.GA14841@sherka.no-ip.biz>
References: <20121212012135.GA9043@sherka.no-ip.biz>
 <20121219084113.GA2758@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20121219084113.GA2758@polaris.bitmath.org>
X-PGP-Key: http://christophe.tordeux.net/data/pgp/c-tor2/pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wednesday 19 December 2012 at 09:41:13AM, Henrik Rydberg has written:
> Hi Christophe,
>=20
> > Fix horizontal two-finger scrolling on Sentelic touchpads. Currently
> > horizontal two-fingers scrolling does not work with these touchpads.
> > The patch also makes vertical two-finger scrolling smoother in some
> > applications e.g. Firefox.
> >=20
> > Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
> > ----
> >=20
> > This patch was inspired by the reading of
> > drivers/input/mouse/synaptics.c. It is known to work (tested) on
> > Sentelic touchpads version STL3888_C0. Very probably works on all later
> > versions, and possibly works on some earlier versions of the hardware in
> > question.
>=20
> Thanks for the patch. I would prefer it if this driver was converted
> to use input_mt_assign_slots() instead.
=20
 Thanks for you feedback.=20
=20
=20
 As for converting the driver to use input_mt_assign_slot, I can try,=20
 and I have the device, give me just a couple of weeks.
=20
 I guess a measure of complete success would be to have the device able=20
 to function in userspace purely based on multitouch events, with=20
 non-multitouch absolute events being kept simply as a legacy feature,=20
 in case one needs to use input userspace drivers like evdev which are=20
 not specifically touchpad/touchscreen drivers.

 However I'm not sure the synaptics xorg driver is fit to achieve this. =20
 With this userspace driver as it stands today, a few more or less=20
 functional multitouch features are achieved because the synaptics xorg=20
 driver interprets a mixture of MT and non-MT absolute events. The=20
 sequence in which MT and non-MT events arrive matters.=20

> Why not save the variables instead of the array?

> Relying on the box (x1, y1, max(x1, x2), max(y1, y2)) seems to assume
> a lot about the behavior of the device.

 Well, as for your other objections, I guess I would agree today we=20
 don't have to report touches which are (potentially) not located where=20
 the physical fingers were detected, like I was doing in this early=20
 attempt. Besides, saving data from the device's previous packet is not=20
 an absolute necessity.

 I'm now going to post a much simpler patch, and probably cleaner. The=20
 way I see it this patch will have a double purpose:
=20
 1) fix horizontal and improve vertical scrolling, though maybe in a=20
 coincidental way and 2) work towards making the non-MT absolute events=20
 a purely legacy single finger fallback mode, without breaking anything.

 I'll post my new patch in something like an hour.

> >=20
> > diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff=20
> > vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c=20
> > linux-3.7-rc8/drivers/input/mouse/sentelic.c
> > --- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-11 04:=
32:44.476930522 +0100
> > +++ linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-12 01:16:41.76=
6018017 +0100
> > @@ -706,8 +706,10 @@ static psmouse_ret_t fsp_process_byte(st
> >  	struct input_dev *dev =3D psmouse->dev;
> >  	struct fsp_data *ad =3D psmouse->private;
> >  	unsigned char *packet =3D psmouse->packet;
> > +	unsigned char *last_packet =3D ad->last_pkt;
> >  	unsigned char button_status =3D 0, lscroll =3D 0, rscroll =3D 0;
> >  	unsigned short abs_x, abs_y, fgrs =3D 0;
> > +	unsigned short last_abs_x, last_abs_y;
> >  	int rel_x, rel_y;
> > =20
> >  	if (psmouse->pktcnt < 4)
> > @@ -734,6 +736,9 @@ static psmouse_ret_t fsp_process_byte(st
> > =20
> >  		abs_x =3D GET_ABS_X(packet);
> >  		abs_y =3D GET_ABS_Y(packet);
> > +		last_abs_x =3D GET_ABS_X(last_packet);
> > +		last_abs_y =3D GET_ABS_Y(last_packet);
> > +		memcpy(ad->last_pkt, packet, psmouse->pktcnt);
>=20
> > =20
> >  		if (packet[0] & FSP_PB0_MFMC) {
> >  			/*
> > @@ -753,10 +758,19 @@ static psmouse_ret_t fsp_process_byte(st
> >  					 */
> >  					fgrs =3D 1;
> >  					fsp_set_slot(dev, 0, false, 0, 0);
> > +
> > +					/* We don't need to re-order
> > +					 * coordinates if last finger
> > +					 * was same finger
> > +					 */
> > +					last_abs_x =3D abs_x;
> > +					last_abs_y =3D abs_y;
> >  				}
> >  				ad->last_mt_fgr =3D 2;
> > =20
> > -				fsp_set_slot(dev, 1, fgrs =3D=3D 2, abs_x, abs_y);
> > +				fsp_set_slot(dev, 1, fgrs =3D=3D 2,
> > +						max(abs_x, last_abs_x),
> > +						max(abs_y, last_abs_y));
>=20
>=20
> >  			} else {
> >  				/* 1st finger */
> >  				if (ad->last_mt_fgr =3D=3D 1) {
> > @@ -767,9 +781,18 @@ static psmouse_ret_t fsp_process_byte(st
> >  					 */
> >  					fgrs =3D 1;
> >  					fsp_set_slot(dev, 1, false, 0, 0);
> > +
> > +					/* We don't need to re-order
> > +					 * coordinates if last finger
> > +					 * was same finger
> > +					 */
> > +					last_abs_x =3D abs_x;
> > +					last_abs_y =3D abs_y;
> >  				}
> >  				ad->last_mt_fgr =3D 1;
> > -				fsp_set_slot(dev, 0, fgrs !=3D 0, abs_x, abs_y);
> > +				fsp_set_slot(dev, 0, fgrs !=3D 0,
> > +						min(abs_x, last_abs_x),
> > +						min(abs_y, last_abs_y));
> >  			}
> >  		} else {
> >  			/* SFAC packet */
> > @@ -788,12 +811,18 @@ static psmouse_ret_t fsp_process_byte(st
> >  			if (abs_x !=3D 0 && abs_y !=3D 0)
> >  				fgrs =3D 1;
> > =20
> > +			/* We don't need to re-order
> > +			 * coordinates of SFAC packets
> > +			 */
> > +			last_abs_x =3D abs_x;
> > +			last_abs_y =3D abs_y;
> > +
> >  			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
> >  			fsp_set_slot(dev, 1, false, 0, 0);
> >  		}
> >  		if (fgrs > 0) {
> > -			input_report_abs(dev, ABS_X, abs_x);
> > -			input_report_abs(dev, ABS_Y, abs_y);
> > +			input_report_abs(dev, ABS_X, min(abs_x, last_abs_x));
> > +			input_report_abs(dev, ABS_Y, min(abs_y, last_abs_y));
>=20
> Looks like this point could differ from the reported MT positions.
>=20
> >  		}
> >  		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
> >  		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
> > diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff vanilla/linu=
x-3.7-rc8/drivers/input/mouse/sentelic.h linux-3.7-rc8/drivers/input/mouse/=
sentelic.h
> > --- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-11 04:=
32:44.476930522 +0100
> > +++ linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-12 01:16:41.95=
4018011 +0100
> > @@ -117,6 +117,7 @@ struct fsp_data {
> >  	unsigned char	last_reg;	/* Last register we requested read from */
> >  	unsigned char	last_val;
> >  	unsigned int	last_mt_fgr;	/* Last seen finger(multitouch) */
> > +	unsigned char	last_pkt[8];    /* Last packet we processed from fsp */
> >  };
> > =20
> >  #ifdef CONFIG_MOUSE_PS2_SENTELIC
>=20
> Thanks.
> Henrik
>=20
>=20

--=20
Christophe TORDEUX
113 rue de la Barri=C3=A8re
19000 Tulle
FRANCE
mob: +33-6-86-50-83-65
tel: +33-5-55-93-64-35
http://christophe.tordeux.net

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQ0jSvAAoJEE/hdwZK2Yyt02gH/RBgIN7sV6aaWCWff9LUeTM3
nNXmRxCUsaKXh627MSqMng4+YlMnOSYz5p0l3WIh8radWfhNQMMvcAYzfip1f7x+
UFUrgBnrQD2ksR5ce5axnZpVwnznfyoWyQ0XsfL2p4+VcAJSlWUz+ARqFnQY/XLW
D699lbOCUFH38/WRB9DLKkqQFTJGSMoLPh3BcSeevLWPTN0h3C+BxJmfU8ZQ/bCt
HIMjSwIQYk3dovQA0EZsNmHonWPrPr4AHLkPGRD5kMz3l6Uo8ITcPMoJupC3h/iU
eBJ4ZjLUtS+P8Cwv0WEHIgDlLwnZjCnzrw20F8A+HEDZKpJl5zf9PzmnU9tsZT0=
=4eNF
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
