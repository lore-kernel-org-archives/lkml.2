Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1DRKwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:52:12 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:42194 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab1DRKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:51:46 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 06:51:46 EDT
Date: Mon, 18 Apr 2011 12:45:47 +0200
From: Jan Losinski <losinski@wh2.tu-dresden.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: losinski@wh2.tu-dresden.de
Subject: [PATCH 1/1] Input: ati_remote - extend keytable for medion remotes
Message-ID: <20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
X-PGP-Key: https://box.losinski.de/public/pgp/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This extends the ati_remote to support multiple keytables. The table
will be selected with the productId of the device.

It also provides a table for the medion rf remote control that enables
all buttons on it.

Signed-off-by: Jan Losinski <losinski@wh2.tu-dresden.de>
---
 drivers/input/misc/ati_remote.c |  155 ++++++++++++++++++++++++++++++++---=
----
 1 files changed, 128 insertions(+), 27 deletions(-)

diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remot=
e.c
index bce5712..74a3d5c 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -165,6 +165,14 @@ MODULE_DEVICE_TABLE(usb, ati_remote_table);
 static char init1[] =3D { 0x01, 0x00, 0x20, 0x14 };
 static char init2[] =3D { 0x01, 0x00, 0x20, 0x14, 0x20, 0x20, 0x20 };
