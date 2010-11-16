Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab0KPLtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:49:41 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:51751 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab0KPLtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:49:39 -0500
Date: Tue, 16 Nov 2010 12:49:35 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.37-rc2
Message-ID: <20101116124935.43600fed@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (1):
      [S390] ftrace: build without frame pointers on s390

Hendrik Brueckner (1):
      [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking

Martin Schwidefsky (4):
      [S390] fix get_user_pages_fast
      [S390] tape: add medium state notifications
      [S390] kprobes: disable interrupts throughout
      [S390] kprobes: Fix the return address of multiple kretprobes

Sebastian Ott (1):
      [S390] cio: fix incorrect ccw_device_init_count

Stefan Weinhuber (1):
      [S390] vmlogrdr: purge after recording is switched off

 arch/s390/Kconfig.debug       |   12 +++++++
 arch/s390/include/asm/page.h  |    5 +++
 arch/s390/kernel/kprobes.c    |   70 +++++++++++++++++++++++++++++++----------
 arch/s390/mm/gup.c            |    7 ++--
 drivers/s390/char/tape_core.c |   68 ++++++++++++++++++++++++++++++++++-----
 drivers/s390/char/vmlogrdr.c  |   36 ++++++++++++++-------
 drivers/s390/cio/device.c     |   11 ++++++-
 kernel/trace/Kconfig          |    2 +-
 8 files changed, 167 insertions(+), 44 deletions(-)

diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 45e0c61..05221b1 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -6,6 +6,18 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+config STRICT_DEVMEM
+	def_bool y
+	prompt "Filter access to /dev/mem"
+	---help---
+	  This option restricts access to /dev/mem.  If this option is
+	  disabled, you allow userspace access to all memory, including
+	  kernel and userspace memory. Accidental memory access is likely
+	  to be disastrous.
+	  Memory access is required for experts who want to debug the kernel.
+
+	  If you are unsure, say Y.
+
 config DEBUG_STRICT_USER_COPY_CHECKS
 	bool "Strict user copy size checks"
 	---help---
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index a8729ea..3c987e9 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -130,6 +130,11 @@ struct page;
 void arch_free_page(struct page *page, int order);
 void arch_alloc_page(struct page *page, int order);
 
+static inline int devmem_is_allowed(unsigned long pfn)
+{
+	return 0;
+}
+
 #define HAVE_ARCH_FREE_PAGE
 #define HAVE_ARCH_ALLOC_PAGE
 
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index d60fc43..2564793 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -30,6 +30,7 @@
 #include <asm/sections.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/hardirq.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -212,7 +213,7 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 	/* Set the PER control regs, turns on single step for this address */
 	__ctl_load(kprobe_per_regs, 9, 11);
 	regs->psw.mask |= PSW_MASK_PER;
-	regs->psw.mask &= ~(PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
+	regs->psw.mask &= ~(PSW_MASK_IO | PSW_MASK_EXT);
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
@@ -239,7 +240,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 	__get_cpu_var(current_kprobe) = p;
 	/* Save the interrupt and per flags */
 	kcb->kprobe_saved_imask = regs->psw.mask &
-	    (PSW_MASK_PER | PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK);
+		(PSW_MASK_PER | PSW_MASK_IO | PSW_MASK_EXT);
 	/* Save the control regs that govern PER */
 	__ctl_store(kcb->kprobe_saved_ctl, 9, 11);
 }
@@ -316,8 +317,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		return 1;
 
 ss_probe:
-	if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
-		local_irq_disable();
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_HIT_SS;
 	return 1;
@@ -350,6 +349,7 @@ static int __kprobes trampoline_probe_handler(struct kprobe *p,
 	struct hlist_node *node, *tmp;
 	unsigned long flags, orig_ret_address = 0;
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
+	kprobe_opcode_t *correct_ret_addr = NULL;
 
 	INIT_HLIST_HEAD(&empty_rp);
 	kretprobe_hash_lock(current, &head, &flags);
@@ -372,10 +372,32 @@ static int __kprobes trampoline_probe_handler(struct kprobe *p,
 			/* another task is sharing our hash bucket */
 			continue;
 
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
+		orig_ret_address = (unsigned long)ri->ret_addr;
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	correct_ret_addr = ri->ret_addr;
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
 
 		orig_ret_address = (unsigned long)ri->ret_addr;
+
+		if (ri->rp && ri->rp->handler) {
+			ri->ret_addr = correct_ret_addr;
+			ri->rp->handler(ri, regs);
+		}
+
 		recycle_rp_inst(ri, &empty_rp);
 
 		if (orig_ret_address != trampoline_address) {
@@ -387,7 +409,7 @@ static int __kprobes trampoline_probe_handler(struct kprobe *p,
 			break;
 		}
 	}
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
 	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
 
 	reset_current_kprobe();
@@ -465,8 +487,6 @@ static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 		goto out;
 	}
 	reset_current_kprobe();
-	if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
-		local_irq_enable();
 out:
 	preempt_enable_no_resched();
 
@@ -482,7 +502,7 @@ out:
 	return 1;
 }
 
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+static int __kprobes kprobe_trap_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
@@ -508,8 +528,6 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 			restore_previous_kprobe(kcb);
 		else {
 			reset_current_kprobe();
-			if (regs->psw.mask & (PSW_MASK_PER | PSW_MASK_IO))
-				local_irq_enable();
 		}
 		preempt_enable_no_resched();
 		break;
@@ -553,6 +571,18 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 	return 0;
 }
 
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	int ret;
+
+	if (regs->psw.mask & (PSW_MASK_IO | PSW_MASK_EXT))
+		local_irq_disable();
+	ret = kprobe_trap_handler(regs, trapnr);
+	if (regs->psw.mask & (PSW_MASK_IO | PSW_MASK_EXT))
+		local_irq_restore(regs->psw.mask & ~PSW_MASK_PER);
+	return ret;
+}
+
 /*
  * Wrapper routine to for handling exceptions.
  */
