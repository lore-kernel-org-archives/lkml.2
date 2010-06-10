Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab0FJPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:06:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55337 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab0FJPGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:06:19 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [10/23] SCHED: Only allocate per cpu cpu mask buffer with offstack cpumasks
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
	<20100610111046.18EB4B1A2B@basil.firstfloor.org>
	<1276181030.2077.399.camel@twins>
	<20100610145243.GC19561@basil.fritz.box>
	<1276181743.2077.426.camel@twins>
Date: Thu, 10 Jun 2010 17:06:18 +0200
In-Reply-To: <1276181743.2077.426.camel@twins> (Peter Zijlstra's message of "Thu\, 10 Jun 2010 16\:55\:43 +0200")
Message-ID: <87fx0v3p1x.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, 2010-06-10 at 16:52 +0200, Andi Kleen wrote:
>> > This patch will actually break things.. please read the code.
>> > 
>> > I guess we could move the unsigned long into that block, but I really
>> > don't see the point.
>> 
>> How does it break things? 
>> 
>> ptr is not used for anything unless that define is set. gcc doesn't
>> lie on this.

Ok.

For the !FAIR_GROUP_SCHED || !CPUMASK_OFFSTACK case it's still wasted
memory because it is not used for anything. If you enable the kmemleak
tracer you should also get a warning about this

I updated the patch with a better ifdef to have CONFIG_UNFAIR_GROUP_SCHED
too.

-Andi

---

SCHED: Only allocate per cpu cpu mask buffer with offstack cpumasks v2

This will save a few bytes in the non offstack cpumask case.

Found by gcc 4.6's new warnings.

Cc: peterz@infradead.org
Cc: mingo@elte.hu
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sched.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc2-gcc/kernel/sched.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/kernel/sched.c
+++ linux-2.6.35-rc2-gcc/kernel/sched.c
@@ -7482,7 +7482,7 @@ static void init_tg_rt_entry(struct task
 void __init sched_init(void)
 {
 	int i, j;
-	unsigned long alloc_size = 0, ptr;
+	unsigned long alloc_size = 0;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
@@ -7494,7 +7494,10 @@ void __init sched_init(void)
 	alloc_size += num_possible_cpus() * cpumask_size();
 #endif
 	if (alloc_size) {
+#if defined(CONFIG_CPUMASK_OFFSTACK) || defined(CONFIG_FAIR_GROUP_SCHED)
+		unsigned long ptr;
 		ptr = (unsigned long)kzalloc(alloc_size, GFP_NOWAIT);
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;


-- 
ak@linux.intel.com -- Speaking for myself only.
