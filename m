Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0DGUXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:23:42 -0400
Received: from atreides.gradator.net ([212.85.155.42]:57277 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0DGUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 16:23:40 -0400
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 16:23:40 EDT
Date: Wed, 7 Apr 2010 22:23:39 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20100407202339.GB4830@gradator.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: PROBLEM: 2.4.37.9 destroying an Ethernet interface with permanent NUD leaves the kernels with undestroyable interfaces when ATM is compiled in
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fXStkuK2IQBfcDe+
Content-Type: multipart/mixed; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

When ATM and Ethernet are compiled in, ATM and Ethernet create their=20
NEIGH/ARP tables, they are both assigned to family AF_INET.


int neigh_add(....) {

 ...
        for (tbl=3Dneigh_tables; tbl; tbl =3D tbl->next) {
                if (tbl->family !=3D ndm->ndm_family)
                        continue;
  ...
}


As ATM table is created before Ethernet(main?) table,=20
net/core/neighbour.c::neigh_add() function add all permanent IP ARP=20
Ethernet NUD to the IP ATM table, which is wrong.

Therefore, when net/core/neighbour.c::neigh_ifdown() is called ARP=20
entries are not cleared, leaving dev->refcnt to a value that will never=20
be able to reach 0 anymore.

So, when net/core/dev.c::unregister_netdevice() is called it stalls=20
without being able to destroy the interface leaving the system with no=20
network tools working anymore.


This is really easy to reproduce:

openvpn --mktun --dev tap10
ip addr add 10.20.30.20/24 dev tap10
ip link set up dev tap10
ip neighbour add 10.20.30.40 lladdr 01:02:03:04:05:06 nud permanent dev tap=
10
ip link set down dev tap10
openvpn --rmtun --dev tap10

and then kernel log starts being filled by:

unregister_netdevice: waiting for tap10 to become free. Usage count =3D 2
unregister_netdevice: waiting for tap10 to become free. Usage count =3D 2
unregister_netdevice: waiting for tap10 to become free. Usage count =3D 2
unregister_netdevice: waiting for tap10 to become free. Usage count =3D 2


I changed the family of the ATM table to AF_ATMPVC, of course it fixes=20
the issue but I guess this is the wrong way to fix that.


Best regard,
Sylvain

--/Uq4LBwYP4y1W6pO
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="wrongfamily-atm-2.5.36.6.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru linux-2.4.36.6.a/net/atm/clip.c linux-2.4.36.6.b/net/atm/clip.c
--- linux-2.4.36.6.a/net/atm/clip.c	2008-06-06 18:25:34.000000000 +0200
+++ linux-2.4.36.6.b/net/atm/clip.c	2010-04-07 21:33:38.000000000 +0200
@@ -277,7 +277,7 @@
=20
=20
 static struct neigh_ops clip_neigh_ops =3D {
-	family:			AF_INET,
+	family:			AF_ATMPVC,
 	destructor:		clip_neigh_destroy,
 	solicit:		clip_neigh_solicit,
 	error_report:		clip_neigh_error,
@@ -316,7 +316,7 @@
=20
 static struct neigh_table clip_tbl =3D {
 	NULL,			/* next */
-	AF_INET,		/* family */
+	AF_ATMPVC,		/* family */
 	sizeof(struct neighbour)+sizeof(struct atmarp_entry), /* entry_size */
 	4,			/* key_len */
 	clip_hash,

--/Uq4LBwYP4y1W6pO--

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLvOnLDFub3qtEsS8RAqQ6AJ4o/31BgKPJBWqhUc26nDynPLAI1ACgnjD0
qJ5JgEu8Yim+X1PM74NbvBM=
=19QH
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
