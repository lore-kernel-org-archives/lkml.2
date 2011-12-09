Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1LICxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:53:14 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:15444 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1LICxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:53:12 -0500
X-Authority-Analysis: v=2.0 cv=RPYx7ve+ c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=mGYA_rCkFlX3OQJj69UA:9 a=wPNLvfGTeEIA:10 a=ayC55rCoAAAA:8 a=ucpdzKScsDtkka9Rqp4A:9 a=XykIicPH2Rpco2E3igoA:7 a=scvvheB1Wj66geuC:21 a=qHuK0dqj05kdbEwp:21 a=xe8BsctaAAAA:8 a=PAetnM8GYNrfGpzxVPUA:9 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EE17815.6050806@cfl.rr.com>
Date: Thu, 08 Dec 2011 21:53:09 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com> <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com> <4EE0D6E6.9000807@cfl.rr.com> <20111208155844.GA9281@redhat.com> <4EE0E085.8000907@cfl.rr.com> <20111208162847.GB9281@redhat.com>
In-Reply-To: <20111208162847.GB9281@redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig540651EBAE6F61B3CCCFF065"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig540651EBAE6F61B3CCCFF065
Content-Type: multipart/mixed;
 boundary="------------060100090702010301010902"

This is a multi-part message in MIME format.
--------------060100090702010301010902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/08/2011 11:28 AM, Vivek Goyal wrote:
> I thought I have found couple of places where we don't take mutex. For
> example.

I merged your seq changes into my patch.  How does this look?



--------------060100090702010301010902
Content-Type: text/x-patch;
 name="0001-Add-partition-resize-function-to-BLKPG-ioctl.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-Add-partition-resize-function-to-BLKPG-ioctl.patch"

=46rom 8dbca9e824dd18eeb44079717234db0e853f8478 Mon Sep 17 00:00:00 2001
From: Phillip Susi <psusi@cfl.rr.com>
Date: Wed, 30 Nov 2011 22:05:24 -0500
Subject: [PATCH 1/3] Add partition resize function to BLKPG ioctl

Add a new operation code ( BLKPG_RES_PARTITION ) to the
BLKPG ioctl that allows altering the size of an existing
partition, even if it is currently in use.
---
 block/genhd.c         |   10 ++++----
 block/ioctl.c         |   51 +++++++++++++++++++++++++++++++++++++-
 fs/partitions/check.c |   65 +++++++++++++++++++++++++++++++++++++++++++=
+++++-
 include/linux/blkpg.h |    1 +
 include/linux/genhd.h |    7 +++++
 5 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 02e9fca..b34fb90 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -154,7 +154,7 @@ struct hd_struct *disk_part_iter_next(struct disk_par=
t_iter *piter)
 		part =3D rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
-		if (!part->nr_sects &&
+		if (!part_nr_sects_read(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
 		      piter->idx =3D=3D 0))
@@ -191,7 +191,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 static inline int sector_in_part(struct hd_struct *part, sector_t sector=
)
 {
 	return part->start_sect <=3D sector &&
-		sector < part->start_sect + part->nr_sects;
+		sector < part->start_sect + part_nr_sects_read(part);
 }
=20
 /**
@@ -766,8 +766,8 @@ void __init printk_all_partitions(void)
=20
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
-			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       (unsigned long long)part_nr_sects_read(part) >> 1
+			       , disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev !=3D NULL &&
 				    disk->driverfs_dev->driver !=3D NULL)
@@ -858,7 +858,7 @@ static int show_partition(struct seq_file *seqf, void=
 *v)
 	while ((part =3D disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
-			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
=20
diff --git a/block/ioctl.c b/block/ioctl.c
index ca939fc..f97e6a4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -36,8 +36,8 @@ static int blkpg_ioctl(struct block_device *bdev, struc=
t blkpg_ioctl_arg __user
 		case BLKPG_ADD_PARTITION:
 			start =3D p.start >> 9;
 			length =3D p.length >> 9;
-			/* check for fit in a hd_struct */=20
-			if (sizeof(sector_t) =3D=3D sizeof(long) &&=20
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) =3D=3D sizeof(long) &&
 			    sizeof(long long) > sizeof(long)) {
 				long pstart =3D start, plength =3D length;
 				if (pstart !=3D start || plength !=3D length
@@ -92,6 +92,53 @@ static int blkpg_ioctl(struct block_device *bdev, stru=
ct blkpg_ioctl_arg __user
 			bdput(bdevp);
=20
 			return 0;
+		case BLKPG_RES_PARTITION:
+			start =3D p.start >> 9;
+			length =3D p.length >> 9;
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) =3D=3D sizeof(long) &&
+			    sizeof(long long) > sizeof(long)) {
+				long pstart =3D start, plength =3D length;
+				if (pstart !=3D start || plength !=3D length
+				    || pstart < 0 || plength < 0)
+					return -EINVAL;
+			}
+
+			mutex_lock(&bdev->bd_mutex);
+
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			while ((part =3D disk_part_iter_next(&piter))) {
+				if (part->partno !=3D partno && !(start + length <=3D part->start_se=
ct ||
+				      start >=3D part->start_sect + part->nr_sects)) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdev->bd_mutex);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			part =3D disk_get_part(disk, partno);
+			if (!part)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				return -ENXIO;
+			}
+			if (start !=3D part->start_sect)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				disk_put_part(part);
+				return -EINVAL;
+			}
+			part->nr_sects =3D length;
+			bdevp =3D bdget(part_devt(part));
+			mutex_lock(&bdevp->bd_mutex);
+			i_size_write(bdevp->bd_inode, p.length);
+			mutex_unlock(&bdevp->bd_mutex);
+			bdput(bdevp);
+			disk_put_part(part);
+			mutex_unlock(&bdev->bd_mutex);
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e3c63d1..090ee1a 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -234,7 +234,7 @@ ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p =3D dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p))=
;
 }
