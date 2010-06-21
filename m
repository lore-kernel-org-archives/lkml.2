Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab0FUVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758656Ab0FUVg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:36:27 -0400
Date: Mon, 21 Jun 2010 17:36:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100621213618.GC6474@redhat.com>
References: <20100621094828.GA30748@lst.de>
 <4C1F3916.4070608@kernel.dk>
 <20100621110436.GA4056@lst.de>
 <4C1FB5F7.3070908@kernel.dk>
 <20100621191410.GA24213@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621191410.GA24213@lst.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 09:14:10PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 08:56:55PM +0200, Jens Axboe wrote:
> > FWIW, Windows marks meta data writes and they go out with FUA set
> > on SATA disks. And SATA firmware prioritizes FUA writes, it's essentially
> > a priority bit as well as a platter access bit. So at least we have some
> > one else using a meta data boost. I agree that it would be a lot more
> > trivial to add the annotations if they didn't have scheduler impact
> > as well, but I still think it's a sane thing.
> 
> And we still disable the FUA bit in libata unless people set a
> non-standard module option..
> 
> > >> Reads are sync by nature in the block layer, so they don't get that
> > >> special annotation.
> > > 
> > > Well, we do give them this special annotation in a few places, but we
> > > don't actually use it.
> > 
> > For unplugging?
> 
> We use the explicit unplugging, yes - but READ_META also includes
> REQ_SYNC which is not used anywhere.
> 
> > > But that leaves the question why disabling the idling logical for
> > > data integrity ->writepage is fine?  This gets called from ->fsync
> > > or O_SYNC writes and will have the same impact as O_DIRECT writes.
> > 
> > We have never enabled idling for those. O_SYNC should get a nice
> > boost too, it just needs to be benchmarked and tested and then
> > there would be no reason not to add it.
> 
> We've only started using any kind of sync tag last year in ->writepage in
> commit a64c8610bd3b753c6aff58f51c04cdf0ae478c18 "block_write_full_page:
> Use synchronous writes for WBC_SYNC_ALL writebacks", switching from
> WRITE_SYNC to WRITE_SYNC_PLUG a bit later in commit
> 6e34eeddf7deec1444bbddab533f03f520d8458c "block_write_full_page: switch
> synchronous writes to use WRITE_SYNC_PLUG"
> 
> Before that we used plain WRITE, which had the normal idling logic.

I have got very little understanding of file system layer, but if I had
to guess, i think following might have happened.

- We switched from WRITE to WRITE_SYNC for fsync() path.

- This might have caused issues with idling as for SYNC_WRITE we will idle
  in CFQ but probably it is not desirable in certain cases where next set
  of WRITES is going to come from journaling thread. 

- That might have prompted us to introduce the rq_noidle() to make sure
  we don't idle in WRITE_SYNC path but direct IO path was avoided to make
  sure good throughput is maintained. But this left one question open 
  and that is it good to disable idling on all WRITE_SYNC path in kernel.

- Slowly cfq code emerged and as it stands today, to me rq_noidle() is
  practically of not much use. For sync-idle tree (where idling is
  enabled), we are ignoring the rq_noidle() and always arming the timer.
  For sync-noidle, we choose not to idle based on if there was some other
  thread who did even a single IO with rq_noidle=0.

  I think in practice, there is on thread of other which is doing some
  read or write with rq_noidle=0 and if that's the case, we will end up
  idling on sync-noidle tree also and rq_noidle() practically does
  not take effect.

So if rq_noidle() was introduced to solve the issue of not idling on 
fsync() path (as jbd thread will send more data now), then probably slice
yielding patch of jeff might come handy here and and we can get rid of
rq_noidle() logic. This is just a guess work and I might be completely
wrong here...

Thanks
Vivek
