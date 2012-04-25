Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2DYCtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:49:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab2DYCtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:49:19 -0400
Date: Wed, 25 Apr 2012 12:49:14 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120425124914.3187a794@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5O4YJ/UCVeL3_FMrSku0zQp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5O4YJ/UCVeL3_FMrSku0zQp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


w1 devices need a mutex to serial IO.
Most use master->mutex.

However that is used for other purposes and they can conflict.

In particular master->mutex is held while w1_attach_slave_device is
called.

For bq27000, this registers a 'powersupply' device which tries to
read the current status.  The attempt to read will cause a deadlock on
master->mutex.

So create a new per-slave mutex and use that for serializing IO for
bq27000.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/w1/slaves/w1_bq27000.c |    4 ++--
 drivers/w1/w1.c                |    1 +
 drivers/w1/w1.h                |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 52ad812..8755478 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -31,10 +31,10 @@ static int w1_bq27000_read(struct device *dev, unsigned=
 int reg)
 	u8 val;
 	struct w1_slave *sl =3D container_of(dev->parent, struct w1_slave, dev);
=20
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->mutex);
 	w1_write_8(sl->master, HDQ_CMD_READ | reg);
 	val =3D w1_read_8(sl->master);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->mutex);
=20
 	return val;
 }
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 9761950..2173f83 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -688,6 +688,7 @@ static int w1_attach_slave_device(struct w1_master *dev=
, struct w1_reg_num *rn)
 	memcpy(&sl->reg_num, rn, sizeof(sl->reg_num));
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
+	mutex_init(&sl->mutex);
=20
 	spin_lock(&w1_flock);
 	f =3D w1_family_registered(rn->family);
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 4d012ca..8c8be38 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -75,6 +75,7 @@ struct w1_slave
 	void			*family_data;
 	struct device		dev;
 	struct completion	released;
+	struct mutex		mutex;
 };
=20
 typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
--=20
1.7.10


--Sig_/5O4YJ/UCVeL3_FMrSku0zQp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dmKjnsnt1WYoG5AQJ1OxAAmEEsVNPtJBqD8kpoTXFAlO5a9XFfLaQZ
+hckArT/dgSr+BlfqHnR175GLP3hBrcFo2s6l3CfKcUVyj15PGqrXRN6Jm/i78M6
TCclN8rKQKhMt4hLLOaSh0MifD/E6ep87mP5pwiu2WgulqzhxUYrF2kA+ly/uqrI
B/NN2QhLEA3PEqB6bB1ohrPXpuedKZPuL0Wxa63dJkpOAwD8JRxLhcTaC+Zzic3J
ifaVz3amNL3bBbBCqXOeztpIbHmAA4KKlxZ6K/KUp7NDdk32j8Q1jC3bisRl4/b4
IM54TLaymFo6hT7z0u93y6P8w8BXEiLhxUlLFtY43mv+fhK1NUi2BOlxhlkJAwwP
auX7z9+OztkcMCubjEt3kOW9GPPU5wR8g5rirUR25BRDWY9fCEU1eNXoAhXRd5cF
GQYCr/jH9XzW4rEX4jknLy7ULuljltV4xv0qTrxTWknHSXGpMReEoqBUT0x8Lv+7
06tItfMz2hGZhFSn06dIDbCzujoEyuTAKdU/E8yP9546/W+ZzVkAK6WYTZx0Ctau
vqayGmI6yq9B3A+ytmXsfd7tFw6gGInuwa4lS8/ePJrKRpfBiTkEDvLfwATSzJ9+
HAKWgOOOTO9iXAocP4chMjCU26mIsI0nkRLBBiKujRHaI5Xuff94Esfo2/3JaZHr
xWNdALnYim4=
=M1hy
-----END PGP SIGNATURE-----

--Sig_/5O4YJ/UCVeL3_FMrSku0zQp--
