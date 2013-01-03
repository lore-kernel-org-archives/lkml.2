Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3ACWeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 17:34:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29391 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3ACWeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 17:34:15 -0500
MIME-Version: 1.0
Message-ID: <640d712e-0217-456a-a2d1-d03dd7914a55@default>
Date: Thu, 3 Jan 2013 14:33:09 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: RE: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>>
 <0e91c1e5-7a62-4b89-9473-09fff384a334@default>
 <50E32255.60901@linux.vnet.ibm.com>
 <26bb76b3-308e-404f-b2bf-3d19b28b393a@default>
 <50E4C1FA.4070701@linux.vnet.ibm.com>
In-Reply-To: <50E4C1FA.4070701@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH 7/8] zswap: add to mm/
> 
> >> What I'm looking to do is give zswap a little insight into zsmalloc
> >> internals,
> 
> I'm putting at lot of thought into how to do it cleanly, while
> maintaining the generic nature of zsmalloc.  I did a PoC already, but
> I wasn't comfortable with how much had to be exposed to achieve it.
> So I'm still working on it.

Zbud exposes LRU-ness as well... why not also do that
for zsmalloc?  I guess I am asking, as long as you are doing
a "new API" for zsmalloc that zram doesn't benefit from, why not
eliminate the abstraction layer and consider your "zsmalloc2" to
be a captive allocator, like zbud?  What's the point of limiting
"how much had to be exposed" unless you are certain that other
kernel-internal-users will benefit?
 
> > I fear that problem (B) is the fundamental concern with
> > using a high-density storage allocator such as zsmalloc, which
> > is why I abandoned zsmalloc in favor of a more-predictable-but-
> > less-dense allocator (zbud).  However, if you have a solution
> > for (B) as well, I would gladly abandon zbud in zcache (for _both_
> > cleancache and frontswap pages) and our respective in-kernel
> > compression efforts would be more easy to merge into one solution
> > in the future.
> 
> The only difference afaict between zbud and zsmalloc wrt vacating a
> page frame is that zbud will only ever need to write back two pages to
> swap where zsmalloc might have to write back more to free up the
> zspage that contains the page frame to be vacated.  This is doable
> with zsmalloc.  The question that remains for me is how cleanly can it
> be done (for either approach).

One other major difference is that zpages in zsmalloc can cross pageframe
boundaries.  I don't understand zsmalloc well enough to estimate
how frequently this is true, but it is does complicate the set of
race conditions.

Also, unless I misunderstand, ensuring a pageframe can be freed
will require you to somehow "lock" all the zpages and remove
them atomically.  At least, that's what was required for zbud
to avoid races.  If this is true, increasing the number of zpages
to be freed would have a significant impact.

You may have a way around this... I'm just cautioning.

> > Hmmm... IIRC, to avoid races in zcache, it was necessary to
> > update both the data (zpage) and meta-data ("tree" in zswap,
> > and tmem-data-structure in zcache) atomically.  I will need
> > to study your code more to understand how zswap avoids this
> > requirement.  Or if it is obvious to you, I would be grateful
> > if you would point it out to me.
> 
> Without the flushing mechanism, a simple lock guarding the tree was
> enough in zswap.  The per-entry serialization of the
> store/load/invalidate paths are all handled at a higher level.  For
> example, we never get a load and invalidate concurrently on the same
> swap entry.
> 
> However, once the flushing code was introduced and could free an entry
> from the zswap_fs_store() path, it became necessary to add a per-entry
> refcount to make sure that the entry isn't freed while another code
> path was operating on it.

Hmmm... doesn't the refcount at least need to be an atomic_t?

Also, how can you "free" any entry of an rbtree while another
thread is walking the rbtree?  (Deleting an entry from an rbtree
causes rebalancing... afaik there is no equivalent RCU
implementation for rbtrees... not that RCU would necessarily
work well for this anyway.)

BTW, in case it appears otherwise, I'm trying to be helpful, not
critical.  In the end, I think we are in agreement that in-kernel
compression is very important and that the frontswap (and/or
cleancache) interface(s) are the right way to identify compressible
data, and we are mostly arguing allocation and implementation details.

Dan
