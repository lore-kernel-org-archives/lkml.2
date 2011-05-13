Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1EMRsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 13:48:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:64467 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1EMRs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 13:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="746921417"
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
	 <20110510073551.GH11595@elte.hu>
	 <BANLkTik0GTwV0Z21+UO69JX0cqjxwqu7jw@mail.gmail.com>
	 <1305071894.2736.50.camel@sbsiddha-MOBL3.sc.intel.com>
	 <BANLkTimvX3YXTxVSHDFm1N9a8vsALufrMg@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 13 May 2011 10:48:39 -0700
Message-Id: <1305308919.27535.19.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 09:15 -0700, Daniel J Blueman wrote:
> Superb, this works, tested against 2.6.39-rc7 and addresses the "BUG:
> sleeping function called from invalid context at mm/slub.c:824"
> warning I was previously seeing. It would be good to get this fix into
> 2.6.39-final if possible.
> 
> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>

Thanks Daniel for testing my quick patch. I have appended the complete
patch which cleans up this code.

Ingo, This patch is relatively big (mostly removes the duplicate code
and changes the location where we allocate ioapic_saved_data, so that
this can be shared between interrupt-remapping and io-apic
suspend/resume flows). May be this can go into 2.6.40-rc1 and probably
go to 2.6.39-stable?

Or we can take the Daniel's GFP_ATOMIC patch for 2.6.39 and push this
patch for 2.6.40-rc1. I am ok either way.

Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, ioapic: Remove the duplicate code for saving/restoring io-apic RTE's

Daniel reported that x2apic and interrupt-remapping resume code flow is
allocating memory with GFP_KERNEL while the interrupts are disabled.

Code flow for enabling interrupt-remapping has its own routines for saving and
restoring io-apic RTE's. ioapic suspend/resume code flow also has similar
routines. Remove the duplicate code. This will consolidate code aswell
as remove the unnecessary allocation/free of the temporary buffers during
suspend/resume of interrupt-remapping enabled platforms (and thus avoid
the GFP_KERNEL allocation in the interrupts disabled context).

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org	[v2.6.39]
---

 arch/x86/include/asm/io_apic.h |   21 ++----
 arch/x86/kernel/apic/apic.c    |   49 ++++----------
 arch/x86/kernel/apic/io_apic.c |  148 +++++++++++-----------------------------
 3 files changed, 61 insertions(+), 157 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a97a240..7e52404 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -152,11 +152,9 @@ extern void ioapic_insert_resources(void);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
-extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
-extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
-extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
+extern int save_ioapic_entries(void);
+extern void mask_ioapic_entries(void);
+extern void restore_ioapic_entries(void);
 
 extern int get_nr_irqs_gsi(void);
 
@@ -192,21 +190,14 @@ struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
 
-static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	return NULL;
-}
-
-static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
-static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline int save_ioapic_entries(void)
 {
 	return -ENOMEM;
 }
 
-static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
-static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline void mask_ioapic_entries(void) { }
+static inline void restore_ioapic_entries(void)
 {
-	return -ENOMEM;
 }
 
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fabf01e..835766f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1450,7 +1450,6 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
@@ -1458,13 +1457,7 @@ void __init enable_IR_x2apic(void)
 	if (dmar_table_init_ret && !x2apic_supported())
 		return;
 
-	ioapic_entries = alloc_ioapic_entries();
-	if (!ioapic_entries) {
-		pr_err("Allocate ioapic_entries failed\n");
-		goto out;
-	}
-
-	ret = save_IO_APIC_setup(ioapic_entries);
+	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
 		goto out;
@@ -1472,7 +1465,7 @@ void __init enable_IR_x2apic(void)
 
 	local_irq_save(flags);
 	legacy_pic->mask_all();
-	mask_IO_APIC_setup(ioapic_entries);
+	mask_ioapic_entries();
 
 	if (dmar_table_init_ret)
 		ret = 0;
@@ -1503,14 +1496,11 @@ void __init enable_IR_x2apic(void)
 
 nox2apic:
 	if (!ret) /* IR enabling failed */
-		restore_IO_APIC_setup(ioapic_entries);
+		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
-	if (ioapic_entries)
-		free_ioapic_entries(ioapic_entries);
-
 	if (x2apic_enabled)
 		return;
 
@@ -2088,28 +2078,21 @@ static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt, ret;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int maxlvt;
 
 	if (!apic_pm_state.active)
 		return;
 
 	local_irq_save(flags);
-	if (intr_remapping_enabled) {
-		ioapic_entries = alloc_ioapic_entries();
-		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			goto restore;
-		}
-
-		ret = save_IO_APIC_setup(ioapic_entries);
-		if (ret) {
-			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
-			free_ioapic_entries(ioapic_entries);
-			goto restore;
-		}
 
-		mask_IO_APIC_setup(ioapic_entries);
+	if (intr_remapping_enabled) {
+		/*
+		 * IO-APIC and PIC have their own resume routines.
+		 * We just mask them here to make sure the interrupt
+		 * subsystem is completely quiet while we enable x2apic
+		 * and interrupt-remapping.
+		 */
+		mask_ioapic_entries();
 		legacy_pic->mask_all();
 	}
 
