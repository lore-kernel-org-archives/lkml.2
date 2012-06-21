Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2FUL1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 07:27:49 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55197 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070Ab2FUL1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 07:27:48 -0400
Message-ID: <4FE304D0.5000202@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 16:56:08 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        chegu_vinod@hp.com
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <4FE22E9E.7070206@linux.vnet.ibm.com>
In-Reply-To: <4FE22E9E.7070206@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------030506030109010507000102"
x-cbid: 12062111-5564-0000-0000-0000034886FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030506030109010507000102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/21/2012 01:42 AM, Raghavendra K T wrote:
> On 06/20/2012 02:21 AM, Rik van Riel wrote:
>> On Wed, 20 Jun 2012 01:50:50 +0530
>> Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com> wrote:
>>
[...]
>> Please let me know how it goes.
>
> Yes, have got result today, too tired to summarize. got better
> performance result too. will come back again tomorrow morning.
> have to post, randomized start point patch also, which I discussed to
> know the opinion.
>

Here are the results from kernbench.

PS: I think we have to only take that, both the patches perform better,
than reading into actual numbers since I am seeing more variance in
especially 3x. may be I can test with some more stable benchmark if
somebody points

+----------+-------------+------------+------------+-----------+
|  base    |  Rik patch  | % improve  |Random patch|  %improve  |
+----------+-------------+------------+------------+-----------+
| 49.98    |   49.935    | 0.0901172  |  49.924286 |  0.111597 |
| 106.0051 |   89.25806  | 18.7625    |  88.122217 |  20.2933  |
| 189.82067|   175.58783 | 8.10582    |  166.99989 |  13.6651  |
+----------+-------------+------------+------------+-----------+

I also have posted result of randomizing starting point patch.

I agree that Rik's fix should ideally go into git ASAP. and when above
patches go into git, feel free to add,

Tested-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

But I still see some questions unanswered.
1) why can't we move setting of last_boosted_vcpu up, it gives more
randomness ( As I said earlier, it gave degradation in 1x case because
of violent yields but performance benefit in 3x case. degradation
because  most of them yielding back to same spinning guy increasing
busy-wait but it gives huge benefit with ple_window set to higher
values such as 32k/64k. But that is a different issue altogethor)

2) Having the update of last_boosted_vcpu after yield_to does not seem
to be entirely correct. and having a common variable as starting point
may not be that good too. Also RR is little slower.

suppose we have 64 vcpu guest, and 4 vcpus enter ple_handler all of
them jumping on same guy to yield may not be good. Rather I personally
feel each of them starting at different point would be good idea.

But this alone will not help, we need more filtering of eligible VCPU.
for e.g. in first pass don't choose a VCPU that has recently done
PL exit. (Thanks Vatsa for brainstorming this). May be Peter/Avi
/Rik/Vatsa can give more idea in this area ( I mean, how can we identify
that a vcpu had done a PL exit/OR exited from spinlock context etc)

other idea  may be something like identifying next eligible lock-holder
(which is already possible with PV patches), and do yield-to him.

Here is the stat from randomizing starting point patch. We can see that
the patch has amazing fairness w.r.t starting point. IMO, this would be
great only after we add more eligibility criteria to target vcpus (of
yield_to).

Randomizing start index
===========================
snapshot1
PLE handler yield stat :
218416  176802  164554  141184  148495  154709  159871  145157
135476  158025  139997  247638  152498  133338  122774  248228
158469  121825  138542  113351  164988  120432  136391  129855
172764  214015  158710  133049  83485   112134  81651   190878

PLE handler start stat :
547772  547725  547545  547931  547836  548656  548272  547849
548879  549012  547285  548185  548700  547132  548310  547286
547236  547307  548328  548059  547842  549152  547870  548340
548170  546996  546678  547842  547716  548096  547918  547546

snapshot2
==============
PLE handler yield stat :
310690  222992  275829  156876  187354  185373  187584  155534
151578  205994  223731  320894  194995  167011  153415  286910
181290  143653  173988  181413  194505  170330  194455  181617
251108  226577  192070  143843  137878  166393  131405  250657

PLE handler start stat :
781335  782388  781837  782942  782025  781357  781950  781695
783183  783312  782004  782804  783766  780825  783232  781013
781587  781228  781642  781595  781665  783530  781546  781950
782268  781443  781327  781666  781907  781593  782105  781073


Sorry for attaching patch inline, I am using a dumb client. will post
it separately if needed.

====8<====

Currently PLE handler uses per VM variable as starting point. Get rid
of the variable and use randomized starting point.
Thanks Vatsa for scheduler related clarifications.

Suggested-by: Srikar <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---

--------------030506030109010507000102
Content-Type: text/x-patch;
 name="randomize_starting_vcpu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="randomize_starting_vcpu.patch"

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c446435..9799cab 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -275,7 +275,6 @@ struct kvm {
 #endif
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	atomic_t online_vcpus;
-	int last_boosted_vcpu;
 	struct list_head vm_list;
 	struct mutex lock;
 	struct kvm_io_bus *buses[KVM_NR_BUSES];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..6bab9f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -49,6 +49,7 @@
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
+#include <linux/random.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -1572,31 +1573,32 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int vcpu_to_boost;
 	int yielded = 0;
 	int pass;
 	int i;
+	int num_vcpus = atomic_read(&kvm->online_vcpus);
 
+	vcpu_to_boost = (random32() % num_vcpus);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
 	 * currently running, because it got preempted by something
 	 * else and called schedule in __vcpu_run.  Hopefully that
 	 * VCPU is holding the lock that we need and will release it.
-	 * We approximate round-robin by starting at the last boosted VCPU.
+	 * We approximate round-robin by starting at a random VCPU.
 	 */
 	for (pass = 0; pass < 2 && !yielded; pass++) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (!pass && i < last_boosted_vcpu) {
-				i = last_boosted_vcpu;
+			if (!pass && i < vcpu_to_boost) {
+				i = vcpu_to_boost;
 				continue;
-			} else if (pass && i > last_boosted_vcpu)
+			} else if (pass && i > vcpu_to_boost)
 				break;
 			if (vcpu == me)
 				continue;
 			if (waitqueue_active(&vcpu->wq))
 				continue;
 			if (kvm_vcpu_yield_to(vcpu)) {
-				kvm->last_boosted_vcpu = i;
 				yielded = 1;
 				break;
 			}

--------------030506030109010507000102--

