Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3AHDQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:16:33 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:62301 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3AHDQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:16:32 -0500
Date: Mon, 7 Jan 2013 19:16:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Jason Liu <r64343@freescale.com>,
        linux-kernel@vger.kernel.org, riel@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm: compaction: fix echo 1 > compact_memory return error
 issue
In-Reply-To: <20130107133354.03f2ba80.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1301071916140.18525@chino.kir.corp.google.com>
References: <1357458273-28558-1-git-send-email-r64343@freescale.com> <20130107135721.GD3885@suse.de> <20130107133354.03f2ba80.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Andrew Morton wrote:

> --- a/mm/compaction.c~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix
> +++ a/mm/compaction.c
> @@ -1150,7 +1150,7 @@ unsigned long try_to_compact_pages(struc
>  
>  
>  /* Compact all zones within a node */
> -static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
> +static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
>  {
>  	int zoneid;
>  	struct zone *zone;
> @@ -1183,11 +1183,9 @@ static int __compact_pgdat(pg_data_t *pg
>  		VM_BUG_ON(!list_empty(&cc->freepages));
>  		VM_BUG_ON(!list_empty(&cc->migratepages));
>  	}
> -
> -	return 0;
>  }
>  
> -int compact_pgdat(pg_data_t *pgdat, int order)
> +void compact_pgdat(pg_data_t *pgdat, int order)
>  {
>  	struct compact_control cc = {
>  		.order = order,
> @@ -1195,10 +1193,10 @@ int compact_pgdat(pg_data_t *pgdat, int 
>  		.page = NULL,
>  	};
>  
> -	return __compact_pgdat(pgdat, &cc);
> +	__compact_pgdat(pgdat, &cc);
>  }
>  
> -static int compact_node(int nid)
> +static void compact_node(int nid)
>  {
>  	struct compact_control cc = {
>  		.order = -1,
> @@ -1206,7 +1204,7 @@ static int compact_node(int nid)
>  		.page = NULL,
>  	};
>  
> -	return __compact_pgdat(NODE_DATA(nid), &cc);
> +	__compact_pgdat(NODE_DATA(nid), &cc);
>  }
>  
>  /* Compact all nodes in the system */
> diff -puN include/linux/compaction.h~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix include/linux/compaction.h
> --- a/include/linux/compaction.h~mm-compaction-fix-echo-1-compact_memory-return-error-issue-fix
> +++ a/include/linux/compaction.h
> @@ -23,7 +23,7 @@ extern int fragmentation_index(struct zo
>  extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *mask,
>  			bool sync, bool *contended, struct page **page);
> -extern int compact_pgdat(pg_data_t *pgdat, int order);
> +extern void compact_pgdat(pg_data_t *pgdat, int order);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>  extern unsigned long compaction_suitable(struct zone *zone, int order);
>  
> @@ -80,9 +80,8 @@ static inline unsigned long try_to_compa
>  	return COMPACT_CONTINUE;
>  }
>  
> -static inline int compact_pgdat(pg_data_t *pgdat, int order)
> +static inline void compact_pgdat(pg_data_t *pgdat, int order)
>  {
> -	return COMPACT_CONTINUE;
>  }
>  
>  static inline void reset_isolation_suitable(pg_data_t *pgdat)

Acked-by: David Rientjes <rientjes@google.com>
