Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab2EJObb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:31:31 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56049 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab2EJOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/9] x86, MCE, AMD: Move shared bank to node descriptor
Date: Thu, 10 May 2012 16:30:24 +0200
Message-Id: <1336660229-32644-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Well, instead of having a real bank 4 on the BSP of each node and
symlinks on the remaining cores, we push it up into the amd_northbridge
descriptor which now contains a pointer to the northbridge bank 4
because the bank is one per northbridge and, as such, belongs in the NB
descriptor anyway.

Each time we hotplug CPUs, we use the northbridge pointer to copy the
shared bank into the per-CPU array of threshold_banks pointers, or
destroy it when the last CPU on the node goes offline, or create it when
the first comes online.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/amd_nb.h        |   21 +++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c |  107 +++++++++++++++++++++++++++-------
 2 files changed, 108 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 49ad773f4b9f..b3341e9cd8fd 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -26,10 +26,31 @@ struct amd_l3_cache {
 	u8	 subcaches[4];
 };
 
+struct threshold_block {
+	unsigned int		block;
+	unsigned int		bank;
+	unsigned int		cpu;
+	u32			address;
+	u16			interrupt_enable;
+	bool			interrupt_capable;
+	u16			threshold_limit;
+	struct kobject		kobj;
+	struct list_head	miscj;
+};
+
+struct threshold_bank {
+	struct kobject		*kobj;
+	struct threshold_block	*blocks;
+
+	/* initialized to the number of CPUs on the node sharing this bank */
+	atomic_t		cpus;
+};
+
 struct amd_northbridge {
 	struct pci_dev *misc;
 	struct pci_dev *link;
 	struct amd_l3_cache l3_cache;
+	struct threshold_bank *bank4;
 };
 
 struct amd_northbridge_info {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 7fd02cac962b..d67c9e56d609 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -25,6 +25,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 
+#include <asm/amd_nb.h>
 #include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
@@ -45,23 +46,6 @@
 #define MASK_BLKPTR_LO    0xFF000000
 #define MCG_XBLK_ADDR     0xC0000400
 
-struct threshold_block {
-	unsigned int		block;
-	unsigned int		bank;
-	unsigned int		cpu;
-	u32			address;
-	u16			interrupt_enable;
-	bool			interrupt_capable;
-	u16			threshold_limit;
-	struct kobject		kobj;
-	struct list_head	miscj;
-};
-
-struct threshold_bank {
-	struct kobject		*kobj;
-	struct threshold_block	*blocks;
-};
-
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
 static unsigned char shared_bank[NR_BANKS] = {
@@ -546,15 +530,62 @@ out_free:
 	return err;
 }
 
+static __cpuinit int __threshold_add_blocks(struct threshold_bank *b)
+{
+	struct list_head *head = &b->blocks->miscj;
+	struct threshold_block *pos = NULL;
+	struct threshold_block *tmp = NULL;
+	int err = 0;
+
+	err = kobject_add(&b->blocks->kobj, b->kobj, b->blocks->kobj.name);
+	if (err)
+		return err;
+
+	list_for_each_entry_safe(pos, tmp, head, miscj) {
+
+		err = kobject_add(&pos->kobj, b->kobj, pos->kobj.name);
+		if (err) {
+			list_for_each_entry_safe_reverse(pos, tmp, head, miscj)
+				kobject_del(&pos->kobj);
+
+			return err;
+		}
+	}
+	return err;
+}
+
 static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	struct device *dev = per_cpu(mce_device, cpu);
+	struct amd_northbridge *nb = NULL;
 	struct threshold_bank *b = NULL;
 	char name[32];
 	int err = 0;
 
 	sprintf(name, "threshold_bank%i", bank);
 
+	if (shared_bank[bank]) {
+
+		nb = node_to_amd_nb(amd_get_nb_id(cpu));
+		WARN_ON(!nb);
+
+		/* threshold descriptor already initialized on this node? */
+		if (nb->bank4) {
+			/* yes, use it */
+			b = nb->bank4;
+			err = kobject_add(b->kobj, &dev->kobj, name);
+			if (err)
+				goto out;
+
+			per_cpu(threshold_banks, cpu)[bank] = b;
+			atomic_inc(&b->cpus);
+
+			err = __threshold_add_blocks(b);
+
+			goto out;
+		}
+	}
+
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
 		err = -ENOMEM;
@@ -569,15 +600,23 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
+	if (shared_bank[bank]) {
+		atomic_set(&b->cpus, 1);
+
+		/* nb is already initialized, see above */
+		WARN_ON(nb->bank4);
+		nb->bank4 = b;
+	}
+
 	err = allocate_threshold_blocks(cpu, bank, 0,
 					MSR_IA32_MC0_MISC + bank * 4);
 	if (!err)
 		goto out;
 
-out_free:
-	per_cpu(threshold_banks, cpu)[bank] = NULL;
+ out_free:
 	kfree(b);
-out:
+
+ out:
 	return err;
 }
 
@@ -618,16 +657,44 @@ static void deallocate_threshold_block(unsigned int cpu,
 	per_cpu(threshold_banks, cpu)[bank]->blocks = NULL;
 }
 
+static void __threshold_remove_blocks(struct threshold_bank *b)
+{
+	struct threshold_block *pos = NULL;
+	struct threshold_block *tmp = NULL;
+
+	kobject_del(b->kobj);
+
+	list_for_each_entry_safe(pos, tmp, &b->blocks->miscj, miscj)
+		kobject_del(&pos->kobj);
+}
+
 static void threshold_remove_bank(unsigned int cpu, int bank)
 {
+	struct amd_northbridge *nb;
 	struct threshold_bank *b;
 
 	b = per_cpu(threshold_banks, cpu)[bank];
 	if (!b)
 		return;
+
 	if (!b->blocks)
 		goto free_out;
 
+	if (shared_bank[bank]) {
+		if (!atomic_dec_and_test(&b->cpus)) {
+			__threshold_remove_blocks(b);
+			per_cpu(threshold_banks, cpu)[bank] = NULL;
+			return;
+		} else {
+			/*
+			 * the last CPU on this node using the shared bank is
+			 * going away, remove that bank now.
+			 */
+			nb = node_to_amd_nb(amd_get_nb_id(cpu));
+			nb->bank4 = NULL;
+		}
+	}
+
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
-- 
1.7.9.3.362.g71319

