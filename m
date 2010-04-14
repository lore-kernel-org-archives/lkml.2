Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0DNGwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:52:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36621 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0DNGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:52:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20100413143659.GA2493@dastard>
References: <20100413201635.D119.A69D9226@jp.fujitsu.com> <20100413143659.GA2493@dastard>
Message-Id: <20100414155201.D14A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 14 Apr 2010 15:52:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 13, 2010 at 08:39:29PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > > Pros:
> > > > 	1) prevent XFS stack overflow
> > > > 	2) improve io workload performance
> > > > 
> > > > Cons:
> > > > 	3) TOTALLY kill lumpy reclaim (i.e. high order allocation)
> > > > 
> > > > So, If we only need to consider io workload this is no downside. but
> > > > it can't.
> > > > 
> > > > I think (1) is XFS issue. XFS should care it itself.
> > > 
> > > The filesystem is irrelevant, IMO.
> > > 
> > > The traces from the reporter showed that we've got close to a 2k
> > > stack footprint for memory allocation to direct reclaim and then we
> > > can put the entire writeback path on top of that. This is roughly
> > > 3.5k for XFS, and then depending on the storage subsystem
> > > configuration and transport can be another 2k of stack needed below
> > > XFS.
> > > 
> > > IOWs, if we completely ignore the filesystem stack usage, there's
> > > still up to 4k of stack needed in the direct reclaim path. Given
> > > that one of the stack traces supplied show direct reclaim being
> > > entered with over 3k of stack already used, pretty much any
> > > filesystem is capable of blowing an 8k stack.
> > > 
> > > So, this is not an XFS issue, even though XFS is the first to
> > > uncover it. Don't shoot the messenger....
> > 
> > Thanks explanation. I haven't noticed direct reclaim consume
> > 2k stack. I'll investigate it and try diet it.
> > But XFS 3.5K stack consumption is too large too. please diet too.
> 
> It hasn't grown in the last 2 years after the last major diet where
> all the fat was trimmed from it in the last round of the i386 4k
> stack vs XFS saga. it seems that everything else around XFS has
> grown in that time, and now we are blowing stacks again....

I have dumb question, If xfs haven't bloat stack usage, why 3.5
stack usage works fine on 4k stack kernel? It seems impossible.

Please don't think I blame you. I don't know what is "4k stack vs XFS saga".
I merely want to understand what you said.


> > > Hence I think that direct reclaim should be deferring to the
> > > background flusher threads for cleaning memory and not trying to be
> > > doing it itself.
> > 
> > Well, you seems continue to discuss io workload. I don't disagree
> > such point. 
> > 
> > example, If only order-0 reclaim skip pageout(), we will get the above
> > benefit too.
> 
> But it won't prevent start blowups...
> 
> > > > but we never kill pageout() completely because we can't
> > > > assume users don't run high order allocation workload.
> > > 
> > > I think that lumpy reclaim will still work just fine.
> > > 
> > > Lumpy reclaim appears to be using IO as a method of slowing
> > > down the reclaim cycle - the congestion_wait() call will still
> > > function as it does now if the background flusher threads are active
> > > and causing congestion. I don't see why lumpy reclaim specifically
> > > needs to be issuing IO to make it work - if the congestion_wait() is
> > > not waiting long enough then wait longer - don't issue IO to extend
> > > the wait time.
> > 
> > lumpy reclaim is for allocation high order page. then, it not only
> > reclaim LRU head page, but also its PFN neighborhood. PFN neighborhood
> > is often newly page and still dirty. then we enfoce pageout cleaning
> > and discard it.
> 
> Ok, I see that now - I missed the second call to __isolate_lru_pages()
> in isolate_lru_pages().

No problem. It's one of VM mess. Usual developers don't know it :-)



> > When high order allocation occur, we don't only need free enough amount
> > memory, but also need free enough contenious memory block.
> 
> Agreed, that was why I was kind of surprised not to find it was
> doing that. But, as you have pointed out, that was my mistake.
> 
> > If we need to consider _only_ io throughput, waiting flusher thread
> > might faster perhaps, but actually we also need to consider reclaim
> > latency. I'm worry about such point too.
> 
> True, but without know how to test and measure such things I can't
> really comment...

Agreed. I know making VM mesurement benchmark is very difficult. but
probably it is necessary....
I'm sorry, now I can't give you good convenient benchmark.

> 
> > > Of course, the code is a maze of twisty passages, so I probably
> > > missed something important. Hopefully someone can tell me what. ;)
> > > 
> > > FWIW, the biggest problem here is that I have absolutely no clue on
> > > how to test what the impact on lumpy reclaim really is. Does anyone
> > > have a relatively simple test that can be run to determine what the
> > > impact is?
> > 
> > So, can you please run two workloads concurrently?
> >  - Normal IO workload (fio, iozone, etc..)
> >  - echo $NUM > /proc/sys/vm/nr_hugepages
> 
> What do I measure/observe/record that is meaningful?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



