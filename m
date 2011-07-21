Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1GUXBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:01:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1GUXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:01:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:content-disposition;
	b=RbKosFdQGE67wKKOkt9ig1KIDeSsIzdW9iWoasBrLYwax3TdAi8C04HRurc5zw6cp
	CCgbW7fK9nNujQgJ1DcgA==
Message-Id: <20110721184758.403388616@google.com>
User-Agent: quilt/0.48-1
Date: Thu, 21 Jul 2011 09:43:42 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: [RFT][patch 17/18] sched: use jump labels to reduce overhead when bandwidth control is inactive
References: <20110721164325.231521704@google.com>
Content-Disposition: inline; filename=sched-bwc-add_jump_labels.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm seeing some strange costs associated with jump_labels; while on paper
the branches and instructions retired improves (as expected) we're taking an
unexpected hit in IPC.

[From the initial mail we have workloads:
  mkdir -p /cgroup/cpu/test
  echo $$ > /dev/cgroup/cpu/test (only cpu,cpuacct mounted)
  (W1) taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "for ((i=0;i<5;i++)); do $(dirname $0)/pipe-test 20000; done"
  (W2)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;true"
  (W3)taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches bash -c "$(dirname $0)/pipe-test 100000;"
]

To make some of the figures more clear:

Legend:
!BWC = tip + bwc, BWC compiled out
BWC = tip + bwc
BWC_JL = tip + bwc + jump label (this patch)


Now, comparing under W1 we see:
W1: BWC vs BWC_JL
                            instructions            cycles                  branches              elapsed                
---------------------------------------------------------------------------------------------------------------------
clovertown [BWC]            845934117               974222228               152715407             0.419014188 [baseline]
+unconstrained              857963815 (+1.42)      1007152750 (+3.38)       153140328 (+0.28)     0.433186926 (+3.38)  [rel]
+10000000000/1000:          876937753 (+2.55)      1033978705 (+5.65)       160038434 (+3.59)     0.443638365 (+5.66)  [rel]
+10000000000/1000000:       880276838 (+3.08)      1036176245 (+6.13)       160683878 (+4.15)     0.444577244 (+6.14)  [rel]

barcelona [BWC]             820573353               748178486               148161233             0.342122850 [baseline] 
+unconstrained              817011602 (-0.43)       759838181 (+1.56)       145951513 (-1.49)     0.347462571 (+1.56)  [rel]
+10000000000/1000:          830109086 (+0.26)       770451537 (+1.67)       151228902 (+1.08)     0.350824677 (+1.65)  [rel]
+10000000000/1000000:       830196206 (+0.30)       770704213 (+2.27)       151250413 (+1.12)     0.350962182 (+2.28)  [rel]

westmere [BWC]              802533191               694415157               146071233             0.194428018 [baseline]
+unconstrained              799057936 (-0.43)       751384496 (+8.20)       143875513 (-1.50)     0.211182620 (+8.62)  [rel]
+10000000000/1000:          812033785 (+0.27)       761469084 (+8.51)       149134146 (+1.09)     0.212149229 (+8.28)  [rel]
+10000000000/1000000:       811912834 (+0.27)       757842988 (+7.45)       149113291 (+1.09)     0.211364804 (+7.30)  [rel]
e.g. Barcelona issues ~0.43% less instructions, for a total of 817011602, in
the unconstrained case with BWC.


Where "unconstrained, 10000000000/1000, 10000000000/10000" are the on
measurements for BWC_JL, with (%d) being the relative difference to their
BWC counterparts.

W1: BWC vs BWC_JL is very similar.
	BWC vs BWC_JL
clovertown [BWC]            985732031              1283113452               175621212             1.375905653  
+unconstrained              979242938 (-0.66)      1288971141 (+0.46)       172122546 (-1.99)     1.389795165 (+1.01)  [rel]
+10000000000/1000:          999886468 (+0.33)      1296597143 (+1.13)       180554004 (+1.62)     1.392576770 (+1.18)  [rel]
+10000000000/1000000:       999034223 (+0.11)      1293925500 (+0.57)       180413829 (+1.39)     1.391041338 (+0.94)  [rel]

barcelona [BWC]             982139920              1078757792               175417574             1.069537049  
+unconstrained              965443672 (-1.70)      1075377223 (-0.31)       170215844 (-2.97)     1.045595065 (-2.24)  [rel]
+10000000000/1000:          989104943 (+0.05)      1100836668 (+0.52)       178837754 (+1.22)     1.058730316 (-1.77)  [rel]
+10000000000/1000000:       987627489 (-0.32)      1095843758 (-0.17)       178567411 (+0.84)     1.056100899 (-2.28)  [rel]

westmere [BWC]              918633403               896047900               166496917             0.754629182  
+unconstrained              914740541 (-0.42)       903906801 (+0.88)       163652848 (-1.71)     0.758050332 (+0.45)  [rel]
+10000000000/1000:          927517377 (-0.41)       952579771 (+5.67)       170173060 (+0.75)     0.771193786 (+2.43)  [rel]
+10000000000/1000000:       914676985 (-0.89)       936106277 (+3.81)       167683288 (+0.22)     0.764973632 (+1.38)  [rel]

