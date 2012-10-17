Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2JQX2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:28:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2JQX2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:28:41 -0400
Date: Wed, 17 Oct 2012 16:28:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 09/14] memcg: kmem accounting lifecycle management
In-Reply-To: <1350382611-20579-10-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-10-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Glauber Costa wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1182188..e24b388 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -344,6 +344,7 @@ struct mem_cgroup {
>  /* internal only representation about the status of kmem accounting. */
>  enum {
>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
> +	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */

"dead memcg with pending kmem charges" seems better.

>  };
>  
>  #define KMEM_ACCOUNTED_MASK (1 << KMEM_ACCOUNTED_ACTIVE)
> @@ -353,6 +354,22 @@ static void memcg_kmem_set_active(struct mem_cgroup *memcg)
>  {
>  	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
>  }
> +
> +static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
> +{
> +	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
> +}

I think all of these should be inline.

> +
> +static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
> +{
> +	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted))
> +		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_accounted);
> +}

The set_bit() doesn't happen atomically with the test_bit(), what 
synchronization is required for this?
