Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1FIHVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:21:05 -0400
Received: from home.keithp.com ([63.227.221.253]:53994 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab1FIHVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:21:03 -0400
From: "Keith Packard" <keithp@keithp.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: Regression caused by "Bluetooth: Map sec_level to link key requirements"
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 09 Jun 2011 00:20:55 -0700
Message-ID: <yunboy7a2so.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Patch 13d39315c22b128f4796fc008b04914a7c32bb1a is causing a regression
From=202.6.39. I cannot communicate with my Nokia N900 using either the
SyncML or DUN RFCOMM services.  I get a connection reset error shortly
after startup.

I've reverted this patch on top of something past -rc2 (to be precise,
I'm branching from ef2398019b305827ea7130ebaf7bf521b444530e).
With the following fix-up to make things build again, my bluetooth works
again.

From=209774a1309ef662308c6ffb7db160788f6e2b5e35 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Thu, 9 Jun 2011 00:11:33 -0700
Subject: [PATCH 2/2] net/bluetooth: Clean up revert of 13d39315c22b128f4796=
fc008b04914a7c32bb1a.

This removes lingering references to key_type and makes the code work
like it did before the offending commit.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 net/bluetooth/hci_conn.c    |   17 -----------------
 net/bluetooth/hci_core.c    |    4 +---
 net/bluetooth/hci_event.c   |    1 -
 net/bluetooth/rfcomm/core.c |    2 +-
 4 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 25c4ea0..de3a4c0 100644
=2D-- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -582,23 +582,6 @@ int hci_conn_security(struct hci_conn *conn, __u8 sec_=
level, __u8 auth_type)
 }
 EXPORT_SYMBOL(hci_conn_security);
=20
=2D/* Check secure link requirement */
=2Dint hci_conn_check_secure(struct hci_conn *conn, __u8 sec_level)
=2D{
=2D	BT_DBG("conn %p", conn);
=2D
=2D	if (sec_level !=3D BT_SECURITY_HIGH)
=2D		return 1; /* Accept if non-secure is required */
=2D
=2D	if (conn->key_type =3D=3D HCI_LK_AUTH_COMBINATION ||
=2D			(conn->key_type =3D=3D HCI_LK_COMBINATION &&
=2D			conn->pin_length =3D=3D 16))
=2D		return 1;
=2D
=2D	return 0; /* Reject not secure link */
=2D}
=2DEXPORT_SYMBOL(hci_conn_check_secure);
=2D
 /* Change link key */
 int hci_conn_change_link_key(struct hci_conn *conn)
 {
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 815269b..47dff20 100644
=2D-- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1067,7 +1067,7 @@ int hci_add_link_key(struct hci_dev *hdev, struct hci=
_conn *conn, int new_key,
 		old_key_type =3D old_key->type;
 		key =3D old_key;
 	} else {
=2D		old_key_type =3D conn ? conn->key_type : 0xff;
+		old_key_type =3D 0xff;
 		key =3D kzalloc(sizeof(*key), GFP_ATOMIC);
 		if (!key)
 			return -ENOMEM;
@@ -1083,8 +1083,6 @@ int hci_add_link_key(struct hci_dev *hdev, struct hci=
_conn *conn, int new_key,
 					(!conn || conn->remote_auth =3D=3D 0xff) &&
 					old_key_type =3D=3D 0xff) {
 		type =3D HCI_LK_COMBINATION;
=2D		if (conn)
=2D			conn->key_type =3D type;
 	}
=20
 	bacpy(&key->bdaddr, bdaddr);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a61ca11..b57b971 100644
=2D-- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2095,7 +2095,6 @@ static inline void hci_link_key_request_evt(struct hc=
i_dev *hdev, struct sk_buff
 			goto not_found;
 		}
=20
=2D		conn->key_type =3D key->type;
 		conn->pin_length =3D key->pin_len;
 	}
=20
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 5759bb7..121a5c1 100644
=2D-- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2096,7 +2096,7 @@ static void rfcomm_security_cfm(struct hci_conn *conn=
, u8 status, u8 encrypt)
 		if (!test_and_clear_bit(RFCOMM_AUTH_PENDING, &d->flags))
 			continue;
=20
=2D		if (!status && hci_conn_check_secure(conn, d->sec_level))
+		if (!status)
 			set_bit(RFCOMM_AUTH_ACCEPT, &d->flags);
 		else
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
=2D-=20
1.7.5.3

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN8HRXQp8BWwlsTdMRAmSIAKDWQ41H7f45RpMD9TaHQOrsMDpI1wCgqUh2
e9kmifkKcYWvKHYCRlNcWTc=
=D7/w
-----END PGP SIGNATURE-----
--=-=-=--
