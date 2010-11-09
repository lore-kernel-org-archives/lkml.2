Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0KIUBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:01:25 -0500
Received: from smtp-out.google.com ([74.125.121.35]:13508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0KIUBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:01:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=mN/KgKhfFoSXVuoagh9h4ytRSeOKiB+qZmnb/V7n/BzOaC6JRcoQ8EPh7GA21HwOK
	Db9nmhb6XVm28nty2xcRA==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: fix unit mismatch in memcg oom limit calculation
References: <20101109110521.GS23393@cmpxchg.org>
Date: Tue, 09 Nov 2010 12:00:26 -0800
Message-ID: <xr93iq068dyd.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> Adding the number of swap pages to the byte limit of a memory control
> group makes no sense.  Convert the pages to bytes before adding them.
>
> The only user of this code is the OOM killer, and the way it is used
> means that the error results in a higher OOM badness value.  Since the
> cgroup limit is the same for all tasks in the cgroup, the error should
> have no practical impact at the moment.
>
> But let's not wait for future or changing users to trip over it.

Thanks for the fix.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Greg Thelen <gthelen@google.com>

> ---
>  mm/memcontrol.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1552,8 +1552,9 @@ u64 mem_cgroup_get_limit(struct mem_cgro
>  	u64 limit;
>  	u64 memsw;
>  
> -	limit = res_counter_read_u64(&memcg->res, RES_LIMIT) +
> -			total_swap_pages;
> +	limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
> +	limit += total_swap_pages << PAGE_SHIFT;
> +
>  	memsw = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
>  	/*
>  	 * If memsw is finite and limits the amount of swap space available
