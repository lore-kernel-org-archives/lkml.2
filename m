Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab1GUPrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:47:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59024 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab1GUPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:47:11 -0400
Date: Thu, 21 Jul 2011 16:46:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110721154648.GD8446@e102144-lin.cambridge.arm.com>
References: <4E1BF5A1.5070301@redhat.com>
 <1310459898.18678.108.camel@twins>
 <4E1C0F02.9040906@redhat.com>
 <1310462046.14978.11.camel@twins>
 <4E1C10F8.6010300@redhat.com>
 <1310462335.14978.12.camel@twins>
 <4E1C1373.5080500@redhat.com>
 <1310463060.14978.17.camel@twins>
 <20110721153238.GC8446@e102144-lin.cambridge.arm.com>
 <4E28478B.1070907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E28478B.1070907@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:36:43PM +0100, Avi Kivity wrote:
> On 07/21/2011 06:32 PM, Will Deacon wrote:
> > >
> > >  Using TIF_bits sounds like a much better solution for this, wakeups are
> > >  really rather expensive and its best to avoid extra if at all possible.
> >
> > The problem with using a TIF bit to tell a task that it needs to perform
> > some preempt_notifier registrations is that you end up with something that
> > looks a lot like preempt notifiers! You also don't escape the concurrent
> > read/write to thelist of pending registrations.
> >
> > One thing I tried was simply using an RCU protected hlist for the preempt
> > notifiers so that we don't have to worry about atomicity when reading the
> > notifiers in finish_task_switch. It's a bit odd, since we know we only ever
> > have a single reader, but I've included it below anyway.
> >
> > If anybody has any better ideas, I'm all ears.
> 
> > +void preempt_notifier_register_task(struct preempt_notifier *notifier,
> > +				    struct task_struct *tsk)
> > +{
> > +	mutex_lock(&tsk->preempt_notifiers_mutex);
> > +	hlist_add_head_rcu(&notifier->link,&tsk->preempt_notifiers);
> > +	mutex_unlock(&tsk->preempt_notifiers_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(preempt_notifier_register_task);
> > +
> > +void preempt_notifier_unregister_task(struct preempt_notifier *notifier,
> > +				      struct task_struct *tsk)
> > +{
> > +	mutex_lock(&tsk->preempt_notifiers_mutex);
> > +	hlist_del_rcu(&notifier->link);
> > +	mutex_unlock(&tsk->preempt_notifiers_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(preempt_notifier_unregister_task);
> > +
> >   /**
> >    * preempt_notifier_register - tell me when current is being preempted&  rescheduled
> >    * @notifier: notifier struct to register
> >    */
> >   void preempt_notifier_register(struct preempt_notifier *notifier)
> >   {
> > -	hlist_add_head(&notifier->link,&current->preempt_notifiers);
> > +	preempt_notifier_register_task(notifier, current);
> >   }
> >   EXPORT_SYMBOL_GPL(preempt_notifier_register);
> 
> This is (and must be) called from a preempt disabled context, no mutexes 
> around here.

Bah, yes, that is essential if you're dealing with current. Maybe use a
spinlock instead?

Will
