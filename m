Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1KVT1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:27:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1KVT1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:27:38 -0500
Date: Tue, 22 Nov 2011 20:27:36 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: hard throttle 1000+ dd on a slow USB stick
Message-ID: <20111122192736.GG8058@quack.suse.cz>
References: <20111117115914.GA24502@localhost>
 <20111121203742.GD4017@quack.suse.cz>
 <20111122022053.GA20982@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122022053.GA20982@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 10:20:53, Wu Fengguang wrote:
> On Tue, Nov 22, 2011 at 04:37:42AM +0800, Jan Kara wrote:
> > On Thu 17-11-11 19:59:14, Wu Fengguang wrote:
> > > The sleep based balance_dirty_pages() can pause at most MAX_PAUSE=200ms
> > > on every 1 4KB-page, which means it cannot throttle a task under
> > > 4KB/200ms=20KB/s. So when there are more than 512 dd writing to a
> > > 10MB/s USB stick, its bdi dirty pages could grow out of control.
> > > 
> > > Even if we can increase MAX_PAUSE, the minimal (task_ratelimit = 1)
> > > means a limit of 4KB/s.
> > > 
> > > They can eventually be safeguarded by the global limit check
> > > (nr_dirty < dirty_thresh). However if someone is also writing to an
> > > HDD at the same time, it'll get poor HDD write performance.
> > > 
> > > We at least want to maintain good write performance for other devices
> > > when one device is attacked by some "massive parallel" workload, or
> > > suffers from slow write bandwidth, or somehow get stalled due to some
> > > error condition (eg. NFS server not responding).
> > > 
> > > For a stalled device, we need to completely block its dirtiers, too,
> > > before its bdi dirty pages grow all the way up to the global limit and
> > > leave no space for the other functional devices.
> >   This is a fundamental question - how much do you allow dirty cache of one
> > device to grow when other devices are relatively idle? Every choice has
> > advantages and disadvantages. If you allow device to occupy lot of the
> > cache, you may later find yourself short on dirtiable memory when other
> > devices become active. On the other hand allowing more dirty memory can
> > improve IO pattern and thus writeout speed. So whatever choice we make,
> > we should explain our choice somewhere in the code and stick to that...
> 
> The answer lies in bdi_thresh and will continue to be so with this patch :)
>
> Basically we let active devices to grow its quota of dirty pages and
> stalled/inactive devices to decrease its quota over time. That's the
> backing rational for Peter's "floating proportions".
  Sure, but how we use bdi_thresh was changing in the past. For example at
which global level of dirty pages we decide to enforce bdi_thresh. Now you
again slightly change the logic when bdi_thresh is enforced and when not...
So my suggestion was more aiming at having somewhere documented, when we
enforce bdi_thresh and when not, together with description of goals we try
to achieve with this setting.
 
> It works well except in the case of "an inactive disk suddenly goes
> busy", where the initial quota may be too small. To mitigate this,
> bdi_position_ratio() has the below line to raise a small bdi_thresh
> when it's safe to do so, so that the disk get a reasonable large
> initial quota for fast rampup:
> 
>         bdi_thresh = max(bdi_thresh, (limit - dirty) / 8);
> 
> > > So change the loop exit condition to
> > > 
> > > 	/*
> > > 	 * Always enforce global dirty limit; also enforce bdi dirty limit
> > > 	 * if the normal max_pause sleeps cannot keep things under control.
> > > 	 */
> > > 	if (nr_dirty < dirty_thresh &&
> > > 	    (bdi_dirty < bdi_thresh || bdi->dirty_ratelimit > 1))
> > > 		break;
> > > 
> > > which can be further simplified to
> > > 
> > > 	if (task_ratelimit)
> > > 		break;
> >   Hmm, but if pos_ratio == 0, task_ratelimit is uninitialized... Generally,
> 
> Shy.. That's fixed by a recent commit 3a73dbbc9bb ("writeback: fix
> uninitialized task_ratelimit") in Linus' tree.
  Ah, OK, I missed that.

> > I would find it more robust to have there a test directly with numbers of
> > dirty pages - then it would be independent of whatever changes we make in
> > ratelimit computations in future. 
> 
> In principle, task_ratelimit has to be 0 when over the global dirty
> limit. But yeah the explicit check sounds more robust. I can add it
> back when doing some more tricky ratelimit calculations (eg. for async
> write IO controller).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
