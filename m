Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1IFKwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:52:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45892 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754189Ab1IFKwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:52:40 -0400
Date: Tue, 6 Sep 2011 06:52:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -mm 3/4] llist, Move cpu_relax after cmpxchg
Message-ID: <20110906105239.GC21602@Krystal>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com> <1315290307-25145-3-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315290307-25145-3-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:52:05 up 286 days, 15:55,  1 user,  load average: 1.00, 1.00,
	0.83
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> If the first cmpxchg calling succeeds, it is not necessary to use
> cpu_relax before cmpxchg.  So cpu_relax in a busy loop involving
> cmpxchg should go after cmpxchg instead of before that.  This patch
> fixes this in llist.
>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

MAthieu
 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/llist.h |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -156,11 +156,14 @@ static inline void llist_add(struct llis
>  	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
> -	do {
> +	for (;;) {
>  		old_entry = entry;
>  		new->next = entry;
> +		entry = cmpxchg(&head->first, old_entry, new);
> +		if (entry == old_entry)
> +			break;
>  		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, new)) != old_entry);
> +	}
>  }
>  
>  /**
> @@ -178,11 +181,14 @@ static inline void llist_add_batch(struc
>  	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
> -	do {
> +	for (;;) {
>  		old_entry = entry;
>  		new_last->next = entry;
> +		entry = cmpxchg(&head->first, old_entry, new_first);
> +		if (entry == old_entry)
> +			break;
>  		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, new_first)) != old_entry);
> +	}
>  }
>  
>  /**
> @@ -206,13 +212,16 @@ static inline struct llist_node *llist_d
>  	CHECK_NMI_SAFE_CMPXCHG();
>  
>  	entry = head->first;
> -	do {
> +	for (;;) {
>  		if (entry == NULL)
>  			return NULL;
>  		old_entry = entry;
>  		next = entry->next;
> +		entry = cmpxchg(&head->first, old_entry, next);
> +		if (entry == old_entry)
> +			break;
>  		cpu_relax();
> -	} while ((entry = cmpxchg(&head->first, old_entry, next)) != old_entry);
> +	}
>  
>  	return entry;
>  }

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