Now this is rather odd, almost across the board we're seeing the expected
drops in instructions and branches, yet we appear to be paying a heavy IPC
price.  The fact that wall-time has scaled equivalently with cycles roughly
rules out the cycles counter being off.

We are seeing the expected behavior in the bandwidth enabled case;
specifically the <jl=jmp><ret><cond><ret> blocks are taking an extra branch
and instruction which shows up on all the numbers above.

With respect to compiler mangling the text is essentially unchanged in size.
One lurking suspicion is whether the inserted nops have perturbed some of the
jmp/branch alignments?

    text    data     bss     dec     hex filename
 7277206 2827256 2125824 12230286         ba9e8e vmlinux.jump_label
 7276886 2826744 2125824 12229454         ba9b4e vmlinux.no_jump_label
 
 I have checked to make sure that the right instructions are being patched in
 at run-time.  I've also pulled a fully patched jump_label out of the kernel
 into a userspace test (and benchmarked it directly under perf).  The results
 here are also exactly as expected.

e.g.
 Performance counter stats for './jump_test':
     1,500,839,002 instructions, 300,147,081 branches 702,468,404 cycles
Performance counter stats for './jump_test 1':
     2,001,014,609 instructions, 400,177,192 branches 901,758,219 cycles

Overall if we can fix the IPC the benefit in the globally unconstrained case
looks really good.

Any thoughts Jason?

-----
Some more raw data:

perf-stat_to_perf-stat variance in performance for W1:

	BWC_JL vs BWC_JL (sample run-to-run variance on JL measurements)
                            instructions            cycles                  branches              elapsed                
---------------------------------------------------------------------------------------------------------------------
clovertown [BWC_JL]         857963815              1007152750               153140328             0.433186926  
+unconstrained              856457537 (-0.18)       986820040 (-2.02)       152871983 (-0.18)     0.424187340 (-2.08)  [rel]
+10000000000/1000:          880281114 (+0.38)      1009349419 (-2.38)       160668480 (+0.39)     0.433031825 (-2.39)  [rel]
+10000000000/1000000:       881001883 (+0.08)      1008445782 (-2.68)       160811824 (+0.08)     0.432629132 (-2.69)  [rel]

barcelona [BWC_JL]          817011602               759838181               145951513             0.347462571  
+unconstrained              817076246 (+0.01)       758404044 (-0.19)       145958670 (+0.00)     0.346313238 (-0.33)  [rel]
+10000000000/1000:          830087089 (-0.00)       773100724 (+0.34)       151218674 (-0.01)     0.352047450 (+0.35)  [rel]
+10000000000/1000000:       830002149 (-0.02)       773209942 (+0.33)       151208657 (-0.03)     0.352090862 (+0.32)  [rel]

westmere [BWC_JL]           799057936               751384496               143875513             0.211182620  
+unconstrained              799067664 (+0.00)       751165910 (-0.03)       143877385 (+0.00)     0.210928554 (-0.12)  [rel]
+10000000000/1000:          812040497 (+0.00)       748711039 (-1.68)       149135568 (+0.00)     0.208868390 (-1.55)  [rel]
+10000000000/1000000:       811911208 (-0.00)       746860347 (-1.45)       149113194 (-0.00)     0.208663627 (-1.28)  [rel]

	BWC vs BWC (sample run-to-run variance on BWC measurements)

ilium [BWC]                845934117               974222228               152715407             0.419014188  
+unconstrained              849061624 (+0.37)       965568244 (-0.89)       153288606 (+0.38)     0.415287406 (-0.89)  [rel]
+10000000000/1000:          861138018 (+0.71)       975979688 (-0.28)       155594606 (+0.71)     0.418710227 (-0.28)  [rel]
+10000000000/1000000:       858768659 (+0.56)       972288157 (-0.42)       155163198 (+0.57)     0.417130144 (-0.42)  [rel]

barcelona [BWC]                820573353               748178486               148161233             0.342122850  
+unconstrained              820494225 (-0.01)       748302946 (+0.02)       148147559 (-0.01)     0.341349438 (-0.23)  [rel]
+10000000000/1000:          827929735 (-0.00)       756163375 (-0.22)       149609111 (-0.00)     0.344356113 (-0.22)  [rel]
+10000000000/1000000:       827682550 (-0.00)       759867539 (+0.84)       149565408 (-0.00)     0.346039855 (+0.84)  [rel]

westmere [BWC]                802533191               694415157               146071233             0.194428018  
+unconstrained              802648805 (+0.01)       698052899 (+0.52)       146099982 (+0.02)     0.195632318 (+0.62)  [rel]
+10000000000/1000:          809855427 (-0.00)       703633926 (+0.26)       147519800 (-0.00)     0.196545542 (+0.32)  [rel]
+10000000000/1000000:       809646717 (-0.01)       704895639 (-0.05)       147476169 (-0.02)     0.197022787 (+0.01)  [rel]

