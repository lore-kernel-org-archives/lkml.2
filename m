Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab2IXR6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:58:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2IXR6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:58:06 -0400
Date: Mon, 24 Sep 2012 10:58:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/16] memcg: infrastructure to match an allocation
 to the right cache
Message-ID: <20120924175801.GE7694@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-7-git-send-email-glommer@parallels.com>
 <20120921205236.GT7264@google.com>
 <50601721.6040805@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50601721.6040805@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 12:17:37PM +0400, Glauber Costa wrote:
> On 09/22/2012 12:52 AM, Tejun Heo wrote:
> > Missed some stuff.
> > 
> > On Tue, Sep 18, 2012 at 06:12:00PM +0400, Glauber Costa wrote:
> >> +static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
> >> +						  struct kmem_cache *cachep)
> >> +{
> > ...
> >> +	memcg->slabs[idx] = new_cachep;
> > ...
> >> +struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
> >> +					  gfp_t gfp)
> >> +{
> > ...
> >> +	return memcg->slabs[idx];
> > 
> > I think you need memory barriers for the above pair.
> > 
> > Thanks.
> > 
> 
> Why is that?
> 
> We'll either see a value, or NULL. If we see NULL, we assume the cache
> is not yet created. Not a big deal.

Because when you see !NULL cache pointer you want to be able to see
the cache fully initialized.  You need wmb between cache creation and
pointer assignment and at least read_barrier_depends() between
fetching the cache pointer and dereferencing it.

Thanks.

-- 
tejun
