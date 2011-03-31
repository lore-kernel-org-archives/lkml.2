Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1CaDRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:17:03 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:57926 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab1CaDRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:17:00 -0400
Date: Wed, 30 Mar 2011 23:16:29 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-pm@lists.linux-foundation.org
Subject: [PATCH] x86 idle APM: delete apm_cpu_idle(), and its use of pm_idle
In-reply-to: <alpine.LNX.2.00.1103282309290.26754@pobox.suse.cz>
Message-id: <alpine.LFD.2.02.1103302311500.2444@x980>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>
 <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
 <20110329004438.d9e755ef.sfr@canb.auug.org.au>
 <alpine.LNX.2.00.1103281604040.26754@pobox.suse.cz>
 <20110328174542.GW21838@one.firstfloor.org> <4D90CC0B.8070105@zytor.com>
 <20110328182123.GX21838@one.firstfloor.org>
 <AANLkTimqE2YZCH5GonnqeHGGBwzggTymauS1KYuTsqOX@mail.gmail.com>
 <alpine.LNX.2.00.1103282309290.26754@pobox.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

There is some doubt whether the APM idle feature
to call into the BIOS from the idle loop is reliable.
Certainly it was known to fail on some machines,
but more importantly, APM machines have not shipped
for a decade and so finding machines to test the code
is problematic.

After this patch, systems running in APM mode will
simply run default_idle() and HALT without calling
into the BIOS from their idle loop.

This deletes a much-maligned modular user of the (pm_idle)()
function pointer.

Signed-off-by: Len Brown <len.brown@intel.com>
---
Jiri,
If you can review, test, ack, that would be great.
I'll probably end up shipping this via the idle tree
because subsequent patches to delete pm_idle
will depend on it.

thanks,
-Len

 arch/x86/Kconfig         |   11 --
 arch/x86/kernel/apm_32.c |  232 ----------------------------------------------
 2 files changed, 0 insertions(+), 243 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..681bb25 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1809,17 +1809,6 @@ config APM_DO_ENABLE
 	  T400CDT. This is off by default since most machines do fine without
 	  this feature.
 
-config APM_CPU_IDLE
-	bool "Make CPU Idle calls when idle"
-	---help---
-	  Enable calls to APM CPU Idle/CPU Busy inside the kernel's idle loop.
-	  On some machines, this can activate improved power savings, such as
-	  a slowed CPU clock rate, when the machine is idle. These idle calls
-	  are made after the idle loop has run for some length of time (e.g.,
-	  333 mS). On some machines, this will cause a hang at boot time or
-	  whenever the CPU becomes idle. (On machines with more than one CPU,
-	  this option does nothing.)
-
 config APM_DISPLAY_BLANK
 	bool "Enable console blanking using APM"
 	---help---
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 0e4f24c..5bc37aa 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -175,8 +175,6 @@
  *         Ignore first resume after we generate our own resume event
  *         after a suspend (Thomas Hood)
  *         Daemonize now gets rid of our controlling terminal (sfr).
- *         CONFIG_APM_CPU_IDLE now just affects the default value of
- *         idle_threshold (sfr).
  *         Change name of kernel apm daemon (as it no longer idles) (sfr).
  *   1.16ac: Fix up SMP support somewhat. You can now force SMP on and we
  *	   make _all_ APM calls on the CPU#0. Fix unsafe sign bug.
@@ -261,12 +259,6 @@ extern int (*console_blank_hook)(int);
  *	    [no-]smp			Use apm even on an SMP box
  *	    bounce[-_]interval=<n>	number of ticks to ignore suspend
  *	    				bounces
- *          idle[-_]threshold=<n>       System idle percentage above which to
- *                                      make APM BIOS idle calls. Set it to
- *                                      100 to disable.
- *          idle[-_]period=<n>          Period (in 1/100s of a second) over
- *                                      which the idle percentage is
- *                                      calculated.
  */
 
 /* KNOWN PROBLEM MACHINES:
@@ -356,26 +348,12 @@ struct apm_user {
 #define APM_BIOS_MAGIC		0x4101
 
 /*
- * idle percentage above which bios idle calls are done
- */
-#ifdef CONFIG_APM_CPU_IDLE
-#define DEFAULT_IDLE_THRESHOLD	95
-#else
-#define DEFAULT_IDLE_THRESHOLD	100
-#endif
-#define DEFAULT_IDLE_PERIOD	(100 / 3)
-
-/*
  * Local variables
  */
 static struct {
 	unsigned long	offset;
 	unsigned short	segment;
 } apm_bios_entry;
