Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2ECFq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 01:46:59 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34020 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2ECFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 01:46:58 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better latencies
In-Reply-To: <20120502140117.GC22740@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com> <1335286696.28150.206.camel@twins> <1335287354.28150.209.camel@twins> <20120502140117.GC22740@linux.vnet.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Thu, 03 May 2012 11:13:24 +0530
Message-ID: <87mx5px1j7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12050305-8256-0000-0000-00000238CA9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012 19:31:17 +0530, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-04-24 19:09:14]:
> 
> > On Tue, 2012-04-24 at 18:58 +0200, Peter Zijlstra wrote:
> > > On Tue, 2012-04-24 at 22:26 +0530, Srivatsa Vaddagiri wrote:
> > > > Steer a waking task towards a cpu where its cgroup has zero tasks (in
> > > > order to provide it better sleeper credits and hence reduce its wakeup
> > > > latency). 
> > > 
> > > That's just vile.. pjt could you post your global vruntime stuff so
> > > vatsa can have a go at that?
> > 
> > That is, you're playing a deficiency we should fix, not exploit.
> > 
> > Also, you do a second loop over all those cpus right after we've already
> > iterated them..
> > 
> > furthermore, that 100%+ gain is still way insane, what else is broken?
> > Did you try those paravirt tlb-flush patches and other such weirdness?
> 
> I got around to try pv-tlb-flush patches and it showed >100%
> improvement for sysbench (without the balance-on-wake patch on host). This
> was what readprofile showed (when pv-tlb-flush patches were absent in
> guest):
> 
> 1135704 total                                   0.3265
> 636737 native_cpuid                             18192.4857
> 283201 __bitmap_empty                           2832.0100
> 137853 flush_tlb_others_ipi                     569.6405
> 
> I will try out how much they help Trade workload (which got me started
> on this originally) and report back (part of the problem in trying out
> is that pv-tlb-flush platches are throwing wierd problems - which Nikunj
> is helping investigate). 
> 
A bug, the below patch should cure it. kvm_mmu_flush_tlb will queue the
request, but we have already passed the phase of checking that. I will
fold this in my next version.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c42056..b114411 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1550,7 +1550,7 @@ static void kvm_set_vcpu_state(struct kvm_vcpu *vcpu)
 
        vs->state = 1;
        if (vs->flush_on_enter) {
-               kvm_mmu_flush_tlb(vcpu);
+               kvm_x86_ops->tlb_flush(vcpu);
                vs->flush_on_enter = 0;
        }
 

