Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab2EJOcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:32:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56036 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab2EJOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/9] x86, MCE, AMD: Remove shared banks sysfs linking
Date: Thu, 10 May 2012 16:30:22 +0200
Message-Id: <1336660229-32644-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The code used to create a symlink on all non-BSP cores of a node when
the MCi_MISCj bank is present once per node. (This is generally the
case with bank 4 on AMD). However, these sysfs links cause a bunch
of problems with cpu off-/onlining testing and are, as such, a bit
overengineered. IOW, there's nothing wrong with having normal sysfs
files for the shared banks since the corresponding MSRs are replicated
across each core anyway.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |  105 +++-------------------------------
 1 file changed, 7 insertions(+), 98 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f4873a64f46d..2a5dd30f9969 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -60,7 +60,6 @@ struct threshold_block {
 struct threshold_bank {
 	struct kobject		*kobj;
 	struct threshold_block	*blocks;
-	cpumask_var_t		cpus;
 };
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
@@ -224,8 +223,6 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 
 			if (!block)
 				per_cpu(bank_map, cpu) |= (1 << bank);
-			if (shared_bank[bank] && c->cpu_core_id)
-				break;
 
 			memset(&b, 0, sizeof(b));
 			b.cpu			= cpu;
@@ -555,89 +552,35 @@ local_allocate_threshold_blocks(int cpu, unsigned int bank)
 					 MSR_IA32_MC0_MISC + bank * 4);
 }
 
-/* symlinks sibling shared banks to first core.  first core owns dir/files. */
 static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
-	int i, err = 0;
-	struct threshold_bank *b = NULL;
 	struct device *dev = per_cpu(mce_device, cpu);
+	struct threshold_bank *b = NULL;
 	char name[32];
+	int err = 0;
 
 	sprintf(name, "threshold_bank%i", bank);
 
-#ifdef CONFIG_SMP
-	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = cpumask_first(cpu_llc_shared_mask(cpu));
-
-		/* first core not up yet */
-		if (cpu_data(i).cpu_core_id)
-			goto out;
-
-		/* already linked */
-		if (per_cpu(threshold_banks, cpu)[bank])
-			goto out;
-
-		b = per_cpu(threshold_banks, i)[bank];
-
-		if (!b)
-			goto out;
-
-		err = sysfs_create_link(&dev->kobj, b->kobj, name);
-		if (err)
-			goto out;
-
-		cpumask_copy(b->cpus, cpu_llc_shared_mask(cpu));
-		per_cpu(threshold_banks, cpu)[bank] = b;
-
-		goto out;
-	}
-#endif
-
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
 		err = -ENOMEM;
 		goto out;
 	}
-	if (!zalloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
-		kfree(b);
-		err = -ENOMEM;
-		goto out;
-	}
 
 	b->kobj = kobject_create_and_add(name, &dev->kobj);
-	if (!b->kobj)
+	if (!b->kobj) {
+		err = -EINVAL;
 		goto out_free;
-
-#ifndef CONFIG_SMP
-	cpumask_setall(b->cpus);
-#else
-	cpumask_set_cpu(cpu, b->cpus);
-#endif
+	}
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
 	err = local_allocate_threshold_blocks(cpu, bank);
-	if (err)
-		goto out_free;
-
-	for_each_cpu(i, b->cpus) {
-		if (i == cpu)
-			continue;
-
-		dev = per_cpu(mce_device, i);
-		if (dev)
-			err = sysfs_create_link(&dev->kobj,b->kobj, name);
-		if (err)
-			goto out;
-
-		per_cpu(threshold_banks, i)[bank] = b;
-	}
-
-	goto out;
+	if (!err)
+		goto out;
 
 out_free:
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
-	free_cpumask_var(b->cpus);
 	kfree(b);
 out:
 	return err;
@@ -660,12 +603,6 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
 	return err;
 }
 
-/*
- * let's be hotplug friendly.
- * in case of multiple core processors, the first core always takes ownership
- *   of shared sysfs dir/files, and rest of the cores will be symlinked to it.
- */
-
 static void deallocate_threshold_block(unsigned int cpu,
 						 unsigned int bank)
 {
@@ -689,9 +626,6 @@ static void deallocate_threshold_block(unsigned int cpu,
 static void threshold_remove_bank(unsigned int cpu, int bank)
 {
 	struct threshold_bank *b;
-	struct device *dev;
-	char name[32];
-	int i = 0;
 
 	b = per_cpu(threshold_banks, cpu)[bank];
 	if (!b)
@@ -699,36 +633,11 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	if (!b->blocks)
 		goto free_out;
 
-	sprintf(name, "threshold_bank%i", bank);
-
-#ifdef CONFIG_SMP
-	/* sibling symlink */
-	if (shared_bank[bank] && b->blocks->cpu != cpu) {
-		dev = per_cpu(mce_device, cpu);
-		sysfs_remove_link(&dev->kobj, name);
-		per_cpu(threshold_banks, cpu)[bank] = NULL;
-
-		return;
-	}
-#endif
-
-	/* remove all sibling symlinks before unregistering */
-	for_each_cpu(i, b->cpus) {
-		if (i == cpu)
-			continue;
-
-		dev = per_cpu(mce_device, i);
-		if (dev)
-			sysfs_remove_link(&dev->kobj, name);
-		per_cpu(threshold_banks, i)[bank] = NULL;
-	}
-
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
 	kobject_del(b->kobj);
 	kobject_put(b->kobj);
-	free_cpumask_var(b->cpus);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
-- 
1.7.9.3.362.g71319

