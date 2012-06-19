Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2FSX6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:58:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2FSX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:58:16 -0400
Date: Tue, 19 Jun 2012 16:58:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] memcg: clean up force_empty_list() return value
 check
Message-Id: <20120619165815.5ce24be7.akpm@linux-foundation.org>
In-Reply-To: <4FDF1830.1000504@jp.fujitsu.com>
References: <4FDF17A3.9060202@jp.fujitsu.com>
	<4FDF1830.1000504@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 20:59:44 +0900
Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> By commit "memcg: move charges to root cgroup if use_hierarchy=0"
> mem_cgroup_move_parent() only returns -EBUSY, -EINVAL.
> So, we can remove -ENOMEM and -EINTR checks.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cf8a0f6..726b7c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3847,8 +3847,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  		pc = lookup_page_cgroup(page);
>  
>  		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
> -		if (ret == -ENOMEM || ret == -EINTR)
> -			break;
>  
>  		if (ret == -EBUSY || ret == -EINVAL) {

This looks a bit fragile - if mem_cgroup_move_parent() is later changed
(intentionally or otherwise!) to return -Esomethingelse then
mem_cgroup_force_empty_list() will subtly break.  Why not just do

		if (ret < 0)

here?


