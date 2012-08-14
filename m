Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2HNDVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 23:21:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45423 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366Ab2HNDU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 23:20:59 -0400
Message-ID: <1344914439.824.178.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 3/6] floppy: avoid leaking extra reference to queue
 on do_floppy_init error handling
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Date: Tue, 14 Aug 2012 04:20:39 +0100
In-Reply-To: <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
References: <1344881787-6422-1-git-send-email-herton.krzesinski@canonical.com>
	 <1344881787-6422-4-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UsxMOd631+8ZWR0R7gzZ"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UsxMOd631+8ZWR0R7gzZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 15:16 -0300, Herton Ronaldo Krzesinski wrote:
> After commit 3f9a5aa ("floppy: Cleanup disk->queue before caling
> put_disk() if add_disk() was never called"), if something fails in the
> add_disk loop, we unconditionally set disks[dr]->queue to NULL. But
> that's wrong, since we may have succesfully done an add_disk on some of
> the drives previously in the loop, and in this case we would end up with
> an extra reference to the disks[dr]->queue.
>=20
> Add a new global array to mark "registered" disks, and use that to check
> if we did an add_disk on one of the disks already. Using an array to
> track added disks also will help to simplify/cleanup code later, as
> suggested by Vivek Goyal.
[...]

It's totally ridiculous that a driver should have to do this.  Any
registered disk should have the GENHD_FL_UP flag set... so why can't
genhd check it?  It doesn't look like floppy is the only driver affected
by this problem, either.  So I suggest the following general fix
(untested):

---
Subject: genhd: Make put_disk() safe for disks that have not been registere=
d

Since commit 9f53d2f ('block: fix __blkdev_get and add_disk race
condition'), add_disk() adds a reference to disk->queue, which is then
dropped by disk_release().  But if a disk is destroyed without being
registered through add_disk() (or if add_disk() fails at the first
hurdle) then we have a reference imbalance.

Use the GENHD_FL_UP flag to tell whether this extra reference has been
added.  Remove the incomplete workaround from the floppy driver.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
---
 block/genhd.c          |    6 +++---
 drivers/block/floppy.c |   16 +---------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cac7366..6201212 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -587,8 +587,6 @@ void add_disk(struct gendisk *disk)
 	WARN_ON(disk->minors && !(disk->major || disk->first_minor));
 	WARN_ON(!disk->minors && !(disk->flags & GENHD_FL_EXT_DEVT));
=20
-	disk->flags |=3D GENHD_FL_UP;
-
 	retval =3D blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
@@ -596,6 +594,8 @@ void add_disk(struct gendisk *disk)
 	}
 	disk_to_dev(disk)->devt =3D devt;
=20
+	disk->flags |=3D GENHD_FL_UP;
+
 	/* ->major and ->first_minor aren't supposed to be
 	 * dereferenced from here on, but set them just in case.
 	 */
@@ -1105,7 +1105,7 @@ static void disk_release(struct device *dev)
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	free_part_info(&disk->part0);
-	if (disk->queue)
+	if (disk->queue && disk->flags & GENHD_FL_UP)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a7d6347..cf27922 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4325,14 +4325,8 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
+		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
-			/*
-			 * put_disk() is not paired with add_disk() and
-			 * will put queue reference one extra time. fix it.
-			 */
-			disks[dr]->queue =3D NULL;
-		}
 		put_disk(disks[dr]);
 	}
 	return err;
@@ -4560,14 +4554,6 @@ static void __exit floppy_module_exit(void)
 		}
 		blk_cleanup_queue(disks[drive]->queue);
=20
-		/*
-		 * These disks have not called add_disk().  Don't put down
-		 * queue reference in put_disk().
-		 */
-		if (!(allowed_drive_mask & (1 << drive)) ||
-		    fdc_state[FDC(drive)].version =3D=3D FDC_NONE)
-			disks[drive]->queue =3D NULL;
-
 		put_disk(disks[drive]);
 	}
=20


--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-UsxMOd631+8ZWR0R7gzZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCnEB+e/yOyVhhEJAQqjjw/9HiPEHBx2oh3AvHJ1VvbR5P8QXcruOjuX
wu3a6heC9K3f2lYt5ibpy68QO+9ImOaKw2z9gjTgMWLUr7kn0ewhrQ4k5xh4xuQN
jEKkXWerK00t2DwvsGL64jgPZSB09T9hUa03I3Q2bzQv8Y9VEn3zTRt7SCD6w6n2
Nbkvt/KiDU/1tdaB0djpuy+P1a3RWCuhKMh3rPdpTVVwSqo3bosPtyeShS+V1Tfc
GZfAjTGnOVS6+8mJLNh/kG7p9Tp2Tz+YS1sT8vHFa2v4+26pjsbp0lX0rMxRfzyU
HS+Oltqh+Ajh2eWkQogEW42VlH6d8L7TYekuwBCu9m6tEmg9iYLngKOFh/vvW79K
WlDNfHEQ6FzP74M7siVTqOh+OT+GKZvBYcBUFcSDvAb+DpzfAYMZAFCmS0qeevDh
TTlNGn9Kl6ib4RaWlA3OZcp6TI8exK95pWJggRQpLcwUhvTWXfcuQ+LpjyD0ohnY
FOWdTg7VVxwQETT+RX0aGC1G6fW79IX8IXGQCNxSwIr3m8ICwczM1v+YR3qIkb1p
p3oILa8rZW8reN6KauLzzNzjbL5jwnYa1IpETCKexl2axmRUSDadCgXk2fKNCOW9
Et+TkVEB7zxHPjFk4EISP2U7yTgGQQgGbejb0DkuYcCVZcrJKGtDxJtB7mExJSqc
nGeDrhic7og=
=ESOB
-----END PGP SIGNATURE-----

--=-UsxMOd631+8ZWR0R7gzZ--
