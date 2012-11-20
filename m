Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2KTW3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:29:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2KTW3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:29:30 -0500
Date: Tue, 20 Nov 2012 14:29:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rob Landley <rob@landley.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PART4 Patch v2 2/2] memory_hotplug: allow online/offline
 memory to result movable node
Message-Id: <20121120142928.0aaf8fc8.akpm@linux-foundation.org>
In-Reply-To: <1353067090-19468-3-git-send-email-wency@cn.fujitsu.com>
References: <1353067090-19468-1-git-send-email-wency@cn.fujitsu.com>
	<1353067090-19468-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012 19:58:10 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Now, memory management can handle movable node or nodes which don't have
> any normal memory, so we can dynamic configure and add movable node by:
> 	online a ZONE_MOVABLE memory from a previous offline node
> 	offline the last normal memory which result a non-normal-memory-node
> 
> movable-node is very important for power-saving,
> hardware partitioning and high-available-system(hardware fault management).
> 
> ...
>
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -589,11 +589,19 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_MOVABLE_NODE
> +/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */

The comment is hard to understand.  Should it read "When
CONFIG_MOVABLE_NODE, we permit onlining of a node which doesn't have
normal memory"?

> +static bool can_online_high_movable(struct zone *zone)
> +{
> +	return true;
> +}
> +#else /* #ifdef CONFIG_MOVABLE_NODE */
>  /* ensure every online node has NORMAL memory */
>  static bool can_online_high_movable(struct zone *zone)
>  {
>  	return node_state(zone_to_nid(zone), N_NORMAL_MEMORY);
>  }
> +#endif /* #ifdef CONFIG_MOVABLE_NODE */
>  
>  /* check which state of node_states will be changed when online memory */
>  static void node_states_check_changes_online(unsigned long nr_pages,
> @@ -1097,6 +1105,13 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>  	return offlined;
>  }
>  
> +#ifdef CONFIG_MOVABLE_NODE
> +/* when CONFIG_MOVABLE_NODE, we allow online node don't have normal memory */

Ditto, after replacing "online" with offlining".

> +static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
> +{
> +	return true;
> +}
> +#else /* #ifdef CONFIG_MOVABLE_NODE */
>  /* ensure the node has NORMAL memory if it is still online */
>  static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
>  {
> @@ -1120,6 +1135,7 @@ static bool can_offline_normal(struct zone *zone, unsigned long nr_pages)
>  	 */
>  	return present_pages == 0;
>  }
> +#endif /* #ifdef CONFIG_MOVABLE_NODE */

Please, spend more time over the accuracy and completeness of the
changelog and comments?  That will result in better and more
maintainable code.  And it results in *much* more effective code
reviewing.


