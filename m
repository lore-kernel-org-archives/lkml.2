Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab2DBJwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:52:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47246 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2DBJwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:52:38 -0400
Message-ID: <4F7976B6.5050000@linux.vnet.ibm.com>
Date: Mon, 02 Apr 2012 15:21:50 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Alan Meadows <alan.meadows@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com> <4F73568D.7000703@linux.vnet.ibm.com> <4F743247.5080407@redhat.com> <4F74A405.2040609@linux.vnet.ibm.com> <4F7585EE.7060203@linux.vnet.ibm.com> <4F7855A1.80107@redhat.com> <4F785CC9.7070204@linux.vnet.ibm.com> <4F785DCF.7020809@redhat.com>
In-Reply-To: <4F785DCF.7020809@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12040209-2000-0000-0000-000006FE62B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 07:23 PM, Avi Kivity wrote:
 > On 04/01/2012 04:48 PM, Raghavendra K T wrote:
 >>>> I have patch something like below in mind to try:
 >>>>
 >>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
 >>>> index d3b98b1..5127668 100644
 >>>> --- a/virt/kvm/kvm_main.c
 >>>> +++ b/virt/kvm/kvm_main.c
 >>>> @@ -1608,15 +1608,18 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 >>>>         * else and called schedule in __vcpu_run.  Hopefully that
 >>>>         * VCPU is holding the lock that we need and will release it.
 >>>>         * We approximate round-robin by starting at the last boosted
 >>>> VCPU.
 >>>> +     * Priority is given to vcpu that are unhalted.
 >>>>         */
 >>>> -    for (pass = 0; pass<   2&&   !yielded; pass++) {
 >>>> +    for (pass = 0; pass<   3&&   !yielded; pass++) {
 >>>>            kvm_for_each_vcpu(i, vcpu, kvm) {
 >>>>                struct task_struct *task = NULL;
 >>>>                struct pid *pid;
 >>>> -            if (!pass&&   i<   last_boosted_vcpu) {
 >>>> +            if (!pass&&   !vcpu->pv_unhalted)
 >>>> +                continue;
 >>>> +            else if (pass == 1&&   i<   last_boosted_vcpu) {
 >>>>                    i = last_boosted_vcpu;
 >>>>                    continue;
 >>>> -            } else if (pass&&   i>   last_boosted_vcpu)
 >>>> +            } else if (pass == 2&&   i>   last_boosted_vcpu)
 >>>>                    break;
 >>>>                if (vcpu == me)
 >>>>                    continue;
 >>>>
 >>>
 >>> Actually I think this is unneeded.  The loops tries to find vcpus that
 >>> are runnable but not running (vcpu_active(vcpu->wq)), and halted vcpus
 >>> don't match this condition.
 >>>

Oh! I think I misinterpreted your statement. hmm I got it. you told to
remove if (vcpu == me) condition.

I got some more interesting idea ( not sure there is some flaw in idea too).
Basically tried  similar idea (to PLE exit handler) in vcpu_block.

Instead of blind scheduling we try to do yield to vcpu that is kicked.
IMO it may solve some scalability problem and make LHP problem further
shrink.

I think Thomas would be happy to see the result.

results:
test setup.
===========
Host: i5-2540M CPU @ 2.60GHz laptop with 4cpu w/ hyperthreading. 8GB RAM
guest: 16 vcpu 2GB RAM  single guest.

Did kernbench run under guest:
x rc6-with ticketlock (current patchset)+ kvmpatches 
(CONFIG_PARAVIRT_SPINLOCK=y)
+ rc6-with ticketlock + kvmpatches + try_yield_patch (below one) 
(YIELD_THRESHOLD=256) (CONFIG_PARAVIRT_SPINLOCK=y)
* rc6-withticketlock + kvmpatches + try_yield_patch 
(YIELD_THRESHOLD=2048) (CONFIG_PARAVIRT_SPINLOCK=y)

N           Min           Max        Median           Avg        Stddev
x   3        162.45        165.94       165.433     164.60767     1.8857111
+   3        114.02       117.243       115.953     115.73867     1.6221548
Difference at 95.0% confidence
         -29.6882% +/- 2.42192%
*   3       115.823       120.423       117.103       117.783     2.3741946
Difference at 95.0% confidence
         -28.4462% +/- 2.9521%


improvement ~29% w.r.t to current patches.

Note: vanilla rc6 (host and guest) with (CONFIG_PARAVIRT_SPINLOCK=n)
did not finish kernbench run even after *1hr 45* minutes (above
kernbench runs took 9 minute and  6.5 min respectively). I did not try
to test it again.


Yes, I understand that  have to do some more test. and immediate TODO's
for patch are.

1) code belongs to arch/x86 directory and fill in static inline for
other archs
2) tweek YIELD_THRESHOLD value.

Ideas/suggestions welcome

Here is the try_yield_to patch.
---
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5127668..3fa912a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1557,12 +1557,17 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
  	mark_page_dirty_in_slot(kvm, memslot, gfn);
  }

+#define YIELD_THRESHOLD 2048
+static void kvm_vcpu_try_yield_to(struct kvm_vcpu *me);
  /*
   * The vCPU has executed a HLT instruction with in-kernel mode enabled.
   */
  void kvm_vcpu_block(struct kvm_vcpu *vcpu)
  {
  	DEFINE_WAIT(wait);
+	unsigned int loop_count;
+
+	loop_count = 0;

  	for (;;) {
  		prepare_to_wait(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
@@ -1579,7 +1584,10 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
  		if (signal_pending(current))
  			break;

-		schedule();
+		if (loop_count++ % YIELD_THRESHOLD)
+			schedule();
+		else
+			kvm_vcpu_try_yield_to(vcpu);
  	}

  	finish_wait(&vcpu->wq, &wait);
@@ -1593,6 +1601,39 @@ void kvm_resched(struct kvm_vcpu *vcpu)
  }
  EXPORT_SYMBOL_GPL(kvm_resched);

+static void kvm_vcpu_try_yield(struct kvm_vcpu *me)
+{
+
+	struct kvm *kvm = me->kvm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct task_struct *task = NULL;
+		struct pid *pid;
+		if (!vcpu->pv_unhalted)
+			continue;
+		if (waitqueue_active(&vcpu->wq))
+			continue;
+		rcu_read_lock();
+		pid = rcu_dereference(vcpu->pid);
+		if (pid)
+			task = get_pid_task(vcpu->pid, PIDTYPE_PID);
+		rcu_read_unlock();
+		if (!task)
+			continue;
+		if (task->flags & PF_VCPU) {
+			put_task_struct(task);
+			continue;
+		}
+		if (yield_to(task, 1)) {
+			put_task_struct(task);
+			break;
+		}
+		put_task_struct(task);
+	}
+}
+
  void kvm_vcpu_on_spin(struct kvm_vcpu *me)
  {
  	struct kvm *kvm = me->kvm;
---

