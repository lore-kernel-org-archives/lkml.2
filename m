Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2E3PdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:33:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44842 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2E3PdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:33:07 -0400
Date: Wed, 30 May 2012 17:33:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Message-ID: <20120530153256.GA27008@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
 <20120530130416.GD25094@somewhere.redhat.com>
 <4FC61B4E.2060206@parallels.com>
 <20120530133736.GF25094@somewhere.redhat.com>
 <4FC622B5.9080600@parallels.com>
 <20120530135319.GG25094@somewhere.redhat.com>
 <4FC626DA.3030408@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC626DA.3030408@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:55:38PM +0400, Glauber Costa wrote:
> On 05/30/2012 05:53 PM, Frederic Weisbecker wrote:
> >On Wed, May 30, 2012 at 05:37:57PM +0400, Glauber Costa wrote:
> >>On 05/30/2012 05:37 PM, Frederic Weisbecker wrote:
> >>>Right. __mem_cgroup_get_kmem_cache() fetches the memcg of the owner
> >>>and calls memcg_create_cache_enqueue() which does css_tryget(&memcg->css).
> >>>After this tryget I think you're fine. And in-between you're safe against
> >>>css_set removal due to rcu_read_lock().
> >>>
> >>>I'm less clear with __mem_cgroup_new_kmem_page() though...
> >>
> >>That one does not get memcg->css but it does call mem_cgroup_get(),
> >>that does prevent against the memcg structure being freed, which I
> >>believe to be good enough.
> >
> >What if the owner calls cgroup_exit() between mem_cgroup_from_task()
> >and mem_cgroup_get()? The css_set which contains the memcg gets freed.
> >Also the reference on the memcg doesn't even prevent the css_set to
> >be removed, does it?
> It doesn't, but we don't really care. The css can go away, if the
> memcg structure stays.

Ah right, the memcg itself is only freed at destroy time.

> The caches will outlive the memcg anyway,
> since it is possible that you delete it, with some caches still
> holding objects that
> are not freed (they will be marked as dead).

I guess I need to look at how the destroy path is handled in your patchset
then. Or how you ensure that __mem_cgroup_new_kmem_page() can't race against
destroy.
