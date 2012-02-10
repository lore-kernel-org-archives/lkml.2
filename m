Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab2BJQ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab2BJQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:27:07 -0500
Date: Fri, 10 Feb 2012 11:26:58 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20120210162658.GC3150@redhat.com>
References: <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
 <20111223025629.GE12738@redhat.com>
 <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
 <20111227175249.GE17712@google.com>
 <20111228091402.c45a08f6.kamezawa.hiroyu@jp.fujitsu.com>
 <20111228004102.GK17712@google.com>
 <20120105012842.GQ31746@google.com>
 <20120209235845.GH19392@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209235845.GH19392@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 03:58:45PM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> On Wed, Jan 04, 2012 at 05:28:42PM -0800, Tejun Heo wrote:
> > On Tue, Dec 27, 2011 at 04:41:02PM -0800, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Wed, Dec 28, 2011 at 09:14:02AM +0900, KAMEZAWA Hiroyuki wrote:
> > > > > This is essentially more specialized form of the mempool approach.  It
> > > > > doesn't seem any simpler to me while being less generic.  I don't see
> > > > > what the upside would be.
> > > > 
> > > > Hm, but this never causes -ENOMEM error, at all.
> > > 
> > > Ooh, I missed the part it falls back to the global counter if percpu
> > > counters aren't allocated yet.  Yeah, this is an interesting approach.
> > > I'll think more about it.
> > 
> > I've been staring at the blkcg stats code and commit logs and am
> > wondering whether we can just scrap percpu counters there.  It seems
> > the reason why it was introduced in the first place is to avoid
> > stats->lock, which BTW is extremely heavy handed for gathering stats,
> > overhead in fast paths and I think there can be easier ways to avoid
> > stats->lock.
> 
> I could remove stats_lock without much trouble but couldn't get
> blk-throtl fast path stat working. :(
> 
> I think I'll try to get KAMEZAWA's percpu counter working.  Any
> objections?

So IIUC, that patch essentially does the same thing which my patch
was doing for blk-throttle.c and cfq-iosched.c. That is do the allocation
of counters from worker thread and till allocation does not happen we do
not record the stats.

The only difference is that by putting this logic in per cpu counters,
we make it somewhat generic so that other users who can't do GFP_KERNEL
allocation of per cpu data, can use it. I can live with that.

Ideally I would have thought that if passing gfp_flag to alloc_percpu()
is a need, then we need to fix that instead of trying to create generic
infrastructure around that. For the code which is broken currently like
blkcg, we can fix them by doing allocation from worker context so that
this workaround is limited to a specific piece of code and not generic
enough that other subsystems latch on to it.

But if you don't think that fixing alloc_percpu() is possible in long
term and users should use per cpu counters for any kind of non GFP_KERNEL
needs, then it probably is find to continue to develop this patch.

Personally, I liked my old patch of restricting worker thread allocation
logic to blk-throttle.c and cfq-iosched.c. If you don't have objection
to that approach, I can brush it up, fix a pending issue and post it?

Thanks
Vivek
