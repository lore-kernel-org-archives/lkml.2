Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2LLBVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:21:45 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:55355 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2LLBVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:21:43 -0500
Date: Wed, 12 Dec 2012 02:21:35 +0100
From: Christophe TORDEUX <christophe@tordeux.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Tai-hwa Liang <avatar@sentelic.com>,
        Oskari Saarenmaa <os@ohmu.fi>, Paul Fox <pgf@laptop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: [PATCH 01/01] Input multitouch: fix horizontal two-finger-scrolling
 on Sentelic touchpads
Message-ID: <20121212012135.GA9043@sherka.no-ip.biz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
X-PGP-Key: http://christophe.tordeux.net/data/pgp/c-tor2/pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Christophe TORDEUX <christophe@tordeux.net>

Fix horizontal two-finger scrolling on Sentelic touchpads. Currently
horizontal two-fingers scrolling does not work with these touchpads.
The patch also makes vertical two-finger scrolling smoother in some
applications e.g. Firefox.

Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
----

This patch was inspired by the reading of
drivers/input/mouse/synaptics.c. It is known to work (tested) on
Sentelic touchpads version STL3888_C0. Very probably works on all later
versions, and possibly works on some earlier versions of the hardware in
question.

diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff=20
vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c=20
linux-3.7-rc8/drivers/input/mouse/sentelic.c
--- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-11 04:32:4=
4.476930522 +0100
+++ linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-12 01:16:41.766018=
017 +0100
@@ -706,8 +706,10 @@ static psmouse_ret_t fsp_process_byte(st
 	struct input_dev *dev =3D psmouse->dev;
 	struct fsp_data *ad =3D psmouse->private;
 	unsigned char *packet =3D psmouse->packet;
+	unsigned char *last_packet =3D ad->last_pkt;
 	unsigned char button_status =3D 0, lscroll =3D 0, rscroll =3D 0;
 	unsigned short abs_x, abs_y, fgrs =3D 0;
+	unsigned short last_abs_x, last_abs_y;
 	int rel_x, rel_y;
=20
 	if (psmouse->pktcnt < 4)
@@ -734,6 +736,9 @@ static psmouse_ret_t fsp_process_byte(st
=20
 		abs_x =3D GET_ABS_X(packet);
 		abs_y =3D GET_ABS_Y(packet);
+		last_abs_x =3D GET_ABS_X(last_packet);
+		last_abs_y =3D GET_ABS_Y(last_packet);
+		memcpy(ad->last_pkt, packet, psmouse->pktcnt);
=20
 		if (packet[0] & FSP_PB0_MFMC) {
 			/*
@@ -753,10 +758,19 @@ static psmouse_ret_t fsp_process_byte(st
 					 */
 					fgrs =3D 1;
 					fsp_set_slot(dev, 0, false, 0, 0);
+
+					/* We don't need to re-order
+					 * coordinates if last finger
+					 * was same finger
+					 */
+					last_abs_x =3D abs_x;
+					last_abs_y =3D abs_y;
 				}
 				ad->last_mt_fgr =3D 2;
=20
-				fsp_set_slot(dev, 1, fgrs =3D=3D 2, abs_x, abs_y);
+				fsp_set_slot(dev, 1, fgrs =3D=3D 2,
+						max(abs_x, last_abs_x),
+						max(abs_y, last_abs_y));
 			} else {
 				/* 1st finger */
 				if (ad->last_mt_fgr =3D=3D 1) {
@@ -767,9 +781,18 @@ static psmouse_ret_t fsp_process_byte(st
 					 */
 					fgrs =3D 1;
 					fsp_set_slot(dev, 1, false, 0, 0);
+
+					/* We don't need to re-order
+					 * coordinates if last finger
+					 * was same finger
+					 */
+					last_abs_x =3D abs_x;
+					last_abs_y =3D abs_y;
 				}
 				ad->last_mt_fgr =3D 1;
-				fsp_set_slot(dev, 0, fgrs !=3D 0, abs_x, abs_y);
+				fsp_set_slot(dev, 0, fgrs !=3D 0,
+						min(abs_x, last_abs_x),
+						min(abs_y, last_abs_y));
 			}
 		} else {
 			/* SFAC packet */
@@ -788,12 +811,18 @@ static psmouse_ret_t fsp_process_byte(st
 			if (abs_x !=3D 0 && abs_y !=3D 0)
 				fgrs =3D 1;
=20
+			/* We don't need to re-order
+			 * coordinates of SFAC packets
+			 */
+			last_abs_x =3D abs_x;
+			last_abs_y =3D abs_y;
+
 			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
 			fsp_set_slot(dev, 1, false, 0, 0);
 		}
 		if (fgrs > 0) {
-			input_report_abs(dev, ABS_X, abs_x);
-			input_report_abs(dev, ABS_Y, abs_y);
+			input_report_abs(dev, ABS_X, min(abs_x, last_abs_x));
+			input_report_abs(dev, ABS_Y, min(abs_y, last_abs_y));
 		}
 		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff vanilla/linux-3.=
7-rc8/drivers/input/mouse/sentelic.h linux-3.7-rc8/drivers/input/mouse/sent=
elic.h
--- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-11 04:32:4=
4.476930522 +0100
+++ linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-12 01:16:41.954018=
011 +0100
@@ -117,6 +117,7 @@ struct fsp_data {
 	unsigned char	last_reg;	/* Last register we requested read from */
 	unsigned char	last_val;
 	unsigned int	last_mt_fgr;	/* Last seen finger(multitouch) */
+	unsigned char	last_pkt[8];    /* Last packet we processed from fsp */
 };
=20
 #ifdef CONFIG_MOUSE_PS2_SENTELIC

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQx9wfAAoJEE/hdwZK2YytGqEH/2fdGkqss21lpavKYuZEXlVu
WUFrjaR7PRgsEfhxAXiDJMdRYGH4pzoGcvkE5u+pG9P0dmMuVaXlCJf5CrWKHyx7
EPjqgTGOKnJyz4jabERsneyTSmMHKzniKchCxb70kWGe+8lzDAw73rP+6cjI95sN
BNvYVsb+bpd3hTsNw7p+dxFbfTj10gi8v26YNFwclZ3TkVRqU5YWyJ+cYnvxROnl
0pC7H9BZ/Tpf8xioIqD7j7td7GK+V+Vf1ZXHOUYZC2GV7Hg8LtT0URhNRUYcu2la
1duyqSHdaPXoCdW/KoNSDsGOhpp4dKJyrN/W5zGTzFLYgF3p0zB/RMsJrdyu0P0=
=0A0e
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
