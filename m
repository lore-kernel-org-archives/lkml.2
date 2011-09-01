Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1IAH6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:58:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:53283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1IAH6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:58:54 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 01 Sep 2011 09:58:47 +0200
In-Reply-To: <4E5EFA08.30205@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
		 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
	 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
	 <4E5EFA08.30205@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314863927.7945.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 11:20 +0800, Huang Ying wrote:
> On 09/01/2011 09:46 AM, Huang Ying wrote:
> >>> -static void __irq_work_queue(struct irq_work *entry)
> >>> +static void __irq_work_queue(struct irq_work *work)
> >>>  {
> >>> -	struct irq_work *next;
> >>> +	struct irq_work_list *irq_work_list;
> >>>  
> >>> -	preempt_disable();
> >>> +	irq_work_list = &get_cpu_var(irq_work_lists);
> >>>  
> >>> -	do {
> >>> -		next = __this_cpu_read(irq_work_list);
> >>> -		/* Can assign non-atomic because we keep the flags set. */
> >>> -		entry->next = next_flags(next, IRQ_WORK_FLAGS);
> >>> -	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
> >>> +	llist_add(&work->llnode, &irq_work_list->llist);
> >>>  
> >>>  	/* The list was empty, raise self-interrupt to start processing. */
> >>> -	if (!irq_work_next(entry))
> >>> +	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
> >>>  		arch_irq_work_raise();
> >>
> >> So why can't you simply test work->llnode->next?
> > 
> > Yes.  That is better.  Even if there may be a small race window, it is
> > not a big issue to raise one extra self interrupt seldom.
> 
> Remember something about this.  I didn't test work->llnode->next here
> because I didn't want expose the implementation details like that here.
>  How about make llist_add() return whether list is empty before adding?
>  Because it will be an inline function, that should be optimized out if
> the caller do not need the information.

You could also use llist_empty() although that brings me to that
ACCESS_ONCE thing in there, what's the point?
