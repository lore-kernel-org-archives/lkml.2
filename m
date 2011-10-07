Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab1JGDG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:06:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36972 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1JGDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:06:56 -0400
Date: Fri, 7 Oct 2011 14:06:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the md tree with the block tree
Message-Id: <20111007140633.a3b52490ca0027033dae37de@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_14_06_33_+1100_z8MjG.fBXxhdnMf0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_14_06_33_+1100_z8MjG.fBXxhdnMf0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got conflicts in
drivers/md/faulty.c, drivers/md/linear.c, drivers/md/md.c,
drivers/md/md.h, drivers/md/multipath.c, drivers/md/raid0.c,
drivers/md/raid1.c, drivers/md/raid10.c and drivers/md/raid5.c between
commit 5a7bbad27a41 ("block: remove support for bio remapping from
->make_request") from the block tree and commit 546208fc263c ("md: remove
typedefs: mddev_t -> struct mddev") from the md tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/faulty.c
index 5ef304d,571445e..0000000
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@@ -169,9 -169,9 +169,9 @@@ static void add_sector(struct faulty_co
  		conf->nfaults =3D n+1;
  }
 =20
- static void make_request(mddev_t *mddev, struct bio *bio)
 -static int make_request(struct mddev *mddev, struct bio *bio)
++static void make_request(struct mddev *mddev, struct bio *bio)
  {
- 	conf_t *conf =3D mddev->private;
+ 	struct faulty_conf *conf =3D mddev->private;
  	int failit =3D 0;
 =20
  	if (bio_data_dir(bio) =3D=3D WRITE) {
@@@ -215,16 -214,17 +215,16 @@@
  		b->bi_bdev =3D conf->rdev->bdev;
  		b->bi_private =3D bio;
  		b->bi_end_io =3D faulty_fail;
 -		generic_make_request(b);
 -		return 0;
 -	} else {
 +		bio =3D b;
 +	} else
  		bio->bi_bdev =3D conf->rdev->bdev;
 -		return 1;
 -	}
 +
 +	generic_make_request(bio);
  }
 =20
