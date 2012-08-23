Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817Ab2HWMPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:15:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566Ab2HWMPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:15:14 -0400
Date: Thu, 23 Aug 2012 09:13:39 -0300
From: Rafael Aquini <aquini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120823121338.GA3062@t510.redhat.com>
References: <20120821172819.GA12294@t510.redhat.com>
 <20120821191330.GA8324@redhat.com>
 <20120821192357.GD12294@t510.redhat.com>
 <20120821193031.GC9027@redhat.com>
 <20120821204556.GF12294@t510.redhat.com>
 <20120822000741.GI9027@redhat.com>
 <20120822011930.GA23753@t510.redhat.com>
 <20120822093317.GC10680@redhat.com>
 <20120823021903.GA23660@x61.redhat.com>
 <20120823100107.GA17409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823100107.GA17409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:01:07PM +0300, Michael S. Tsirkin wrote:
> > So, when remove_common() calls leak_balloon() looping on
> > vb->num_pages, that won't become a tight loop. 
> > The scheme was apparently working before this series, and it will remain working
> > after it.
> 
> It seems that before we would always leak all requested memory
> in one go. I can't tell why we have a while loop there at all.
> Rusty, could you clarify please?
>

It seems that your claim isn't right. leak_balloon() cannot do it all at once,
as for each round it only releases 256 pages, at most; and the 'one go' would
require a couple of loop rounds at remove_common().
So, nothing has changed here.

 
> > Just as before, same thing here. If you leaked less than required, balloon()
> > will keep calling leak_balloon() until the balloon target is reached. This
> > scheme was working before, and it will keep working after this patch.
> >
> 
> IIUC we never hit this path before.
>  
So, how does balloon() works then?


> > > How about we signal config_change
> > > event when pages are back to pages_list?
> > 
> > I really don't know what to tell you here, but, to me, it seems like an
> > overcomplication that isn't directly entangled with this patch purposes.
> > Besides, you cannot expect compation / migration happening and racing against
> > leak_balloon() all the time to make them signal events to the later, so we might
> > just be creating a wait-forever condition for leak_balloon(), IMHO.
> 
> So use wait_event or similar, check for existance of isolated pages.
> 

The thing here is expecting compaction as being an external event to signal
actions to the balloon driver won't work as you desire. Also, as far as the
balloon driver is concerned, it's only a matter of time to accomplish a total,
or partial, balloon leak, even when we have some pages isolated from balloon's
page list.

IMHO, you're attempting to complicate a simple thing that is already working
well. As said before, there are no guarantees you'll have isolated pages 
by the time you're leaking the balloon, so you might leave it waiting forever
on something that will not happen. And if there are isolated pages while balloon
is leaking, they'll have their chance to get back to the list before the device
finishes its leaking job.

