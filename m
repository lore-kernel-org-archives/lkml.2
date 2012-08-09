Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2HIAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:09:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2HIAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:09:24 -0400
Date: Wed, 8 Aug 2012 17:08:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net,
        Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH v5 04/12] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120809000850.GC7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-5-git-send-email-koverstreet@google.com>
 <20120808221359.GC6983@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808221359.GC6983@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 03:13:59PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Aug 06, 2012 at 03:08:33PM -0700, Kent Overstreet wrote:
> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> > 
> > v5: Un-reorder some functions, to make the patch easier to review
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> Please Cc: the maintainers.  Cc'ing Peter Osterlund and keeping the
> whole body for him.

Whoops, thanks.

> Generally looks good to me.  How is this tested?

Untested - no hardware for it.

> 
> Thanks.
> 
> > ---
> >  drivers/block/pktcdvd.c |   67 +++++++++++-----------------------------------
> >  1 files changed, 16 insertions(+), 51 deletions(-)
> > 
> > diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> > index ba66e44..ae55f08 100644
> > --- a/drivers/block/pktcdvd.c
> > +++ b/drivers/block/pktcdvd.c
> > @@ -101,6 +101,8 @@ static struct dentry	*pkt_debugfs_root = NULL; /* /sys/kernel/debug/pktcdvd */
> >  static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev);
> >  static int pkt_remove_dev(dev_t pkt_dev);
> >  static int pkt_seq_show(struct seq_file *m, void *p);
> > +static void pkt_end_io_read(struct bio *bio, int err);
> > +static void pkt_end_io_packet_write(struct bio *bio, int err);
> >  
> >  
> >  
> > @@ -522,38 +524,6 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
> >  	}
> >  }
> >  
> > -static void pkt_bio_destructor(struct bio *bio)
> > -{
> > -	kfree(bio->bi_io_vec);
> > -	kfree(bio);
> > -}
> > -
> > -static struct bio *pkt_bio_alloc(int nr_iovecs)
> > -{
> > -	struct bio_vec *bvl = NULL;
> > -	struct bio *bio;
> > -
> > -	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
> > -	if (!bio)
> > -		goto no_bio;
> > -	bio_init(bio);
> > -
> > -	bvl = kcalloc(nr_iovecs, sizeof(struct bio_vec), GFP_KERNEL);
> > -	if (!bvl)
> > -		goto no_bvl;
> > -
> > -	bio->bi_max_vecs = nr_iovecs;
> > -	bio->bi_io_vec = bvl;
> > -	bio->bi_destructor = pkt_bio_destructor;
> > -
> > -	return bio;
> > -
> > - no_bvl:
> > -	kfree(bio);
> > - no_bio:
> > -	return NULL;
> > -}
> > -
> >  /*
> >   * Allocate a packet_data struct
> >   */
> > @@ -567,10 +537,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
> >  		goto no_pkt;
> >  
> >  	pkt->frames = frames;
> > -	pkt->w_bio = pkt_bio_alloc(frames);
> > +	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
> >  	if (!pkt->w_bio)
> >  		goto no_bio;
> >  
> > +	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
> > +	pkt->w_bio->bi_private = pkt;
> > +
> >  	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
> >  		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
> >  		if (!pkt->pages[i])
> > @@ -581,9 +554,12 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
> >  	bio_list_init(&pkt->orig_bios);
> >  
> >  	for (i = 0; i < frames; i++) {
> > -		struct bio *bio = pkt_bio_alloc(1);
> > +		struct bio *bio = bio_kmalloc(GFP_KERNEL, 1);
> >  		if (!bio)
> >  			goto no_rd_bio;
> > +
> > +		bio->bi_end_io = pkt_end_io_read;
> > +		bio->bi_private = pkt;
> >  		pkt->r_bios[i] = bio;
> >  	}
> >  
> > @@ -1111,21 +1087,15 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
> >  	 * Schedule reads for missing parts of the packet.
> >  	 */
> >  	for (f = 0; f < pkt->frames; f++) {
> > -		struct bio_vec *vec;
> > -
> >  		int p, offset;
> > +
> >  		if (written[f])
> >  			continue;
> > +
> >  		bio = pkt->r_bios[f];
> > -		vec = bio->bi_io_vec;
> > -		bio_init(bio);
> > -		bio->bi_max_vecs = 1;
> > -		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
> > -		bio->bi_bdev = pd->bdev;
> > -		bio->bi_end_io = pkt_end_io_read;
> > -		bio->bi_private = pkt;
> > -		bio->bi_io_vec = vec;
> > -		bio->bi_destructor = pkt_bio_destructor;
> > +		bio_reset(bio);
> > +		bio->bi_sector	= pkt->sector + f * (CD_FRAMESIZE >> 9);
> > +		bio->bi_bdev	= pd->bdev;
> >  
> >  		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
> >  		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
> > @@ -1418,14 +1388,9 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
> >  	}
> >  
> >  	/* Start the write request */
> > -	bio_init(pkt->w_bio);
> > -	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
> > +	bio_reset(pkt->w_bio);
> >  	pkt->w_bio->bi_sector = pkt->sector;
> >  	pkt->w_bio->bi_bdev = pd->bdev;
> > -	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
> > -	pkt->w_bio->bi_private = pkt;
> > -	pkt->w_bio->bi_io_vec = bvec;
> > -	pkt->w_bio->bi_destructor = pkt_bio_destructor;
> >  	for (f = 0; f < pkt->frames; f++)
> >  		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
> >  			BUG();
> > -- 
> > 1.7.7.3
> > 
> 
> -- 
> tejun
