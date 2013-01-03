Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3ACUYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:24:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3ACUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:24:06 -0500
Date: Thu, 3 Jan 2013 12:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <htejun@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH -repost] memcg,vmscan: do not break out targeted reclaim
 without reclaimed pages
Message-Id: <20130103122404.033eeb20.akpm@linux-foundation.org>
In-Reply-To: <20130103180901.GA22067@dhcp22.suse.cz>
References: <20130103180901.GA22067@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2013 19:09:01 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Hi,
> I have posted this quite some time ago
> (https://lkml.org/lkml/2012/12/14/102) but it probably slipped through
> ---
> >From 28b4e10bc3c18b82bee695b76f4bf25c03baa5f8 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 14 Dec 2012 11:12:43 +0100
> Subject: [PATCH] memcg,vmscan: do not break out targeted reclaim without
>  reclaimed pages
> 
> Targeted (hard resp. soft) reclaim has traditionally tried to scan one
> group with decreasing priority until nr_to_reclaim (SWAP_CLUSTER_MAX
> pages) is reclaimed or all priorities are exhausted. The reclaim is
> then retried until the limit is met.
> 
> This approach, however, doesn't work well with deeper hierarchies where
> groups higher in the hierarchy do not have any or only very few pages
> (this usually happens if those groups do not have any tasks and they
> have only re-parented pages after some of their children is removed).
> Those groups are reclaimed with decreasing priority pointlessly as there
> is nothing to reclaim from them.
> 
> An easiest fix is to break out of the memcg iteration loop in shrink_zone
> only if the whole hierarchy has been visited or sufficient pages have
> been reclaimed. This is also more natural because the reclaimer expects
> that the hierarchy under the given root is reclaimed. As a result we can
> simplify the soft limit reclaim which does its own iteration.
> 
> Reported-by: Ying Han <yinghan@google.com>

But what was in that report?

My guess would be "excessive CPU consumption", and perhaps "excessive
reclaim in the higher-level memcgs".

IOW, what are the user-visible effects of this change?

(And congrats - you're the first person I've sent that sentence to this
year!  But not, I fear, the last)


I don't really understand what prevents limit reclaim from stealing
lots of pages from the top-level groups.  How do we ensure
balancing/fairness in this case?


> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1973,18 +1973,17 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)

shrink_zone() might be getting a bit bloaty for CONFIG_MEMCG=n kernels.
