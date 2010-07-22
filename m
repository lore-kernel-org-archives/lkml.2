Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0GVXEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:04:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37527 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0GVXEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:04:24 -0400
Message-ID: <4C48CD0D.5020201@kernel.org>
Date: Thu, 22 Jul 2010 15:58:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: fweisbec@gmail.com, peterz@infradead.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: perf swallows all NMIs when registered with a user
References: <20100722215136.GA23517@redhat.com>
In-Reply-To: <20100722215136.GA23517@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C48CD14.0269,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 02:51 PM, Don Zickus wrote:
> Hi,
> 
> When debugging a problem with Yinghai, I noticed that when the perf event
> subsystem has a user (in this case the new generic nmi_watchdog), it just
> blindly swallows all the NMIs in the system.
> 
> This causes issues for people like Yinghai, who want to use an external
> nmi button to generate a panic, or other big companies that like to
> registered the nmi handlers at a lower priority to be a catch-all for NMI
> problems or also it will start masking any unknown nmi problems that would
> have cropped up due to broken firmware or such.
> 
> The problem is spelled out in the comment in
> arch/x86/kernel/cpu/perf_event.c::perf_event_nmi_handler
> 
> perf_event_nmi_handler(struct notifier_block *self,
>                          unsigned long cmd, void *__args)
> {
>         struct die_args *args = __args;
>         struct pt_regs *regs;
>         static int eat_nmis = 0;
> 
>         if (!atomic_read(&active_events))
>                 return NOTIFY_DONE;
> 
>         switch (cmd) {
>         case DIE_NMI:
>         case DIE_NMI_IPI:
>                 break;
> 
>         default:
>                 return NOTIFY_DONE;
>         }
> 
>         regs = args->regs;
> 
>         apic_write(APIC_LVTPC, APIC_DM_NMI);
>         /*
>          * Can't rely on the handled return value to say it was our NMI,
>          * two
>          * events could trigger 'simultaneously' raising two back-to-back
>          * NMIs.
>          *
>          * If the first NMI handles both, the latter will be empty and
>          * daze
>          * the CPU.
>          */
>         x86_pmu.handle_irq(regs);
> 
>         return NOTIFY_STOP;
> }
> 
> In the normal case, there is no perf user, so the function returns with
> NOTIFY_DONE right away.  But with the new nmi_watchdog, which is a user of
> the perf subsystem, it catches DIE_NMI, executes x86_pmu.handle_irq, and
> finally returns NOTIFY_STOP.
> 
> The comment above describes the problem well, but as a result no other
> NMIs can get through.
> 
> I looked at the code and thought I could modify the handle_irq to only
> handle one PMU at a time, with the thought that there is probably another
> NMI waiting for the other PMUs.  This would handle the problem nicely.
> 
> But I believe the code is structured such that an event can occupy more
> than one PMU in complex cases and as a result would probably break things
> because the event would be in limbo until all the NMIs happened to
> disable it??  I am not familiar enough with how perf works to know if that
> case is correct or not.
> 
> So I hacked up some stupid code to start a conversation that just keeps
> track of how many NMIs are supposed to happen based on the number of PMUs
> handled.  Then on future NMIs those are 'eaten' until the count is zero
> again.
> 
> Like I said this patch is just something to start a conversation.  I
> tested it, but could not do anything complicated enough such that more
> than one PMU was handled during one NMI call.
> 
> Comments?
> 
> Cheers,
> Don
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index f2da20f..df6255c 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1154,7 +1156,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
>  		/*
>  		 * event overflow
>  		 */
> -		handled		= 1;
> +		handled		+= 1;
>  		data.period	= event->hw.last_period;
>  
>  		if (!x86_perf_event_set_period(event))
> @@ -1206,6 +1210,7 @@ perf_event_nmi_handler(struct notifier_block *self,
>  {
>  	struct die_args *args = __args;
>  	struct pt_regs *regs;
> +	static int eat_nmis = 0;
>  
>  	if (!atomic_read(&active_events))
>  		return NOTIFY_DONE;
> @@ -1229,9 +1234,13 @@ perf_event_nmi_handler(struct notifier_block *self,
>  	 * If the first NMI handles both, the latter will be empty and daze
>  	 * the CPU.
>  	 */
> -	x86_pmu.handle_irq(regs);
> +	eat_nmis += x86_pmu.handle_irq(regs);
> +	if (eat_nmis) {
> +		eat_nmis--;
> +		return NOTIFY_STOP;
> +	}
>  
> -	return NOTIFY_STOP;
> +	return NOTIFY_DONE;
>  }
>  
>  static __read_mostly struct notifier_block perf_event_nmi_notifier = {

cool, with your patch and following patch i can use nmi button now with CONFIG_LOCKUP_DETECTOR defined

[PATCH] x86,nmi: move unknown_nmi_panic to traps.c

So we use it even LOCKUP_DETECTOR is defined.

need Don's patch...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/nmi.h    |    8 --------
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/apic/nmi.c    |   27 ---------------------------
 arch/x86/kernel/traps.c       |   29 ++++++++++++++++++++++++++++-
 kernel/sysctl.c               |    4 +++-
 5 files changed, 31 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/nmi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/nmi.c
+++ linux-2.6/arch/x86/kernel/apic/nmi.c
@@ -37,7 +37,6 @@
 
 #include <asm/mach_traps.h>
 
-int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
 /* For reliability, we're prepared to waste bits here. */
@@ -483,23 +482,6 @@ static void disable_ioapic_nmi_watchdog(
 	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
 }
 
-static int __init setup_unknown_nmi_panic(char *str)
-{
-	unknown_nmi_panic = 1;
-	return 1;
-}
-__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
-
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
-{
-	unsigned char reason = get_nmi_reason();
-	char buf[64];
-
-	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(buf, regs, 1); /* Always panic here */
-	return 0;
-}
-
 /*
  * proc handler for /proc/sys/kernel/nmi
  */
@@ -540,15 +522,6 @@ int proc_nmi_enabled(struct ctl_table *t
 
 #endif /* CONFIG_SYSCTL */
 
-int do_nmi_callback(struct pt_regs *regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
Index: linux-2.6/arch/x86/kernel/apic/hw_nmi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/hw_nmi.c
+++ linux-2.6/arch/x86/kernel/apic/hw_nmi.c
@@ -100,7 +100,6 @@ void acpi_nmi_disable(void) { return; }
 #endif
 atomic_t nmi_active = ATOMIC_INIT(0);           /* oprofile uses this */
 EXPORT_SYMBOL(nmi_active);
-int unknown_nmi_panic;
 void cpu_nmi_set_wd_enabled(void) { return; }
 void stop_apic_nmi_watchdog(void *unused) { return; }
 void setup_apic_nmi_watchdog(void *unused) { return; }
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -377,6 +377,33 @@ unknown_nmi_error(unsigned char reason,
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_X86_LOCAL_APIC)
+int unknown_nmi_panic;
+static int __init setup_unknown_nmi_panic(char *str)
+{
+	unknown_nmi_panic = 1;
+	return 1;
+}
+__setup("unknown_nmi_panic", setup_unknown_nmi_panic);
+
+static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
+{
+	unsigned char reason = get_nmi_reason();
+	char buf[64];
+
+	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
+	die_nmi(buf, regs, 1); /* Always panic here */
+	return 0;
+}
+
+static int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+	return 0;
+}
+#endif
+
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
@@ -405,8 +432,8 @@ static notrace __kprobes void default_do
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, cpu))
 #endif /* !CONFIG_LOCKUP_DETECTOR */
+		if (!do_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -741,7 +741,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one,
 	},
 #endif
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.procname       = "unknown_nmi_panic",
 		.data           = &unknown_nmi_panic,
@@ -749,6 +749,8 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec,
 	},
+#endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86) && !defined(CONFIG_LOCKUP_DETECTOR)
 	{
 		.procname       = "nmi_watchdog",
 		.data           = &nmi_watchdog_enabled,
Index: linux-2.6/arch/x86/include/asm/nmi.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/nmi.h
+++ linux-2.6/arch/x86/include/asm/nmi.h
@@ -7,14 +7,6 @@
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
 
-/**
- * do_nmi_callback
- *
- * Check to see if a callback exists and execute it.  Return 1
- * if the handler exists and was handled successfully.
- */
-int do_nmi_callback(struct pt_regs *regs, int cpu);
-
 extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 #if !defined(CONFIG_LOCKUP_DETECTOR)

