Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1GMXaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:30:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1GMXaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:30:20 -0400
Date: Thu, 14 Jul 2011 01:30:16 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110713233016.GE21787@quack.suse.cz>
References: <20110629145245.835998321@intel.com>
 <20110629145553.906668553@intel.com>
 <20110630195609.GA9722@quack.suse.cz>
 <20110701145831.GB8475@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701145831.GB8475@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Fengguang,

On Fri 01-07-11 22:58:31, Wu Fengguang wrote:
> On Fri, Jul 01, 2011 at 03:56:09AM +0800, Jan Kara wrote:
> > On Wed 29-06-11 22:52:48, Wu Fengguang wrote:
> > > The estimation value will start from 100MB/s and adapt to the real
> > > bandwidth in seconds.
> > > 
> > > It tries to update the bandwidth only when disk is fully utilized.
> > > Any inactive period of more than one second will be skipped.
> > > 
> > > The estimated bandwidth will be reflecting how fast the device can
> > > writeout when _fully utilized_, and won't drop to 0 when it goes idle.
> > > The value will remain constant at disk idle time. At busy write time, if
> > > not considering fluctuations, it will also remain high unless be knocked
> > > down by possible concurrent reads that compete for the disk time and
> > > bandwidth with async writes.
> > > 
> > > The estimation is not done purely in the flusher because there is no
> > > guarantee for write_cache_pages() to return timely to update bandwidth.
> > > 
> > > The bdi->avg_write_bandwidth smoothing is very effective for filtering
> > > out sudden spikes, however may be a little biased in long term.
> > > 
> > > The overheads are low because the bdi bandwidth update only occurs at
> > > 200ms intervals.
> > > 
> > > The 200ms update interval is suitable, becuase it's not possible to get
> > > the real bandwidth for the instance at all, due to large fluctuations.
> > > 
> > > The NFS commits can be as large as seconds worth of data. One XFS
> > > completion may be as large as half second worth of data if we are going
> > > to increase the write chunk to half second worth of data. In ext4,
> > > fluctuations with time period of around 5 seconds is observed. And there
> > > is another pattern of irregular periods of up to 20 seconds on SSD tests.
> > > 
> > > That's why we are not only doing the estimation at 200ms intervals, but
> > > also averaging them over a period of 3 seconds and then go further to do
> > > another level of smoothing in avg_write_bandwidth.
> >   I was thinking about your formulas and also observing how it behaves when
> > writeback happens while the disk is loaded with other load as well (e.g.
> > grep -r of a large tree or cp from another partition).
> > 
> > I agree that some kind of averaging is needed. But how we average depends
> > on what do we need the number for. My thoughts were that there is not such
> > a thing as *the* write bandwidth since that depends on the background load
> > on the disk and also type of writes we do (sequential, random) as you noted
> > as well. What writeback needs to estimate in fact is "how fast can we write
> > this bulk of data?". Since we should ultimately size dirty limits and other
> > writeback tunables so that the bulk of data can be written in order of
> > seconds (but maybe much slower because of background load) I agree with
> > your first choice that we should measure written pages in a window of
> > several seconds - so your choice of 3 seconds is OK - but this number
> > should have a reasoning attached to it in a comment (something like my
> > elaborate above ;)
> 
> Agree totally and thanks for the reasoning in great details ;)
> 
> > Now to your second level of smoothing - is it really useful? We already
> 
> It's useful for filtering out sudden disturbances. Oh I forgot to show
> the SSD case which see sudden drops of throughput:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/1SSD-64G/ext4-1dd-1M-64p-64288M-20%25-2.6.38-rc6-dt6+-2011-03-01-16-19/balance_dirty_pages-bandwidth.png
> 
> It's also very effective for XFS (see the below graph).
  I see. I think I finally understood what your second level of smoothing
does. When e.g. IO is stalled for some time and then is getting up to speed
for a while your second level of smoothing erases this spike when the stall
is shorter than twice update time of the bandwidth (if it is more,
bandwidth will drop two times in a row and you start decreasing your
smoothed bandwidth as well).

> > average over several second window so that should really eliminate big
> > spikes comming from bumpy IO completion from storage (NFS might be a
> > separate question but we talked about that already). Your second level
> > of smoothing just spreads the window even further but if you find that
> > necessary, why not make the window larger in the first place? Also my
> 
> Because they are two different type of smoothing. I employed the same
> smoothing as avg_write_bandwidth for bdi_dirty, where I wrote this
> comment to illustrate its unique usefulness:
  But is your second level of smoothing really that much different from
making the window over which we average larger? E.g. if you have 3s window
and the IO stalls 1s, you will see 33% variation in computed bandwidth.
But if you had 10s window, you would see only 10% variation.

To get some real numbers I've run simple dd on XFS filesystem and plotted
basic computed bandwidth and smoothed bandwidth with 3s and 10s window.
The results are at:
http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-write.png
http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-write-10s.png

You can see that with 10s window basic bandwidth is (unsuprisingly) quite
closer to your smoothed bandwidth than with 3s window. Of course if the
variations in throughput are longer in time, the throughput will oscilate
more even with larger window. But that is the case with your smoothed
bandwidth as well and it is in fact desirable because as soon as amount of
data we can write per second is lower for several seconds, we have to
really consider this and change writeback tunables accordingly. To
demostrate the changes in smoothed bandwidth, I've run a test where we are
writing lots of 10MB files to the filesystem and in paralel we read randomly
1-1000MB from the filesystem and then sleep for 1-15s. The results (with 3s
and 10s window) are at:
http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-read-dd-write.png
http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-read-dd-write-10s.png

