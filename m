Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab2CEAVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:21:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38685 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2CEAVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:21:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Mar 2012 09:19:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC] memcg usage_in_bytes does not account file mapped and
 slab memory
Message-Id: <20120305091934.588c160b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120302162753.GA11748@oksana.dev.rtsoft.ru>
References: <20120302162753.GA11748@oksana.dev.rtsoft.ru>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 20:27:53 +0400
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> ... and thus is useless for low memory notifications.
> 
> Hi all!
> 
> While working on userspace low memory killer daemon (a supposed
> substitution for the kernel low memory killer, i.e.
> drivers/staging/android/lowmemorykiller.c), I noticed that current
> cgroups memory notifications aren't suitable for such a daemon.
> 
> Suppose we want to install a notification when free memory drops below
> 8 MB. Logically (taking memory hotplug aside), using current usage_in_bytes
> notifications we would install an event on 'total_ram - 8MB' threshold.
> 
> But as usage_in_bytes doesn't account file mapped memory and memory
> used by kernel slab, the formula won't work.
> 
> Currently I use the following patch that makes things going:
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 228d646..c8abdc5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3812,6 +3812,9 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>  
>         val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
>         val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
> +       val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
> +       val += global_page_state(NR_SLAB_RECLAIMABLE);
> +       val += global_page_state(NR_SLAB_UNRECLAIMABLE);
> 
> 
> But here are some questions:
> 
> 1. Is there any particular reason we don't currently account file mapped
>    memory in usage_in_bytes?
> 

CACHE includes all file caches. Why do you think FILE_MAPPED is not included in CACHE ?


>    To me, MEM_CGROUP_STAT_FILE_MAPPED hunk seems logical even if we
>    don't use it for lowmemory notifications.
> 
>    Plus, it seems that FILE_MAPPED _is_ accounted for the non-root
>    cgroups, so I guess it's clearly a bug for the root memcg?
> 
> 2. As for NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE, it seems that
>    these numbers are only applicable for the root memcg.
>    I'm not sure that usage_in_bytes semantics should actually account
>    these, but I tend to think that we should.
> 

Now, SLAB is not accounted by memcg at all.
See memifo if necessary.

> All in all, not accounting both 1. and 2. looks like bugs to me.
> 

It's spec. not bug. If you want to see slab status in memcg's file,
Please add kernel memory accounting feature. There has been already 2 proposals.
Check them and comment.

Thanks,
-Kame

