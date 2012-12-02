Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2LBDwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:52:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58184 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab2LBDwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:52:33 -0500
Message-ID: <1354420343.7995.55.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/66] GFS2: Test bufdata with buffer locked and
 gfs2_log_lock held
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 02 Dec 2012 03:52:23 +0000
In-Reply-To: <1353942801.2716.18.camel@menhir>
References: <20121115040939.016421011@linuxfoundation.org>
	 <20121115040943.748338602@linuxfoundation.org>
	 <1353849115.4424.6.camel@deadeye.wl.decadent.org.uk>
	 <1353942801.2716.18.camel@menhir>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LEiylH1hb+d/C3hxgK1G"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LEiylH1hb+d/C3hxgK1G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 15:13 +0000, Steven Whitehouse wrote:
> Hi,
>=20
> On Sun, 2012-11-25 at 14:11 +0100, Ben Hutchings wrote:
> > On Wed, 2012-11-14 at 20:11 -0800, Greg Kroah-Hartman wrote:
> > > 3.6-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Benjamin Marzinski <bmarzins@redhat.com>
> > >=20
> > > commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.
> > >=20
> > > In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached=
 to the
> > > buffer without having the gfs2_log_lock held. It was then assuming it=
 would
> > > stay attached for the rest of the function. However, without either t=
he log
> > > lock being held of the buffer locked, __gfs2_ail_flush() could detach=
 bd at any
> > > time.  This patch moves the locking before the test.  If there isn't =
a bd
> > > already attached, gfs2 can safely allocate one and attach it before l=
ocking.
> > > There is no way that the newly allocated bd could be on the ail list,
> > > and thus no way for __gfs2_ail_flush() to detach it.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [...]
> >=20
> > Is this needed for any earlier versions?  It looks applicable to 3.2
> > (with minor changes).
> >=20
> > Ben.
> >=20
>=20
> Potentially yes, although I don't think we've had any reports from that
> far back,

OK, I've queued up this version for 3.2.

Ben.

---
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 7 Nov 2012 00:38:06 -0600
Subject: GFS2: Test bufdata with buffer locked and gfs2_log_lock held

commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.

In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to th=
e
buffer without having the gfs2_log_lock held. It was then assuming it would
stay attached for the rest of the function. However, without either the log
lock being held of the buffer locked, __gfs2_ail_flush() could detach bd at=
 any
time.  This patch moves the locking before the test.  If there isn't a bd
already attached, gfs2 can safely allocate one and attach it before locking=
.
There is no way that the newly allocated bd could be on the ail list,
and thus no way for __gfs2_ail_flush() to detach it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/gfs2/lops.c  |   14 ++------------
 fs/gfs2/trans.c |    8 ++++++++
 2 files changed, 10 insertions(+), 12 deletions(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -165,16 +165,14 @@ static void buf_lo_add(struct gfs2_sbd *
 	struct gfs2_meta_header *mh;
 	struct gfs2_trans *tr;
=20
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (!list_empty(&bd->bd_list_tr))
-		goto out;
+		return;
 	tr =3D current->journal_info;
 	tr->tr_touched =3D 1;
 	tr->tr_num_buf++;
 	list_add(&bd->bd_list_tr, &tr->tr_list_buf);
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	gfs2_meta_check(sdp, bd->bd_bh);
@@ -185,9 +183,6 @@ static void buf_lo_add(struct gfs2_sbd *
 	sdp->sd_log_num_buf++;
 	list_add(&le->le_list, &sdp->sd_log_le_buf);
 	tr->tr_num_buf_new++;
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
=20
 static void buf_lo_before_commit(struct gfs2_sbd *sdp)
@@ -518,11 +513,9 @@ static void databuf_lo_add(struct gfs2_s
 	struct address_space *mapping =3D bd->bd_bh->b_page->mapping;
 	struct gfs2_inode *ip =3D GFS2_I(mapping->host);
=20
-	lock_buffer(bd->bd_bh);
-	gfs2_log_lock(sdp);
 	if (tr) {
 		if (!list_empty(&bd->bd_list_tr))
-			goto out;
+			return;
 		tr->tr_touched =3D 1;
 		if (gfs2_is_jdata(ip)) {
 			tr->tr_num_buf++;
@@ -530,7 +523,7 @@ static void databuf_lo_add(struct gfs2_s
 		}
 	}
 	if (!list_empty(&le->le_list))
-		goto out;
+		return;
=20
 	set_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
@@ -542,9 +535,6 @@ static void databuf_lo_add(struct gfs2_s
 	} else {
 		list_add_tail(&le->le_list, &sdp->sd_log_le_ordered);
 	}
-out:
-	gfs2_log_unlock(sdp);
-	unlock_buffer(bd->bd_bh);
 }
=20
 static void gfs2_check_magic(struct buffer_head *bh)
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -145,14 +145,22 @@ void gfs2_trans_add_bh(struct gfs2_glock
 	struct gfs2_sbd *sdp =3D gl->gl_sbd;
 	struct gfs2_bufdata *bd;
=20
+	lock_buffer(bh);
+	gfs2_log_lock(sdp);
 	bd =3D bh->b_private;
 	if (bd)
 		gfs2_assert(sdp, bd->bd_gl =3D=3D gl);
 	else {
+		gfs2_log_unlock(sdp);
+		unlock_buffer(bh);
 		gfs2_attach_bufdata(gl, bh, meta);
 		bd =3D bh->b_private;
+		lock_buffer(bh);
+		gfs2_log_lock(sdp);
 	}
 	lops_add(sdp, &bd->bd_le);
+	gfs2_log_unlock(sdp);
+	unlock_buffer(bh);
 }
=20
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)


--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-LEiylH1hb+d/C3hxgK1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULrQd+e/yOyVhhEJAQpAxg/+MKypoB0IW8BlKuB/O4U0c5eXE7uvxx51
xILrz+oYpw4w5XvDFJ8UTLAYKWh+mLPLjOeAqsk1m53lHGMHxeC5ngxTJtwmxLa0
Le+bsME50hVJ04Y89tDllh9Y3QLj8s8ou2QDvh0odUo2PLqRf9XpnoXCvFlsHOC7
FGbmOxHMNi2MAK9AHjnN0RuPodNbjlThPhhl9HYptjQ6sE5Tk8WLoCe7HqcqCrID
ZlOUcpRJbV+Zb5ddUJwU5z9uVyJjBnSQvoPAJOdMnskU1j06hyHchhT0ZcEwQsci
1xl8Jx8Vxm8NPHWCB1kpOTIMVZSlno+1eeeg7yXAwL8vclIjfh6nEe1XuERCHttx
Ue4yVOWET/Bk67sXmrScDqRI4YlMvXQoYfBmr94BQ4Xhe/u4uyR5pJIE3jgPHxVA
kezo9roNnlBizWtu+XUAgkXOAwZiA0FG1zHXMhW6mbP8QjxOqT3g/CzKTRavBC3u
+Nm6RVYFmm3dt6GNM9o3e22A9V28CDbX8D+q43RJcIAfKg+caS7Z27LCtbzqQS9x
l8juW57BsWkLNzDDg55rrdPBzt0c5e3AAalv78Nu4wuRXRy00m7UtRbDyCpoKzxC
uoHeCgI+X6R0/N+toSGRMIKJdf6NtvtidTt119QOukouOndjrj7Dw/hYyoA7Rz0m
FHcb7eDzKPc=
=3ImA
-----END PGP SIGNATURE-----

--=-LEiylH1hb+d/C3hxgK1G--
