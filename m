Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2CLMkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:40:01 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49270 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab2CLMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:39:59 -0400
Message-ID: <4F5DEE42.6050607@parallels.com>
Date: Mon, 12 Mar 2012 16:38:26 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suleiman Souhlal <ssouhlal@FreeBSD.org>
CC: <cgroups@vger.kernel.org>, <suleiman@google.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <penberg@kernel.org>, <cl@linux.com>,
        <yinghan@google.com>, <hughd@google.com>, <gthelen@google.com>,
        <peterz@infradead.org>, <dan.magenheimer@oracle.com>,
        <hannes@cmpxchg.org>, <mgorman@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>
In-Reply-To: <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +int
> +memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, long long delta)
> +{
> +	struct res_counter *fail_res;
> +	struct mem_cgroup *_memcg;
> +	int may_oom, ret;
> +
> +	may_oom = (gfp&  __GFP_WAIT)&&  (gfp&  __GFP_FS)&&
> +	    !(gfp&  __GFP_NORETRY);
> +
> +	ret = 0;
> +
> +	_memcg = memcg;
> +	if (memcg&&  !mem_cgroup_test_flag(memcg,
> +	    MEMCG_INDEPENDENT_KMEM_LIMIT)) {
> +		ret = __mem_cgroup_try_charge(NULL, gfp, delta / PAGE_SIZE,
> +		&_memcg, may_oom);
> +		if (ret == -ENOMEM)
> +			return ret;
> +	}
> +
> +	if (memcg&&  _memcg == memcg)
> +		ret = res_counter_charge(&memcg->kmem, delta,&fail_res);
> +
> +	return ret;
> +}
> +
> +void
Ok.

So I've spent most of the day today trying to come up with a way not to 
kill the whole performance we gain from consume_stock() by this 
res_counter_charge() to kmem afterwards...

You mentioned you want to still be able to bill to memcg->kmem mostly 
for debugging/display purposes. So we're surely not using all of the 
res_counter infrastructure (limiting, soft limits, etc)

I was thinking: Can't we have a percpu_counter that we use for this 
purpose when !kmem_independent ?

we may not even need to bloat the struct, since we can fold it into a 
union with struct res_counter kmem (which is bigger than a percpu 
counter anyway).

We just need to be a bit more careful not to allow kmem_independent to 
change when we already have charges to any of them (but we need to do it 
anyway)


