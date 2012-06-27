Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2F0KBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 06:01:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32944 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab2F0KBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 06:01:36 -0400
Message-ID: <1340791282.10063.8.camel@twins>
Subject: Re: [PATCH 2/2] perf/x86: Uncore Filter support for SandyBridge-EP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 27 Jun 2012 12:01:22 +0200
In-Reply-To: <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
	 <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:09 +0800, Yan, Zheng wrote:
> +struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
> +                                         int cpu)
>  {
>         struct intel_uncore_box *box;
> +       int size = sizeof(*box);
> +
> +       if (type->num_shared_regs)
> +               size += type->num_shared_regs *
> +                       sizeof(struct intel_uncore_extra_reg);
>  
> -       box = kmalloc_node(sizeof(*box), GFP_KERNEL | __GFP_ZERO,
> -                          cpu_to_node(cpu));
> +       box = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO, cpu_to_node(cpu));
>         if (!box)
>                 return NULL;
>  
> +       if (type->num_shared_regs) {
> +               int i;
> +               box->shared_regs = (struct intel_uncore_extra_reg *)(box + 1);
> +               for (i = 0; i < type->num_shared_regs; i++)
> +                       raw_spin_lock_init(&box->shared_regs[i].lock);
> +       }
> +
>         uncore_pmu_init_hrtimer(box);
>         atomic_set(&box->refcnt, 1);
>         box->cpu = -1; 

Yuck.. that's vile. How about something like this:


---
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -206,7 +206,7 @@ static void snbep_uncore_put_constraint(
 		return;
 
 	er = &box->shared_regs[reg1->idx];
-	atomic_sub(1, &er->ref);
+	atomic_dec(&er->ref);
 	reg1->alloc = 0;
 }
 
@@ -862,22 +862,17 @@ struct intel_uncore_box *uncore_alloc_bo
 					  int cpu)
 {
 	struct intel_uncore_box *box;
-	int size = sizeof(*box);
-
-	if (type->num_shared_regs)
-		size += type->num_shared_regs *
-			sizeof(struct intel_uncore_extra_reg);
+	int i, size;
+       
+	size = sizeof(*box) + type->num_shared_regs *
+		sizeof(struct intel_uncore_extra_reg);
 
 	box = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO, cpu_to_node(cpu));
 	if (!box)
 		return NULL;
 
-	if (type->num_shared_regs) {
-		int i;
-		box->shared_regs = (struct intel_uncore_extra_reg *)(box + 1);
-		for (i = 0; i < type->num_shared_regs; i++)
-			raw_spin_lock_init(&box->shared_regs[i].lock);
-	}
+	for (i = 0; i < type->num_shared_regs; i++)
+		raw_spin_lock_init(&box->shared_regs[i].lock);
 
 	uncore_pmu_init_hrtimer(box);
 	atomic_set(&box->refcnt, 1);
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -228,11 +228,11 @@ struct intel_uncore_box {
 	struct perf_event *event_list[UNCORE_PMC_IDX_MAX];
 	unsigned long active_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
 	u64 tags[UNCORE_PMC_IDX_MAX];
-	struct intel_uncore_extra_reg *shared_regs;
 	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
 	struct hrtimer hrtimer;
 	struct list_head list;
+	struct intel_uncore_extra_reg shared_regs[0];
 };
 
 #define UNCORE_BOX_FLAG_INITIATED	0

