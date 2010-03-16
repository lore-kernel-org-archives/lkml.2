Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937773Ab0CPK7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:59:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:55125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937746Ab0CPK70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:59:26 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Robert =?utf-8?q?Sch=C3=B6ne?= <robert.schoene@tu-dresden.de>
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for Intel x86 CPUs)
Date: Tue, 16 Mar 2010 11:59:24 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
References: <1268399863.3407.15.camel@localhost> <201003151151.05741.trenn@suse.de> <1268723628.3367.16.camel@localhost>
In-Reply-To: <1268723628.3367.16.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003161159.24424.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010 08:13:48 Robert Schöne wrote:
> Am Montag, den 15.03.2010, 11:51 +0100 schrieb Thomas Renninger:
> > On Friday 12 March 2010 16:41:46 Robert Schöne wrote:
> > > Am Freitag, den 12.03.2010, 06:52 -0800 schrieb Arjan van de Ven:
> > > > On 3/12/2010 5:17, Robert Schöne wrote:
> > > > > This patch fixes the following behaviour:
> > > > > Currently, the power_frequency event is reported for the cpu (core) which initiated the frequency change.
> > > > > It should be reported for the cpu that actually changes its frequency.
> > > > >
> > > > > Example: when using
> > > > >   taskset -c 0 echo<new_frequency>  >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
> > > > > cpu 0 is traced, instead of cpu 1
> > > > >
> > > > > Signed of by Robert Schoene<robert.schoene@tu-dresden.de>
> > > > >
> > > > >
> > > > > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > > index 1b1920f..0a47f10 100644
> > > > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > > @@ -174,6 +174,7 @@ static void do_drv_write(void *_cmd)
> > > > >
> > > > >          switch (cmd->type) {
> > > > >          case SYSTEM_INTEL_MSR_CAPABLE:
> > > > > +               trace_power_frequency(POWER_PSTATE, cmd->val);
> > > > >                  rdmsr(cmd->addr.msr.reg, lo, hi);
> > > > >                  lo = (lo&  ~INTEL_MSR_RANGE) | (cmd->val&  INTEL_MSR_RANGE);
> > > > >                  wrmsr(cmd->addr.msr.reg, lo, hi);
> > > > > @@ -363,7 +364,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
> > > > >                  }
> > > > >          }
> > > > >
> > > > > -       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
This is still wrong:
Before the frequency:
   data->freq_table[next_state].frequency
now the control field is traced. This is an arbitrary value which must be
written to the HW (IO or MSR), it's pure luck that in MSR case it seem to
be identical to the frequency (on this HW), but this needs not to be
the case.
   cmd.val = (u32) perf->states[next_perf_state].control


But something else...:
What exactly is the power tracer good for and what is it
capable of which cpufreq_stats is not capable to do?

Beside the fact that it is an ugly macro you cannot grep for,
acpi-cpufreq really seem to be the only place it gets used in
the whole kernel:
grep trace_power_frequency * -rl
arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c

Robert: If you want to get proper cpufreq tracing/statistics,
compile with:
CONFIG_CPU_FREQ_STAT=y
and do:
modprobe cpufreq_stats
cat /sys/devices/system/cpu/cpu*/cpufreq/stats/*

Below patch fixes the problem.
This time submitted on the right mailing list,
it looks like the trace_power_frequency stuff never hit
the cpufreq list, even the maintainer wasn't CC'ed on
any trace_power_frequency submission.

For the trace people: To do it right, you have to hook
your trace function into cpufreq_stats. You also have
to pass the cpu on which the frequency change happened.

---
cpufreq: Remove broken trace_power_frequency

cpufreq_stats is used for frequency statistics and supports *all*
frequency switching drivers/HW.

The trace_power_frequency interface:
  - only supports one cpufreq driver (acpi-cpufreq)
  - has no additional capabilities compared to cpufreq_stats
  - is broken and traces wrong CPUs on frequency switches
    (cmp. with mail thread:
    trace power_frequency events on the correct cpu
    on the cpufreq@vger.kernel.org list)

Signed-off-by: Thomas Renninger <trenn@suse.de>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..1808284 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,7 +33,6 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
-#include <trace/events/power.h>
 
 #include <linux/acpi.h>
 #include <linux/io.h>
@@ -363,8 +362,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
-
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index c4efe9b..82b2b99 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -42,13 +42,6 @@ DEFINE_EVENT(power, power_start,
 	TP_ARGS(type, state)
 );
 
-DEFINE_EVENT(power, power_frequency,
-
-	TP_PROTO(unsigned int type, unsigned int state),
-
-	TP_ARGS(type, state)
-);
-
 TRACE_EVENT(power_end,
 
 	TP_PROTO(int dummy),
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index 9f4f565..705d926 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -13,6 +13,3 @@
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
-
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
-