@@ -560,8 +590,12 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
 	struct die_args *args = (struct die_args *)data;
+	struct pt_regs *regs = args->regs;
 	int ret = NOTIFY_DONE;
 
+	if (regs->psw.mask & (PSW_MASK_IO | PSW_MASK_EXT))
+		local_irq_disable();
+
 	switch (val) {
 	case DIE_BPT:
 		if (kprobe_handler(args->regs))
@@ -572,16 +606,17 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 			ret = NOTIFY_STOP;
 		break;
 	case DIE_TRAP:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
+		if (!preemptible() && kprobe_running() &&
+		    kprobe_trap_handler(args->regs, args->trapnr))
 			ret = NOTIFY_STOP;
-		preempt_enable();
 		break;
 	default:
 		break;
 	}
+
+	if (regs->psw.mask & (PSW_MASK_IO | PSW_MASK_EXT))
+		local_irq_restore(regs->psw.mask & ~PSW_MASK_PER);
+
 	return ret;
 }
 
@@ -595,6 +630,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 
 	/* setup return addr to the jprobe handler routine */
 	regs->psw.addr = (unsigned long)(jp->entry) | PSW_ADDR_AMODE;
+	regs->psw.mask &= ~(PSW_MASK_IO | PSW_MASK_EXT);
 
 	/* r14 is the function return address */
 	kcb->jprobe_saved_r14 = (unsigned long)regs->gprs[14];
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 38e641c..45b405c 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -20,18 +20,17 @@
 static inline int gup_pte_range(pmd_t *pmdp, pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
-	unsigned long mask, result;
+	unsigned long mask;
 	pte_t *ptep, pte;
 	struct page *page;
 
-	result = write ? 0 : _PAGE_RO;
-	mask = result | _PAGE_INVALID | _PAGE_SPECIAL;
+	mask = (write ? _PAGE_RO : 0) | _PAGE_INVALID | _PAGE_SPECIAL;
 
 	ptep = ((pte_t *) pmd_deref(pmd)) + pte_index(addr);
 	do {
 		pte = *ptep;
 		barrier();
-		if ((pte_val(pte) & mask) != result)
+		if ((pte_val(pte) & mask) != 0)
 			return 0;
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index 6c40867..b3a3e8e 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -209,29 +209,79 @@ tape_state_set(struct tape_device *device, enum tape_state newstate)
 	wake_up(&device->state_change_wq);
 }
 
+struct tape_med_state_work_data {
+	struct tape_device *device;
+	enum tape_medium_state state;
+	struct work_struct  work;
+};
+
+static void
+tape_med_state_work_handler(struct work_struct *work)
+{
+	static char env_state_loaded[] = "MEDIUM_STATE=LOADED";
+	static char env_state_unloaded[] = "MEDIUM_STATE=UNLOADED";
+	struct tape_med_state_work_data *p =
+		container_of(work, struct tape_med_state_work_data, work);
+	struct tape_device *device = p->device;
+	char *envp[] = { NULL, NULL };
+
+	switch (p->state) {
+	case MS_UNLOADED:
+		pr_info("%s: The tape cartridge has been successfully "
+			"unloaded\n", dev_name(&device->cdev->dev));
+		envp[0] = env_state_unloaded;
+		kobject_uevent_env(&device->cdev->dev.kobj, KOBJ_CHANGE, envp);
+		break;
+	case MS_LOADED:
+		pr_info("%s: A tape cartridge has been mounted\n",
+			dev_name(&device->cdev->dev));
+		envp[0] = env_state_loaded;
+		kobject_uevent_env(&device->cdev->dev.kobj, KOBJ_CHANGE, envp);
+		break;
+	default:
+		break;
+	}
+	tape_put_device(device);
+	kfree(p);
+}
+
+static void
+tape_med_state_work(struct tape_device *device, enum tape_medium_state state)
+{
+	struct tape_med_state_work_data *p;
+
+	p = kzalloc(sizeof(*p), GFP_ATOMIC);
+	if (p) {
+		INIT_WORK(&p->work, tape_med_state_work_handler);
+		p->device = tape_get_device(device);
+		p->state = state;
+		schedule_work(&p->work);
+	}
+}
+
 void
 tape_med_state_set(struct tape_device *device, enum tape_medium_state newstate)
 {
-	if (device->medium_state == newstate)
+	enum tape_medium_state oldstate;
+
+	oldstate = device->medium_state;
+	if (oldstate == newstate)
 		return;
+	device->medium_state = newstate;
 	switch(newstate){
 	case MS_UNLOADED:
 		device->tape_generic_status |= GMT_DR_OPEN(~0);
-		if (device->medium_state == MS_LOADED)
-			pr_info("%s: The tape cartridge has been successfully "
-				"unloaded\n", dev_name(&device->cdev->dev));
+		if (oldstate == MS_LOADED)
+			tape_med_state_work(device, MS_UNLOADED);
 		break;
 	case MS_LOADED:
 		device->tape_generic_status &= ~GMT_DR_OPEN(~0);
-		if (device->medium_state == MS_UNLOADED)
-			pr_info("%s: A tape cartridge has been mounted\n",
-				dev_name(&device->cdev->dev));
+		if (oldstate == MS_UNLOADED)
+			tape_med_state_work(device, MS_LOADED);
 		break;
 	default:
-		// print nothing
 		break;
 	}
-	device->medium_state = newstate;
 	wake_up(&device->state_change_wq);
 }
 
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 9f66142..1cc726b 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -249,27 +249,25 @@ static int vmlogrdr_recording(struct vmlogrdr_priv_t * logptr,
 	char cp_command[80];
 	char cp_response[160];
 	char *onoff, *qid_string;
+	int rc;
 
-	memset(cp_command, 0x00, sizeof(cp_command));
-	memset(cp_response, 0x00, sizeof(cp_response));
-
-        onoff = ((action == 1) ? "ON" : "OFF");
+	onoff = ((action == 1) ? "ON" : "OFF");
 	qid_string = ((recording_class_AB == 1) ? " QID * " : "");
 
-        /*
+	/*
 	 * The recording commands needs to be called with option QID
 	 * for guests that have previlege classes A or B.
 	 * Purging has to be done as separate step, because recording
 	 * can't be switched on as long as records are on the queue.
 	 * Doing both at the same time doesn't work.
 	 */
-
-	if (purge) {
+	if (purge && (action == 1)) {
+		memset(cp_command, 0x00, sizeof(cp_command));
+		memset(cp_response, 0x00, sizeof(cp_response));
 		snprintf(cp_command, sizeof(cp_command),
 			 "RECORDING %s PURGE %s",
 			 logptr->recording_name,
 			 qid_string);
-
 		cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
 	}
 
@@ -279,19 +277,33 @@ static int vmlogrdr_recording(struct vmlogrdr_priv_t * logptr,
 		logptr->recording_name,
 		onoff,
 		qid_string);
-
 	cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
 	/* The recording command will usually answer with 'Command complete'
 	 * on success, but when the specific service was never connected
 	 * before then there might be an additional informational message
 	 * 'HCPCRC8072I Recording entry not found' before the
-         * 'Command complete'. So I use strstr rather then the strncmp.
+	 * 'Command complete'. So I use strstr rather then the strncmp.
 	 */
 	if (strstr(cp_response,"Command complete"))
-		return 0;
+		rc = 0;
 	else
-		return -EIO;
+		rc = -EIO;
+	/*
+	 * If we turn recording off, we have to purge any remaining records
+	 * afterwards, as a large number of queued records may impact z/VM
+	 * performance.
+	 */
+	if (purge && (action == 0)) {
+		memset(cp_command, 0x00, sizeof(cp_command));
+		memset(cp_response, 0x00, sizeof(cp_response));
+		snprintf(cp_command, sizeof(cp_command),
+			 "RECORDING %s PURGE %s",
+			 logptr->recording_name,
+			 qid_string);
+		cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
+	}
 
+	return rc;
 }
 
 
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 2ff8a22..e8391b8 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1455,7 +1455,16 @@ static int io_subchannel_sch_event(struct subchannel *sch, int process)
 		break;
 	case IO_SCH_UNREG_ATTACH:
 	case IO_SCH_UNREG:
-		if (cdev)
+		if (!cdev)
+			break;
+		if (cdev->private->state == DEV_STATE_SENSE_ID) {
+			/*
+			 * Note: delayed work triggered by this event
+			 * and repeated calls to sch_event are synchronized
+			 * by the above check for work_pending(cdev).
+			 */
+			dev_fsm_event(cdev, DEV_EVENT_NOTOPER);
+		} else
 			ccw_device_set_notoper(cdev);
 		break;
 	case IO_SCH_NOP:
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e04b8bc..ea37e2f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -126,7 +126,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if (!ARM_UNWIND)
+	select FRAME_POINTER if !ARM_UNWIND && !S390
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
