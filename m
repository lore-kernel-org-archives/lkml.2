Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2FLBrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:47:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38959 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2FLBrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:47:08 -0400
Date: Tue, 12 Jun 2012 11:47:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: linux-next: manual merge of the bluetooth tree with the wireless
 tree
Message-Id: <20120612114701.85f70fd92fc42a9c9f2962ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Jun_2012_11_47_01_+1000_hpgsyZgIO/Ow_vsV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jun_2012_11_47_01_+1000_hpgsyZgIO/Ow_vsV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
net/bluetooth/hci_event.c between commit 1c2e00418317 ("Bluetooth: Add
support for encryption key refresh") from the wireless tree and commit
6039aa73a132 ("Bluetooth: Remove most of the inline usage") from the
bluetooth tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/bluetooth/hci_event.c
index 94ad124,47656be..0000000
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@@ -3043,51 -3040,7 +3040,51 @@@ static void hci_extended_inquiry_result
  	hci_dev_unlock(hdev);
  }
 =20
 +static void hci_key_refresh_complete_evt(struct hci_dev *hdev,
 +					 struct sk_buff *skb)
 +{
 +	struct hci_ev_key_refresh_complete *ev =3D (void *) skb->data;
 +	struct hci_conn *conn;
 +
 +	BT_DBG("%s status %u handle %u", hdev->name, ev->status,
 +	       __le16_to_cpu(ev->handle));
 +
 +	hci_dev_lock(hdev);
 +
 +	conn =3D hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(ev->handle));
 +	if (!conn)
 +		goto unlock;
 +
 +	if (!ev->status)
 +		conn->sec_level =3D conn->pending_sec_level;
 +
 +	clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 +
 +	if (ev->status && conn->state =3D=3D BT_CONNECTED) {
 +		hci_acl_disconn(conn, HCI_ERROR_AUTH_FAILURE);
 +		hci_conn_put(conn);
 +		goto unlock;
 +	}
 +
 +	if (conn->state =3D=3D BT_CONFIG) {
 +		if (!ev->status)
 +			conn->state =3D BT_CONNECTED;
 +
 +		hci_proto_connect_cfm(conn, ev->status);
 +		hci_conn_put(conn);
 +	} else {
 +		hci_auth_cfm(conn, ev->status);
 +
 +		hci_conn_hold(conn);
 +		conn->disc_timeout =3D HCI_DISCONN_TIMEOUT;
 +		hci_conn_put(conn);
 +	}
 +
 +unlock:
 +	hci_dev_unlock(hdev);
 +}
 +
- static inline u8 hci_get_auth_req(struct hci_conn *conn)
+ static u8 hci_get_auth_req(struct hci_conn *conn)
  {
  	/* If remote requests dedicated bonding follow that lead */
  	if (conn->remote_auth =3D=3D 0x02 || conn->remote_auth =3D=3D 0x03) {

--Signature=_Tue__12_Jun_2012_11_47_01_+1000_hpgsyZgIO/Ow_vsV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP1p+VAAoJEECxmPOUX5FEZZMQAJJpwLBWCd1inzO3ewMioryP
xErjZjUxGeB7P2HYBdCZKM46Vvwv92qzC37kXe94l5cu7Vt9HekVgjkIEILAKMhf
U/m4kkxkq8PajHpDsm7zLHXDiyxAQGR07N/i4dwsXNhPIpLkbQWrwe4sIG36JMN6
D8X+aYgK5sWnyIdGS/AKHUi++PerfqR6fGxDYgTs8EUOU6Et87lz73R7WlS/yExq
RJU7dNBmwPaf/+xodOJ6nVBAF7siBrXO2APkkblNfIN+8Pzq/8DwhGaErNGFzURA
VzcgUZQMnluAbFvEgqgaGU8VMyKMutsfQikoxImjBq3dHJcxsUFyVsXdpyiC/DOv
Twww4zbDKBAptGsivjsBXDZUVb+fV3/VymdXGfWJkSkPgUMNU3DSJBVtMEv4rxti
LErVW9Nc1lnXZLdF8sER4GwGCKu6OCDOVzGpIQvP6C03F3D5JtZVnc9jhvSOO8NG
0CG79o/RYJruuEz2AE6FQNTvaKrMUZaX4zfBCERNwm9PGmzXlEeu3B3Pt6RaTi9i
xv47KQsxUG0BsP2M6Jg+U2OWfDct2UNIB7HcwHBeYeUZFMelx+2T2QSnErhWZ9fl
+H7fHE+aW7EVOLSHAq+Y97Z5yWujMuMWAiTz05X3ILtgnfNdRs/T9kt0krIvUjJr
NFfZ2SvpR1crWNgWR8tm
=celB
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jun_2012_11_47_01_+1000_hpgsyZgIO/Ow_vsV--
