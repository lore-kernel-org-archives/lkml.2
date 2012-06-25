Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2FYU6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 16:58:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36211 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2FYU57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 16:57:59 -0400
Date: Mon, 25 Jun 2012 22:57:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@redhat.com>,
        Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Message-ID: <20120625205747.GA8101@somewhere>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-12-git-send-email-glommer@parallels.com>
 <4FE89807.50708@redhat.com>
 <20120625183818.GH3869@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625183818.GH3869@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 11:38:18AM -0700, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
> > On 06/25/2012 04:15 PM, Glauber Costa wrote:
> > 
> > > Because those architectures will draw their stacks directly from
> > > the page allocator, rather than the slab cache, we can directly
> > > pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
> > > 
> > > This code path is taken when the architecture doesn't define
> > > CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
> > > THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
> > > remaining architectures fall in this category.
> > > 
> > > This will guarantee that every stack page is accounted to the memcg
> > > the process currently lives on, and will have the allocations to fail
> > > if they go over limit.
> > > 
> > > For the time being, I am defining a new variant of THREADINFO_GFP, not
> > > to mess with the other path. Once the slab is also tracked by memcg,
> > > we can get rid of that flag.
> > > 
> > > Tested to successfully protect against :(){ :|:& };:
> > > 
> > > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > > CC: Christoph Lameter <cl@linux.com>
> > > CC: Pekka Enberg <penberg@cs.helsinki.fi>
> > > CC: Michal Hocko <mhocko@suse.cz>
> > > CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > CC: Johannes Weiner <hannes@cmpxchg.org>
> > > CC: Suleiman Souhlal <suleiman@google.com>
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@redhat.com>
> 
> Frederic, does this (with proper slab accounting added later) achieve
> what you wanted with the task counter?

I think so yeah. Relying on general kernel memory accounting should do
the trick for us. And if we need more finegrained limitation on kernel
stack accounting we can still add it incrementally. But I believe global
limitation can be enough.

Thanks.
