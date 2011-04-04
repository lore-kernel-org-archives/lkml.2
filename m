Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1DDOaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:30:30 -0400
Received: from toro.web-alm.net ([62.245.132.31]:37406 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab1DDOa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:30:29 -0400
Message-ID: <4D99D38E.9040700@osadl.org>
Date: Mon, 04 Apr 2011 16:19:58 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>, Greg KH <gregkh@suse.de>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Holler <holler@ahsoftware.de>
Subject: Re: Intel i7/X 980 freezes with CONFIG_INTEL_IDLE and frequency scaling
References: <20110321204104.GA2702@kroah.com> <4D96D147.60607@osadl.org>
In-Reply-To: <4D96D147.60607@osadl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2011 09:33 AM, Carsten Emde wrote:
> after upgrading a Fedora 14 based Intel i7/X 980 box to 2.6.39-rc1, the
> system freezes when frequency scaling is started. Looks like a complete
> CPU halt, since neither SysRq nor anything else can convince the box to
> provide any information.
> Loading acpi_cpufreq is save, but selecting the performance
> scaling_governor immediately freezes the system. Selecting the ondemand
> scaling_governor freezes the system when load is generated for the first
> time, presumably when the frequency is increased. Fortunately, when the
> kernel was built with another config file, the system did not freeze.
> After enabling and disabling some suspicious config items (before going
> through the hassle and bisect the config using ktest.pl), the culprit
> was found to be CONFIG_INTEL_IDLE. Fedora 14 enables it.
While digging deeper into this mystery, I found a detail that may 
connect this problem to the poweroff problem 
(https://lkml.org/lkml/2011/3/31/458).

The CPU (i7/X 980 box) apparently freezes when it executes

__monitor(&current_thread_info()->flags, 0, 0);

which is

static inline void __monitor(const void *eax, unsigned long ecx,
                              unsigned long edx)
{
         /* "monitor %eax, %ecx, %edx;" */
         asm volatile(".byte 0x0f, 0x01, 0xc8;"
                      :: "a" (eax), "c" (ecx), "d"(edx));
}

After removing this line from the execution path (see below patch), the 
problem is gone and the system no longer freezes when processor 
frequency scaling is enabled. I double-checked this, so I am pretty sure 
that this is, in fact, the case.

Interestingly, the __monitor() command is also used in mwait_play_dead() 
at arch/x86/kernel/smpboot.c where the poweroff problem is originating. 
Maybe, a misbehavior of this instruction also causes the poweroff problem.

But we should solve this problem first. Len or anybody else at Intel, I 
don't think that I can go any further without your help. Do you have any 
explanation what is going on here when the processor

vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz
stepping	: 2

encounters the above instruction?

Thanks,
	-Carsten.


Index: linux-2.6.39-rc1/drivers/idle/intel_idle.c
===================================================================
--- linux-2.6.39-rc1.orig/drivers/idle/intel_idle.c
+++ linux-2.6.39-rc1/drivers/idle/intel_idle.c
@@ -99,11 +99,54 @@ static unsigned long long auto_demotion_
   */
  #define CPUIDLE_FLAG_TLB_FLUSHED	0x10000

+static int intel_idle_monitor(struct cpuidle_device *dev,
+	struct cpuidle_state *state, int monitor);
+
+static int intel_idle_westmere(struct cpuidle_device *dev,
+	struct cpuidle_state *state)
+{
+	return intel_idle_monitor(dev, state, 0);
+}
+
+static int intel_idle(struct cpuidle_device *dev,
+	struct cpuidle_state *state)
+{
+	return intel_idle_monitor(dev, state, 1);
+}
+
  /*
   * States are indexed by the cstate number,
   * which is also the index into the MWAIT hint array.
   * Thus C0 is a dummy.
   */
+static struct cpuidle_state westmere_cstates[MWAIT_MAX_NUM_CSTATES] = {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name = "C1-NHM",
+		.desc = "MWAIT 0x00",
+		.driver_data = (void *) 0x00,
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 3,
+		.target_residency = 6,
+		.enter = &intel_idle_westmere },
+	{ /* MWAIT C2 */
+		.name = "C3-NHM",
+		.desc = "MWAIT 0x10",
+		.driver_data = (void *) 0x10,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 20,
+		.target_residency = 80,
+		.enter = &intel_idle_westmere },
+	{ /* MWAIT C3 */
+		.name = "C6-NHM",
+		.desc = "MWAIT 0x20",
+		.driver_data = (void *) 0x20,
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 200,
+		.target_residency = 800,
+		.enter = &intel_idle_westmere },
+};
+
  static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
  	{ /* MWAIT C0 */ },
  	{ /* MWAIT C1 */
@@ -212,7 +255,8 @@ static struct cpuidle_state atom_cstates
   * @state: cpuidle state
   *
   */
-static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state 
*state)
+static int intel_idle_monitor(struct cpuidle_device *dev,
+	struct cpuidle_state *state, int monitor)
  {
  	unsigned long ecx = 1; /* break on interrupt flag */
  	unsigned long eax = (unsigned long)cpuidle_get_statedata(state);
@@ -239,8 +283,8 @@ static int intel_idle(struct cpuidle_dev

  	stop_critical_timings();
  	if (!need_resched()) {
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		if (monitor)
+			__monitor((void *)&current_thread_info()->flags, 0, 0);
  		smp_mb();
  		if (!need_resched())
  			__mwait(eax, ecx);
@@ -338,12 +382,17 @@ static int intel_idle_probe(void)
  	case 0x2E:	/* Nehalem-EX Xeon */
  	case 0x2F:	/* Westmere-EX Xeon */
  	case 0x25:	/* Westmere */
-	case 0x2C:	/* Westmere */
  		cpuidle_state_table = nehalem_cstates;
  		auto_demotion_disable_flags =
  			(NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE);
  		break;

+	case 0x2C:	/* Special Westmere? */
+		cpuidle_state_table = westmere_cstates;
+		auto_demotion_disable_flags =
+			(NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE);
+		break;
+
  	case 0x1C:	/* 28 - Atom Processor */
  		cpuidle_state_table = atom_cstates;
  		break;
