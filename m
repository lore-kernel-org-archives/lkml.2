Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0LEVwB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:52:01 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:49059 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab0LEVwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:52:00 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] block: add_disk: fix error handling
Date: Sun, 5 Dec 2010 22:51:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: axboe@kernel.dk, paulmck@linux.vnet.ibm.com, shemminger@vyatta.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-kernel@vger.kernel.org
References: <1291562127-31432-1-git-send-email-richard@nod.at> <20101206081752.72db2c80@notabene.brown>
In-Reply-To: <20101206081752.72db2c80@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012052251.53733.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 05 Dezember 2010, 22:17:52 schrieb Neil Brown:
> On Sun,  5 Dec 2010 16:15:27 +0100 Richard Weinberger <richard@nod.at> wrote:
> > This patch brings better error handling to the
> > add_disk function.
> > Now it reports success or failure.
> 
> So does that mean that all callers of add_disk should now check the return
> status and possible error-out ???  Sounds a bit painful.

Currently add_disk() is used 77 times in the kernel.
If this patch goes into mainline I'll happily provide a patch for every call.
When this is done we can also remove most the WARN_ON()s within add_disk().

> Could you summaries the real-life situations in which add_disk can fail?
> And what the consequences of failure are?

blk_alloc_devt() can fail i case of no memory.
bdi_register_dev() too.

In the current implementation of add_disk() the return values of bdi_register_dev()
and blk_register_queue() are ignored which isn't very nice.

Thanks,
//richard

> Thanks,
> NeilBrown
> 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> > 
> >  block/genhd.c         |   34 +++++++++++++++++++++++++++-------
> >  include/linux/genhd.h |    2 +-
> >  2 files changed, 28 insertions(+), 8 deletions(-)
> > 
> > diff --git a/block/genhd.c b/block/genhd.c
> > index 5fa2b44..075e630 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -508,10 +508,8 @@ static int exact_lock(dev_t devt, void *data)
> > 
> >   *
> >   * This function registers the partitioning information in @disk
> >   * with the kernel.
> > 
> > - *
> > - * FIXME: error handling
> > 
> >   */
> > 
> > -void add_disk(struct gendisk *disk)
> > +int add_disk(struct gendisk *disk)
> > 
> >  {
> >  
> >  	struct backing_dev_info *bdi;
> >  	dev_t devt;
> > 
> > @@ -529,7 +527,7 @@ void add_disk(struct gendisk *disk)
> > 
> >  	retval = blk_alloc_devt(&disk->part0, &devt);
> >  	if (retval) {
> >  	
> >  		WARN_ON(1);
> > 
> > -		return;
> > +		goto out;
> > 
> >  	}
> >  	disk_to_dev(disk)->devt = devt;
> > 
> > @@ -541,16 +539,38 @@ void add_disk(struct gendisk *disk)
> > 
> >  	/* Register BDI before referencing it from bdev */
> >  	bdi = &disk->queue->backing_dev_info;
> > 
> > -	bdi_register_dev(bdi, disk_devt(disk));
> > +	retval = bdi_register_dev(bdi, disk_devt(disk));
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto out_free_devt;
> > +	}
> > 
> >  	blk_register_region(disk_devt(disk), disk->minors, NULL,
> >  	
> >  			    exact_match, exact_lock, disk);
> >  	
> >  	register_disk(disk);
> > 
> > -	blk_register_queue(disk);
> > +	retval = blk_register_queue(disk);
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto out_unregister_bdi;
> > +	}
> > 
> >  	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
> >  	
> >  				   "bdi");
> > 
> > -	WARN_ON(retval);
> > +	if (retval) {
> > +		WARN_ON(1);
> > +		goto out_unregister_queue;
> > +	}
> > +
> > +	return 0;
> > +
> > +out_unregister_queue:
> > +	blk_unregister_queue(disk);
> > +out_unregister_bdi:
> > +	bdi_unregister(bdi);
> > +out_free_devt:
> > +	blk_free_devt(devt);
> > +out:
> > +	return -1;
> > 
> >  }
> >  
> >  EXPORT_SYMBOL(add_disk);
> > 
> > diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> > index 7a7b9c1..4e7ab8e 100644
> > --- a/include/linux/genhd.h
> > +++ b/include/linux/genhd.h
> > @@ -393,7 +393,7 @@ static inline void free_part_info(struct hd_struct
> > *part)
> > 
> >  extern void part_round_stats(int cpu, struct hd_struct *part);
> >  
> >  /* block/genhd.c */
> > 
> > -extern void add_disk(struct gendisk *disk);
> > +extern int add_disk(struct gendisk *disk);
> > 
> >  extern void del_gendisk(struct gendisk *gp);
> >  extern void unlink_gendisk(struct gendisk *gp);
> >  extern struct gendisk *get_gendisk(dev_t dev, int *partno);