Raw Westmere measurements:

BWC:
Case: Unconstrained -1

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         802533191 instructions             #      1.156 IPC     ( +-   0.004% )
         694415157 cycles                     ( +-   0.165% )
         146071233 branches                   ( +-   0.003% )

        0.194428018  seconds time elapsed   ( +-   0.437% )

Case: 10000000000/1000:

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         809861594 instructions             #      1.154 IPC     ( +-   0.016% )
         701781996 cycles                     ( +-   0.184% )
         147520953 branches                   ( +-   0.022% )

        0.195928354  seconds time elapsed   ( +-   0.262% )


Case: 10000000000/1000000:

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         809752541 instructions             #      1.148 IPC     ( +-   0.016% )
         705278419 cycles                     ( +-   0.593% )
         147502154 branches                   ( +-   0.022% )

        0.196993502  seconds time elapsed   ( +-   0.698% )

BWC_JL
Case: Unconstrained -1

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         799057936 instructions             #      1.063 IPC     ( +-   0.001% )
         751384496 cycles                     ( +-   0.584% )
         143875513 branches                   ( +-   0.001% )

        0.211182620  seconds time elapsed   ( +-   0.771% )

Case: 10000000000/1000:

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         812033785 instructions             #      1.066 IPC     ( +-   0.017% )
         761469084 cycles                     ( +-   0.125% )
         149134146 branches                   ( +-   0.022% )

        0.212149229  seconds time elapsed   ( +-   0.171% )


Case: 10000000000/1000000:

 Performance counter stats for 'bash -c for ((i=0;i<5;i++)); do ./pipe-test 20000; done' (50 runs):

         811912834 instructions             #      1.071 IPC     ( +-   0.017% )
         757842988 cycles                     ( +-   0.158% )
         149113291 branches                   ( +-   0.022% )

        0.211364804  seconds time elapsed   ( +-   0.225% )


Let me know if there's any particular raw data you want, westmere seems the
most interesting because it's taking the biggest hit.

-------


From: Paul Turner <pjt@google.com>
When no groups within the system are constrained we can use jump labels to
reduce overheads -- skipping the per-cfs_rq runtime enabled checks.

Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c      |   33 +++++++++++++++++++++++++++++++--
 kernel/sched_fair.c |   15 ++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/jump_label.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -499,7 +500,32 @@ static void destroy_cfs_bandwidth(struct
 	hrtimer_cancel(&cfs_b->period_timer);
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
-#else
+
+#ifdef HAVE_JUMP_LABEL
+static struct jump_label_key __cfs_bandwidth_enabled;
+
+static inline bool cfs_bandwidth_enabled(void)
+{
+	return static_branch(&__cfs_bandwidth_enabled);
+}
+
+static void account_cfs_bandwidth_enabled(int enabled, int was_enabled)
+{
+	/* only need to count groups transitioning between enabled/!enabled */
+	if (enabled && !was_enabled)
+		jump_label_inc(&__cfs_bandwidth_enabled);
+	else if (!enabled && was_enabled)
+		jump_label_dec(&__cfs_bandwidth_enabled);
+}
+#else /* !HAVE_JUMP_LABEL */
+/* static_branch doesn't help unless supported */
+static int cfs_bandwidth_enabled(void)
+{
+	return 1;
+}
+static void account_cfs_bandwidth_enabled(int enabled, int was_enabled) {}
+#endif /* HAVE_JUMP_LABEL */
+#else /* !CONFIG_CFS_BANDWIDTH */
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
@@ -9025,7 +9051,7 @@ static int __cfs_schedulable(struct task
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0, runtime_enabled;
+	int i, ret = 0, runtime_enabled, runtime_was_enabled;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 
 	if (tg == &root_task_group)
@@ -9053,6 +9079,9 @@ static int tg_set_cfs_bandwidth(struct t
 		goto out_unlock;
 
 	runtime_enabled = quota != RUNTIME_INF;
+	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
+	account_cfs_bandwidth_enabled(runtime_enabled, runtime_was_enabled);
+
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1430,7 +1430,7 @@ static void __account_cfs_rq_runtime(str
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_rq->runtime_enabled)
+	if (!cfs_bandwidth_enabled() || !cfs_rq->runtime_enabled)
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1438,13 +1438,13 @@ static __always_inline void account_cfs_
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttled;
+	return cfs_bandwidth_enabled() && cfs_rq->throttled;
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
 static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttle_count;
+	return cfs_bandwidth_enabled() && cfs_rq->throttle_count;
 }
 
 /*
@@ -1765,6 +1765,9 @@ static void __return_cfs_rq_runtime(stru
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_enabled())
+		return;
+
 	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
 		return;
 
@@ -1810,6 +1813,9 @@ static void do_sched_cfs_slack_timer(str
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_enabled())
+		return;
+
 	/* an active group must be handled by the update_curr()->put() path */
 	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
 		return;
@@ -1827,6 +1833,9 @@ static void check_enqueue_throttle(struc
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_enabled())
+		return;
+
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
 		return;
 


