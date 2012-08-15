Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2HOLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:16:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33085 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2HOLQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:16:57 -0400
Date: Wed, 15 Aug 2012 12:16:51 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120815111651.GL4052@csn.ul.ie>
References: <cover.1344619987.git.aquini@redhat.com>
 <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com>
 <20120813084123.GF14081@redhat.com>
 <20120814182244.GB13338@t510.redhat.com>
 <20120814195139.GA28870@redhat.com>
 <20120814201113.GE22133@t510.redhat.com>
 <20120815090528.GH4052@csn.ul.ie>
 <20120815092528.GA29214@redhat.com>
 <20120815094839.GJ4052@csn.ul.ie>
 <20120815100108.GA1999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120815100108.GA1999@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:01:08PM +0300, Michael S. Tsirkin wrote:
> On Wed, Aug 15, 2012 at 10:48:39AM +0100, Mel Gorman wrote:
> > On Wed, Aug 15, 2012 at 12:25:28PM +0300, Michael S. Tsirkin wrote:
> > > On Wed, Aug 15, 2012 at 10:05:28AM +0100, Mel Gorman wrote:
> > > > On Tue, Aug 14, 2012 at 05:11:13PM -0300, Rafael Aquini wrote:
> > > > > On Tue, Aug 14, 2012 at 10:51:39PM +0300, Michael S. Tsirkin wrote:
> > > > > > What I think you should do is use rcu for access.
> > > > > > And here sync rcu before freeing.
> > > > > > Maybe an overkill but at least a documented synchronization
> > > > > > primitive, and it is very light weight.
> > > > > > 
> > > > > 
> > > > > I liked your suggestion on barriers, as well.
> > > > > 
> > > > 
> > > > I have not thought about this as deeply as I shouold but is simply rechecking
> > > > the mapping under the pages_lock to make sure the page is still a balloon
> > > > page an option? i.e. use pages_lock to stabilise page->mapping.
> > > 
> > > To clarify, are you concerned about cost of rcu_read_lock
> > > for non balloon pages?
> > > 
> > 
> > Not as such, but given the choice between introducing RCU locking and
> > rechecking page->mapping under a spinlock I would choose the latter as it
> > is more straight-forward.
> 
> OK but checking it how? page->mapping == balloon_mapping does not scale to
> multiple balloons,

I was thinking of exactly that page->mapping == balloon_mapping check. As I
do not know how many active balloon drivers there might be I cannot guess
in advance how much of a scalability problem it will be.

> so I hoped we can switch to
> page->mapping->flags & BALLOON_MAPPING or some such,
> but this means we dereference it outside the lock ...
> 

That also sounded like future stuff to me that would be justified with
profiling if necessary. Personally I would have started with the spinlock
and a simple check and moved to RCU later when either scalability was a
problem or it was found there was a need to stabilise whether a page was
a balloon page or not outside a spinlock.

This is not a NAK to the idea and I'm not objecting to RCU being used now
if that is what is really desired. I just suspect it's making the series
more complex than it needs to be right now.

-- 
Mel Gorman
SUSE Labs
