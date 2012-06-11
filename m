Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2FKFqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:46:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:63846 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2FKFq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163998959"
Message-ID: <4FD58632.1010903@linux.intel.com>
Date: Mon, 11 Jun 2012 13:46:26 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
References: <20120606214941.104735929@linutronix.de> <4FD07D8F.5020303@linux.intel.com> <alpine.LFD.2.02.1206080940360.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206080940360.3086@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/8 15:49, Thomas Gleixner 写道:
> On Thu, 7 Jun 2012, Chen Gong wrote:
>>
>> But during the CPU online/offline test I found an issue. After *STORM*
>> mode is entered, it can't come back from *STORM* mode to normal
>> interrupt mode. At least there exists such an issue: when *STORM* is
>> entered, in the meanwhile, one CPU is offline during this period,
>> which means *cmci_storm_on_cpus* can't decrease to 0 because there
>> is one bit stuck on this offlined CPU. So we should detect such
>> situation and decrease on *cmci_storm_on_cpus* at proper time.
>
> Yes, we need to reset the storm state as well I think.
>
>> BTW, even I online the *CPU* in above situation, the normal CMCI
>> still doesn't come back, strange.
>
> That's weird.

Here is the reason. When CPU offline and then online, the CMCI is
reenabled, which means it opens a backdoor to enable *CMCI storm detect*
again. The result is the counter cmci_sotrm_cnt is increased again
before it decreases to zero. At last, this counter will never be back
to zero, irrelevant to CPU online. Obviously, we must stop CMCI enabling
again before CMCI storm ends, even during CPU online/offline. Besides
this, we still need to remove the count if one CPU is offlined. Like
below tmp patch I wrote (not guarantee it is OK :-))

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h 
b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 2cd73ce..6a05c1d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -31,9 +31,11 @@ extern struct mce_bank *mce_banks;
  #ifdef CONFIG_X86_MCE_INTEL
  unsigned long mce_intel_adjust_timer(unsigned long interval);
  void mce_intel_cmci_poll(void);
+void mce_intel_hcpu_update(unsigned long cpu);
  #else
  # define mce_intel_adjust_timer mce_adjust_timer_default
  static inline void mce_intel_cmci_poll(void) { }
+static inline void mce_intel_hcpu_update(unsigned long cpu) { }
  #endif

  void mce_timer_kick(unsigned long interval);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c 
b/arch/x86/kernel/cpu/mcheck/mce.c
index e3f8b94..5e22d99 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2306,6 +2306,7 @@ mce_cpu_callback(struct notifier_block *nfb, 
unsigned long action, void *hcpu)
  		if (threshold_cpu_callback)
  			threshold_cpu_callback(action, cpu);
  		mce_device_remove(cpu);
+		mce_intel_hcpu_update(cpu);
  		break;
  	case CPU_DOWN_PREPARE:
  		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c 
b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 92d8b5c..0051b2d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -40,6 +40,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
  static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
  static DEFINE_PER_CPU(unsigned int, cmci_storm_cnt);
  static DEFINE_PER_CPU(unsigned int, cmci_storm_state);
+static DEFINE_PER_CPU(unsigned long, cmci_storm_hcpu_status);

  enum {
  	CMCI_STORM_NONE,
@@ -47,6 +48,11 @@ enum {
  	CMCI_STORM_SUBSIDED,
  };

+enum {
+	CMCI_STORM_HCPU_NONE,
+	CMCI_STORM_HCPU_ACTIVE,
+};
+
  static atomic_t cmci_storm_on_cpus;

  static int cmci_supported(int *banks)
@@ -77,6 +83,17 @@ void mce_intel_cmci_poll(void)
  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
  }

+void mce_intel_hcpu_update(unsigned long cpu)
+{
+	unsigned long *status = &per_cpu(cmci_storm_hcpu_status, cpu);
+
+	if (*status == CMCI_STORM_HCPU_ACTIVE) {
+		*status = CMCI_STORM_HCPU_NONE;
+		atomic_dec(&cmci_storm_on_cpus);
+		per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
+	}	
+}
+
  unsigned long mce_intel_adjust_timer(unsigned long interval)
  {
  	if (interval < CMCI_POLL_INTERVAL)
@@ -132,6 +149,7 @@ static bool cmci_storm_detect(void)

  	cmci_clear();
  	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
+	__this_cpu_write(cmci_storm_hcpu_status, CMCI_STORM_HCPU_ACTIVE);
  	atomic_inc(&cmci_storm_on_cpus);
  	mce_timer_kick(CMCI_POLL_INTERVAL);
  	return true;


>
>> I still have another question: When we handle following case:
>> mce_cpu_callback(struct notifier_block *
>> 		mce_device_remove(cpu);
>> 		break;
>> 	case CPU_DOWN_PREPARE:
>> -		del_timer_sync(t);
>> 		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
>> + 		del_timer_sync(t);
>> 		break;
>>
>> Where we add this timer back? I can't find it in "case CPU_ONLINE".
>
> The timer gets added back via mcheck_cpu_init(), which is called on
> the newly onlined cpu from smp_callin().

Stupid me! I must too busy that day so that I lost my head. :-(.
Thanks Tomas for your explanation!

>
> Thanks,
>
> 	tglx
>
>


