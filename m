Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0FDJAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:00:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41050 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab0FDJAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:00:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Et+bQ9LJ5GqulVB7SZaSIplPxqe4WTtFezaaV1lPtyHH/iJ5YEwWBWHJ9yDx+XsRCm
         PLGs9fAagD0RW/43NN4+BBCofFHls6yKV2RcUXWdgdRCGFKzKx9JgOaPTBPxEgUs816c
         1940DWc0H+wVwZ4JGEVzcAMnylj1cDb6Mjb/8=
MIME-Version: 1.0
In-Reply-To: <20100604041047.GB2780@linux.vnet.ibm.com>
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com>
	<20100602145653.GA2385@linux.vnet.ibm.com>
	<4C07743C.7030204@cn.fujitsu.com>
	<20100603183040.GA2385@linux.vnet.ibm.com>
	<4C0868A0.5080508@cn.fujitsu.com>
	<20100604041047.GB2780@linux.vnet.ibm.com>
Date: Fri, 4 Jun 2010 09:54:13 +0100
Message-ID: <AANLkTimROz06Xu0KtGQNFKQVPE_arks8rBY-NwMv_hoj@mail.gmail.com>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious 
	rcu_dereference_check() usage
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 5:10 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Jun 04, 2010 at 10:44:48AM +0800, Li Zefan wrote:
>> > Seems worth reviewing the other uses of task_group():
>> >
>> > 1.  set_task_rq() -- only a runqueue and a sched_rt_entity leave
>> >     the RCU read-side critical section.  Runqueues do persist.
>> >     I don't claim to understand the sched_rt_entity life cycle.
>> >
>> > 2.  __sched_setscheduler() -- not clear to me that this one is
>> >     protected to begin with.  If it is somehow correctly protected,
>> >     it discards the RCU-protected pointer immediately, so is OK
>> >     otherwise.
>> >
>> > 3.  cpu_cgroup_destroy() -- ditto.
>> >
>> > 4.  cpu_shares_read_u64() -- ditto.
>> >
>> > 5.  print_task() -- protected by rcu_read_lock() and discards the
>> >     RCU-protected pointer immediately, so this one is OK.
>> >
>> > Any task_group() experts able to weigh in on #2, #3, and #4?
>> >
>>
>> #3 and #4 are safe, because it's not calling task_group(), but
>> cgroup_tg():
>>
>>       struct task_group *tg = cgroup_tg(cgrp);
>>
>> As long as it's safe to access cgrp, it's safe to access tg.
>
> Good point, thank you!
>
> Any takers on #2?

Indeed, __sched_setscheduler() is not protected. How does this look?

Since the struct task_group pointed to by the return value from task_group
isn't taken holding the RCU read lock, when it is soon after dereferenced,
it may have gone.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index d484081..b086a36 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4483,9 +4483,13 @@ recheck:
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
 		 */
+		rcu_read_lock();
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
+				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+			rcu_read_unlock();
 			return -EPERM;
+		}
+		rcu_read_unlock();
 #endif

 		retval = security_task_setscheduler(p, policy, param);

>
>                                                        Thanx, Paul
>
>> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> >
>> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> > index 50ec9ea..224ef98 100644
>> > --- a/kernel/sched_fair.c
>> > +++ b/kernel/sched_fair.c
>> > @@ -1251,7 +1251,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>> >     }
>> >
>> >     tg = task_group(p);
>> > -   rcu_read_unlock();
>> >     weight = p->se.load.weight;
>> >
>> >     imbalance = 100 + (sd->imbalance_pct - 100) / 2;
>> > @@ -1268,6 +1267,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>> >     balanced = !this_load ||
>> >             100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
>> >             imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
>> > +   rcu_read_unlock();
>> >
>>
>> This is fine.
>>
>> Another way is :
>>
>> rcu_read_lock();
>> tg = task_group(p);
>> css_get(&tg->css);
>> rcu_read_unlock();
>>
>> /* do something */
>> ...
>>
>> css_put(&tg->css);
-- 
Daniel J Blueman
