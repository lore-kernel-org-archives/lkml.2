Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0DHNrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:47:11 -0400
Received: from atreides.gradator.net ([212.85.155.42]:38964 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab0DHNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:47:07 -0400
Date: Thu, 8 Apr 2010 15:47:05 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20100408134705.GA983@gradator.net>
References: <20100407202339.GB4830@gradator.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20100407202339.GB4830@gradator.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: Re: PROBLEM: 2.4.37.9 destroying an Ethernet interface with permanent NUD leaves the kernels with undestroyable interfaces when ATM is compiled in
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 07, 2010 at 10:23:39PM +0200, Sylvain Rochet wrote:
> Hi,
>=20
> (...)
>=20
> I changed the family of the ATM table to AF_ATMPVC, of course it fixes=20
> the issue but I guess this is the wrong way to fix that.

Finally made a patch that follows what Linux 2.6 does, which consists of=20
having "netlink" and "no-netlink" tables.

Sylvain

--UlVJffcvxoiEqYs2
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="neigh_no_netlink_atm_clip-2.4.37.9.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru linux-2.4.36.6.a/include/net/neighbour.h linux-2.4.36.6.b/include=
/net/neighbour.h
--- linux-2.4.36.6.a/include/net/neighbour.h	2008-06-06 16:25:34.000000000 =
+0000
+++ linux-2.4.36.6.b/include/net/neighbour.h	2010-04-08 13:36:12.000000000 =
+0000
@@ -192,6 +192,7 @@
 };
=20
 extern void			neigh_table_init(struct neigh_table *tbl);
+extern void			neigh_table_init_no_netlink(struct neigh_table *tbl);
 extern int			neigh_table_clear(struct neigh_table *tbl);
 extern struct neighbour *	neigh_lookup(struct neigh_table *tbl,
 					     const void *pkey,
diff -Nru linux-2.4.36.6.a/net/atm/clip.c linux-2.4.36.6.b/net/atm/clip.c
--- linux-2.4.36.6.a/net/atm/clip.c	2008-06-06 16:25:34.000000000 +0000
+++ linux-2.4.36.6.b/net/atm/clip.c	2010-04-08 13:35:09.000000000 +0000
@@ -752,7 +752,7 @@
=20
 static int __init atm_clip_init(void)
 {
-	neigh_table_init(&clip_tbl);
+	neigh_table_init_no_netlink(&clip_tbl);
=20
 	clip_tbl_hook =3D &clip_tbl;
 	atm_clip_ops_set(&__atm_clip_ops);
diff -Nru linux-2.4.36.6.a/net/core/neighbour.c linux-2.4.36.6.b/net/core/n=
eighbour.c
--- linux-2.4.36.6.a/net/core/neighbour.c	2008-06-06 16:25:34.000000000 +00=
00
+++ linux-2.4.36.6.b/net/core/neighbour.c	2010-04-08 13:33:40.000000000 +00=
00
@@ -1248,7 +1248,7 @@
 }
=20
=20
-void neigh_table_init(struct neigh_table *tbl)
+void neigh_table_init_no_netlink(struct neigh_table *tbl)
 {
 	unsigned long now =3D jiffies;
 	unsigned long phsize;
@@ -1302,10 +1302,27 @@
=20
 	tbl->last_flush =3D now;
 	tbl->last_rand =3D now + tbl->parms.reachable_time*20;
+}
+
+void neigh_table_init(struct neigh_table *tbl)
+{
+	struct neigh_table *tmp;
+
+	neigh_table_init_no_netlink(tbl);
 	write_lock(&neigh_tbl_lock);
-	tbl->next =3D neigh_tables;
-	neigh_tables =3D tbl;
+	for (tmp =3D neigh_tables; tmp; tmp =3D tmp->next) {
+		if (tmp->family =3D=3D tbl->family)
+		break;
+	}
+	tbl->next       =3D neigh_tables;
+	neigh_tables    =3D tbl;
 	write_unlock(&neigh_tbl_lock);
+
+	if (unlikely(tmp)) {
+		printk(KERN_ERR "NEIGH: Registering multiple tables for "
+			"family %d\n", tbl->family);
+		dump_stack();
+	}
 }
=20
 int neigh_table_clear(struct neigh_table *tbl)

--UlVJffcvxoiEqYs2--

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFLvd5ZDFub3qtEsS8RAtdTAJ9tbBKW36sJCNl+L2RArOFVVOTYSgCfXmO/
xdZ2iD7ftiSp/OqrG2+klGs=
=KCmn
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
