Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1GWH06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:26:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:30253 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1GWH0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,252,1309762800"; 
   d="scan'208";a="30594823"
Date: Sat, 23 Jul 2011 15:26:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] writeback: bdi write bandwidth estimation
Message-ID: <20110723072630.GA2923@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713233016.GE21787@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Thu, Jul 14, 2011 at 07:30:16AM +0800, Jan Kara wrote:
>   Hi Fengguang,
>
> On Fri 01-07-11 22:58:31, Wu Fengguang wrote:
> > On Fri, Jul 01, 2011 at 03:56:09AM +0800, Jan Kara wrote:
> > > On Wed 29-06-11 22:52:48, Wu Fengguang wrote:
> > > > The estimation value will start from 100MB/s and adapt to the real
> > > > bandwidth in seconds.
> > > >
> > > > It tries to update the bandwidth only when disk is fully utilized.
> > > > Any inactive period of more than one second will be skipped.
> > > >
> > > > The estimated bandwidth will be reflecting how fast the device can
> > > > writeout when _fully utilized_, and won't drop to 0 when it goes idle.
> > > > The value will remain constant at disk idle time. At busy write time, if
> > > > not considering fluctuations, it will also remain high unless be knocked
> > > > down by possible concurrent reads that compete for the disk time and
> > > > bandwidth with async writes.
> > > >
> > > > The estimation is not done purely in the flusher because there is no
> > > > guarantee for write_cache_pages() to return timely to update bandwidth.
> > > >
> > > > The bdi->avg_write_bandwidth smoothing is very effective for filtering
> > > > out sudden spikes, however may be a little biased in long term.
> > > >
> > > > The overheads are low because the bdi bandwidth update only occurs at
> > > > 200ms intervals.
> > > >
> > > > The 200ms update interval is suitable, becuase it's not possible to get
> > > > the real bandwidth for the instance at all, due to large fluctuations.
> > > >
> > > > The NFS commits can be as large as seconds worth of data. One XFS
> > > > completion may be as large as half second worth of data if we are going
> > > > to increase the write chunk to half second worth of data. In ext4,
> > > > fluctuations with time period of around 5 seconds is observed. And there
> > > > is another pattern of irregular periods of up to 20 seconds on SSD tests.
> > > >
> > > > That's why we are not only doing the estimation at 200ms intervals, but
> > > > also averaging them over a period of 3 seconds and then go further to do
> > > > another level of smoothing in avg_write_bandwidth.
> > >   I was thinking about your formulas and also observing how it behaves when
> > > writeback happens while the disk is loaded with other load as well (e.g.
> > > grep -r of a large tree or cp from another partition).
> > >
> > > I agree that some kind of averaging is needed. But how we average depends
> > > on what do we need the number for. My thoughts were that there is not such
> > > a thing as *the* write bandwidth since that depends on the background load
> > > on the disk and also type of writes we do (sequential, random) as you noted
> > > as well. What writeback needs to estimate in fact is "how fast can we write
> > > this bulk of data?". Since we should ultimately size dirty limits and other
> > > writeback tunables so that the bulk of data can be written in order of
> > > seconds (but maybe much slower because of background load) I agree with
> > > your first choice that we should measure written pages in a window of
> > > several seconds - so your choice of 3 seconds is OK - but this number
> > > should have a reasoning attached to it in a comment (something like my
> > > elaborate above ;)
> >
> > Agree totally and thanks for the reasoning in great details ;)
> >
> > > Now to your second level of smoothing - is it really useful? We already
> >
> > It's useful for filtering out sudden disturbances. Oh I forgot to show
> > the SSD case which see sudden drops of throughput:
> >
> > http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/1SSD-64G/ext4-1dd-1M-64p-64288M-20%25-2.6.38-rc6-dt6+-2011-03-01-16-19/balance_dirty_pages-bandwidth.png
> >
> > It's also very effective for XFS (see the below graph).
>   I see. I think I finally understood what your second level of smoothing
> does. When e.g. IO is stalled for some time and then is getting up to speed
> for a while your second level of smoothing erases this spike when the stall
> is shorter than twice update time of the bandwidth (if it is more,
> bandwidth will drop two times in a row and you start decreasing your
> smoothed bandwidth as well).

Yeah it does help that case. However that's not the main use case in my mind.

Technically speaking, the input to the write bandwidth estimation
is a series of points (T_i, W_i), where T_i is the i-th time delta
and W_i is the i-th written delta.

T_i may be any value from BANDWIDTH_INTERVAL=200ms to 1s or even more.
For example, XFS will regularly have T_i up to 500ms after the patch
"writeback: scale IO chunk size up to half device bandwidth".

When T_i > 200ms, the direct estimated write_bandwidth will be
consisted of a series of sudden-up-slow-down spikes. The below
graph shows such a spike. The merit of avg_write_bandwidth is,
it can _completely_ smooth out such spikes.

        *
        *  *
        *     *                               [*] write_bandwdith
        *        *                            [.] avg_write_bandwidth
        *           *
        *               *
        *                   *
        *                       *
        *                            *
        *                                 *
        *                                       *
        *                                              *
  ......*........................................................
  *******

