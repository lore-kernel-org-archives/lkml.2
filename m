Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0IGVRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:17:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519Ab0IGVRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:17:49 -0400
Date: Tue, 7 Sep 2010 17:17:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de,
        rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com,
        mpatocka@redhat.com
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Message-ID: <20100907211724.GA22525@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <4C84CD18.6060906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C84CD18.6060906@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06 2010 at  7:14am -0400,
Milan Broz <mbroz@redhat.com> wrote:

> On 09/03/2010 12:29 PM, Tejun Heo wrote:
> 
> > +++ b/drivers/md/dm-crypt.c
> > @@ -1278,7 +1278,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
> >  	struct dm_crypt_io *io;
> >  	struct crypt_config *cc;
> >  
> > -	if (unlikely(bio_empty_barrier(bio))) {
> > +	if (bio->bi_rw & REQ_FLUSH) {
> >  		cc = ti->private;
> >  		bio->bi_bdev = cc->dev->bdev;
> >  		return DM_MAPIO_REMAPPED;
> 
> ...
> 
> > +++ b/drivers/md/dm.c
> > @@ -1400,14 +1391,22 @@ static void __split_and_process_bio(struct mapped_device *md, struct bio *bio)
> >  	ci.io->md = md;
> >  	spin_lock_init(&ci.io->endio_lock);
> >  	ci.sector = bio->bi_sector;
> > -	ci.sector_count = bio_sectors(bio);
> > -	if (unlikely(bio_empty_barrier(bio)))
> > +	if (!(bio->bi_rw & REQ_FLUSH))
> > +		ci.sector_count = bio_sectors(bio);
> > +	else {
> > +		/* all FLUSH bio's reaching here should be empty */
> > +		WARN_ON_ONCE(bio_has_data(bio));
> >  		ci.sector_count = 1;
> > +	}
> 
> 
> I would add BUG_ON(bio_has_data(bio)) either to dm-crypt target or directly to DM core
> in this path.

I agree, that WARN_ON_ONCE should be changed to BUG_ON.  This is a
guarantee that the block layer now provides so it seems correct to have
the DM core bug if that guarantee isn't actually provided.
 
> Note that empty barrier request bypass encryption layer now in dm-crypt, so if some bio
> with data payload reach it after the change, it causes data corruption
> (moreover plain data reach the disk directly).

Given the consequences, it wouldn't hurt to BUG_ON() in dm-crypt too.
It's redundant if the DM core will also BUG_ON() but it serves as a
dm-crypt safety-net/documentation.

Mike
