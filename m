Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0J0Qpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0J0Qpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:45:52 -0400
Date: Wed, 27 Oct 2010 12:45:22 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
Message-ID: <20101027164522.GA25738@redhat.com>
References: <1286844650.7768.137.camel@yhuang-dev>
 <1286863479.2336.1451.camel@twins>
 <1286864080.7768.179.camel@yhuang-dev>
 <1286865071.2336.1478.camel@twins>
 <1286865447.7768.184.camel@yhuang-dev>
 <1286865629.2336.1490.camel@twins>
 <1286865923.7768.188.camel@yhuang-dev>
 <1286866193.2336.1503.camel@twins>
 <20101012135112.GE20436@basil.fritz.box>
 <1286892927.29097.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286892927.29097.42.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 04:15:27PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-10-12 at 15:51 +0200, Andi Kleen wrote:
> > > No, its not making sense, there's only one event source - the NMI, it
> > > doesn't make any sense what so ever to then artificially split it in
> > > two.
> > 
> > I can see that "unknown NMI" is a different kind of event than
> > "NMI event triggered"
> > 
> > e.g. the debugger would only hook into "unknown NMI"
> 
> Sure, I'm not arguing about DIE_NMI vs DIE_NMI_UNKNOWN. I simply don't
> see the point of DIE_NMI_IPI.

I threw together a patch last week and did some panic and perf testing on
it.  Things still seemed to work correctly.  This patch goes on top of the
3/6 patch in this thread.

I assume this is sorta of what Peter was looking for.

Cheers,
Don


diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 5bdfca8..e28ec43 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -18,7 +18,6 @@ enum die_val {
 	DIE_TRAP,
 	DIE_GPF,
 	DIE_CALL,
-	DIE_NMI_IPI,
 	DIE_PAGE_FAULT,
 	DIE_NMIUNKNOWN,
 };
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index cefd694..7f9e3ac 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -53,7 +53,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 
 	switch (cmd) {
 	case DIE_NMI:
-	case DIE_NMI_IPI:
 		break;
 
 	default:
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f744f54..1f657a2 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -602,7 +602,7 @@ void __cpuinit uv_cpu_init(void)
  */
 int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
 {
-	if (reason != DIE_NMI_IPI)
+	if (reason != DIE_NMIUNKNOWN)
 		return NOTIFY_OK;
 
 	if (in_crash_kexec)
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e7dbde7..7e0dba6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -83,7 +83,7 @@ static int mce_raise_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
-	if (val != DIE_NMI_IPI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
+	if (val != DIE_NMI || !cpumask_test_cpu(cpu, mce_inject_cpumask))
 		return NOTIFY_DONE;
 	cpumask_clear_cpu(cpu, mce_inject_cpumask);
 	if (m->inject_flags & MCJ_EXCEPTION)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index da98b6d..ccd3b6d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1226,7 +1226,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 
 	switch (cmd) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 852b819..805c5ab 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -523,10 +523,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 		}
 		return NOTIFY_DONE;
 
-	case DIE_NMI_IPI:
-		/* Just ignore, we will handle the roundup on DIE_NMI. */
-		return NOTIFY_DONE;
-
 	case DIE_NMIUNKNOWN:
 		if (was_in_debug_nmi[raw_smp_processor_id()]) {
 			was_in_debug_nmi[raw_smp_processor_id()] = 0;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e3af342..fd7dc85 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -753,7 +753,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 {
 	int cpu;
 
-	if (val != DIE_NMI_IPI)
+	if (val != DIE_NMI)
 		return NOTIFY_OK;
 
 	cpu = raw_smp_processor_id();
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d8acab3..9e56e3d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -395,8 +395,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	 * CPU-specific NMI: send to specific CPU or NMI sources must
 	 * be processed on specific CPU
 	 */
-	if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, 0, 2, SIGINT)
-	    == NOTIFY_STOP)
+	if (notify_die(DIE_NMI, "nmi_ipi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
@@ -405,9 +404,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	if (!cpu) {
 		reason = get_nmi_reason();
 		if (reason & NMI_REASON_MASK) {
-			if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			    == NOTIFY_STOP)
-				return;
 			if (reason & NMI_REASON_SERR)
 				pci_serr_error(reason, regs);
 			else if (reason & NMI_REASON_IOCHK)
@@ -423,9 +419,6 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		}
 	}
 
-	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
-		return;
-
 #if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
 	if (nmi_watchdog_tick(regs, reason))
 		return;
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 57f01bb..dd0039c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -64,7 +64,7 @@ static int profile_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		if (ctr_running)
 			model->check_ctrs(args->regs, &__get_cpu_var(cpu_msrs));
 		else if (!nmi_enabled)
diff --git a/arch/x86/oprofile/nmi_timer_int.c b/arch/x86/oprofile/nmi_timer_int.c
index ab72a21..e3ecb71 100644
--- a/arch/x86/oprofile/nmi_timer_int.c
+++ b/arch/x86/oprofile/nmi_timer_int.c
@@ -25,7 +25,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
 	int ret = NOTIFY_DONE;
 
 	switch (val) {
-	case DIE_NMI_IPI:
+	case DIE_NMI:
 		oprofile_add_sample(args->regs, 0);
 		ret = NOTIFY_STOP;
 		break;
