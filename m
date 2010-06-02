Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0FBPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:24:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33991 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0FBPYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:24:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mY1Szqfefx61w6v5rXYTFkI4y3xwQlVeE0skioQcK2dLdvaGem6MRUvS/q8DDPU/cd
         46/NK4aIHYPxDkGFTRjPN6OPtG3DpnXw5WnvkHyTjnoqxKe2AeoTDoVpc6c/+M6i5Jax
         FzhsdBbZM7rZUL4A5N0fBicsugU7w7aHv7J9g=
MIME-Version: 1.0
In-Reply-To: <20100602145653.GA2385@linux.vnet.ibm.com>
References: <AANLkTinNygSdXsg3vAVRHttAMh6nX4tauNKn3XnfQC_x@mail.gmail.com>
	<20100602145653.GA2385@linux.vnet.ibm.com>
Date: Wed, 2 Jun 2010 16:24:12 +0100
Message-ID: <AANLkTinu-JJ-X7annZ0U3oY8mcGF-hUEMV3ByYpNtL9n@mail.gmail.com>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious 
	rcu_dereference_check() usage
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 3:56 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jun 01, 2010 at 02:06:13PM +0100, Daniel J Blueman wrote:
>> Hi Paul,
>>
>> With 2.6.35-rc1 and your patch in the context below, we still see
>> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
>> protection!", so need this additional patch:
>>
>> Acquire read-side RCU lock around task_group() calls, addressing
>> "include/linux/cgroup.h:534 invoked rcu_dereference_check() without
>> protection!" warning.
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
> Thank you, Daniel!  I have queued this for 2.6.35.
>
> I had to apply the patch by hand due to line wrapping.  Could you please
> check your email-agent settings?  This simple patch was no problem to
> hand apply, but for a larger patch this process would be both tedious
> and error prone.

True - will do.

Thanks,
  Daniel

>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 217e4a9..50ec9ea 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -1241,6 +1241,7 @@ static int wake_affine(struct sched_domain *sd,
>> struct task_struct *p, int sync)
>>        * effect of the currently running task from the load
>>        * of the current CPU:
>>        */
>> +     rcu_read_lock();
>>       if (sync) {
>>               tg = task_group(current);
>>               weight = current->se.load.weight;
>> @@ -1250,6 +1251,7 @@ static int wake_affine(struct sched_domain *sd,
>> struct task_struct *p, int sync)
>>       }
>>
>>       tg = task_group(p);
>> +     rcu_read_unlock();
>>       weight = p->se.load.weight;
>>
>>       imbalance = 100 + (sd->imbalance_pct - 100) / 2;
>>
>> ---
>>
>> On Wed, Apr 21, 2010 at 02:35:43PM -0700, Paul E. McKenney wrote:
>>     On Tue, Apr 20, 2010 at 11:38:28AM -0400, Miles Lane wrote:
>>         Excellent. Here are the results on my machine. .config appended.
>>     First, thank you very much for testing this, Miles!
>>
>> And as Tetsuo Handa pointed out privately, my patch was way broken.
>>
>> Here is an updated version.
>>
>> Thanx, Paul
>>
>> commit b15e561ed91b7a366c3cc635026f3b9ce6483070
>> Author: Paul E. McKenney <paulmck@xxxxxxxxxxxxxxxxxx>
>> Date: Wed Apr 21 14:04:56 2010 -0700
>>
>> sched: protect __sched_setscheduler() access to cgroups
>>
>> A given task's cgroups structures must remain while that task is running
>> due to reference counting, so this is presumably a false positive.
>> Updated to reflect feedback from Tetsuo Handa.
>>
>> Signed-off-by: Paul E. McKenney <paulmck@xxxxxxxxxxxxxxxxxx>
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 14c44ec..f425a2b 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -4575,9 +4575,13 @@ recheck:
>> * Do not allow realtime tasks into groups that have no runtime
>> * assigned.
>> */
>> + rcu_read_lock();
>> if (rt_bandwidth_enabled() && rt_policy(policy) &&
>> - task_group(p)->rt_bandwidth.rt_runtime == 0)
>> + task_group(p)->rt_bandwidth.rt_runtime == 0) {
>> + rcu_read_unlock();
>> return -EPERM;
>> + }
>> + rcu_read_unlock();
>> #endif
>>
>> retval = security_task_setscheduler(p, policy, param);
-- 
Daniel J Blueman
