Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2KGHN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2KGHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:13:56 -0500
Date: Tue, 6 Nov 2012 23:13:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>, JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v6 19/29] memcg: infrastructure to match an allocation
 to the right cache
Message-Id: <20121106231353.0585f39d.akpm@linux-foundation.org>
In-Reply-To: <509A07E3.5090700@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-20-git-send-email-glommer@parallels.com>
	<20121105162837.5fdac20c.akpm@linux-foundation.org>
	<509A07E3.5090700@parallels.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012 08:04:03 +0100 Glauber Costa <glommer@parallels.com> wrote:

> On 11/06/2012 01:28 AM, Andrew Morton wrote:
> > On Thu,  1 Nov 2012 16:07:35 +0400
> > Glauber Costa <glommer@parallels.com> wrote:
> > 
> >> +static __always_inline struct kmem_cache *
> >> +memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
> > 
> > I still don't understand why this code uses __always_inline so much.
> > 
> > I don't recall seeing the compiler producing out-of-line versions of
> > "static inline" functions (and perhaps it has special treatment for
> > functions which were defined in a header file?).
> > 
> > And if the compiler *does* decide to uninline the function, perhaps it
> > knows best, and the function shouldn't have been declared inline in the
> > first place.
> > 
> > 
> > If it is indeed better to use __always_inline in this code then we have
> > a heck of a lot of other "static inline" definitions whcih we need to
> > convert!  So, what's going on here?
> > 
> 
> The original motivation is indeed performance related. We want to make
> sure it is inline so it will figure out quickly the "I am not a memcg
> user" case and keep it going. The slub, for instance, is full of
> __always_inline functions to make sure that the fast path contains
> absolutely no function calls. So I was just following this here.

Well.  Do we really know that inlining is best in all these cases?  And
in future, as the code evolves?  If for some reason the compiler
chooses not to inline the function, maybe it was right.  Small code
footprint has benefits.

> I can remove the marker without a problem and leave it to the compiler
> if you think it is best

It's a minor thing.  But __always_inline is rather specialised and
readers of this code will be wondering why it was done here.  Unless we
can actually demonstrate benefit from __always_inline, I'd suggest
following convention here.

