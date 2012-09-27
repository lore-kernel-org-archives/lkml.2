Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2I0I7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:59:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2I0I7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:59:35 -0400
Message-ID: <50641569.9060305@redhat.com>
Date: Thu, 27 Sep 2012 10:59:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <5060851E.1030404@redhat.com> <506166B4.4010207@linux.vnet.ibm.com> <5061713D.5060406@redhat.com> <20120927074405.GE23096@redhat.com>
In-Reply-To: <20120927074405.GE23096@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 09:44 AM, Gleb Natapov wrote:
> On Tue, Sep 25, 2012 at 10:54:21AM +0200, Avi Kivity wrote:
>> On 09/25/2012 10:09 AM, Raghavendra K T wrote:
>> > On 09/24/2012 09:36 PM, Avi Kivity wrote:
>> >> On 09/24/2012 05:41 PM, Avi Kivity wrote:
>> >>>
>> >>>>
>> >>>> case 2)
>> >>>> rq1 : vcpu1->wait(lockA) (spinning)
>> >>>> rq2 : vcpu3 (running) ,  vcpu2->holding(lockA) [scheduled out]
>> >>>>
>> >>>> I agree that checking rq1 length is not proper in this case, and as
>> >>>> you
>> >>>> rightly pointed out, we are in trouble here.
>> >>>> nr_running()/num_online_cpus() would give more accurate picture here,
>> >>>> but it seemed costly. May be load balancer save us a bit here in not
>> >>>> running to such sort of cases. ( I agree load balancer is far too
>> >>>> complex).
>> >>>
>> >>> In theory preempt notifier can tell us whether a vcpu is preempted or
>> >>> not (except for exits to userspace), so we can keep track of whether
>> >>> it's we're overcommitted in kvm itself.  It also avoids false positives
>> >>> from other guests and/or processes being overcommitted while our vm
>> >>> is fine.
>> >>
>> >> It also allows us to cheaply skip running vcpus.
>> >
>> > Hi Avi,
>> >
>> > Could you please elaborate on how preempt notifiers can be used
>> > here to keep track of overcommit or skip running vcpus?
>> >
>> > Are we planning set some flag in sched_out() handler etc?
>> >
>> 
>> Keep a bitmap kvm->preempted_vcpus.
>> 
>> In sched_out, test whether we're TASK_RUNNING, and if so, set a vcpu
>> flag and our bit in kvm->preempted_vcpus.  On sched_in, if the flag is
>> set, clear our bit in kvm->preempted_vcpus.  We can also keep a counter
>> of preempted vcpus.
>> 
>> We can use the bitmap and the counter to quickly see if spinning is
>> worthwhile (if the counter is zero, better to spin).  If not, we can use
>> the bitmap to select target vcpus quickly.
>> 
>> The only problem is that in order to keep this accurate we need to keep
>> the preempt notifiers active during exits to userspace.  But we can
>> prototype this without this change, and add it later if it works.
>> 
> Can user return notifier can be used instead? Set bit in
> kvm->preempted_vcpus on return to userspace.
> 

User return notifier is per-cpu, not per-task.  There is a new task_work
(<linux/task_work.h>) that does what you want.  With these
technicalities out of the way, I think it's the wrong idea.  If a vcpu
thread is in userspace, that doesn't mean it's preempted, there's no
point in boosting it if it's already running.

btw, we can have secondary effects.  A vcpu can be waiting for a lock in
the host kernel, or for a host page fault.  There's no point in boosting
anything for that.  Or a vcpu in userspace can be waiting for a lock
that is held by another thread, which has been preempted.  This is (like
I think Peter already said) a priority inheritance problem.  However
with fine-grained locking in userspace, we can make it go away.  The
guest kernel is unlikely to access one device simultaneously from two
threads (and if it does, we just need to improve the threading in the
device model).

-- 
error compiling committee.c: too many arguments to function
