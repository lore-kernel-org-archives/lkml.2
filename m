Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab1CHWKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:10:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1CHWKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:10:10 -0500
Date: Tue, 8 Mar 2011 17:10:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, NeilBrown <neilb@suse.de>
Subject: blk-throttle: Use blk_plug in throttle code (Was: Re: [PATCH 05/10]
 block: remove per-queue plugging)
Message-ID: <20110308221002.GJ27455@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <20110304040048.GA32404@redhat.com>
 <4D761FE1.20503@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D761FE1.20503@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 01:24:01PM +0100, Jens Axboe wrote:
> On 2011-03-04 05:00, Vivek Goyal wrote:
> > On Sat, Jan 22, 2011 at 01:17:24AM +0000, Jens Axboe wrote:
> > 
> > [..]
> >>  mm/page-writeback.c                |    2 +-
> >>  mm/readahead.c                     |   12 ---
> >>  mm/shmem.c                         |    1 -
> >>  mm/swap_state.c                    |    5 +-
> >>  mm/swapfile.c                      |   37 --------
> >>  mm/vmscan.c                        |    2 +-
> >>  118 files changed, 153 insertions(+), 1248 deletions(-)
> > 
> > block/blk-throttle.c also uses blk_unplug(). We need to get rid of that
> > also.
> 
> Done.

Thanks Jens. Looking at the usage of blk_plug, i think it makes sense to
make use of it in throttle dispatch also. Here is the patch.

blk-throttle: Use blk_plug in throttle dispatch

Use plug in throttle dispatch also as we are dispatching a bunch of
bios in throttle context and some of them might merge.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-block/block/blk-throttle.c
===================================================================
--- linux-2.6-block.orig/block/blk-throttle.c	2011-03-08 16:43:14.000000000 -0500
+++ linux-2.6-block/block/blk-throttle.c	2011-03-08 16:59:44.359620804 -0500
@@ -770,6 +770,7 @@ static int throtl_dispatch(struct reques
 	unsigned int nr_disp = 0;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
+	struct blk_plug plug;
 
 	spin_lock_irq(q->queue_lock);
 
@@ -798,8 +799,10 @@ out:
 	 * immediate dispatch
 	 */
 	if (nr_disp) {
+		blk_start_plug(&plug);
 		while((bio = bio_list_pop(&bio_list_on_stack)))
 			generic_make_request(bio);
+		blk_finish_plug(&plug);
 	}
 	return nr_disp;
 }
