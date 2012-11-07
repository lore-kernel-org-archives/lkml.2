Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2KGKaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:30:35 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34447 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab2KGKad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:30:33 -0500
Date: Wed, 7 Nov 2012 15:55:45 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 RFC 2/3] kvm: Handle yield_to failure return code for
 potential undercommit case
Message-ID: <20121107102545.GA18644@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
 <20121029140702.15448.56932.sendpatchset@codeblue>
 <50911BC3.6080305@redhat.com>
 <50911C7D.5080307@linux.vnet.ibm.com>
 <50912463.3040201@linux.vnet.ibm.com>
 <50912A72.6050307@redhat.com>
 <50915A91.1040001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50915A91.1040001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110710-9360-0000-0000-00000C7FC111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> [2012-10-31 22:36:25]:

> On 10/31/2012 07:11 PM, Avi Kivity wrote:
> >On 10/31/2012 03:15 PM, Raghavendra K T wrote:
> >>On 10/31/2012 06:11 PM, Raghavendra K T wrote:
> >>>On 10/31/2012 06:08 PM, Avi Kivity wrote:
> >>>>On 10/29/2012 04:07 PM, Raghavendra K T wrote:
> >>>>>From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >>>>>
> >>>>>Also we do not update last boosted vcpu in failure cases.
> >>>>>
> >>>>>   #endif
> >>>>>+
> >>>>>   void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>>>>   {
> >>>>>       struct kvm *kvm = me->kvm;
> >>>>>@@ -1727,11 +1727,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
> >>>>>                   continue;
> >>>>>               if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
> >>>>>                   continue;
> >>>>>-            if (kvm_vcpu_yield_to(vcpu)) {
> >>>>>+
> >>>>>+            yielded = kvm_vcpu_yield_to(vcpu);
> >>>>>+            if (yielded > 0)
> >>>>>                   kvm->last_boosted_vcpu = i;
> >>>>>-                yielded = 1;
> >>>>>+            if (yielded)
> >>>>>                   break;
> >>>>>-            }
> >>>>>           }
> >>>>
> >>>>If yielded == -ESRCH, should we not try to yield to another vcpu?
> >>>>
> >>>
> >>>   Yes. plan is to abort the iteration. since it means we are mostly
> >>>undercommitted.
> >>
> >>Sorry if it was ambiguous. I wanted to say we do not want to continue
> >>yield to another vcpu..
> >>
> >
> >
> >Why not?  We found that this particular vcpu is running and therefore
> >likely not a lock holder.  That says nothing about other vcpus.  The
> >next in line might be runnable-but-not-running on another runqueue.
> 
> Agree that next in the line might be runnable-not-running.  But here we
> are optimistic that, that is not the case and we save time by
> returning back instead of iterating, thinking we are mostly in
> undercommitted case and each vcpu has dedicated cpu.
> 
> Probably an alternative we have here is to look for say 2-3 successive
> failures before breaking out?

Hi Avi,

I tried the idea of bailing out only when we have successive failure
too (hunk below). results are as follows.

base = 3.7.0-rc1 
A = base +  patch 1 +  patch 2 (original series except patch 3)
B = A + bail out on successive failures patch (hunk below)

% improvements w.r.t base kernel 32 vcpu guest on 32 core PLE machine

                          A               B
kernbench_1x         1.83959         0.95158
kernbench_2x         5.58283         8.31783

ebizzy_1x            144.96959       147.47995	
ebizzy_2x            -11.52278       -4.52835	
ebizzy_3x            -7.59141        -5.17241	
       	
dbench_1x            87.46935        61.14888	
dbench_2x            -7.16749        -4.17130	
dbench_3x            -0.34115        -3.18740


IMO, 
the original patch would have affceted moderate overcommits more
when we have average runqueue length less than two but we are still 
overcommitted.

With this patch though we may get litlle less improvement for
1x overcommit, probability of this affetcting moderate overcommit
situation reduces drastically.

If we consider cases where, we have average run queue length as follows,
and corresponding probability of we considering it as undercommitted (wrongly)
case with rough/simple math is as follows: (correct me if something is
wrong here)

( In precise math it should be the probability of we hitting
a source and target runqueue length one when we are overcommitted for
two successive trials, noting that source of the yield_to remains same)

(Probability = p^3 where p is the probability that we hit a cpu having
rq length = 1. I have taken out #cpus from calculation here though it affects)

average     Probability 
rq length
---------------------------------
1.25       27/64  Note: we are slightly overcommitted here and hopefully it does not afftect much.
1.5        1/8 
1.75       1/64

for original patch it was p^2 and hence 9/16, 1/4, 1/16 respectively.

I think continuing to yield_to beyond this would make us go back to
square one, unnecessarily wasting time.

Please let me know if you have any comments on idea of bailing out after successive trials?

(Side) Note: Dynamic ple window built on top of this logic is already done. and
will be posting it with results in a separate patch.

Changed hunk:
---8<---
@@ -1697,12 +1696,14 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 	return eligible;
 }
 #endif
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
+	int try = 2;
 	int pass;
 	int i;
 
@@ -1714,7 +1715,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	 * VCPU is holding the lock that we need and will release it.
 	 * We approximate round-robin by starting at the last boosted VCPU.
 	 */
-	for (pass = 0; pass < 2 && !yielded; pass++) {
+	for (pass = 0; pass < 2 && !yielded && try; pass++) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (!pass && i <= last_boosted_vcpu) {
 				i = last_boosted_vcpu;
@@ -1727,10 +1728,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				continue;
 			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
 				continue;
-			if (kvm_vcpu_yield_to(vcpu)) {
+
+			yielded = kvm_vcpu_yield_to(vcpu);
+			if (yielded > 0) {
 				kvm->last_boosted_vcpu = i;
-				yielded = 1;
 				break;
+			} else if (yielded < 0) {
+				try--;
+				if (!try)
+					break;
 			}
 		}
 	}