- static void status(struct seq_file *seq, mddev_t *mddev)
+ static void status(struct seq_file *seq, struct mddev *mddev)
  {
- 	conf_t *conf =3D mddev->private;
+ 	struct faulty_conf *conf =3D mddev->private;
  	int n;
 =20
  	if ((n=3Datomic_read(&conf->counters[WriteTransient])) !=3D 0)
diff --cc drivers/md/linear.c
index c6ee491,cbac48c..0000000
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@@ -264,9 -264,9 +264,9 @@@ static int linear_stop (struct mddev *m
  	return 0;
  }
 =20
- static void linear_make_request (mddev_t *mddev, struct bio *bio)
 -static int linear_make_request (struct mddev *mddev, struct bio *bio)
++static void linear_make_request (struct mddev *mddev, struct bio *bio)
  {
- 	dev_info_t *tmp_dev;
+ 	struct dev_info *tmp_dev;
  	sector_t start_sector;
 =20
  	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
@@@ -317,10 -319,11 +317,10 @@@
  	bio->bi_sector =3D bio->bi_sector - start_sector
  		+ tmp_dev->rdev->data_offset;
  	rcu_read_unlock();
 -
 -	return 1;
 +	generic_make_request(bio);
  }
 =20
- static void linear_status (struct seq_file *seq, mddev_t *mddev)
+ static void linear_status (struct seq_file *seq, struct mddev *mddev)
  {
 =20
  	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
diff --cc drivers/md/md.c
index 8f52d4e,f8ed97d..0000000
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@@ -335,10 -332,11 +332,10 @@@ static DEFINE_SPINLOCK(all_mddevs_lock)
   * call has finished, the bio has been linked into some internal structure
   * and so is visible to ->quiesce(), so we don't need the refcount any mo=
re.
   */
 -static int md_make_request(struct request_queue *q, struct bio *bio)
 +static void md_make_request(struct request_queue *q, struct bio *bio)
  {
  	const int rw =3D bio_data_dir(bio);
- 	mddev_t *mddev =3D q->queuedata;
+ 	struct mddev *mddev =3D q->queuedata;
 -	int rv;
  	int cpu;
  	unsigned int sectors;
 =20
diff --cc drivers/md/md.h
index 1509a3e,b618da5..0000000
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@@ -424,10 -419,10 +419,10 @@@ struct mdk_personalit
  	int level;
  	struct list_head list;
  	struct module *owner;
- 	void (*make_request)(mddev_t *mddev, struct bio *bio);
- 	int (*run)(mddev_t *mddev);
- 	int (*stop)(mddev_t *mddev);
- 	void (*status)(struct seq_file *seq, mddev_t *mddev);
 -	int (*make_request)(struct mddev *mddev, struct bio *bio);
++	void (*make_request)(struct mddev *mddev, struct bio *bio);
+ 	int (*run)(struct mddev *mddev);
+ 	int (*stop)(struct mddev *mddev);
+ 	void (*status)(struct seq_file *seq, struct mddev *mddev);
  	/* error_handler must set ->faulty and clear ->in_sync
  	 * if appropriate, and should abort recovery if needed=20
  	 */
diff --cc drivers/md/multipath.c
index 618dd9e,9650593..0000000
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@@ -106,9 -106,9 +106,9 @@@ static void multipath_end_request(struc
  	rdev_dec_pending(rdev, conf->mddev);
  }
 =20
- static void multipath_make_request(mddev_t *mddev, struct bio * bio)
 -static int multipath_make_request(struct mddev *mddev, struct bio * bio)
++static void multipath_make_request(struct mddev *mddev, struct bio * bio)
  {
- 	multipath_conf_t *conf =3D mddev->private;
+ 	struct mpconf *conf =3D mddev->private;
  	struct multipath_bh * mp_bh;
  	struct multipath_info *multipath;
 =20
@@@ -137,12 -137,12 +137,12 @@@
  	mp_bh->bio.bi_end_io =3D multipath_end_request;
  	mp_bh->bio.bi_private =3D mp_bh;
  	generic_make_request(&mp_bh->bio);
 -	return 0;
 +	return;
  }
 =20
- static void multipath_status (struct seq_file *seq, mddev_t *mddev)
+ static void multipath_status (struct seq_file *seq, struct mddev *mddev)
  {
- 	multipath_conf_t *conf =3D mddev->private;
+ 	struct mpconf *conf =3D mddev->private;
  	int i;
  =09
  	seq_printf (seq, " [%d/%d] [", conf->raid_disks,
diff --cc drivers/md/raid0.c
index 4066615,38a9012..0000000
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@@ -466,7 -468,7 +468,7 @@@ static inline int is_io_in_chunk_bounda
  	}
  }
 =20
- static void raid0_make_request(mddev_t *mddev, struct bio *bio)
 -static int raid0_make_request(struct mddev *mddev, struct bio *bio)
++static void raid0_make_request(struct mddev *mddev, struct bio *bio)
  {
  	unsigned int chunk_sects;
  	sector_t sector_offset;
@@@ -519,38 -525,11 +521,11 @@@ bad_map
  	       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
 =20
  	bio_io_error(bio);
 -	return 0;
 +	return;
  }
 =20
- static void raid0_status(struct seq_file *seq, mddev_t *mddev)
+ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
  {
- #undef MD_DEBUG
- #ifdef MD_DEBUG
- 	int j, k, h;
- 	char b[BDEVNAME_SIZE];
- 	raid0_conf_t *conf =3D mddev->private;
- 	int raid_disks =3D conf->strip_zone[0].nb_dev;
-=20
- 	sector_t zone_size;
- 	sector_t zone_start =3D 0;
- 	h =3D 0;
-=20
- 	for (j =3D 0; j < conf->nr_strip_zones; j++) {
- 		seq_printf(seq, "      z%d", j);
- 		seq_printf(seq, "=3D[");
- 		for (k =3D 0; k < conf->strip_zone[j].nb_dev; k++)
- 			seq_printf(seq, "%s/", bdevname(
- 				conf->devlist[j*raid_disks + k]
- 						->bdev, b));
-=20
- 		zone_size  =3D conf->strip_zone[j].zone_end - zone_start;
- 		seq_printf(seq, "] ze=3D%lld ds=3D%lld s=3D%lld\n",
- 			(unsigned long long)zone_start>>1,
- 			(unsigned long long)conf->strip_zone[j].dev_start>>1,
- 			(unsigned long long)zone_size>>1);
- 		zone_start =3D conf->strip_zone[j].zone_end;
- 	}
- #endif
  	seq_printf(seq, " %dk chunks", mddev->chunk_sectors / 2);
  	return;
  }
diff --cc drivers/md/raid1.c
index d4ddfa6,e09f595..0000000
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@@ -782,14 -793,14 +793,14 @@@ do_sync_io
  		if (bvecs[i].bv_page)
  			put_page(bvecs[i].bv_page);
  	kfree(bvecs);
- 	PRINTK("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
+ 	pr_debug("%dB behind alloc failed, doing sync I/O\n", bio->bi_size);
  }
 =20
- static void make_request(mddev_t *mddev, struct bio * bio)
 -static int make_request(struct mddev *mddev, struct bio * bio)
++static void make_request(struct mddev *mddev, struct bio * bio)
  {
- 	conf_t *conf =3D mddev->private;
- 	mirror_info_t *mirror;
- 	r1bio_t *r1_bio;
+ 	struct r1conf *conf =3D mddev->private;
+ 	struct mirror_info *mirror;
+ 	struct r1bio *r1_bio;
  	struct bio *read_bio;
  	int i, disks;
  	struct bitmap *bitmap;
@@@ -1123,11 -1134,13 +1134,11 @@@ read_again
 =20
  	if (do_sync || !bitmap || !plugged)
  		md_wakeup_thread(mddev->thread);
 -
 -	return 0;
  }
 =20
- static void status(struct seq_file *seq, mddev_t *mddev)
+ static void status(struct seq_file *seq, struct mddev *mddev)
  {
- 	conf_t *conf =3D mddev->private;
+ 	struct r1conf *conf =3D mddev->private;
  	int i;
 =20
  	seq_printf(seq, " [%d/%d] [", conf->raid_disks,
diff --cc drivers/md/raid10.c
index ea5fc0b,7ba9742..0000000
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@@ -830,11 -830,11 +830,11 @@@ static void unfreeze_array(struct r10co
  	spin_unlock_irq(&conf->resync_lock);
  }
 =20
- static void make_request(mddev_t *mddev, struct bio * bio)
 -static int make_request(struct mddev *mddev, struct bio * bio)
++static void make_request(struct mddev *mddev, struct bio * bio)
  {
- 	conf_t *conf =3D mddev->private;
- 	mirror_info_t *mirror;
- 	r10bio_t *r10_bio;
+ 	struct r10conf *conf =3D mddev->private;
+ 	struct mirror_info *mirror;
+ 	struct r10bio *r10_bio;
  	struct bio *read_bio;
  	int i;
  	int chunk_sects =3D conf->chunk_mask + 1;
@@@ -1156,11 -1158,12 +1156,11 @@@ retry_write
 =20
  	if (do_sync || !mddev->bitmap || !plugged)
  		md_wakeup_thread(mddev->thread);
 -	return 0;
  }
 =20
- static void status(struct seq_file *seq, mddev_t *mddev)
+ static void status(struct seq_file *seq, struct mddev *mddev)
  {
- 	conf_t *conf =3D mddev->private;
+ 	struct r10conf *conf =3D mddev->private;
  	int i;
 =20
  	if (conf->near_copies < conf->raid_disks)
diff --cc drivers/md/raid5.c
index 83f2c44,921e966..0000000
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@@ -3695,9 -3688,9 +3688,9 @@@ static struct stripe_head *__get_priori
  	return sh;
  }
 =20
- static void make_request(mddev_t *mddev, struct bio * bi)
 -static int make_request(struct mddev *mddev, struct bio * bi)
++static void make_request(struct mddev *mddev, struct bio * bi)
  {
- 	raid5_conf_t *conf =3D mddev->private;
+ 	struct r5conf *conf =3D mddev->private;
  	int dd_idx;
  	sector_t new_sector;
  	sector_t logical_sector, last_sector;
@@@ -3851,11 -3844,13 +3844,11 @@@
 =20
  		bio_endio(bi, 0);
  	}
 -
 -	return 0;
  }
 =20
- static sector_t raid5_size(mddev_t *mddev, sector_t sectors, int raid_dis=
ks);
+ static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int rai=
d_disks);
 =20
- static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *=
skipped)
+ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, =
int *skipped)
  {
  	/* reshaping is quite different to recovery/resync so it is
  	 * handled quite separately ... here.

--Signature=_Fri__7_Oct_2011_14_06_33_+1100_z8MjG.fBXxhdnMf0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjmy5AAoJEECxmPOUX5FEd2gP/1b5VoynjNYVGtPAEIrePTVP
77Unki8tdUC2WB8JE05z0V2Bq5HtzcRPzLiGmOGUhGjChl4Nrf3+Sxeue9iCiN0p
JJ9/pcmXACT17pdYzw2rjSaNZNYrYepEi4PLaHVWlwT+kdgq8iN9fRGqqHpGeXqx
4dsQ4fk6nSoCCL4+7rbIlLUddg/XZUup9EM907wg2JqIvg9mPhJocqCWbG4Z6+CK
Jo+It2SoXnnCVYHnTxN9H2UVHGz0p+7CQJYnNXKnaq0PlZYG/IS1EBB/kMUMMl8/
SCbVo6TenH/GRTLfO4IqGxPHjs5KbqfKbLI6a9xce2u+A1cqlL4BuyniIDzFfDbe
fA2lbQ4TR3Y6ZGuIoeEE0D2k6weUB8vHtkAJiPojH/yjWX51YJz7WYWPNpT7wGtb
G2Xzi5jX+thre7O5ux3XoC6qrmjFu5hOu+26LpCtDq0kNAxig/iY60Qd98lmJzhg
MicIYg3pDc5lO9vgE2lXHyPJcJ1Xjk/eVPyVwdjuQvYTGxyn46al6rYPqW9dvaUw
Y+HpQJ0f2r2WgEZzCSpn8a4tYwF9XgCWIpePCCD1YSgubzQ22vin/1K9xDmflQpS
As3sU2Hc8MTL6xXPaxKkdhS8eIvjL0LeCxjpaQV96nOKhYS5FMEEA0TsnrH/sJWg
KE9DWRuVxdSVEyN74Mjc
=4ddz
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_14_06_33_+1100_z8MjG.fBXxhdnMf0--
