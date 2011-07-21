Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1GUPhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab1GUPhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:37:08 -0400
Message-ID: <4E28478B.1070907@redhat.com>
Date: Thu, 21 Jul 2011 18:36:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <20110704143655.GE5551@somewhere> <20110711210753.GA3582@e102144-lin.cambridge.arm.com> <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins> <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins> <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110721153238.GC8446@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110721153238.GC8446@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 06:32 PM, Will Deacon wrote:
> >
> >  Using TIF_bits sounds like a much better solution for this, wakeups are
> >  really rather expensive and its best to avoid extra if at all possible.
>
> The problem with using a TIF bit to tell a task that it needs to perform
> some preempt_notifier registrations is that you end up with something that
> looks a lot like preempt notifiers! You also don't escape the concurrent
> read/write to thelist of pending registrations.
>
> One thing I tried was simply using an RCU protected hlist for the preempt
> notifiers so that we don't have to worry about atomicity when reading the
> notifiers in finish_task_switch. It's a bit odd, since we know we only ever
> have a single reader, but I've included it below anyway.
>
> If anybody has any better ideas, I'm all ears.

> +void preempt_notifier_register_task(struct preempt_notifier *notifier,
> +				    struct task_struct *tsk)
> +{
> +	mutex_lock(&tsk->preempt_notifiers_mutex);
> +	hlist_add_head_rcu(&notifier->link,&tsk->preempt_notifiers);
> +	mutex_unlock(&tsk->preempt_notifiers_mutex);
> +}
> +EXPORT_SYMBOL_GPL(preempt_notifier_register_task);
> +
> +void preempt_notifier_unregister_task(struct preempt_notifier *notifier,
> +				      struct task_struct *tsk)
> +{
> +	mutex_lock(&tsk->preempt_notifiers_mutex);
> +	hlist_del_rcu(&notifier->link);
> +	mutex_unlock(&tsk->preempt_notifiers_mutex);
> +}
> +EXPORT_SYMBOL_GPL(preempt_notifier_unregister_task);
> +
>   /**
>    * preempt_notifier_register - tell me when current is being preempted&  rescheduled
>    * @notifier: notifier struct to register
>    */
>   void preempt_notifier_register(struct preempt_notifier *notifier)
>   {
> -	hlist_add_head(&notifier->link,&current->preempt_notifiers);
> +	preempt_notifier_register_task(notifier, current);
>   }
>   EXPORT_SYMBOL_GPL(preempt_notifier_register);

This is (and must be) called from a preempt disabled context, no mutexes 
around here.


-- 
error compiling committee.c: too many arguments to function

