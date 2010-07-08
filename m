Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0GHAno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 20:43:44 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:58156 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756388Ab0GHAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 20:43:43 -0400
X-DYX-POP3-Checked-Auth: 114.32.100.136:kernel@takeo.idv.tw
Message-ID: <F0921DE61714438C86A1AB46A4E7F22D@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Neil Brown" <neilb@suse.de>, "Christoph Hellwig" <hch@lst.de>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
       <viro@zeniv.linux.org.uk>, <sfr@canb.auug.org.au>,
       "Takeo Tung" <kernel@takeo.idv.tw>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1><4C129778.7040409@suse.cz><F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1><20100612094937.GA12455@lst.de><F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1><1AEF19B8648844C983F583EEBE9C46F4@TAKEOW7NB1><20100707231732.GA30007@lst.de> <20100708094851.6dc6199d@notabene.brown>
In-Reply-To: <20100708094851.6dc6199d@notabene.brown>
Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags for struct bio and struct request will kernel panic
Date: Thu, 8 Jul 2010 08:43:38 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0025_01CB1E79.A9435770"
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3o,O MIME .f&!*: Multipart 6l%s!C

------=_NextPart_000_0025_01CB1E79.A9435770
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit

Hello,

ok. I rewrite the patch back to bool and re-add bio_rw_flagged fucntion. pls 
review it and any comment?

Thanks,
Takeo Tung

--------------------------------------------------
From: "Neil Brown" <neilb@suse.de>
Sent: Thursday, July 08, 2010 7:48 AM
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Takeo Tung" <kernel@takeo.idv.tw>; "Michal Marek" <mmarek@suse.cz>; 
<linux-kernel@vger.kernel.org>; <viro@zeniv.linux.org.uk>; 
<sfr@canb.auug.org.au>
Subject: Re: [PATCH] struct io panic on raid1 - Re: block: unify flags for 
struct bio and struct request will kernel panic

> On Thu, 8 Jul 2010 01:17:32 +0200
> Christoph Hellwig <hch@lst.de> wrote:
>
>> On Thu, Jul 08, 2010 at 07:05:39AM +0800, Takeo Tung wrote:
>> > Dear Christoph,
>> >
>> > I was check the patch again. I found the panic status haapen on Soft 
>> > RAID
>> > 1. I review it. found some define using bool, so some like ( x & 
>> > REQ_SYNC)
>> > only 0 or 1.
>> > so if bi_rw = rw | sync will bi_rw = rw | 0 or rw | 1. not rw | ( 1 <<
>> > __REQ_SYNC).
>> >
>> > So I write a patch is fix it. seems normal now. could you review the 
>> > patch
>> > or any comment?
>>
>> The patch looks correct to me, although your mailer mangled the
>> whitespace badly.  If Neil wants to keep the flag as bool we could
>> also add a !! around the bit flag checks.
>
> I think it is best to make them "unsigned long" holding the actual but.
> They were only made 'bool' because that is was bio_rw_flagged() returned.
> Converting to a bool then back to a bit-flag is unnecessary.
>
> Thanks,
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> 
------=_NextPart_000_0025_01CB1E79.A9435770
Content-Type: application/octet-stream;
	name="bio-blkdev-rev2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="bio-blkdev-rev2.patch"

