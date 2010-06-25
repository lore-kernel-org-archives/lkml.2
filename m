Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0FYIRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:17:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48287 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0FYIRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:17:00 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277431963.3947.140.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Jun 2010 09:48:30 +0200
Message-ID: <1277452110.22715.2116.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 10:12 +0800, Huang Ying wrote:
> 
> It is better to add "void *data" field in this struct to allow same
> function can be used for multiple struct irq_work. 

No, simply do:

struct my_foo {
  struct irq_work work;
  /* my extra data */
}

void my_func(struct irq_work *work)
{
  struct my_foo *foo = container_of(work, struct my_foo, work);

  /* tada! */
}


> And I think IRQ is the implementation detail here, so irq_work is
> probably not a good name. nmi_return_notifier or nmi_callback is better?

Well, its ran in hard-irq context, so its an irq work. There's nothing
that says it can only be used from NMI context.

> > +void irq_work_run(void)
> > +{
> > +     struct irq_work *list;
> > +
> > +     list = xchg(&__get_cpu_var(irq_work_list), CALLBACK_TAIL);
> > +     while (list != CALLBACK_TAIL) {
> > +             struct irq_work *entry = list;
> > +
> > +             list = list->next;
> > +             entry->func(entry);
> > +
> > +             entry->next = NULL;
> 
> entry->next = NULL should be put before entry->func(entry), so that we
> will not lose a notification from NMI. And maybe check irq_work_list for
> several times to make sure nothing is lost.

But then _sync() will return before its done executing.

I think clearing after the function is done executing is the only sane
semantics (and yes, I should fix the current perf code).

You can always miss an NMI since it can always happen before the
callback gets done, and allowing another enqueue before the callback is
complete is asking for trouble.

> > +             /*
> > +              * matches the mb in cmpxchg() in irq_work_queue()
> > +              */
> > +             smp_wmb();
> > +     }
> > +}
> 
> I don't know why we need smp_wmb() here and smp_rmb() in
> irq_work_pending(). The smp_<x>mb() in original perf_pending_xxx code is
> not necessary too. Because smp_<x>mb is invoked in wake_up_process() and
> __wait_event() already.

The smp_wmb() wants to be before ->next = NULL; so that all writes are
completed before we release the entry. To that same effect _sync() and
_queue need the (r)mb.


