Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2K2Rny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:43:54 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39678 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2K2Rnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:43:52 -0500
Message-ID: <50B79EC9.4000708@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2012 11:43:37 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, kvm@vger.kernel.org, peterz@infradead.org,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 0/5] Alter steal time reporting in KVM
References: <20121126203603.28840.38736.stgit@lambeau> <20121127232442.GA8295@amt.cnet> <50B65B4A.50508@linux.vnet.ibm.com> <50B67A4B.8060800@parallels.com>
In-Reply-To: <50B67A4B.8060800@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112917-4790-0000-0000-000005CC6814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 02:55 PM, Glauber Costa wrote:
> On 11/28/2012 10:43 PM, Michael Wolf wrote:
>> On 11/27/2012 05:24 PM, Marcelo Tosatti wrote:
>>> On Mon, Nov 26, 2012 at 02:36:24PM -0600, Michael Wolf wrote:
>>>> In the case of where you have a system that is running in a
>>>> capped or overcommitted environment the user may see steal time
>>>> being reported in accounting tools such as top or vmstat.
>>> The definition of stolen time is 'time during which the virtual CPU is
>>> runnable to not running'. Overcommit is the main scenario which steal
>>> time helps to detect.
>>>
>>> Can you describe the 'capped' case?
>> In the capped case, the time that the guest spends waiting due to it
>> having used its full allottment of time shows up as steal time.  The way
>> my patchset currently stands is that you would set up the
>> bandwidth control and you would have to pass it a  matching value from
>> qemu.  In the future, it would
>> be possible to have something parse the bandwidth setting and
>> automatically adjust the setting in the
>> host used for steal time reporting.
> Ok, so correct me if I am wrong, but I believe you would be using
> something like the bandwidth capper in the cpu cgroup to set those
> entitlements, right?
Yes, in the context above I'm referring to the cfs bandwidth control.
>
> Some time has passed since I last looked into it, but IIRC, after you
> get are out of your quota, you should be out of the runqueue. In the
> lovely world of KVM, we approximate steal time as runqueue time:
>
> arch/x86/kvm/x86.c:
> delta = current->sched_info.run_delay - vcpu->arch.st.last_steal;
> vcpu->arch.st.last_steal = current->sched_info.run_delay;
> vcpu->arch.st.accum_steal = delta;
>
> include/linux/sched.h:
> unsigned long long run_delay; /* time spent waiting on a runqueue */
>
> So if you are out of the runqueue, you won't get steal time accounted,
> and then I truly fail to understand what you are doing.
So I looked at something like this in the past.  To make sure things 
haven't changed
I set up a cgroup on my test server running a kernel built from the 
latest tip tree.

[root]# cat cpu.cfs_quota_us
50000
[root]# cat cpu.cfs_period_us
100000
[root]# cat cpuset.cpus
1
[root]# cat cpuset.mems
0

Next I put the PID from the cpu thread into tasks.  When I start a 
script that will hog the cpu I see the
following in top on the guest
Cpu(s):  1.9%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa, 48.3%hi, 0.0%si, 
49.8%st

So the steal time here is in line with the bandwidth control settings.
>
> In case I am wrong, and run_delay also includes the time you can't run
> because you are out of capacity, then maybe what we should do, is to
> just subtract it from run_delay in kvm/x86.c before we pass it on. In
> summary:
About a year ago I was playing with this patch.  It is out of date now 
but will give you
an idea of what I was looking at.

  kernel/sched_fair.c  |    4 ++--
  kernel/sched_stats.h |    7 ++++++-
  2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..a837e4e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -707,7 +707,7 @@ account_entity_dequeue(struct cfs_rq *cfs_rq,
struct sched_entity *se)

  #ifdef CONFIG_FAIR_GROUP_SCHED
  /* we need this in update_cfs_load and load-balance functions below */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
+inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
  # ifdef CONFIG_SMP
  static void update_cfs_rq_load_contribution(struct cfs_rq *cfs_rq,
                          int global_update)
@@ -1420,7 +1420,7 @@ static inline int cfs_rq_throttled(struct
cfs_rq *cfs_rq)
  }

  /* check whether cfs_rq, or any parent, is throttled */
-static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
+inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
  {
      return cfs_rq->throttle_count;
  }
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 87f9e36..e30ff26 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -213,14 +213,19 @@ static inline void sched_info_queued(struct
task_struct *t)
   * sched_info_queued() to mark that it has now again started waiting on
   * the runqueue.
   */
+extern inline int throttled_hierarchy(struct cfs_rq *cfs_rq);
  static inline void sched_info_depart(struct task_struct *t)
  {
+    struct task_group *tg = task_group(t);
+    struct cfs_rq *cfs_rq;
      unsigned long long delta = task_rq(t)->clock -
                      t->sched_info.last_arrival;

+    cfs_rq = tg->cfs_rq[smp_processor_id()];
      rq_sched_info_depart(task_rq(t), delta);

-    if (t->state == TASK_RUNNING)
+
+    if (t->state == TASK_RUNNING && !throttled_hierarchy(cfs_rq))
          sched_info_queued(t);
  }


So then the steal time did not show on the guest.  You have no value 
that needs to be passed
around.  What I did not like about this approach was
* only works for cfs bandwidth control.  If another type of hard limit 
was added to the kernel
    the code would potentially need to change.
* This approach doesn't help if the limits are set by overcommitting the 
cpus.  It is my understanding
    that this is a common approach.

>
>>>>         Alter the amount of steal time reported by the guest.
> Maybe this should go away.
>
>>>>         Expand the steal time msr to also contain the consigned time.
> Maybe this should go away
>
>>>>         Add the code to send the consigned time from the host to the
>>>> guest
> This definitely should be heavily modified
>
>>>>         Add a timer to allow the separation of consigned from steal time.
> Maybe this should go away
>
>>>>         Add an ioctl to communicate the consign limit to the host.
> This definitely should go away.
>
> More specifically, *whatever* way we use to cap the processor, the host
> system will have all the information at all times.
I'm not understanding that comment.  If you are capping by simply 
controlling the amount of
overcommit on the host then wouldn't you still need some value to 
indicate the desired amount.
If another guest was inadvertently started or something else on the host 
started taking more
processor than expected, you would need to report the steal time.


>
>
>