diff -urNp ./drivers/md/raid10.c.orig ./drivers/md/raid10.c=0A=
--- ./drivers/md/raid10.c.orig	2010-07-07 19:24:12.000000000 +0800=0A=
+++ ./drivers/md/raid10.c	2010-07-08 08:35:19.000000000 +0800=0A=
@@ -799,7 +799,7 @@ static int make_request(mddev_t *mddev, =0A=
 	int i;=0A=
 	int chunk_sects =3D conf->chunk_mask + 1;=0A=
 	const int rw =3D bio_data_dir(bio);=0A=
-	const bool do_sync =3D (bio->bi_rw & REQ_SYNC);=0A=
+	const bool do_sync =3D bio_rw_flagged(bio, REQ_SYNC);=0A=
 	struct bio_list bl;=0A=
 	unsigned long flags;=0A=
 	mdk_rdev_t *blocked_rdev;=0A=
@@ -879,7 +879,7 @@ static int make_request(mddev_t *mddev, =0A=
 			mirror->rdev->data_offset;=0A=
 		read_bio->bi_bdev =3D mirror->rdev->bdev;=0A=
 		read_bio->bi_end_io =3D raid10_end_read_request;=0A=
-		read_bio->bi_rw =3D READ | do_sync;=0A=
+		read_bio->bi_rw =3D READ | (do_sync << __REQ_SYNC);=0A=
 		read_bio->bi_private =3D r10_bio;=0A=
 =0A=
 		generic_make_request(read_bio);=0A=
@@ -947,7 +947,7 @@ static int make_request(mddev_t *mddev, =0A=
 			conf->mirrors[d].rdev->data_offset;=0A=
 		mbio->bi_bdev =3D conf->mirrors[d].rdev->bdev;=0A=
 		mbio->bi_end_io	=3D raid10_end_write_request;=0A=
-		mbio->bi_rw =3D WRITE | do_sync;=0A=
+		mbio->bi_rw =3D WRITE | (do_sync << __REQ_SYNC);=0A=
 		mbio->bi_private =3D r10_bio;=0A=
 =0A=
 		atomic_inc(&r10_bio->remaining);=0A=
@@ -1716,7 +1716,7 @@ static void raid10d(mddev_t *mddev)=0A=
 				raid_end_bio_io(r10_bio);=0A=
 				bio_put(bio);=0A=
 			} else {=0A=
-				const bool do_sync =3D (r10_bio->master_bio->bi_rw & REQ_SYNC);=0A=
+				const bool do_sync =3D bio_rw_flagged(r10_bio->master_bio, =
REQ_SYNC);=0A=
 				bio_put(bio);=0A=
 				rdev =3D conf->mirrors[mirror].rdev;=0A=
 				if (printk_ratelimit())=0A=
@@ -1730,7 +1730,7 @@ static void raid10d(mddev_t *mddev)=0A=
 				bio->bi_sector =3D r10_bio->devs[r10_bio->read_slot].addr=0A=
 					+ rdev->data_offset;=0A=
 				bio->bi_bdev =3D rdev->bdev;=0A=
-				bio->bi_rw =3D READ | do_sync;=0A=
+				bio->bi_rw =3D READ | (do_sync << __REQ_SYNC);=0A=
 				bio->bi_private =3D r10_bio;=0A=
 				bio->bi_end_io =3D raid10_end_read_request;=0A=
 				unplug =3D 1;=0A=
diff -urNp ./drivers/md/raid1.c.orig ./drivers/md/raid1.c=0A=
--- ./drivers/md/raid1.c.orig	2010-07-07 19:21:45.000000000 +0800=0A=
+++ ./drivers/md/raid1.c	2010-07-08 08:37:08.000000000 +0800=0A=
@@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev, =0A=
 	struct bio_list bl;=0A=
 	struct page **behind_pages =3D NULL;=0A=
 	const int rw =3D bio_data_dir(bio);=0A=
-	const bool do_sync =3D (bio->bi_rw & REQ_SYNC);=0A=
+	const bool do_sync =3D bio_rw_flagged(bio, REQ_SYNC);=0A=
 	bool do_barriers;=0A=
 	mdk_rdev_t *blocked_rdev;=0A=
 =0A=
@@ -877,7 +877,7 @@ static int make_request(mddev_t *mddev, =0A=
 		read_bio->bi_sector =3D r1_bio->sector + mirror->rdev->data_offset;=0A=
 		read_bio->bi_bdev =3D mirror->rdev->bdev;=0A=
 		read_bio->bi_end_io =3D raid1_end_read_request;=0A=
-		read_bio->bi_rw =3D READ | do_sync;=0A=
+		read_bio->bi_rw =3D READ | (do_sync << __REQ_SYNC);=0A=
 		read_bio->bi_private =3D r1_bio;=0A=
 =0A=
 		generic_make_request(read_bio);=0A=
@@ -959,7 +959,7 @@ static int make_request(mddev_t *mddev, =0A=
 	atomic_set(&r1_bio->remaining, 0);=0A=
 	atomic_set(&r1_bio->behind_remaining, 0);=0A=
 =0A=
-	do_barriers =3D bio->bi_rw & REQ_HARDBARRIER;=0A=
+	do_barriers =3D bio_rw_flagged(bio, REQ_HARDBARRIER);=0A=
 	if (do_barriers)=0A=
 		set_bit(R1BIO_Barrier, &r1_bio->state);=0A=
 =0A=
@@ -975,7 +975,7 @@ static int make_request(mddev_t *mddev, =0A=
 		mbio->bi_sector	=3D r1_bio->sector + =
conf->mirrors[i].rdev->data_offset;=0A=
 		mbio->bi_bdev =3D conf->mirrors[i].rdev->bdev;=0A=
 		mbio->bi_end_io	=3D raid1_end_write_request;=0A=
-		mbio->bi_rw =3D WRITE | do_barriers | do_sync;=0A=
+		mbio->bi_rw =3D WRITE | (do_barriers << __REQ_HARDBARRIER) | (do_sync =
<< __REQ_SYNC);=0A=
 		mbio->bi_private =3D r1_bio;=0A=
 =0A=
 		if (behind_pages) {=0A=
@@ -1640,7 +1640,7 @@ static void raid1d(mddev_t *mddev)=0A=
 			 * We already have a nr_pending reference on these rdevs.=0A=
 			 */=0A=
 			int i;=0A=
-			const bool do_sync =3D (r1_bio->master_bio->bi_rw & REQ_SYNC);=0A=
+			const bool do_sync =3D bio_rw_flagged(r1_bio->master_bio, REQ_SYNC);=0A=
 			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);=0A=
 			clear_bit(R1BIO_Barrier, &r1_bio->state);=0A=
 			for (i=3D0; i < conf->raid_disks; i++)=0A=
@@ -1661,7 +1661,7 @@ static void raid1d(mddev_t *mddev)=0A=
 						conf->mirrors[i].rdev->data_offset;=0A=
 					bio->bi_bdev =3D conf->mirrors[i].rdev->bdev;=0A=
 					bio->bi_end_io =3D raid1_end_write_request;=0A=
-					bio->bi_rw =3D WRITE | do_sync;=0A=
+					bio->bi_rw =3D WRITE | (do_sync << __REQ_SYNC);=0A=
 					bio->bi_private =3D r1_bio;=0A=
 					r1_bio->bios[i] =3D bio;=0A=
 					generic_make_request(bio);=0A=
@@ -1696,7 +1696,7 @@ static void raid1d(mddev_t *mddev)=0A=
 				       (unsigned long long)r1_bio->sector);=0A=
 				raid_end_bio_io(r1_bio);=0A=
 			} else {=0A=
-				const bool do_sync =3D r1_bio->master_bio->bi_rw & REQ_SYNC;=0A=
+				const bool do_sync =3D bio_rw_flagged(r1_bio->master_bio, REQ_SYNC);=0A=
 				r1_bio->bios[r1_bio->read_disk] =3D=0A=
 					mddev->ro ? IO_BLOCKED : NULL;=0A=
 				r1_bio->read_disk =3D disk;=0A=
@@ -1713,7 +1713,7 @@ static void raid1d(mddev_t *mddev)=0A=
 				bio->bi_sector =3D r1_bio->sector + rdev->data_offset;=0A=
 				bio->bi_bdev =3D rdev->bdev;=0A=
 				bio->bi_end_io =3D raid1_end_read_request;=0A=
-				bio->bi_rw =3D READ | do_sync;=0A=
+				bio->bi_rw =3D READ | (do_sync << __REQ_SYNC);=0A=
 				bio->bi_private =3D r1_bio;=0A=
 				unplug =3D 1;=0A=
 				generic_make_request(bio);=0A=
diff -urNp ./drivers/block/loop.c.orig ./drivers/block/loop.c=0A=
--- ./drivers/block/loop.c.orig	2010-07-07 19:21:12.000000000 +0800=0A=
+++ ./drivers/block/loop.c	2010-07-08 08:38:06.000000000 +0800=0A=
@@ -476,7 +476,7 @@ static int do_bio_filebacked(struct loop=0A=
 	pos =3D ((loff_t) bio->bi_sector << 9) + lo->lo_offset;=0A=
 =0A=
 	if (bio_rw(bio) =3D=3D WRITE) {=0A=
-		bool barrier =3D (bio->bi_rw & REQ_HARDBARRIER);=0A=
+		bool barrier =3D bio_rw_flagged(bio, REQ_HARDBARRIER);=0A=
 		struct file *file =3D lo->lo_backing_file;=0A=
 =0A=
 		if (barrier) {=0A=
diff -urNp ./block/blk-core.c.orig ./block/blk-core.c=0A=
--- ./block/blk-core.c.orig	2010-07-07 19:14:55.000000000 +0800=0A=
+++ ./block/blk-core.c	2010-07-08 08:39:10.000000000 +0800=0A=
@@ -174,7 +174,7 @@ void blk_dump_rq_flags(struct request *r=0A=
 {=0A=
 	int bit;=0A=
 =0A=
-	printk(KERN_INFO "%s: dev %s: type=3D%x, flags=3D%x\n", msg,=0A=
+	printk(KERN_INFO "%s: dev %s: type=3D%x, flags=3D%lx\n", msg,=0A=
 		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,=0A=
 		rq->cmd_flags);=0A=
 =0A=
@@ -1198,9 +1198,9 @@ static int __make_request(struct request=0A=
 	int el_ret;=0A=
 	unsigned int bytes =3D bio->bi_size;=0A=
 	const unsigned short prio =3D bio_prio(bio);=0A=
-	const bool sync =3D (bio->bi_rw & REQ_SYNC);=0A=
-	const bool unplug =3D (bio->bi_rw & REQ_UNPLUG);=0A=
-	const unsigned int ff =3D bio->bi_rw & REQ_FAILFAST_MASK;=0A=
+	const bool sync =3D bio_rw_flagged(bio, REQ_SYNC);=0A=
+	const bool unplug =3D bio_rw_flagged(bio, REQ_UNPLUG);=0A=
+	const unsigned long ff =3D bio->bi_rw & REQ_FAILFAST_MASK;=0A=
 	int rw_flags;=0A=
 =0A=
 	if ((bio->bi_rw & REQ_HARDBARRIER) &&=0A=
@@ -1719,7 +1719,7 @@ EXPORT_SYMBOL_GPL(blk_insert_cloned_requ=0A=
  */=0A=
 unsigned int blk_rq_err_bytes(const struct request *rq)=0A=
 {=0A=
-	unsigned int ff =3D rq->cmd_flags & REQ_FAILFAST_MASK;=0A=
+	unsigned long ff =3D rq->cmd_flags & REQ_FAILFAST_MASK;=0A=
 	unsigned int bytes =3D 0;=0A=
 	struct bio *bio;=0A=
 =0A=
diff -urNp ./include/linux/blkdev.h.orig ./include/linux/blkdev.h=0A=
--- ./include/linux/blkdev.h.orig	2010-07-08 07:54:51.000000000 +0800=0A=
+++ ./include/linux/blkdev.h	2010-07-08 07:55:30.000000000 +0800=0A=
@@ -97,7 +97,7 @@ struct request {=0A=
 =0A=
 	struct request_queue *q;=0A=
 =0A=
-	unsigned int cmd_flags;=0A=
+	unsigned long cmd_flags;=0A=
 	enum rq_cmd_type_bits cmd_type;=0A=
 	unsigned long atomic_flags;=0A=
 =0A=
diff -urNp ./include/linux/bio.h.orig ./include/linux/bio.h=0A=
--- ./include/linux/bio.h.orig	2010-07-08 08:32:53.000000000 +0800=0A=
+++ ./include/linux/bio.h	2010-07-08 08:32:17.000000000 +0800=0A=
@@ -218,6 +218,11 @@ enum rq_flag_bits {=0A=
 #define REQ_IO_STAT		(1 << __REQ_IO_STAT)=0A=
 #define REQ_MIXED_MERGE		(1 << __REQ_MIXED_MERGE)=0A=
 =0A=
+static inline bool bio_rw_flagged(struct bio *bio, unsigned long flag)=0A=
+{=0A=
+	return (bio->bi_rw & flag) !=3D 0;=0A=
+}=0A=
+=0A=
 /*=0A=
  * upper 16 bits of bi_rw define the io priority of this bio=0A=
  */=0A=

------=_NextPart_000_0025_01CB1E79.A9435770--

