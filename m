Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1IFK56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:57:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39503 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751450Ab1IFK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:57:52 -0400
Date: Tue, 6 Sep 2011 06:57:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -mm 4/4] irq_work, Use llist in irq_work
Message-ID: <20110906105750.GD21602@Krystal>
References: <1315290307-25145-1-git-send-email-ying.huang@intel.com> <1315290307-25145-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315290307-25145-4-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 06:53:47 up 286 days, 15:56,  1 user,  load average: 1.00, 1.00,
	0.84
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> Use llist in irq_work instead of the lock-less linked list
> implementation in irq_work to avoid the code duplication.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  include/linux/irq_work.h |   15 ++++---
>  kernel/irq_work.c        |   92 ++++++++++++++++-------------------------------
>  2 files changed, 41 insertions(+), 66 deletions(-)
> 
[...]
> -static void __irq_work_queue(struct irq_work *entry)
> +static void __irq_work_queue(struct irq_work *work)
>  {
> -	struct irq_work *next;
> -
>  	preempt_disable();
>  
> -	do {
> -		next = __this_cpu_read(irq_work_list);
> -		/* Can assign non-atomic because we keep the flags set. */
> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
> -
> +	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
>  	/* The list was empty, raise self-interrupt to start processing. */
> -	if (!irq_work_next(entry))
> +	if (!work->llnode.next)


Hrm. What happens if this function gets delayed between llist_add and
"if (!work->llnode.next)" ? It seems like the threads performing
llist_del_all would be within its right to free the memory pointed to by
work in the meantime.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
