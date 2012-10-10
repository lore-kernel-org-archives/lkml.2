Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2JJPxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:53:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36703 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351Ab2JJPxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:53:12 -0400
Message-ID: <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
From: Ben Hutchings <ben@decadent.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Oct 2012 16:52:54 +0100
In-Reply-To: <50742600.10606@gmail.com>
References: <505E2108.2060108@gmail.com>
	 <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>
	 <20121008172207.GB14767@quack.suse.cz>
	 <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>
	 <507424F7.60801@gmail.com> <50742600.10606@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kFrmacWGrt7UrJdGn/KR"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kFrmacWGrt7UrJdGn/KR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-09 at 09:26 -0400, Sasha Levin wrote:
> On 10/09/2012 09:21 AM, Sasha Levin wrote:
> > On 10/08/2012 05:45 PM, Jiri Kosina wrote:
> >> On Mon, 8 Oct 2012, Jan Kara wrote:
> >>
> >>>>>> I'm still seeing this on linux-next.
> >>>>   I think this is floppy related (see redo_fd_request() in the stack
> >>>> trace). And there were quite some changes to the area recently. Addi=
ng
> >>>> maintainer to CC.
> >> Hmm ... I don't immediately see how this is happening.
> >>
> >> Sasha, could you please do git bisect on drivers/block/floppy.c betwee=
n=20
> >> f6365201d and your git HEAD for starters (assuming that f6365201d work=
s=20
> >> well for you?).
> >>
> >=20
> > A bisect on floppy.c yielded the following:
> >=20
> > b33d002f4b6bae912463e5a66387c498aa69b6fe is the first bad commit
> > commit b33d002f4b6bae912463e5a66387c498aa69b6fe
> > Author: Ben Hutchings <ben@decadent.org.uk>
> > Date:   Mon Aug 27 20:56:53 2012 -0300
> >=20
> >     genhd: Make put_disk() safe for disks that have not been registered
>=20
> 2 more things:
>=20
>  1. The guest vm which I'm testing on doesn't emulate anything which even=
 looks like a floppy.
>  2. I'm seeing the following lines before the BUG:
>=20
> [    9.836604] floppy0: no floppy controllers found
> [    9.837246] work still pending
> [    9.837743] floppy0: floppy_shutdown: timeout handler died.

I see two problems:

1. redo_fd_request() races with tear-down of the disks, but because
set_next_request() checks disk->queue before doing anything this was
usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
the race condition is much easier to hit.  This may fix that problem in
do_floppy_init(), though there appear to be worse bugs in tear-down
order in floppy_module_exit():

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4320,13 +4320,13 @@ out_unreg_region:
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
+	destroy_workqueue(floppy_wq);
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
 		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
 		put_disk(disks[dr]);
 	}
-	destroy_workqueue(floppy_wq);
 	return err;
 }
=20
--- END ---

2. I made a big mistake in using the existing GENHD_FL_UP flag, as it is
cleared by del_gendisk().  Incremental patch below, but it should be
squashed into the previous patch if that branch is still rebase-able.

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 10 Oct 2012 16:17:01 +0100
Subject: [PATCH] genhd: Make put_disk() safe again for disks that *have* be=
en
 registered

Commit b33d002 ('genhd: Make put_disk() safe for disks that have not
been registered') wrongly used the GENHD_FL_UP flag to test whether a
disk held a reference to its queue.  Since this is cleared by
del_gendisk(), queues will not be properly cleaned up if a disk has
been registered and then torn down in the normal way.  Introduce a
new flag for this purpose.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 block/genhd.c         |    7 +++++--
 include/linux/genhd.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 633751d..b5f482f 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -617,7 +617,10 @@ void add_disk(struct gendisk *disk)
 	 * Take an extra ref on queue which will be put on disk_release()
 	 * so that it sticks around as long as @disk is there.
 	 */
-	WARN_ON_ONCE(!blk_get_queue(disk->queue));
+	if (blk_get_queue(disk->queue))
+		disk->flags |=3D GENHD_FL_GOT_QUEUE;
+	else
+		WARN_ON(1);
=20
 	retval =3D sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
@@ -1105,7 +1108,7 @@ static void disk_release(struct device *dev)
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	free_part_info(&disk->part0);
-	if (disk->queue && disk->flags & GENHD_FL_UP)
+	if (disk->queue && disk->flags & GENHD_FL_GOT_QUEUE)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..7c2560c 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -134,6 +134,7 @@ struct hd_struct {
 #define GENHD_FL_NATIVE_CAPACITY		128
 #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	256
 #define GENHD_FL_NO_PART_SCAN			512
+#define GENHD_FL_GOT_QUEUE			1024
=20
 enum {
 	DISK_EVENT_MEDIA_CHANGE			=3D 1 << 0, /* media changed */


--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-kFrmacWGrt7UrJdGn/KR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHWZ1ue/yOyVhhEJAQpFAw//dztvaIozJPN7r7mFU+Ju+l9zTDI9x1lV
eBKjVdii8POAtRgMlXk1KLwSkbRtVN4ceOYnlRCW4ucl7shqW8+Cu5Q0+khtqEDl
VtFicDqPVP+LXECGEpumkp+QgfoJFKci6qW/m9eqZ+rQ4n7HNAEhrARuW34shrh7
Q6vipvRb5s8oI0OSJ0u4HXAGyt/nZoD0IgW6ETyCyxNkWWYXhPr/3Jrnxs0OufNo
yNEeh3yGAuYhfDPAJnZq++0mlP1ujdFgdi7q6ZgIf5Tnz2m43uNVqQkYUUUr64Cu
QqJZ6vw1VYx9LpcDJl34KGAmlKssWptyLS0nhUUqOKlekGKD4S9brZBPuyHVNmF4
lIDX2ojp7paMT8u/pMlHLsHK9lj4BMJi3H1U3cpwEUUSofepxW1IZD1Q3ChcQKfk
HGuLJJ2wu/BsYZoh9MA7h+mtM9DI/u2ikufSM/dTD3Sp1HtNC8zprXyO9K5wF1J3
HqpkWpC7fayDSE6UafgB9Q0nNlDMTilh341r6AuH2hvqeY5KRpEbTTZ15VvbY6A6
ov1AGGi4m5SFTyrnL5nw0l0n7v2DAm+xEEnViWzcMDGActMVpxdBP7ePmon6SuSC
udfldp7fjEExne0eY3HwDSR+GQHI6EQ5/pbmL7baF2+btsKMh4l5gOUhalNiClv/
a29g/KAMi3g=
=ehy6
-----END PGP SIGNATURE-----

--=-kFrmacWGrt7UrJdGn/KR--
