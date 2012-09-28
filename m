Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2I1FmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 01:42:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51270 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2I1FmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 01:42:06 -0400
Message-ID: <506537C7.9070909@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 11:08:15 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com> <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com> <1348494895.11847.64.camel@twins> <50606B33.1040102@linux.vnet.ibm.com> <5061B437.8070300@linux.vnet.ibm.com> <5064101A.5070902@redhat.com> <50643745.6010202@linux.vnet.ibm.com> <506440AF.9080202@redhat.com>
In-Reply-To: <506440AF.9080202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092805-3864-0000-0000-000004D3A1B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 05:33 PM, Avi Kivity wrote:
> On 09/27/2012 01:23 PM, Raghavendra K T wrote:
>>>
>>> This gives us a good case for tracking preemption on a per-vm basis.  As
>>> long as we aren't preempted, we can keep the PLE window high, and also
>>> return immediately from the handler without looking for candidates.
>>
>> 1) So do you think, deferring preemption patch ( Vatsa was mentioning
>> long back)  is also another thing worth trying, so we reduce the chance
>> of LHP.
>
> Yes, we have to keep it in mind.  It will be useful for fine grained
> locks, not so much so coarse locks or IPIs.
>

Agree.

> I would still of course prefer a PLE solution, but if we can't get it to
> work we can consider preemption deferral.
>

Okay.

>>
>> IIRC, with defer preemption :
>> we will have hook in spinlock/unlock path to measure depth of lock held,
>> and shared with host scheduler (may be via MSRs now).
>> Host scheduler 'prefers' not to preempt lock holding vcpu. (or rather
>> give say one chance.
>
> A downside is that we have to do that even when undercommitted.
>
> Also there may be a lot of false positives (deferred preemptions even
> when there is no contention).

Yes. That is a worry.

>
>>
>> 2) looking at the result (comparing A & C) , I do feel we have
>> significant in iterating over vcpus (when compared to even vmexit)
>> so We still would need undercommit fix sugested by PeterZ (improving by
>> 140%). ?
>
> Looking only at the current runqueue?  My worry is that it misses a lot
> of cases.  Maybe try the current runqueue first and then others.
>
> Or were you referring to something else?

No. I was referring to the same thing.

However. I had tried following also (which works well to check 
undercommited scenario). But thinking to use only for yielding in case
of overcommit (yield in overcommit suggested by Rik) and keep 
undercommit patch as suggested by PeterZ

[ patch is not in proper diff I suppose ].

Will test them.

Peter, Can I post your patch with your from/sob.. in V2?
Please let me know..

---
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28f00bc..9ed3759 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1620,6 +1620,21 @@ bool kvm_vcpu_eligible_for_directed_yield(struct 
kvm_vcpu *vcpu)
  	return eligible;
  }
  #endif
+
+bool kvm_overcommitted()
+{
+	unsigned long load;
+
+	load = avenrun[0] + FIXED_1/200;
+	load = load >> FSHIFT;
+	load = (load << 7) / num_online_cpus();
+
+	if (load > 128)
+		return true;
+
+	return false;
+}
+
  void kvm_vcpu_on_spin(struct kvm_vcpu *me)
  {
  	struct kvm *kvm = me->kvm;
@@ -1629,6 +1644,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
  	int pass;
  	int i;

+	if (!kvm_overcommitted())
+		return;
+
  	kvm_vcpu_set_in_spin_loop(me, true);
  	/*
  	 * We boost the priority of a VCPU that is runnable but not

