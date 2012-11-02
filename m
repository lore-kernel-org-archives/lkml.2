Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537Ab2KBAFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 20:05:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762520Ab2KBAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 20:05:50 -0400
Date: Thu, 1 Nov 2012 17:05:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v6 23/29] memcg: destroy memcg caches
Message-Id: <20121101170548.86e0c7e5.akpm@linux-foundation.org>
In-Reply-To: <1351771665-11076-24-git-send-email-glommer@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<1351771665-11076-24-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 16:07:39 +0400
Glauber Costa <glommer@parallels.com> wrote:

> This patch implements destruction of memcg caches. Right now,
> only caches where our reference counter is the last remaining are
> deleted. If there are any other reference counters around, we just
> leave the caches lying around until they go away.
> 
> When that happen, a destruction function is called from the cache
> code. Caches are only destroyed in process context, so we queue them
> up for later processing in the general case.
> 
>
> ...
>
> @@ -5950,6 +6012,7 @@ static int mem_cgroup_pre_destroy(struct cgroup *cont)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  
> +	mem_cgroup_destroy_all_caches(memcg);
>  	return mem_cgroup_force_empty(memcg, false);
>  }
>  

Conflicts with linux-next cgroup changes.  Looks pretty simple:


static int mem_cgroup_pre_destroy(struct cgroup *cont)
{
	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
	int ret;

	css_get(&memcg->css);
	ret = mem_cgroup_reparent_charges(memcg);
	mem_cgroup_destroy_all_caches(memcg);
	css_put(&memcg->css);

	return ret;
}

