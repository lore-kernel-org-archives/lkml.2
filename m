Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab1CWU4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:56:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab1CWU4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=azMWAJF6F92K2lhYZAs9B5+JQOI5WcGCLwOFd/MLriXJq9hJWNa4Mwa27xhJw7pnoU
         wNf949B75B+qy1yZx0FQ==
MIME-Version: 1.0
In-Reply-To: <20110323103906.GC5507@siel.b>
References: <20110323030326.789836913@google.com> <20110323030448.853861319@google.com>
 <20110323103906.GC5507@siel.b>
From: Paul Turner <pjt@google.com>
Date: Wed, 23 Mar 2011 13:49:59 -0700
Message-ID: <AANLkTikfTB_VW4p9eGXnB71q-7s2qRR=ZK57eJQyF-Qn@mail.gmail.com>
Subject: Re: [patch 02/15] sched: validate CFS quota hierarchies
To: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Cc: torbenh <torbenh@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 3:39 AM, torbenh <torbenh@gmx.de> wrote:
> On Tue, Mar 22, 2011 at 08:03:28PM -0700, Paul Turner wrote:
>> Add constraints validation for CFS bandwidth hierachies.
>>
>> It is checked that:
>>    sum(child bandwidth) <= parent_bandwidth
>>
>> In a quota limited hierarchy, an unconstrainted entity
>> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
>>
>> Since bandwidth periods may be non-uniform we normalize to the maximum allowed
>> period, 5 seconds.
>>
>> This behavior may be disabled (allowing child bandwidth to exceed parent) via
>> kernel.sched_cfs_bandwidth_consistent=0
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>>
>> ---
>>  include/linux/sched.h |    8 +++
>>  kernel/sched.c        |  127 +++++++++++++++++++++++++++++++++++++++++++++++---
>>  kernel/sched_fair.c   |    8 +++
>>  kernel/sysctl.c       |   11 ++++
>>  4 files changed, 147 insertions(+), 7 deletions(-)
>>
>> Index: tip/kernel/sched.c
>> ===================================================================
>> --- tip.orig/kernel/sched.c
>> +++ tip/kernel/sched.c
>> +static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
>> +{
>> +     struct cfs_schedulable_data *d = data;
>> +     struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>> +     s64 quota = 0, parent_quota = -1;
>> +
>> +     quota = normalize_cfs_quota(tg, d);
>> +     if (!tg->parent) {
>> +             quota = RUNTIME_INF;
>> +     } else {
>> +             struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
>> +
>> +             parent_quota = parent_b->hierarchal_quota;
>> +             if (parent_quota != RUNTIME_INF) {
>> +                     parent_quota -= quota;
>> +                     /* invalid hierarchy, child bandwidth exceeds parent */
>> +                     if (parent_quota < 0)
>> +                             return -EINVAL;
>> +             }
>> +
>> +             /* if no inherent limit then inherit parent quota */
>> +             if (quota == RUNTIME_INF)
>> +                     quota = parent_quota;
>> +             parent_b->hierarchal_quota = parent_quota;
>> +     }
>> +     cfs_b->hierarchal_quota = quota;
>> +
>> +     return 0;
>> +}
>
> I find this logic pretty weird.
> As long as quota == INF i can overcommit, but as soon as there is some
> quota, i can not ?
>

I don't think I understand what you mean by being able to overcommit
when quota ==INF.  For a state of overcommit to exist an upper limit
must exist to exceed.

> Its clear, that one needs to be able to overcommit runtime, or the
> default runtime for a new cgroup would need to be 0.

Actually this is one of the primary reasons that the semantic of
inheritance was chosen.  By inheriting our parent's quota all existing
hiearchies remain valid.

There are also many cases which are not expressible without such a semantic:

Consider,

     X
  /  |   \
A  B  C

Suppose we have the following constraints:
X - is the top level application group, we wish to provision X with 4 cpus
C - is a threadpool performing some background work, we wish it to
consume no more than 2 cpus
A/B - split the remaining time available to the hierarchy

If we require absolute limits on A/B there is no way to allow this
usage, we must establish a priori hard usage ratios; yet, if a usage
ratio is desired using cpu.shares to specify this is a much better
solution as gives you a soft-ratio while remaining work-conserving
with respect to X's limit).


> The root problem imo is that runtime and shares should not be in the
> same cgroup subsystem. The semantics are too different.
>

Shares are a relative and represent a lower limit for cgroup bandwidth
Bandwidth is absolute and represents an upper limit for cgroup bandwidth

Given that one is absolute and the other relative, the semantics will
be necessarily different.  It does not work to extend bandwidth from
the definition of shares since there are many use-cases which require
their specification to be independent.

They are however intrinsically related since they effectively form
upper/lower bounds on the same parameter and should be controlled from
the same group.

>> +
>> +static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
>> +{
>> +     int ret;
>> +     struct cfs_schedulable_data data = {
>> +             .tg = tg,
>> +             .period = period / NSEC_PER_USEC,
>> +             .quota = quota / NSEC_PER_USEC,
>> +     };
>> +
>> +     if (!sysctl_sched_cfs_bandwidth_consistent)
>> +             return 0;
>> +
>> +     rcu_read_lock();
>> +     ret = walk_tg_tree(tg_cfs_schedulable_down, tg_nop,
>> +                         &data);
>> +     rcu_read_unlock();
>
> walk_tg_tree does the rcu_read_lock itself.
> not necessary to do that here.
> look at __rt_schedulable there is no rcu.
>

Oops yeah -- I wrote this one after fiddling with the new _from
variant (which does require rcu_lock to be external); you're right,
it's not needed here.  Thanks!

>
>> +
>> +     return ret;
>> +}
>
> --
> torben Hohn
>