=20
 static ssize_t part_ro_show(struct device *dev,
@@ -408,6 +408,69 @@ void delete_partition(struct gendisk *disk, int part=
no)
 	hd_struct_put(part);
 }
=20
+#if BITS_PER_LONG =3D=3D 32 && defined(CONFIG_LBDAF)
+static inline void part_nr_sects_write_begin(struct seqcount_t *seq)
+{
+	write_seqcount_begin(&seq);
+}
+
+static inline void part_nr_sects_write_end(struct seqcount_t *seq)
+{
+	write_seqcount_end(&seq);
+}
+
+/*
+ * Any access of part->nr_sects which is not protected by partition
+ * bd_mutex or gendisk bdev bd_mutex, hould be done using this accessor
+ * function.
+ */
+sector_t part_nr_sects_read(struct hd_struct *part)
+{
+	sector_t nr_sects;
+        unsigned seq;
+
+        do {
+                seq =3D read_seqcount_begin(&part->seq);
+                nr_sects =3D part->nr_sects;
+        } while (read_seqcount_retry(&part->seq, seq));
+
+        return nr_sects;
+}
+#else
+static inline void part_nr_sects_write_begin(seqcount_t *seq) {}
+static inline void part_nr_sects_write_end(seqcount_t *seq) {}
+sector_t part_nr_sects_read(struct hd_struct *part)
+{
+	return part->nr_sects;
+}
+#endif
+
+int extend_partition(struct gendisk *disk, int partno, sector_t size)
+{
+	struct disk_part_tbl *ptbl =3D disk->part_tbl;
+	struct hd_struct *part;
+	unsigned long flags;
+
+	if (partno >=3D ptbl->len)
+		return 1;
+
+	part =3D ptbl->part[partno];
+	if (!part)
+		return 1;
+
+	/*
+	 * It is called with mutex held for writer mutual exclusion. Disabling
+	 * interrupts to protect against a reader in interrupt/softirq
+	 * context. Is it not needed?
+	 */
+	local_irq_save(flags);
+	part_nr_sects_write_begin(&part->seq);
+	part->nr_sects +=3D size;
+	part_nr_sects_write_end(&part->seq);
+	local_irq_restore(flags);
+	return 0;
+}
+
 static ssize_t whole_disk_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index faf8a45..103da38 100644
--- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_RES_PARTITION	3
=20
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6d18f35..a55ce2c 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -98,7 +98,13 @@ struct partition_meta_info {
=20
 struct hd_struct {
 	sector_t start_sect;
+	/*
+	 * nr_sects is protected by sequence counter. One might extend a
+	 * partition while IO is happening to it and update of nr_sects
+	 * can be non-atomic on 32bit machines with 64bit sector_t.
+	 */
 	sector_t nr_sects;
+	seqcount_t seq;
 	sector_t alignment_offset;
 	unsigned int discard_alignment;
 	struct device __dev;
@@ -604,6 +610,7 @@ extern struct hd_struct * __must_check add_partition(=
struct gendisk *disk,
 extern void __delete_partition(struct hd_struct *);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
+extern sector_t part_nr_sects_read(struct hd_struct *part);
=20
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
--=20
1.7.5.4


--------------060100090702010301010902--

--------------enig540651EBAE6F61B3CCCFF065
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7heBUACgkQJ4UciIs+XuL0RQCguouordF9bEEzNc0xLEZciqVp
29MAn1EMTt4QjnzZkS+//huz9eH8ZI7D
=Ct23
-----END PGP SIGNATURE-----

--------------enig540651EBAE6F61B3CCCFF065--
