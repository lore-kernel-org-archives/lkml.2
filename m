Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1GUPc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:32:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57040 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598Ab1GUPc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:32:56 -0400
Date: Thu, 21 Jul 2011 16:32:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110721153238.GC8446@e102144-lin.cambridge.arm.com>
References: <20110704143655.GE5551@somewhere>
 <20110711210753.GA3582@e102144-lin.cambridge.arm.com>
 <4E1BF5A1.5070301@redhat.com>
 <1310459898.18678.108.camel@twins>
 <4E1C0F02.9040906@redhat.com>
 <1310462046.14978.11.camel@twins>
 <4E1C10F8.6010300@redhat.com>
 <1310462335.14978.12.camel@twins>
 <4E1C1373.5080500@redhat.com>
 <1310463060.14978.17.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310463060.14978.17.camel@twins>
Thread-Topic: [PATCH 1/3] perf: add context field to perf_event
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:31:00AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 12:27 +0300, Avi Kivity wrote:
> > On 07/12/2011 12:18 PM, Peter Zijlstra wrote:
> > > >
> > > >  The guarantee is that the task was sleeping just before the function is
> > > >  called.  Of course it's woken up to run the function.
> > > >
> > > >  The idea is that you run the function in a known safe point to avoid
> > > >  extra synchronization.
> > > >
> > >
> > > I'd much rather we didn't wake the task and let it sleep, that's usually
> > > a very safe place for tasks to be. All you'd need is a guarantee it
> > > won't be woken up while you're doing your thing.
> > 
> > But it means that 'current' is not set to the right value.  If the 
> > function depends on it, then it will misbehave.  And in fact 
> > preempt_notifier_register(), which is the function we want to call here, 
> > does depend on current.
> > 
> > Of course we need to find more users for this, but I have a feeling this 
> > will be generally useful.  The alternative is to keep adding bits to 
> > thread_info::flags.
> 
> Using TIF_bits sounds like a much better solution for this, wakeups are
> really rather expensive and its best to avoid extra if at all possible.

The problem with using a TIF bit to tell a task that it needs to perform
some preempt_notifier registrations is that you end up with something that
looks a lot like preempt notifiers! You also don't escape the concurrent
read/write to thelist of pending registrations.

One thing I tried was simply using an RCU protected hlist for the preempt
notifiers so that we don't have to worry about atomicity when reading the
notifiers in finish_task_switch. It's a bit odd, since we know we only ever
have a single reader, but I've included it below anyway.

If anybody has any better ideas, I'm all ears.

Will


diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2e681d9..2e21ffe 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -132,6 +132,11 @@ struct preempt_notifier {
 void preempt_notifier_register(struct preempt_notifier *notifier);
 void preempt_notifier_unregister(struct preempt_notifier *notifier);
 
+void preempt_notifier_register_task(struct preempt_notifier *notifier,
+				    struct task_struct *tsk);
+void preempt_notifier_unregister_task(struct preempt_notifier *notifier,
+				      struct task_struct *tsk);
+
 static inline void preempt_notifier_init(struct preempt_notifier *notifier,
 				     struct preempt_ops *ops)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..5530d91 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1233,6 +1233,7 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
+	struct mutex preempt_notifiers_mutex;
 #endif
 
 	/*
diff --git a/kernel/sched.c b/kernel/sched.c
index 9769c75..d3c46ca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2784,6 +2784,7 @@ static void __sched_fork(struct task_struct *p)
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
+	mutex_init(&p->preempt_notifiers_mutex);
 #endif
 }
 
@@ -2901,13 +2902,31 @@ void wake_up_new_task(struct task_struct *p)
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
+void preempt_notifier_register_task(struct preempt_notifier *notifier,
+				    struct task_struct *tsk)
+{
+	mutex_lock(&tsk->preempt_notifiers_mutex);
+	hlist_add_head_rcu(&notifier->link, &tsk->preempt_notifiers);
+	mutex_unlock(&tsk->preempt_notifiers_mutex);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_register_task);
+
+void preempt_notifier_unregister_task(struct preempt_notifier *notifier,
+				      struct task_struct *tsk)
+{
+	mutex_lock(&tsk->preempt_notifiers_mutex);
+	hlist_del_rcu(&notifier->link);
+	mutex_unlock(&tsk->preempt_notifiers_mutex);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_unregister_task);
+
 /**
  * preempt_notifier_register - tell me when current is being preempted & rescheduled
  * @notifier: notifier struct to register
  */
 void preempt_notifier_register(struct preempt_notifier *notifier)
 {
-	hlist_add_head(&notifier->link, &current->preempt_notifiers);
+	preempt_notifier_register_task(notifier, current);
 }
 EXPORT_SYMBOL_GPL(preempt_notifier_register);
 
@@ -2919,7 +2938,7 @@ EXPORT_SYMBOL_GPL(preempt_notifier_register);
  */
 void preempt_notifier_unregister(struct preempt_notifier *notifier)
 {
-	hlist_del(&notifier->link);
+	preempt_notifier_unregister_task(notifier, current);
 }
 EXPORT_SYMBOL_GPL(preempt_notifier_unregister);
 
@@ -2928,8 +2947,12 @@ static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
 	struct preempt_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(notifier, node, &curr->preempt_notifiers, link)
 		notifier->ops->sched_in(notifier, raw_smp_processor_id());
+
+	rcu_read_unlock();
 }
 
 static void
@@ -2939,8 +2962,12 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 	struct preempt_notifier *notifier;
 	struct hlist_node *node;
 
-	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(notifier, node, &curr->preempt_notifiers, link)
 		notifier->ops->sched_out(notifier, next);
+
+	rcu_read_unlock();
 }
 
 #else /* !CONFIG_PREEMPT_NOTIFIERS */
@@ -7979,6 +8006,7 @@ void __init sched_init(void)
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
+	mutex_init(&init_task.preempt_notifiers_mutex);
 #endif
 
 #ifdef CONFIG_SMP

