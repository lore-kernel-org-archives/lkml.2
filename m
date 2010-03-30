Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0C3I46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:56:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:36908 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0C3I44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:56:56 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Robert =?utf-8?q?Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Tue, 30 Mar 2010 09:56:52 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <1269414437.3355.6.camel@localhost> <1269928015.3384.2.camel@localhost>
In-Reply-To: <1269928015.3384.2.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003301056.52967.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010 07:46:55 Robert Schöne wrote:
...
> I really want to keep this diskussion alive until there's a soultion we
> can all agree.
> So Arjan and Thomas, are there any comments/preferences to the proposed
> options?
I'd like to extend the powertracer and pass the cpu.
This is the only possibility I see to be able to support IO driven
frequency switching drivers where the switching code must not be executed
on the CPU that gets switched (without executing the tracer on each
CPU explicitly which does not make sense).

The next problem where current implementation is unfixable broken with
the tracer just passing the frequency is the fact that several CPUs
could get switched with one MSR write to a depending CPU (SW_ANY).
The same btw applies to C-states for which the tracer is used in
the same way (compare with 8.4.2.2 _CSD (C-State Dependency) of a
current ACPI spec).

No idea what the impact on userspace tools is, if I find some time
I can have a look at timechart how trace data gets read/used.
But I fear the Cstate tracing is used in some more tools already?
It would be great to get feedback/suggestions from people making use
of it already.

Below is still broken, but should make things at least a bit better:

---
X86 cpufreq: Fix powertracer in acpi-cpufreq and exec it on the correct cpu(s)

Several things are broken with the tracer currently.
This patch fixes:
  - With the userspace governor the wrong cpu could get tracked if the target
    function is executed on a CPU which does not get switched
  - In SW_ALL CPU dependency case (CPUFREQ_SHARED_TYPE_ALL) only one CPU got
    tracked. Now all CPUs that depend on each other are tracked.

What this patch does not fix:
  - In SW_ANY case (CPUFREQ_SHARED_TYPE_ANY) it's enough to write to a MSR of
    one of the depending CPUs. The power trace macro misses the ability
    to pass the cpu. Thus only one of the depending CPUs gets tracked correctly.
    To be able to fix this the power trace macro must get extended.


Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Robert Schöne <robert.schoene@tu-dresden.de>
CC: x86@kernel.org
CC: cpufreq <cpufreq@vger.kernel.org>
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: stable@kernel.org

---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..259c49e 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -144,6 +144,7 @@ struct drv_cmd {
 		struct io_addr io;
 	} addr;
 	u32 val;
+	unsigned int frequency;
 };
 
 /* Called via smp_call_function_single(), on the target CPU */
@@ -177,11 +178,13 @@ static void do_drv_write(void *_cmd)
 		rdmsr(cmd->addr.msr.reg, lo, hi);
 		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
 		wrmsr(cmd->addr.msr.reg, lo, hi);
+		trace_power_frequency(POWER_PSTATE, cmd->frequency);
 		break;
 	case SYSTEM_IO_CAPABLE:
 		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
 				cmd->val,
 				(u32)cmd->addr.io.bit_width);
+		trace_power_frequency(POWER_PSTATE, cmd->frequency);
 		break;
 	default:
 		break;
@@ -363,7 +366,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
+	cmd.frequency = data->freq_table[next_state].frequency;
 
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
  