@@ -2152,13 +2135,9 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled) {
+	if (intr_remapping_enabled)
 		reenable_intr_remapping(x2apic_mode);
-		legacy_pic->restore_mask();
-		restore_IO_APIC_setup(ioapic_entries);
-		free_ioapic_entries(ioapic_entries);
-	}
-restore:
+
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..13fe2f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -100,6 +100,12 @@ int mp_irq_entries;
 /* GSI interrupts */
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 
+/*
+ * Saved I/O APIC state during suspend/resume, or while enabling
+ * interrupt-remapping
+ */
+static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
+
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -179,6 +185,14 @@ int __init arch_early_irq_init(void)
 		io_apic_irqs = ~0UL;
 	}
 
+	for (i = 0; i < nr_ioapics; i++) {
+		ioapic_saved_data[i] = 
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				nr_ioapic_registers[i], GFP_KERNEL);
+		if (!ioapic_saved_data[i])
+			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
+	}
+
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
@@ -615,74 +629,43 @@ static int __init ioapic_pirq_setup(char *str)
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	int apic;
-	struct IO_APIC_route_entry **ioapic_entries;
-
-	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
-	if (!ioapic_entries)
-		return 0;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		ioapic_entries[apic] =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
-		if (!ioapic_entries[apic])
-			goto nomem;
-	}
-
-	return ioapic_entries;
-
-nomem:
-	while (--apic >= 0)
-		kfree(ioapic_entries[apic]);
-	kfree(ioapic_entries);
-
-	return 0;
-}
-
 /*
  * Saves all the IO-APIC RTE's
  */
-int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+int save_ioapic_entries(void)
 {
 	int apic, pin;
-
-	if (!ioapic_entries)
-		return -ENOMEM;
+	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (!ioapic_saved_data[apic]) {
+			err = -ENOMEM;
+			continue;
+		}
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
-			ioapic_entries[apic][pin] =
+			ioapic_saved_data[apic][pin] =
 				ioapic_read_entry(apic, pin);
 	}
 
-	return 0;
+	return err;
 }
 
 /*
  * Mask all IO APIC entries.
  */
-void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			break;
+		if (!ioapic_saved_data[apic])
+			continue;
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_entries[apic][pin];
+			entry = ioapic_saved_data[apic][pin];
 			if (!entry.mask) {
 				entry.mask = 1;
 				ioapic_write_entry(apic, pin, entry);
@@ -694,32 +677,18 @@ void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
 /*
  * Restore IO APIC entries which was saved in ioapic_entries.
  */
-int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+void restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return -ENOMEM;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (!ioapic_saved_data[apic])
+			continue;
 
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
-					ioapic_entries[apic][pin]);
+					   ioapic_saved_data[apic][pin]);
 	}
-	return 0;
-}
-
-void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
-{
-	int apic;
-
-	for (apic = 0; apic < nr_ioapics; apic++)
-		kfree(ioapic_entries[apic]);
-
-	kfree(ioapic_entries);
 }
 
 /*
@@ -2918,39 +2887,10 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
-static void suspend_ioapic(int ioapic_id)
+static void restore_ioapic_id(int ioapic_id)
 {
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
-	int i;
-
-	if (!saved_data)
-		return;
-
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		saved_data[i] = ioapic_read_entry(ioapic_id, i);
-}
-
-static int ioapic_suspend(void)
-{
-	int ioapic_id;
-
-	for (ioapic_id = 0; ioapic_id < nr_ioapics; ioapic_id++)
-		suspend_ioapic(ioapic_id);
-
-	return 0;
-}
-
-static void resume_ioapic(int ioapic_id)
-{
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
-	int i;
-
-	if (!saved_data)
-		return;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic_id, 0);
@@ -2959,8 +2899,6 @@ static void resume_ioapic(int ioapic_id)
 		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		ioapic_write_entry(ioapic_id, i, saved_data[i]);
 }
 
 static void ioapic_resume(void)
@@ -2968,28 +2906,18 @@ static void ioapic_resume(void)
 	int ioapic_id;
 
 	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic(ioapic_id);
+		restore_ioapic_id(ioapic_id);
+
+	restore_ioapic_entries();
 }
 
 static struct syscore_ops ioapic_syscore_ops = {
-	.suspend = ioapic_suspend,
+	.suspend = save_ioapic_entries,
 	.resume = ioapic_resume,
 };
 
 static int __init ioapic_init_ops(void)
 {
-	int i;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		unsigned int size;
-
-		size = nr_ioapic_registers[i]
-			* sizeof(struct IO_APIC_route_entry);
-		ioapic_saved_data[i] = kzalloc(size, GFP_KERNEL);
-		if (!ioapic_saved_data[i])
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
-
 	register_syscore_ops(&ioapic_syscore_ops);
 
 	return 0;
@@ -3992,6 +3920,7 @@ static __init int bad_ioapic(unsigned long address)
 
 void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
+	unsigned int size;
 	int idx = 0;
 	int entries;
 
@@ -4030,6 +3959,11 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
 
 	nr_ioapics++;
+
+	size = nr_ioapic_registers[idx] * sizeof(struct IO_APIC_route_entry);
+	ioapic_saved_data[idx] = kzalloc(size, GFP_KERNEL);
+	if (!ioapic_saved_data[idx])
+		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
 }
 
 /* Enable IOAPIC early just for system timer */


