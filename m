Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2KFAXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:23:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2KFAXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:23:31 -0500
Date: Mon, 5 Nov 2012 16:23:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 18/29] Allocate memory for memcg caches whenever a
 new memcg appears
Message-Id: <20121105162330.4aa629f8.akpm@linux-foundation.org>
In-Reply-To: <1351771665-11076-19-git-send-email-glommer@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-19-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 16:07:34 +0400
Glauber Costa <glommer@parallels.com> wrote:

> Every cache that is considered a root cache (basically the "original" caches,
> tied to the root memcg/no-memcg) will have an array that should be large enough
> to store a cache pointer per each memcg in the system.
> 
> Theoreticaly, this is as high as 1 << sizeof(css_id), which is currently in the
> 64k pointers range. Most of the time, we won't be using that much.
> 
> What goes in this patch, is a simple scheme to dynamically allocate such an
> array, in order to minimize memory usage for memcg caches. Because we would
> also like to avoid allocations all the time, at least for now, the array will
> only grow. It will tend to be big enough to hold the maximum number of
> kmem-limited memcgs ever achieved.
> 
> We'll allocate it to be a minimum of 64 kmem-limited memcgs. When we have more
> than that, we'll start doubling the size of this array every time the limit is
> reached.
> 
> Because we are only considering kmem limited memcgs, a natural point for this
> to happen is when we write to the limit. At that point, we already have
> set_limit_mutex held, so that will become our natural synchronization
> mechanism.
> 
> ...
>
> +static struct ida kmem_limited_groups;

Could use DEFINE_IDA() here

>
> ...
>
>  static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  {
> +	int ret;
> +
>  	memcg->kmemcg_id = -1;
> -	memcg_propagate_kmem(memcg);
> +	ret = memcg_propagate_kmem(memcg);
> +	if (ret)
> +		return ret;
> +
> +	if (mem_cgroup_is_root(memcg))
> +		ida_init(&kmem_limited_groups);

and zap this?