You cannot observe such patterns in ext3/4 because they do IO
completions much more frequently than BANDWIDTH_INTERVAL. However if
you take a close look at XFS, it's happening all the time:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/4G-60%25/xfs-1dd-1M-8p-3911M-60%25-2.6.38-rc5-dt6+-2011-02-22-11-10/balance_dirty_pages-bandwidth-500.png

As you can see, avg_write_bandwidth has the drawback of possibly
introducing some systematic error in such case. And here lies the
trade off:

- "accurate" and "timely" bandwidth estimation, not sensitive to fluctuations
  => use write_bandwdith

- constant fluctuations very undesirable, not sensitive to estimation errors
  => use avg_write_bandwdith

IMHO avg_write_bandwdith will be particular useful for IO-less
balance_dirty_pages(), as the users are in general much more sensitive
to the application dirty bandwidth (which will directly inherit the
fluctuations from avg_write_bandwdith) than the number of dirty pages
(whose distance to the dirty threshold will be affected by the
estimation error).

> > > average over several second window so that should really eliminate big
> > > spikes comming from bumpy IO completion from storage (NFS might be a
> > > separate question but we talked about that already). Your second level
> > > of smoothing just spreads the window even further but if you find that
> > > necessary, why not make the window larger in the first place? Also my
> >
> > Because they are two different type of smoothing. I employed the same
> > smoothing as avg_write_bandwidth for bdi_dirty, where I wrote this
> > comment to illustrate its unique usefulness:
>   But is your second level of smoothing really that much different from
> making the window over which we average larger? E.g. if you have 3s window
> and the IO stalls 1s, you will see 33% variation in computed bandwidth.
> But if you had 10s window, you would see only 10% variation.

The 2nd level smoothing can in theory cut down half fluctuations even
for ext3/4, under the constraint of the same response time. For
example, given the below bdi->write_bandwdith curve, whenever it is
returning to avg_write_bandwidth and balance point,
avg_write_bandwidth will _stop_ tracking it and stay close to the
balance point. This conditional tracking helps cancel fluctuations.

                           depart --.             .-- return
                                     \    .-.    /
                           .-.        \  /   \  /        .-.  <--- fluctuating write_bandwdith
  .-.     _     .-.       /   \         /     \         /   \
-/---\---/-\---/---\-----/-----\-------/-------\-------/-----\---- balance point
/     `-'   `-'     \   /       \     /         \     /       \
                     `-'         \   /           \   /         `-'
                                  `-'             `-'                   

> To get some real numbers I've run simple dd on XFS filesystem and plotted
> basic computed bandwidth and smoothed bandwidth with 3s and 10s window.
> The results are at:
> http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-write.png
> http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-write-10s.png

Nice graphs! 

> You can see that with 10s window basic bandwidth is (unsuprisingly) quite
> closer to your smoothed bandwidth than with 3s window. Of course if the
> variations in throughput are longer in time, the throughput will oscilate
> more even with larger window. But that is the case with your smoothed
> bandwidth as well and it is in fact desirable because as soon as amount of
> data we can write per second is lower for several seconds, we have to
> really consider this and change writeback tunables accordingly. To
> demostrate the changes in smoothed bandwidth, I've run a test where we are
> writing lots of 10MB files to the filesystem and in paralel we read randomly
> 1-1000MB from the filesystem and then sleep for 1-15s. The results (with 3s
> and 10s window) are at:
> http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-read-dd-write.png
> http://beta.suse.com/private/jack/bandwidth-tests/fengguang-dd-read-dd-write-10s.png

Thanks for the disturbance tests -- the response curve with intermittent reads
actually answered one of the questions raised by Vivek :)

However you seem to miss the point of avg_write_bandwidth, explained below,
which I failed to mention in the first place. Sorry for that!

> You can see that both basic and smoothed bandwidth are not that much
> different even with 3s window and with 10s window the differences are
> negligible I'd say.

Yes, that's intended. avg_write_bandwidth should track large workload
changes over long time as good as possible.

> So both from my understanding and my experiments, I'd say that the basic
> computation of bandwidth should be enough and if you want to be on a
> smoother side, you can just increase the window size and you will get
> rather similar results as with your second level of smoothing.

avg_write_bandwidth aims to cancel fluctuations within some 1-3 seconds window.

As you can see from your graphs, it does yield much more smooth curve
in that granularity. Simply increasing write_bandwdith's estimation
window from 3s to 10s is much less effective in providing the seconds
long window's smoothness as by avg_write_bandwidth and has the cost of
larger lags in response to changed workload. 

In summary, the bandwidth estimation tries to reflect the real
bandwidth in some timely fashion, while trying to filter out the
_regular_ fluctuations as much as possible. Note that it still tries
to track the _long term_ "fluctuations" that reflect workload changes.

Thanks,
Fengguang
