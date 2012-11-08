Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2KHTVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 14:21:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab2KHTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 14:21:22 -0500
Date: Thu, 8 Nov 2012 11:21:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
Message-Id: <20121108112120.fc964c29.akpm@linux-foundation.org>
In-Reply-To: <0000013ae1050e6f-7f908e0b-720a-4e68-a275-e5086a4f5c74-000000@email.amazonses.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-26-git-send-email-glommer@parallels.com>
	<20121105164813.2eba5ecb.akpm@linux-foundation.org>
	<509A0A04.2030503@parallels.com>
	<20121106231627.3610c908.akpm@linux-foundation.org>
	<509A2849.9090509@parallels.com>
	<20121107144612.e822986f.akpm@linux-foundation.org>
	<0000013ae1050e6f-7f908e0b-720a-4e68-a275-e5086a4f5c74-000000@email.amazonses.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012 17:15:36 +0000
Christoph Lameter <cl@linux.com> wrote:

> On Wed, 7 Nov 2012, Andrew Morton wrote:
> 
> > What's up with kmem_cache_shrink?  It's global and exported to modules
> > but its only external caller is some weird and hopelessly poorly
> > documented site down in drivers/acpi/osl.c.  slab and slob implement
> > kmem_cache_shrink() *only* for acpi!  wtf?  Let's work out what acpi is
> > trying to actually do there, then do it properly, then killkillkill!
> 
> kmem_cache_shrink is also used internally. Its simply releasing unused
> cached objects.

Only in slub.  It could be removed outright from the others and
simplified in slub.

> > Secondly, as slab and slub (at least) have the ability to shed cached
> > memory, why aren't they hooked into the core cache-shinking machinery.
> > After all, it's called "shrink_slab"!
> 
> Because the core cache shrinking needs the slab caches to free up memory
> from inodes and dentries. We could call kmem_cache_shrink at the end of
> the shrink passes in vmscan. The price would be that the caches would have
> to be repopulated when new allocations occur.

Well, the shrinker shouldn't strips away all the cache.  It will perform
a partial trim, the magnitude of which increases with perceived
external memory pressure.

AFACIT, this is correct and desirable behaviour for shrinking
slab's internal caches.

> >
> > If we can fix all that up then I wonder whether this particular patch
> > needs to exist at all.  If the kmem_cache is no longer used then we
> > can simply leave it floating around in memory and the regular cache
> > shrinking code out of shrink_slab() will clean up any remaining pages.
> > The kmem_cache itself can be reclaimed via another shrinker, if
> > necessary?
> 
> The kmem_cache can only be released if all its objects (used and unused)
> are released.  kmem_cache_shrink drops the unused objects on some internal
> slab specific list. That may enable us to release the kmem_cache
> structure.
