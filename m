Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0GGXFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:05:45 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:33136 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756169Ab0GGXFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:05:43 -0400
X-DYX-POP3-Checked-Auth: 114.32.100.136:kernel@takeo.idv.tw
Message-ID: <1AEF19B8648844C983F583EEBE9C46F4@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
       <viro@zeniv.linux.org.uk>, <sfr@canb.auug.org.au>,
       "Takeo Tung" <kernel@takeo.idv.tw>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1> <4C129778.7040409@suse.cz> <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1> <20100612094937.GA12455@lst.de> <F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1>
In-Reply-To: <F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1>
Subject: [PATCH] struct io panic on raid1 - Re: block: unify flags for struct bio and struct request will kernel panic
Date: Thu, 8 Jul 2010 07:05:39 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Christoph,

I was check the patch again. I found the panic status haapen on Soft RAID 1. 
I review it. found some define using bool, so some like ( x & REQ_SYNC) only 
0 or 1.
so if bi_rw = rw | sync will bi_rw = rw | 0 or rw | 1. not rw | ( 1 << 
__REQ_SYNC).

So I write a patch is fix it. seems normal now. could you review the patch 
or any comment?

Thanks
Takeo Tung

Signed-off-by: Takeo Tung <kernel@takeo.idv.tw>
--------
diff -urNp ./drivers/md/raid10.c.orig ./drivers/md/raid10.c
--- ./drivers/md/raid10.c.orig  2010-07-07 19:24:12.000000000 +0800
+++ ./drivers/md/raid10.c       2010-07-07 19:24:36.000000000 +0800
@@ -799,7 +799,7 @@ static int make_request(mddev_t *mddev,
        int i;
        int chunk_sects = conf->chunk_mask + 1;
        const int rw = bio_data_dir(bio);
-       const bool do_sync = (bio->bi_rw & REQ_SYNC);
+       const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
        struct bio_list bl;
        unsigned long flags;
        mdk_rdev_t *blocked_rdev;
@@ -1716,7 +1716,7 @@ static void raid10d(mddev_t *mddev)
                                raid_end_bio_io(r10_bio);
                                bio_put(bio);
                        } else {
-                               const bool do_sync = 
(r10_bio->master_bio->bi_rw & REQ_SYNC);
+                               const unsigned long do_sync = 
(r10_bio->master_bio->bi_rw & REQ_SYNC);
                                bio_put(bio);
                                rdev = conf->mirrors[mirror].rdev;
                                if (printk_ratelimit())
diff -urNp ./drivers/md/raid1.c.orig ./drivers/md/raid1.c
--- ./drivers/md/raid1.c.orig   2010-07-07 19:21:45.000000000 +0800
+++ ./drivers/md/raid1.c        2010-07-07 19:24:10.000000000 +0800
@@ -787,8 +787,8 @@ static int make_request(mddev_t *mddev,
        struct bio_list bl;
        struct page **behind_pages = NULL;
        const int rw = bio_data_dir(bio);
-       const bool do_sync = (bio->bi_rw & REQ_SYNC);
-       bool do_barriers;
+       const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
+       unsigned long do_barriers;
        mdk_rdev_t *blocked_rdev;

        /*
@@ -1640,7 +1640,7 @@ static void raid1d(mddev_t *mddev)
                         * We already have a nr_pending reference on these 
rdevs.
                         */
                        int i;
-                       const bool do_sync = (r1_bio->master_bio->bi_rw & 
REQ_SYNC);
+                       const unsigned long do_sync = 
(r1_bio->master_bio->bi_rw & REQ_SYNC);
                        clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
                        clear_bit(R1BIO_Barrier, &r1_bio->state);
                        for (i=0; i < conf->raid_disks; i++)
@@ -1696,7 +1696,7 @@ static void raid1d(mddev_t *mddev)
                                       (unsigned long long)r1_bio->sector);
                                raid_end_bio_io(r1_bio);
                        } else {
-                               const bool do_sync = 
r1_bio->master_bio->bi_rw & REQ_SYNC;
+                               const unsigned long do_sync = 
r1_bio->master_bio->bi_rw & REQ_SYNC;
                                r1_bio->bios[r1_bio->read_disk] =
                                        mddev->ro ? IO_BLOCKED : NULL;
                                r1_bio->read_disk = disk;
diff -urNp ./drivers/block/loop.c.orig ./drivers/block/loop.c
--- ./drivers/block/loop.c.orig 2010-07-07 19:21:12.000000000 +0800
+++ ./drivers/block/loop.c      2010-07-07 19:21:23.000000000 +0800
@@ -476,7 +476,7 @@ static int do_bio_filebacked(struct loop
        pos = ((loff_t) bio->bi_sector << 9) + lo->lo_offset;

        if (bio_rw(bio) == WRITE) {
-               bool barrier = (bio->bi_rw & REQ_HARDBARRIER);
+               unsigned long barrier = (bio->bi_rw & REQ_HARDBARRIER);
                struct file *file = lo->lo_backing_file;

                if (barrier) {
diff -urNp ./block/blk-core.c.orig ./block/blk-core.c
--- ./block/blk-core.c.orig     2010-07-07 19:14:55.000000000 +0800
+++ ./block/blk-core.c  2010-07-07 19:27:20.000000000 +0800
@@ -1198,9 +1198,9 @@ static int __make_request(struct request
        int el_ret;
        unsigned int bytes = bio->bi_size;
        const unsigned short prio = bio_prio(bio);
-       const bool sync = (bio->bi_rw & REQ_SYNC);
-       const bool unplug = (bio->bi_rw & REQ_UNPLUG);
-       const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
+       const unsigned long sync = (bio->bi_rw & REQ_SYNC);
+       const unsigned long unplug = (bio->bi_rw & REQ_UNPLUG);
+       const unsigned long ff = bio->bi_rw & REQ_FAILFAST_MASK;
        int rw_flags;

        if ((bio->bi_rw & REQ_HARDBARRIER) &&
@@ -1719,7 +1719,7 @@ EXPORT_SYMBOL_GPL(blk_insert_cloned_requ
  */
 unsigned int blk_rq_err_bytes(const struct request *rq)
 {
-       unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+       unsigned long ff = rq->cmd_flags & REQ_FAILFAST_MASK;
        unsigned int bytes = 0;
        struct bio *bio;

--------------------------- 

--------------------------------------------------
From: "Takeo Tung" <kernel@takeo.idv.tw>
Sent: Monday, June 28, 2010 6:52 PM
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Michal Marek" <mmarek@suse.cz>; <linux-kernel@vger.kernel.org>; 
<viro@zeniv.linux.org.uk>; <sfr@canb.auug.org.au>; "Takeo Tung" 
<kernel@takeo.idv.tw>
Subject: block: unify flags for struct bio and struct request will kernel 
panic

> Dear Christoph,
>
> As subject, I revert the patch, seems boot is normal, but apply the patch,
> kernel will panic on scsi_setup_fs_cmnd, could you can check this? bcoz I 
> check long time,
> no found why kernel will panic.
>
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fnext%2Flinux-next.git;a=commitdiff_plain;h=74450be123b6f3cb480c358a056be398cce6aa6e
>
> Thanks,
> Takeo Tung
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> 
