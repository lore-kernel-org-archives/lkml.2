Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2B1Bo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:44:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49723 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2B1Bo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:44:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 28 Feb 2012 10:43:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 19/21] memcg: check lru vectors emptiness in
 pre-destroy
Message-Id: <20120228104331.37f9bcfd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120223135319.12988.73209.stgit@zurg>
References: <20120223133728.12988.5432.stgit@zurg>
	<20120223135319.12988.73209.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 17:53:19 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> We must abort cgroup destroying if it still not empty,
> resource counter cannot catch isolated uncharged pages.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

I like this. 
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtisu.com>

> ---
>  mm/memcontrol.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4de8044..fbeff85 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4859,8 +4859,16 @@ free_out:
>  static int mem_cgroup_pre_destroy(struct cgroup *cont)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> +	int ret;
> +
> +	ret = mem_cgroup_force_empty(memcg, false);
> +	if (ret)
> +		return ret;
>  
> -	return mem_cgroup_force_empty(memcg, false);
> +	if (mem_cgroup_nr_lru_pages(memcg, -1))
> +		return -EBUSY;
> +
> +	return 0;
>  }
>  
>  static void mem_cgroup_destroy(struct cgroup *cont)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

