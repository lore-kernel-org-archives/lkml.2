Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2GYXBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:01:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41216 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2GYXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:01:46 -0400
Date: Wed, 25 Jul 2012 16:01:42 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v4 04/12] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120725230142.GB8673@moria.home.lan>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-5-git-send-email-koverstreet@google.com>
 <500FD8B7.9040701@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FD8B7.9040701@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:29:59PM +0300, Boaz Harrosh wrote:
> On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> 
> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > ---
> >  drivers/block/pktcdvd.c |  115 ++++++++++++++++-------------------------------
> >  1 files changed, 39 insertions(+), 76 deletions(-)
> > 
> > diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> > index ba66e44..6fe693a 100644
> > --- a/drivers/block/pktcdvd.c
> > +++ b/drivers/block/pktcdvd.c
> > @@ -522,36 +522,38 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
> >  	}
> >  }
> >  
> > -static void pkt_bio_destructor(struct bio *bio)
> > +static void pkt_end_io_read(struct bio *bio, int err)
> >  {
> > -	kfree(bio->bi_io_vec);
> > -	kfree(bio);
> > -}
> 
> 
> Again here, you decided to move the pkt_end_io_read && pkt_end_io_packet_write
> functions from below, to above here. Which makes it impossible to find
> any bugs by just reviewing the patch.
> 
> So I have not reviewed it. 
> 
> I know that you wanted so you can reference them at pkt_alloc_packet_data.
> I'd use a forward reference, in this case. And a move in a next patch. But
> this is just me. Perhaps the owner of this code can review it?

Yeah, I tend to be pretty anal about unnecessary forward declarations.
Overly anal in this case, I suppose. Here's a better patch:


commit 88cb170314bfa6cc90af37e433c07927b3b79ed2
Author: Kent Overstreet <koverstreet@google.com>
Date:   Wed Jul 25 16:00:00 2012 -0700

    pktcdvd: Switch to bio_kmalloc()
    
    This is prep work for killing bi_destructor - previously, pktcdvd had
    its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
    necessitating its own bi_destructor implementation.
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ba66e44..ae55f08 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -101,6 +101,8 @@ static struct dentry	*pkt_debugfs_root = NULL; /* /sys/kernel/debug/pktcdvd */
 static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev);
 static int pkt_remove_dev(dev_t pkt_dev);
 static int pkt_seq_show(struct seq_file *m, void *p);
+static void pkt_end_io_read(struct bio *bio, int err);
+static void pkt_end_io_packet_write(struct bio *bio, int err);
 
 
 
@@ -522,38 +524,6 @@ static void pkt_bio_finished(struct pktcdvd_device *pd)
 	}
 }
 
-static void pkt_bio_destructor(struct bio *bio)
-{
-	kfree(bio->bi_io_vec);
-	kfree(bio);
-}
-
-static struct bio *pkt_bio_alloc(int nr_iovecs)
-{
-	struct bio_vec *bvl = NULL;
-	struct bio *bio;
-
-	bio = kmalloc(sizeof(struct bio), GFP_KERNEL);
-	if (!bio)
-		goto no_bio;
-	bio_init(bio);
-
-	bvl = kcalloc(nr_iovecs, sizeof(struct bio_vec), GFP_KERNEL);
-	if (!bvl)
-		goto no_bvl;
-
-	bio->bi_max_vecs = nr_iovecs;
-	bio->bi_io_vec = bvl;
-	bio->bi_destructor = pkt_bio_destructor;
-
-	return bio;
-
- no_bvl:
-	kfree(bio);
- no_bio:
-	return NULL;
-}
-
 /*
  * Allocate a packet_data struct
  */
@@ -567,10 +537,13 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 		goto no_pkt;
 
 	pkt->frames = frames;
-	pkt->w_bio = pkt_bio_alloc(frames);
+	pkt->w_bio = bio_kmalloc(GFP_KERNEL, frames);
 	if (!pkt->w_bio)
 		goto no_bio;
 
+	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
+	pkt->w_bio->bi_private = pkt;
+
 	for (i = 0; i < frames / FRAMES_PER_PAGE; i++) {
 		pkt->pages[i] = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		if (!pkt->pages[i])
@@ -581,9 +554,12 @@ static struct packet_data *pkt_alloc_packet_data(int frames)
 	bio_list_init(&pkt->orig_bios);
 
 	for (i = 0; i < frames; i++) {
-		struct bio *bio = pkt_bio_alloc(1);
+		struct bio *bio = bio_kmalloc(GFP_KERNEL, 1);
 		if (!bio)
 			goto no_rd_bio;
+
+		bio->bi_end_io = pkt_end_io_read;
+		bio->bi_private = pkt;
 		pkt->r_bios[i] = bio;
 	}
 
@@ -1111,21 +1087,15 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 * Schedule reads for missing parts of the packet.
 	 */
 	for (f = 0; f < pkt->frames; f++) {
-		struct bio_vec *vec;
-
 		int p, offset;
+
 		if (written[f])
 			continue;
+
 		bio = pkt->r_bios[f];
-		vec = bio->bi_io_vec;
-		bio_init(bio);
-		bio->bi_max_vecs = 1;
-		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
-		bio->bi_bdev = pd->bdev;
-		bio->bi_end_io = pkt_end_io_read;
-		bio->bi_private = pkt;
-		bio->bi_io_vec = vec;
-		bio->bi_destructor = pkt_bio_destructor;
+		bio_reset(bio);
+		bio->bi_sector	= pkt->sector + f * (CD_FRAMESIZE >> 9);
+		bio->bi_bdev	= pd->bdev;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1418,14 +1388,9 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	}
 
 	/* Start the write request */
-	bio_init(pkt->w_bio);
-	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
+	bio_reset(pkt->w_bio);
 	pkt->w_bio->bi_sector = pkt->sector;
 	pkt->w_bio->bi_bdev = pd->bdev;
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
-	pkt->w_bio->bi_private = pkt;
-	pkt->w_bio->bi_io_vec = bvec;
-	pkt->w_bio->bi_destructor = pkt_bio_destructor;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();