-static int clock_slowed;
-static int idle_threshold __read_mostly = DEFAULT_IDLE_THRESHOLD;
-static int idle_period __read_mostly = DEFAULT_IDLE_PERIOD;
-static int set_pm_idle;
 static int suspends_pending;
 static int standbys_pending;
 static int ignore_sys_suspend;
@@ -805,165 +783,6 @@ static int set_system_power_state(u_short state)
 }
 
 /**
- *	apm_do_idle	-	perform power saving
- *
- *	This function notifies the BIOS that the processor is (in the view
- *	of the OS) idle. It returns -1 in the event that the BIOS refuses
- *	to handle the idle request. On a success the function returns 1
- *	if the BIOS did clock slowing or 0 otherwise.
- */
-
-static int apm_do_idle(void)
-{
-	u32 eax;
-	u8 ret = 0;
-	int idled = 0;
-	int polling;
-	int err = 0;
-
-	polling = !!(current_thread_info()->status & TS_POLLING);
-	if (polling) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-	}
-	if (!need_resched()) {
-		idled = 1;
-		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
-	}
-	if (polling)
-		current_thread_info()->status |= TS_POLLING;
-
-	if (!idled)
-		return 0;
-
-	if (ret) {
-		static unsigned long t;
-
-		/* This always fails on some SMP boards running UP kernels.
-		 * Only report the failure the first 5 times.
-		 */
-		if (++t < 5) {
-			printk(KERN_DEBUG "apm_do_idle failed (%d)\n", err);
-			t = jiffies;
-		}
-		return -1;
-	}
-	clock_slowed = (apm_info.bios.flags & APM_IDLE_SLOWS_CLOCK) != 0;
-	return clock_slowed;
-}
-
-/**
- *	apm_do_busy	-	inform the BIOS the CPU is busy
- *
- *	Request that the BIOS brings the CPU back to full performance.
- */
-
-static void apm_do_busy(void)
-{
-	u32 dummy;
-	int err;
-
-	if (clock_slowed || ALWAYS_CALL_BUSY) {
-		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy, &err);
-		clock_slowed = 0;
-	}
-}
-
-/*
- * If no process has really been interested in
- * the CPU for some time, we want to call BIOS
- * power management - we probably want
- * to conserve power.
- */
-#define IDLE_CALC_LIMIT	(HZ * 100)
-#define IDLE_LEAKY_MAX	16
-
-static void (*original_pm_idle)(void) __read_mostly;
-
-/**
- * apm_cpu_idle		-	cpu idling for APM capable Linux
- *
- * This is the idling function the kernel executes when APM is available. It
- * tries to do BIOS powermanagement based on the average system idle time.
- * Furthermore it calls the system default idle routine.
- */
-
-static void apm_cpu_idle(void)
-{
-	static int use_apm_idle; /* = 0 */
-	static unsigned int last_jiffies; /* = 0 */
-	static unsigned int last_stime; /* = 0 */
-
-	int apm_idle_done = 0;
-	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
-	unsigned int bucket;
-
-recalc:
-	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
-		use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
-	} else if (jiffies_since_last_check > idle_period) {
-		unsigned int idle_percentage;
-
-		idle_percentage = current->stime - last_stime;
-		idle_percentage *= 100;
-		idle_percentage /= jiffies_since_last_check;
-		use_apm_idle = (idle_percentage > idle_threshold);
-		if (apm_info.forbid_idle)
-			use_apm_idle = 0;
-		last_jiffies = jiffies;
-		last_stime = current->stime;
-	}
-
-	bucket = IDLE_LEAKY_MAX;
-
-	while (!need_resched()) {
-		if (use_apm_idle) {
-			unsigned int t;
-
-			t = jiffies;
-			switch (apm_do_idle()) {
-			case 0:
-				apm_idle_done = 1;
-				if (t != jiffies) {
-					if (bucket) {
-						bucket = IDLE_LEAKY_MAX;
-						continue;
-					}
-				} else if (bucket) {
-					bucket--;
-					continue;
-				}
-				break;
-			case 1:
-				apm_idle_done = 1;
-				break;
-			default: /* BIOS refused */
-				break;
-			}
-		}
-		if (original_pm_idle)
-			original_pm_idle();
-		else
-			default_idle();
-		local_irq_disable();
-		jiffies_since_last_check = jiffies - last_jiffies;
-		if (jiffies_since_last_check > idle_period)
-			goto recalc;
-	}
-
-	if (apm_idle_done)
-		apm_do_busy();
-
-	local_irq_enable();
-}
-
-/**
  *	apm_power_off	-	ask the BIOS to power off
  *
  *	Handle the power off sequence. This is the one piece of code we
@@ -1881,12 +1700,6 @@ static int __init apm_setup(char *str)
 		if ((strncmp(str, "bounce-interval=", 16) == 0) ||
 		    (strncmp(str, "bounce_interval=", 16) == 0))
 			bounce_interval = simple_strtol(str + 16, NULL, 0);
-		if ((strncmp(str, "idle-threshold=", 15) == 0) ||
-		    (strncmp(str, "idle_threshold=", 15) == 0))
-			idle_threshold = simple_strtol(str + 15, NULL, 0);
-		if ((strncmp(str, "idle-period=", 12) == 0) ||
-		    (strncmp(str, "idle_period=", 12) == 0))
-			idle_period = simple_strtol(str + 12, NULL, 0);
 		invert = (strncmp(str, "no-", 3) == 0) ||
 			(strncmp(str, "no_", 3) == 0);
 		if (invert)
@@ -1898,7 +1711,6 @@ static int __init apm_setup(char *str)
 			power_off = !invert;
 		if (strncmp(str, "smp", 3) == 0) {
 			smp = !invert;
-			idle_threshold = 100;
 		}
 		if ((strncmp(str, "allow-ints", 10) == 0) ||
 		    (strncmp(str, "allow_ints", 10) == 0))
@@ -1999,17 +1811,6 @@ static int __init apm_is_horked_d850md(const struct dmi_system_id *d)
 	return 0;
 }
 
-/* Some APM bioses hang on APM idle calls */
-static int __init apm_likes_to_melt(const struct dmi_system_id *d)
-{
-	if (apm_info.forbid_idle == 0) {
-		apm_info.forbid_idle = 1;
-		printk(KERN_INFO "%s machine detected. "
-		       "Disabling APM idle calls.\n", d->ident);
-	}
-	return 0;
-}
-
 /*
  *  Check for clue free BIOS implementations who use
  *  the following QA technique
@@ -2150,16 +1951,6 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
 			DMI_MATCH(DMI_BIOS_VERSION, "A11"), },
 	},
-	{	/* APM idle hangs */
-		apm_likes_to_melt, "Jabil AMD",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-			DMI_MATCH(DMI_BIOS_VERSION, "0AASNP06"), },
-	},
-	{	/* APM idle hangs */
-		apm_likes_to_melt, "AMI Bios",
-		{	DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-			DMI_MATCH(DMI_BIOS_VERSION, "0AASNP05"), },
-	},
 	{	/* Handle problems with APM on Sony Vaio PCG-N505X(DE) */
 		swab_apm_power_in_minutes, "Sony VAIO",
 		{	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
@@ -2390,14 +2181,6 @@ static int __init apm_init(void)
 	if (misc_register(&apm_device))
 		printk(KERN_WARNING "apm: Could not register misc device.\n");
 
-	if (HZ != 100)
-		idle_period = (idle_period * HZ) / 100;
-	if (idle_threshold < 100) {
-		original_pm_idle = pm_idle;
-		pm_idle  = apm_cpu_idle;
-		set_pm_idle = 1;
-	}
-
 	return 0;
 }
 
@@ -2405,15 +2188,6 @@ static void __exit apm_exit(void)
 {
 	int error;
 
-	if (set_pm_idle) {
-		pm_idle = original_pm_idle;
-		/*
-		 * We are about to unload the current idle thread pm callback
-		 * (pm_idle), Wait for all processors to update cached/local
-		 * copies of pm_idle before proceeding.
-		 */
-		cpu_idle_wait();
-	}
 	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
 	    && (apm_info.connection_version > 0x0100)) {
 		error = apm_engage_power_management(APM_DEVICE_ALL, 0);
@@ -2451,12 +2225,6 @@ MODULE_PARM_DESC(broken_psr, "BIOS has a broken GetPowerStatus call");
 module_param(realmode_power_off, bool, 0444);
 MODULE_PARM_DESC(realmode_power_off,
 		"Switch to real mode before powering off");
-module_param(idle_threshold, int, 0444);
-MODULE_PARM_DESC(idle_threshold,
-	"System idle percentage above which to make APM BIOS idle calls");
-module_param(idle_period, int, 0444);
-MODULE_PARM_DESC(idle_period,
-	"Period (in sec/100) over which to caculate the idle percentage");
 module_param(smp, bool, 0444);
 MODULE_PARM_DESC(smp,
 	"Set this to enable APM use on an SMP platform. Use with caution on older systems");
-- 
1.7.4.2.406.gbe91

