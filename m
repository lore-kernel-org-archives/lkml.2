Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2EIBoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 21:44:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab2EIBoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 21:44:03 -0400
Date: Wed, 9 May 2012 11:43:49 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120509114349.5ceee472@notabene.brown>
In-Reply-To: <20120503212706.GA26612@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
	<20120501213958.GA15560@ioremap.net>
	<20120502162627.50544c8b@notabene.brown>
	<20120503175857.GA13988@ioremap.net>
	<20120504070838.5bd23110@notabene.brown>
	<20120503212706.GA26612@ioremap.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vUy+99Y4OZWjXdx92DmXE1Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vUy+99Y4OZWjXdx92DmXE1Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 4 May 2012 01:27:06 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Fri, May 04, 2012 at 07:08:38AM +1000, NeilBrown (neilb@suse.de) wrote:
> > You can only check the owner on SMP builds, or when debugging is enable=
d.
> > So I don't think that approach can work.
>=20
> You can store owner in master device and protect with mutex itself.
> On non-smp systems it can not be preempted, so can be checked without
> mutex.
>=20

I tried that - or something a lot like it.  Patch below.

However lockdep didn't like it.  There are ordering problems between this
mutex and and sysfs's s_active.

When you access battery properies via sysfs, the sysfs lock is taken first,
then the master->mutex.
When w1_reconnect_slaves calls through to device_del and sys_addrm_finish,
the mutex is held while the sysfs lock is wanted.

So we might need to come up with something more clever.

I haven't had a chance to look really deeply into this yet.  Hopefully when=
 I
do I'll find something clever and let you know.

Thanks,
NeilBrown



diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 52ad812..83ebaad 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -30,11 +30,14 @@ static int w1_bq27000_read(struct device *dev, unsigned=
 int reg)
 {
 	u8 val;
 	struct w1_slave *sl =3D container_of(dev->parent, struct w1_slave, dev);
+	bool own_mutex =3D (sl->master->mutex_owner =3D=3D current);
=20
-	mutex_lock(&sl->master->mutex);
+	if (!own_mutex)
+		mutex_lock(&sl->master->mutex);
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val =3D w1_read_8(sl->master);
-	mutex_unlock(&sl->master->mutex);
+	if (!own_mutex)
+		mutex_unlock(&sl->master->mutex);
=20
 	return val;
 }
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9761950..97de03d 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -616,7 +616,13 @@ static int __w1_attach_slave_device(struct w1_slave *s=
l)
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
 		dev_name(&sl->dev), sl);
=20
+	/* device_register might end up asking the slave to
+	 * access the bus, so we must let it know that it
+	 * already holds the lock.
+	 */
+	sl->master->mutex_owner =3D current;
 	err =3D device_register(&sl->dev);
+	sl->master->mutex_owner =3D NULL;
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"Device registration [%s] failed. err=3D%d\n",
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 4d012ca..ebb157c 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -180,6 +180,13 @@ struct w1_master
=20
 	struct task_struct	*thread;
 	struct mutex		mutex;
+	/* The mutex_owner owns the mutex and so does not
+	 * need to take it again (and doing so would deadlock).
+	 * This is important when registering a device while holding
+	 * the mutex as the slave might need to access the bus as part
+	 * of registration.
+	 */
+	struct task_struct	*mutex_owner;
=20
 	struct device_driver	*driver;
 	struct device		dev;

--Sig_/vUy+99Y4OZWjXdx92DmXE1Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6nL1jnsnt1WYoG5AQJzAQ//RzlfuDGeI6rsBzRBI8mAefyYeWbI3kdt
ZaXxBoXfZ0WM/oX/yjAiDNvtADA9o4nsWguacYf+gpjlvj8WyZ/gPgDFYkdqy0eT
1d+aMNzpKecbfspEK1fUVCgXhBaDiM2ZOCEn3qdBRgX+91RGWw04kteoDxv6PGJr
fEItCjyqXMFYKnTrthfU2KvS1sL3a3xvGZTHbaZeMJwEWmmUGYKdgeTkWL2sA3s7
5K68BRTdHP3FAJSCU2uThKj59gb7LkTg7hkjRkbjjiiM3XeJCYpp6EgZBJxYc3BY
QE0VtxaT83Z5dslC/xR5pU6D4tEDyAOhZlCQADWKOdnGzjFvVXYizkHRtYdgbRtS
rg00Fwt28H1pwOQO//O6fb7+YrfJFBQYjOqRkKq1atuQ0uIgwSZVvJ6GIibiLFWL
SKD9VDskkXjCrKHF6MrbNfUxZaF1qoC5Lp5qNYlhOX5fCHx5vFSWKKLvFPYIUgoj
McUSrpPP/zky0yQ6cfsMMh+bB532leWbsCqa9R+DplijTgn9xSBIUnQTl+9s5qDq
1HW8PiMnclasqOMSDY0A5T/bDhLF8Murk5iUC8lKIMUmWPbVqoNaO8W9vEY9UNzS
CGqBIK4TRsolPxDLhnbTXMvpVNr3r6WSPLKv6Fkdq6baKeiTxvrj5PlklgcBsN22
5KZ7Ql3YQjg=
=Gg1M
-----END PGP SIGNATURE-----

--Sig_/vUy+99Y4OZWjXdx92DmXE1Q--
