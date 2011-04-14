Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1DNKga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:36:30 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:35432 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758701Ab1DNKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:36:29 -0400
Subject: Re: [PATCH 4/4] writeback: reduce per-bdi dirty threshold ramp up
 time
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20110414002301.GA9826@localhost>
References: <20110413085937.981293444@intel.com>
	 <20110413090415.763161169@intel.com> <20110413220444.GF4648@quack.suse.cz>
	 <20110413233122.GA6097@localhost> <20110413235211.GN31057@dastard>
	 <20110414002301.GA9826@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 11:36:22 +0100
Message-ID: <1302777382.1994.24.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 08:23 +0800, Wu Fengguang wrote:
> On Thu, Apr 14, 2011 at 07:52:11AM +0800, Dave Chinner wrote:
> > On Thu, Apr 14, 2011 at 07:31:22AM +0800, Wu Fengguang wrote:
> > > On Thu, Apr 14, 2011 at 06:04:44AM +0800, Jan Kara wrote:
> > > > On Wed 13-04-11 16:59:41, Wu Fengguang wrote:
> > > > > Reduce the dampening for the control system, yielding faster
> > > > > convergence. The change is a bit conservative, as smaller values may
> > > > > lead to noticeable bdi threshold fluctuates in low memory JBOD setup.
> > > > > 
> > > > > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > CC: Richard Kennedy <richard@rsk.demon.co.uk>
> > > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > >   Well, I have nothing against this change as such but what I don't like is
> > > > that it just changes magical +2 for similarly magical +0. It's clear that
> > > 
> > > The patch tends to make the rampup time a bit more reasonable for
> > > common desktops. From 100s to 25s (see below).
> > > 
> > > > this will lead to more rapid updates of proportions of bdi's share of
> > > > writeback and thread's share of dirtying but why +0? Why not +1 or -1? So
> > > 
> > > Yes, it will especially be a problem on _small memory_ JBOD setups.
> > > Richard actually has requested for a much radical change (decrease by
> > > 6) but that looks too much.
> > > 
> > > My team has a 12-disk JBOD with only 6G memory. The memory is pretty
> > > small as a server, but it's a real setup and serves well as the
> > > reference minimal setup that Linux should be able to run well on.
> > 
> > FWIW, linux runs on a lot of low power NAS boxes with jbod and/or
> > raid setups that have <= 1GB of RAM (many of them run XFS), so even
> > your setup could be considered large by a significant fraction of
> > the storage world. Hence you need to be careful of optimising for
> > what you think is a "normal" server, because there simply isn't such
> > a thing....
> 
> Good point! This patch is likely to hurt a loaded 1GB 4-disk NAS box...
> I'll test the setup.
> 
> I did test low memory setups -- but only on simple 1-disk cases.
> 
> For example, when dirty thresh is lowered to 7MB, the dirty pages are
> fluctuating like mad within the controlled scope:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-pages.png
> 
> But still, it achieves 100% disk utilization
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/iostat-util.png
> 
> and good IO throughput:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-bandwidth.png
> 
> And even better, less than 120ms writeback latencies:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-pause.png
> 
> Thanks,
> Fengguang
> 

I'm only testing on a desktop with 2 drives. I use a simple test to
write 2gb to sda then 2gb to sdb while recording the threshold values.
On 2.6.39-rc3, after the 2nd write starts it take approx 90 seconds for
sda's threshold value to drop from its maximum to minimum and sdb's to
rise from min to max. So this seems much too slow for normal desktop
workloads. 

I haven't tested with this patch on 2.6.39-rc3 yet, but I'm just about
to set that up. 

I know it's difficult to pick one magic number to fit every case, but I
don't see any easy way to make this more adaptive. We could make this
calculation take account of more things, but I don't know what.


Nice graphs :) BTW do you know what's causing that 10 second (1/10 Hz)
fluctuation in write bandwidth? and does this change effect that in any
way?   

regards
Richard


