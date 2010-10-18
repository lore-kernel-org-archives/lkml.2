Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0JRWb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:31:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:52701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab0JRWb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:31:56 -0400
Date: Tue, 19 Oct 2010 09:31:42 +1100
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20101019093142.509d6947@notabene>
In-Reply-To: <20101018145859.eee1ae33.akpm@linux-foundation.org>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
	<20100915122334.3fa7b35f@notabene>
	<20100915082843.GA17252@localhost>
	<20100915184434.18e2d933@notabene>
	<20101018151459.2b443221@notabene>
	<20101018161504.GB29500@localhost>
	<20101018145859.eee1ae33.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 14:58:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 19 Oct 2010 00:15:04 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Neil find that if too_many_isolated() returns true while performing
> > direct reclaim we can end up waiting for other threads to complete their
> > direct reclaim.  If those threads are allowed to enter the FS or IO to
> > free memory, but this thread is not, then it is possible that those
> > threads will be waiting on this thread and so we get a circular
> > deadlock.
> > 
> > some task enters direct reclaim with GFP_KERNEL
> >   => too_many_isolated() false
> >     => vmscan and run into dirty pages
> >       => pageout()
> >         => take some FS lock
> > 	  => fs/block code does GFP_NOIO allocation
> > 	    => enter direct reclaim again
> > 	      => too_many_isolated() true
> > 		=> waiting for others to progress, however the other
> > 		   tasks may be circular waiting for the FS lock..
> > 
> > The fix is to let !__GFP_IO and !__GFP_FS direct reclaims enjoy higher
> > priority than normal ones, by honouring them higher throttle threshold.
> > 
> > Now !GFP_IOFS reclaims won't be waiting for GFP_IOFS reclaims to
> > progress. They will be blocked only when there are too many concurrent
> > !GFP_IOFS reclaims, however that's very unlikely because the IO-less
> > direct reclaims is able to progress much more faster, and they won't
> > deadlock each other. The threshold is raised high enough for them, so
> > that there can be sufficient parallel progress of !GFP_IOFS reclaims.
> 
> I'm not sure that this is really a full fix.  Torsten's analysis does
> appear to point at the real bug: raid1 has code paths which allocate
> more than a single element from a mempool without starting IO against
> previous elements.

... point at "a" real bug.

I think there are two bugs here.
The raid1 bug that Torsten mentions is certainly real (and has been around
for an embarrassingly long time).
The bug that I identified in too_many_isolated is also a real bug and can be
triggered without md/raid1 in the mix.
So this is not a 'full fix' for every bug in the kernel :-), but it could
well be a full fix for this particular bug.

NeilBrown

> 
> Giving these allocations the ability to dip further into reserves will
> make occurrence of the bug less likely, but if enough threads all do
> this at the same time, that reserve will be exhausted and we're back to
> square one?
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

