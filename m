Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1IAH5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:57:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59730 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab1IAH5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:57:15 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 01 Sep 2011 09:57:08 +0200
In-Reply-To: <4E5EE409.3060102@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
		 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
	 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314863829.7945.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 09:46 +0800, Huang Ying wrote:

> You mean we should not use cpu_relax before the first cmpxchg? 

Yeah, that's just wasting time for no reason..

>  You suggest something as follow?
> 
> void llist_add(struct llist_node *new, struct llist_head *head)
> {
>         struct llist_node *entry, *old_entry;
> 
> #ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
>         BUG_ON(in_nmi());
> #endif
> 
>         entry = head->first;
>         for (;;) {
>                 old_entry = entry;
>                 new->next = entry;
>                 entry = cmpxchg(&head->first, old_entry, new);
>                 if (entry == old_entry)
>                         break;
>                 cpu_relax();
>         }
> }

If you insist on having cpu_relax(), then yes that's lots better. Also
avoids the assignment in your conditional. Thing with cpu_relax() is
that its only beneficial in the highly contended case and degrade
light/un-contended loads.

Also, just noticed, why do you have different list_head/list_node
structures? They're the same, a single pointer.

> > and loose the get/put
> > cpu muck? The existing preempt_disable/enable() are already superfluous
> > and could be removed, you just made all this way more horrid than need
> > be.
> 
> Will it cause race condition to remove preempt_disable/enable?
> Considering something as follow:
> 
> - get irq_work_list of CPU A
> - queue irq_work into irq_work_list of CPU A
> - preempted and resumed execution on CPU B
> - arch_irq_work_raise on CPU B
> 
> irq_work_run on CPU B will do nothing.  While irq_work need to wait for
> next timer interrupt.  Isn't it an issue?

Yes that's unfortunate, the current version would work just fine without
preempt but that's because of the this_cpu_* ops foo. 

Not sure it would make sense to add a special this_cpu_llist_add() or
so.. esp seeing that this_cpu_* is basically x86-only.