You can see that both basic and smoothed bandwidth are not that much
different even with 3s window and with 10s window the differences are
negligible I'd say.

So both from my understanding and my experiments, I'd say that the basic
computation of bandwidth should be enough and if you want to be on a
smoother side, you can just increase the window size and you will get
rather similar results as with your second level of smoothing.

> +       /*
> +        * This ...
> +        * ... is most effective on XFS,
> +        * whose pattern is
> +        *                                                             .
> +        *      [.] dirty       [-] avg                       .       .
> +        *                                                   .       .
> +        *              .         .         .         .     .       .
> +        *      ---------------------------------------    .       .
> +        *            .         .         .         .     .       .
> +        *           .         .         .         .     .       .
> +        *          .         .         .         .     .       .
> +        *         .         .         .         .     .       .
> +        *        .         .         .         .
> +        *       .         .         .         .      (fluctuated)
> +        *      .         .         .         .
> +        *     .         .         .         .
> +        *
> +        * @avg will remain flat at the cost of being biased towards high. In
> +        * practice the error tend to be much smaller: thanks to more coarse
> +        * grained fluctuations, @avg becomes the real average number for the
> +        * last two rising lines of @dirty.
> +        */
> 
> > observations of avg-bandwidth and bandwidth when there's some background
> > read load (e.g. from grep) shows that in this case both bandwidth and
> > avg-bandwidth fluctuate +-10%. 
> 
> You can more easily see their fluctuate ranges in my graphs :)
> For example,
> 
> (compare the YELLOW line to the RED dots)
> 
> NFS
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/balance_dirty_pages-bandwidth.png
> 
> XFS
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G/xfs-1dd-1M-8p-3927M-20%25-2.6.38-rc6-dt6+-2011-02-27-22-58/balance_dirty_pages-bandwidth.png
> 
> ext4
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v8/3G/ext4-1dd-4k-8p-2948M-20:10-3.0.0-rc2-next-20110610+-2011-06-12.21:57/balance_dirty_pages-bandwidth.png
> 
> > Finally, as I reasoned above, we are
> > interested in how much we can write in coming say 2 seconds so I don't see
> > a big point smoothing the value too much (I'd even say it's undesirable).
> > What do you think?
> 
> Yeah we typically get 20% ->write_bandwidth fluctuation range in the
> above graphs (except for NFS), which seems reasonably good for guiding
> the write chunk size.
> 
> However I would still like to favor a more stable value and
> ->avg_write_bandwidth looks appealing with much smaller 3%-10% ranges
> in steady state. Because the fluctuations of estimated write bandwidth
> will directly become the fluctuations in write chunk sizes over time
> as well as the application throttled write speed in future IO-less
> balance_dirty_pages().
  I've written about this above.

> Oh I thought the code is clear enough because it's the standard
> running average technique... or let's write down the before-simplified
> formula?
> 
>         /*
>          * bw = written * HZ / elapsed
>          *
>          *                   bw * elapsed + write_bandwidth * (period - elapsed)
>          * write_bandwidth = ---------------------------------------------------
>          *                                          period
>          */
  Yes, it is a standard running average but you shouldn't have to decode
that from the code. The formula explains that nicely. Thanks.

> > > +	bw += (u64)bdi->write_bandwidth * (period - elapsed);
> > > +	cur = bw >> ilog2(period);
> > > +
> > > +	/*
> > > +	 * one more level of smoothing, for filtering out sudden spikes
> > > +	 */
> > > +	if (avg > old && old > cur)
> > > +		avg -= (avg - old) >> 3;
> > > +
> > > +	if (avg < old && old < cur)
> > > +		avg += (old - avg) >> 3;
> > > +
> > > +	bdi->write_bandwidth = cur;
> > > +	bdi->avg_write_bandwidth = avg;
> > > +}
> > > +
> > > +void __bdi_update_bandwidth(struct backing_dev_info *bdi,
> > > +			    unsigned long start_time)
> > > +{
> > > +	unsigned long now = jiffies;
> > > +	unsigned long elapsed = now - bdi->bw_time_stamp;
> > > +	unsigned long written;
> > > +
> > > +	/*
> > > +	 * rate-limit, only update once every 200ms.
> > > +	 */
> > > +	if (elapsed < MAX_PAUSE)
> > > +		return;
> > > +
> > > +	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]);
> > > +
> > > +	/*
> > > +	 * Skip quiet periods when disk bandwidth is under-utilized.
> > > +	 * (at least 1s idle time between two flusher runs)
> > > +	 */
> > > +	if (elapsed > HZ && time_before(bdi->bw_time_stamp, start_time))
> > > +		goto snapshot;
> >   Cannot we just explicitely stamp the written_stamp and bw_time_stamp at
> > the beginning of wb_writeback and be done with it? We wouldn't have to
> > pass the time stamps, keep them in wb_writeback() and balance_dirty_pages()
> > etc.
> 
> I'm afraid that stamping may unnecessarily disturb/invalidate valid
> accounting periods. For example, if the flusher keeps working on tiny
> works, it will effectively disable bandwidth updates.
  OK, sounds reasonable.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
