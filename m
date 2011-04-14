Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1DNAXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:23:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:45201 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab1DNAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:23:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,207,1301900400"; 
   d="scan'208";a="733054204"
Date: Thu, 14 Apr 2011 08:23:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] writeback: reduce per-bdi dirty threshold ramp up
 time
Message-ID: <20110414002301.GA9826@localhost>
References: <20110413085937.981293444@intel.com>
 <20110413090415.763161169@intel.com>
 <20110413220444.GF4648@quack.suse.cz>
 <20110413233122.GA6097@localhost>
 <20110413235211.GN31057@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413235211.GN31057@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 07:52:11AM +0800, Dave Chinner wrote:
> On Thu, Apr 14, 2011 at 07:31:22AM +0800, Wu Fengguang wrote:
> > On Thu, Apr 14, 2011 at 06:04:44AM +0800, Jan Kara wrote:
> > > On Wed 13-04-11 16:59:41, Wu Fengguang wrote:
> > > > Reduce the dampening for the control system, yielding faster
> > > > convergence. The change is a bit conservative, as smaller values may
> > > > lead to noticeable bdi threshold fluctuates in low memory JBOD setup.
> > > > 
> > > > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > CC: Richard Kennedy <richard@rsk.demon.co.uk>
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > >   Well, I have nothing against this change as such but what I don't like is
> > > that it just changes magical +2 for similarly magical +0. It's clear that
> > 
> > The patch tends to make the rampup time a bit more reasonable for
> > common desktops. From 100s to 25s (see below).
> > 
> > > this will lead to more rapid updates of proportions of bdi's share of
> > > writeback and thread's share of dirtying but why +0? Why not +1 or -1? So
> > 
> > Yes, it will especially be a problem on _small memory_ JBOD setups.
> > Richard actually has requested for a much radical change (decrease by
> > 6) but that looks too much.
> > 
> > My team has a 12-disk JBOD with only 6G memory. The memory is pretty
> > small as a server, but it's a real setup and serves well as the
> > reference minimal setup that Linux should be able to run well on.
> 
> FWIW, linux runs on a lot of low power NAS boxes with jbod and/or
> raid setups that have <= 1GB of RAM (many of them run XFS), so even
> your setup could be considered large by a significant fraction of
> the storage world. Hence you need to be careful of optimising for
> what you think is a "normal" server, because there simply isn't such
> a thing....

Good point! This patch is likely to hurt a loaded 1GB 4-disk NAS box...
I'll test the setup.

I did test low memory setups -- but only on simple 1-disk cases.

For example, when dirty thresh is lowered to 7MB, the dirty pages are
fluctuating like mad within the controlled scope:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-pages.png

But still, it achieves 100% disk utilization

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/iostat-util.png

and good IO throughput:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-bandwidth.png

And even better, less than 120ms writeback latencies:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/512M-2%25/xfs-4dd-1M-8p-435M-2%25-2.6.38-rc5-dt6+-2011-02-22-14-34/balance_dirty_pages-pause.png

Thanks,
Fengguang

