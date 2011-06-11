Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1FKKZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:25:16 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38504 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1FKKZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:25:12 -0400
Date: Sat, 11 Jun 2011 12:24:51 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Avi Kivity <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with
 user_return_notifier
Message-ID: <20110611102451.GD9573@aftab>
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
 <4DF1D0EF.7090109@jp.fujitsu.com>
 <BANLkTikkYevvkUeQz4YYGauF52YcDRdokQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikkYevvkUeQz4YYGauF52YcDRdokQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a couple of notes:

On Fri, Jun 10, 2011 at 04:42:33PM -0400, Tony Luck wrote:
> 2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> > Now I'm reconsidering the MCE event notification mechanism.
> > One of something nervous is whether it is really required to process
> > "_AO" memory poisoning (i.e. mce_process_ring()) here in a process
> > context that unfortunately interrupted by MCE (or preempted after that).
> > I'm uncertain how long walking though the task_list for unmap will takes,
> > and not sure it is acceptable if the unlucky thread is a kind of latency
> > sensitive...
> >
> > If we can move mce_process_ring() to worker thread completely, what
> > we have to do will be:
> >  1) from NMI context, request non-NMI context by irq_work()
> >  2) from (irq) context, wake up loggers and schedule work if required
> >  3) from worker thread, process "_AO" memory poisoning etc.
> >
> > So now question is why user_return_notifier is needed here.
> > Is it just an alternative of irq_work() for !LOCAL_APIC ?

I think that an x86 CPU with hw poisoning features support makes
LOCAL_APIC's presence almost axiomatic ...

> I switched this notification over from old TIF_MCE_NOTIFY to
> using user_return_notifier to preserve existing semantics, and
> free up that TIF bit for the task notifier for the action required case.
> 
> You are right that we should have some better method - the
> shot-gun approach of hitting every task on every cpu in the hope
> that one of them will run our code soon sounds like overkill.
> Using some NMI-saf method to wake a single worker thread
> sounds a good idea for a subsequent clean up.

and we should go ahead and do it correctly from the get-go, methinks:
for the AR case, we definitely need to go to userspace _but_ the
worker thread that does the recovery for us has to be the _next_ thing
scheduled seamlessly following the process that was running when the MCE
happened.

If schedule_work() cannot guarantee us that then we need to do something
else like yield_to() to the worker thread, thus not penalizing the
unlucky thread. Maybe PeterZ, Ingo could comment on whether that is a ok
thing to do. Botomline is, we absolutely want to execute the AR handling
thread _before_ we return to normal process scheduling and thus going to
the risk of executing the thread that caused the AR MCE.

Btw, Tony, you could do away without atomic NMI lists if we change the
user return notifier a bit:

diff --git a/include/linux/user-return-notifier.h b/include/linux/user-return-notifier.h
index 9c4a445..eb3c977 100644
--- a/include/linux/user-return-notifier.h
+++ b/include/linux/user-return-notifier.h
@@ -26,6 +26,11 @@ static inline void propagate_user_return_notify(struct task_struct *prev,
 
 void fire_user_return_notifiers(void);
 
+static inline void void set_user_return_notifier(struct task_struct *p)
+{
+       set_tsk_thread_flag(p, TIF_USER_RETURN_NOTIFY);
+}
+
 static inline void clear_user_return_notifier(struct task_struct *p)
 {
        clear_tsk_thread_flag(p, TIF_USER_RETURN_NOTIFY);
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index 92cb706..c54c5d2 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -1,4 +1,3 @@
-
 #include <linux/user-return-notifier.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
@@ -13,12 +12,23 @@ static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
  */
 void user_return_notifier_register(struct user_return_notifier *urn)
 {
-       set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
        hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
 /*
+ * Request a constant notification when the current cpu returns to userspace.
+ * Must be called in atomic context.  The notifier will also be called in atomic
+ * context.
+ */
+void user_return_notifier_register_and_enable(struct user_return_notifier *urn)
+{
+       set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+       hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
+}
+EXPORT_SYMBOL_GPL(user_return_notifier_register_and_enable);
+
+/*
  * Removes a registered user return notifier.  Must be called from atomic
  * context, and from the same cpu registration occurred in.
  */
--

and then in the #MC handler you do user_return_notifier_set(),
having registered it during MCE core init. memory_failure() does
clear_user_return_notifier(current) after it finishes. The _enable
version is what others like KVM would still use. Or something to that
effect.

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