=20
+struct ati_event_table {
+	short kind;
+	unsigned char data1, data2;
+	int type;
+	unsigned int code;
+	int value;
+};
+
 struct ati_remote {
 	struct input_dev *idev;
 	struct usb_device *udev;
@@ -191,6 +199,8 @@ struct ati_remote {
=20
 	wait_queue_head_t wait;
 	int send_flags;
+
+	const struct ati_event_table *event_table;
 };
=20
 /* "Kinds" of messages sent from the hardware to the driver. */
@@ -204,13 +214,7 @@ struct ati_remote {
 #define KIND_ACCEL      7   /* Directional keypad - left, right, up, down.=
*/
=20
 /* Translation table from hardware messages to input events. */
-static const struct {
-	short kind;
-	unsigned char data1, data2;
-	int type;
-	unsigned int code;
-	int value;
-}  ati_remote_tbl[] =3D {
+static const struct  ati_event_table ati_dflt_event_tbl[] =3D {
 	/* Directional control pad axes */
 	{KIND_ACCEL,   0x35, 0x70, EV_REL, REL_X, -1},	 /* left */
 	{KIND_ACCEL,   0x36, 0x71, EV_REL, REL_X, 1},    /* right */
@@ -288,6 +292,88 @@ static const struct {
 	{KIND_END, 0x00, 0x00, EV_MAX + 1, 0, 0}
 };
=20
+/* Translation table from hardware messages to input events.
+ * Special version for the Medion Remote */
+static const struct ati_event_table ati_medion_event_tbl[] =3D {
+
+	{KIND_FILTERED, 0xf1, 0x2c, EV_KEY, KEY_TV, 1},    /* TV */
+	{KIND_FILTERED, 0xf2, 0x2d, EV_KEY, KEY_VCR, 1},   /* VCR */
+	{KIND_FILTERED, 0xc9, 0x04, EV_KEY, KEY_DVD, 1},   /* DVD */
+	{KIND_FILTERED, 0xcb, 0x06, EV_KEY, KEY_AUDIO, 1}, /* MUSIC */
+
+	{KIND_FILTERED, 0xf3, 0x2e, EV_KEY, KEY_RADIO, 1},     /* RADIO */
+	{KIND_FILTERED, 0xca, 0x05, EV_KEY, KEY_DIRECTORY, 1}, /* PHOTO */
+	{KIND_FILTERED, 0xf4, 0x2f, EV_KEY, KEY_INFO, 1},      /* TV-PREVIEW */
+	{KIND_FILTERED, 0xf5, 0x30, EV_KEY, KEY_LIST, 1},      /* CHANNEL-LST */
+
+	{KIND_FILTERED, 0xe0, 0x1b, EV_KEY, KEY_SETUP, 1}, /* SETUP */
+	{KIND_FILTERED, 0xf6, 0x31, EV_KEY, KEY_VIDEO, 1}, /* VIDEO DESKTOP */
+
+	{KIND_FILTERED, 0xcd, 0x08, EV_KEY, KEY_VOLUMEDOWN, 1},  /* VOL - */
+	{KIND_FILTERED, 0xce, 0x09, EV_KEY, KEY_VOLUMEUP, 1},    /* VOL + */
+	{KIND_FILTERED, 0xd0, 0x0b, EV_KEY, KEY_CHANNELUP, 1},   /* CHAN + */
+	{KIND_FILTERED, 0xd1, 0x0c, EV_KEY, KEY_CHANNELDOWN, 1}, /* CHAN - */
+	{KIND_FILTERED, 0xc5, 0x00, EV_KEY, KEY_MUTE, 1},        /* MUTE */
+
+	{KIND_FILTERED, 0xf7, 0x32, EV_KEY, KEY_RED, 1}, /* red */
+	{KIND_FILTERED, 0xf8, 0x33, EV_KEY, KEY_GREEN, 1}, /* green */
+	{KIND_FILTERED, 0xf9, 0x34, EV_KEY, KEY_YELLOW, 1}, /* yellow */
+	{KIND_FILTERED, 0xfa, 0x35, EV_KEY, KEY_BLUE, 1}, /* blue */
+	{KIND_FILTERED, 0xdb, 0x16, EV_KEY, KEY_TEXT, 1}, /* TXT */
+
+	/* keyboard. */
+	{KIND_FILTERED, 0xd2, 0x0d, EV_KEY, KEY_1, 1},
+	{KIND_FILTERED, 0xd3, 0x0e, EV_KEY, KEY_2, 1},
+	{KIND_FILTERED, 0xd4, 0x0f, EV_KEY, KEY_3, 1},
+	{KIND_FILTERED, 0xd5, 0x10, EV_KEY, KEY_4, 1},
+	{KIND_FILTERED, 0xd6, 0x11, EV_KEY, KEY_5, 1},
+	{KIND_FILTERED, 0xd7, 0x12, EV_KEY, KEY_6, 1},
+	{KIND_FILTERED, 0xd8, 0x13, EV_KEY, KEY_7, 1},
+	{KIND_FILTERED, 0xd9, 0x14, EV_KEY, KEY_8, 1},
+	{KIND_FILTERED, 0xda, 0x15, EV_KEY, KEY_9, 1},
+	{KIND_FILTERED, 0xdc, 0x17, EV_KEY, KEY_0, 1},
+	{KIND_FILTERED, 0xe1, 0x1c, EV_KEY, KEY_SEARCH, 1}, /* TV/RAD, CH SRC */
+	{KIND_FILTERED, 0xe5, 0x20, EV_KEY, KEY_DELETE, 1}, /* DELETE */
+
+	{KIND_FILTERED, 0xfb, 0x36, EV_KEY, KEY_KEYBOARD, 1}, /* RENAME */
+	{KIND_FILTERED, 0xdd, 0x18, EV_KEY, KEY_SCREEN, 1},   /* SNAPSHOT */
+
+	{KIND_FILTERED, 0xdf, 0x1a, EV_KEY, KEY_UP, 1},    /* up */
+	{KIND_FILTERED, 0xe7, 0x22, EV_KEY, KEY_DOWN, 1},  /* down */
+	{KIND_FILTERED, 0xe2, 0x1d, EV_KEY, KEY_LEFT, 1},  /* left */
+	{KIND_FILTERED, 0xe4, 0x1f, EV_KEY, KEY_RIGHT, 1}, /* right */
+	{KIND_FILTERED, 0xe3, 0x1e, EV_KEY, KEY_OK, 1},    /* OK */
+
+	{KIND_FILTERED, 0xfc, 0x37, EV_KEY, KEY_SELECT, 1}, /* AQUIRE IMAGE */
+	{KIND_FILTERED, 0xfd, 0x38, EV_KEY, KEY_EDIT, 1},   /* EDIT IMAGE */
+
+	{KIND_FILTERED, 0xe9, 0x24, EV_KEY, KEY_REWIND, 1},   /* rewind  (<<) */
+	{KIND_FILTERED, 0xea, 0x25, EV_KEY, KEY_PLAY, 1},     /* play    ( >) */
+	{KIND_FILTERED, 0xeb, 0x26, EV_KEY, KEY_FORWARD, 1},  /* forward (>>) */
+	{KIND_FILTERED, 0xec, 0x27, EV_KEY, KEY_RECORD, 1},   /* record  ( o) */
+	{KIND_FILTERED, 0xed, 0x28, EV_KEY, KEY_STOP, 1},     /* stop    ([]) */
+	{KIND_FILTERED, 0xee, 0x29, EV_KEY, KEY_PLAYPAUSE, 1},/* pause   ('') */
+
+	{KIND_FILTERED, 0xe6, 0x21, EV_KEY, KEY_PREVIOUS, 1},        /* prev */
+	{KIND_FILTERED, 0xfe, 0x39, EV_KEY, KEY_SWITCHVIDEOMODE, 1}, /* F SCR */
+	{KIND_FILTERED, 0xe8, 0x23, EV_KEY, KEY_NEXT, 1},            /* next */
+	{KIND_FILTERED, 0xde, 0x19, EV_KEY, KEY_MENU, 1},            /* MENU */
+	{KIND_FILTERED, 0xff, 0x3a, EV_KEY, KEY_LANGUAGE, 1},        /* AUDIO */
+
+	{KIND_FILTERED, 0xc7, 0x02, EV_KEY, KEY_POWER, 1}, /* POWER */
+
+	{KIND_END, 0x00, 0x00, EV_MAX + 1, 0, 0}
+};
+
+/* key translation assignment table */
+static const struct {
+	__u16 product_id;
+	const struct ati_event_table * const table;
+} ati_remotes_table[] =3D {
+	{MEDION_REMOTE_PRODUCT_ID, ati_medion_event_tbl},
+	{}	/* Terminating entry */
+};
+
 /* Local function prototypes */
 static int ati_remote_open		(struct input_dev *inputdev);
 static void ati_remote_close		(struct input_dev *inputdev);
@@ -405,7 +491,8 @@ static int ati_remote_sendpacket(struct ati_remote *ati=
_remote, u16 cmd, unsigne
 /*
  *	ati_remote_event_lookup
  */
-static int ati_remote_event_lookup(int rem, unsigned char d1, unsigned cha=
r d2)
+static int ati_remote_event_lookup(const struct ati_event_table *ati_remot=
e_tbl,
+				   int rem, unsigned char d1, unsigned char d2)
 {
 	int i;
=20
@@ -489,7 +576,8 @@ static void ati_remote_input_report(struct urb *urb)
 	}
=20
 	/* Look up event code index in translation table */
-	index =3D ati_remote_event_lookup(remote_num, data[1], data[2]);
+	index =3D ati_remote_event_lookup(ati_remote->event_table,
+					remote_num, data[1], data[2]);
 	if (index < 0) {
 		dev_warn(&ati_remote->interface->dev,
 			 "Unknown input from channel 0x%02x: data %02x,%02x\n",
@@ -498,19 +586,20 @@ static void ati_remote_input_report(struct urb *urb)
 	}
 	dbginfo(&ati_remote->interface->dev,
 		"channel 0x%02x; data %02x,%02x; index %d; keycode %d\n",
-		remote_num, data[1], data[2], index, ati_remote_tbl[index].code);
+		remote_num, data[1], data[2], index,
+		ati_remote->event_table[index].code);
=20
-	if (ati_remote_tbl[index].kind =3D=3D KIND_LITERAL) {
-		input_event(dev, ati_remote_tbl[index].type,
-			ati_remote_tbl[index].code,
-			ati_remote_tbl[index].value);
+	if (ati_remote->event_table[index].kind =3D=3D KIND_LITERAL) {
+		input_event(dev, ati_remote->event_table[index].type,
+			ati_remote->event_table[index].code,
+			ati_remote->event_table[index].value);
 		input_sync(dev);
=20
 		ati_remote->old_jiffies =3D jiffies;
 		return;
 	}
=20
-	if (ati_remote_tbl[index].kind =3D=3D KIND_FILTERED) {
+	if (ati_remote->event_table[index].kind =3D=3D KIND_FILTERED) {
 		unsigned long now =3D jiffies;
=20
 		/* Filter duplicate events which happen "too close" together. */
@@ -539,11 +628,11 @@ static void ati_remote_input_report(struct urb *urb)
 			return;
=20
=20
-		input_event(dev, ati_remote_tbl[index].type,
-			ati_remote_tbl[index].code, 1);
+		input_event(dev, ati_remote->event_table[index].type,
+			ati_remote->event_table[index].code, 1);
 		input_sync(dev);
-		input_event(dev, ati_remote_tbl[index].type,
-			ati_remote_tbl[index].code, 0);
+		input_event(dev, ati_remote->event_table[index].type,
+			ati_remote->event_table[index].code, 0);
 		input_sync(dev);
=20
 	} else {
@@ -555,11 +644,11 @@ static void ati_remote_input_report(struct urb *urb)
 		 */
 		acc =3D ati_remote_compute_accel(ati_remote);
=20
-		switch (ati_remote_tbl[index].kind) {
+		switch (ati_remote->event_table[index].kind) {
 		case KIND_ACCEL:
-			input_event(dev, ati_remote_tbl[index].type,
-				ati_remote_tbl[index].code,
-				ati_remote_tbl[index].value * acc);
+			input_event(dev, ati_remote->event_table[index].type,
+				ati_remote->event_table[index].code,
+				ati_remote->event_table[index].value * acc);
 			break;
 		case KIND_LU:
 			input_report_rel(dev, REL_X, -acc);
@@ -579,7 +668,7 @@ static void ati_remote_input_report(struct urb *urb)
 			break;
 		default:
 			dev_dbg(&ati_remote->interface->dev, "ati_remote kind=3D%d\n",
-				ati_remote_tbl[index].kind);
+				ati_remote->event_table[index].kind);
 		}
 		input_sync(dev);
=20
@@ -669,9 +758,9 @@ static void ati_remote_input_init(struct ati_remote *at=
i_remote)
 	idev->keybit[BIT_WORD(BTN_MOUSE)] =3D BIT_MASK(BTN_LEFT) |
 		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_SIDE) | BIT_MASK(BTN_EXTRA);
 	idev->relbit[0] =3D BIT_MASK(REL_X) | BIT_MASK(REL_Y);
-	for (i =3D 0; ati_remote_tbl[i].kind !=3D KIND_END; i++)
-		if (ati_remote_tbl[i].type =3D=3D EV_KEY)
-			set_bit(ati_remote_tbl[i].code, idev->keybit);
+	for (i =3D 0; ati_remote->event_table[i].kind !=3D KIND_END; i++)
+		if (ati_remote->event_table[i].type =3D=3D EV_KEY)
+			set_bit(ati_remote->event_table[i].code, idev->keybit);
=20
 	input_set_drvdata(idev, ati_remote);
=20
@@ -736,6 +825,7 @@ static int ati_remote_probe(struct usb_interface *inter=
face, const struct usb_de
 	struct ati_remote *ati_remote;
 	struct input_dev *input_dev;
 	int err =3D -ENOMEM;
+	int i;
=20
 	if (iface_host->desc.bNumEndpoints !=3D 2) {
 		err("%s: Unexpected desc.bNumEndpoints\n", __func__);
@@ -785,6 +875,17 @@ static int ati_remote_probe(struct usb_interface *inte=
rface, const struct usb_de
 			le16_to_cpu(ati_remote->udev->descriptor.idVendor),
 			le16_to_cpu(ati_remote->udev->descriptor.idProduct));
=20
+	/* choose the right translation table */
+	ati_remote->event_table =3D ati_dflt_event_tbl;
+	for (i =3D 0; ati_remotes_table[i].product_id ||
+	     ati_remotes_table[i].table; i++) {
+		if (le16_to_cpu(ati_remote->udev->descriptor.idProduct) =3D=3D
+		    ati_remotes_table[i].product_id) {
+			ati_remote->event_table =3D ati_remotes_table[i].table;
+			break;
+		}
+	}
+
 	ati_remote_input_init(ati_remote);
=20
 	/* Device Hardware Initialization - fills in ati_remote->idev from udev. =
*/
--=20
1.7.4.1


--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2sFlsACgkQ1Hv7AMjH+2GJSwCbBduF64HSHHokQ0pMECnxS1hb
uOwAoKbem2PosIJunKuB7/K9kkV416lV
=xSjH
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
