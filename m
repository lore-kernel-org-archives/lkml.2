Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2KHRPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 12:15:40 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:42390 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2KHRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 12:15:37 -0500
Date: Thu, 8 Nov 2012 17:15:36 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
In-Reply-To: <20121107144612.e822986f.akpm@linux-foundation.org>
Message-ID: <0000013ae1050e6f-7f908e0b-720a-4e68-a275-e5086a4f5c74-000000@email.amazonses.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-26-git-send-email-glommer@parallels.com> <20121105164813.2eba5ecb.akpm@linux-foundation.org> <509A0A04.2030503@parallels.com> <20121106231627.3610c908.akpm@linux-foundation.org>
 <509A2849.9090509@parallels.com> <20121107144612.e822986f.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Andrew Morton wrote:

> What's up with kmem_cache_shrink?  It's global and exported to modules
> but its only external caller is some weird and hopelessly poorly
> documented site down in drivers/acpi/osl.c.  slab and slob implement
> kmem_cache_shrink() *only* for acpi!  wtf?  Let's work out what acpi is
> trying to actually do there, then do it properly, then killkillkill!

kmem_cache_shrink is also used internally. Its simply releasing unused
cached objects.

> Secondly, as slab and slub (at least) have the ability to shed cached
> memory, why aren't they hooked into the core cache-shinking machinery.
> After all, it's called "shrink_slab"!

Because the core cache shrinking needs the slab caches to free up memory
from inodes and dentries. We could call kmem_cache_shrink at the end of
the shrink passes in vmscan. The price would be that the caches would have
to be repopulated when new allocations occur.
>
> If we can fix all that up then I wonder whether this particular patch
> needs to exist at all.  If the kmem_cache is no longer used then we
> can simply leave it floating around in memory and the regular cache
> shrinking code out of shrink_slab() will clean up any remaining pages.
> The kmem_cache itself can be reclaimed via another shrinker, if
> necessary?

The kmem_cache can only be released if all its objects (used and unused)
are released.  kmem_cache_shrink drops the unused objects on some internal
slab specific list. That may enable us to release the kmem_cache
structure.

