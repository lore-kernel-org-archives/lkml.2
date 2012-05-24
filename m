Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2EXAjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:39:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2EXAjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:39:19 -0400
Date: Wed, 23 May 2012 17:39:16 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Message-ID: <20120524003915.GA27443@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-3-git-send-email-koverstreet@google.com>
 <4FBD7E80.4020005@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD7E80.4020005@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
> Hi,
> 
> On 05/24/12 09:02, Kent Overstreet wrote:
> > @@ -1438,15 +1439,6 @@ void dm_dispatch_request(struct request *rq)
> >  }
> >  EXPORT_SYMBOL_GPL(dm_dispatch_request);
> >  
> > -static void dm_rq_bio_destructor(struct bio *bio)
> > -{
> > -	struct dm_rq_clone_bio_info *info = bio->bi_private;
> > -	struct mapped_device *md = info->tio->md;
> > -
> > -	free_bio_info(info);
> > -	bio_free(bio, md->bs);
> > -}
> > -
> >  static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
> >  				 void *data)
> >  {
> > @@ -1461,7 +1453,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
> >  	info->tio = tio;
> >  	bio->bi_end_io = end_clone_bio;
> >  	bio->bi_private = info;
> > -	bio->bi_destructor = dm_rq_bio_destructor;
> 
> The destructor may also be called from blk_rq_unprep_clone(),
> which just puts bio.
> So this patch will introduce a memory leak.

Well, keeping around bi_destructor solely for that reason would be
pretty lousy. Can you come up with a better solution?
