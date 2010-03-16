Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937493Ab0CPHN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 03:13:58 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:47381 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111Ab0CPHN4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 03:13:56 -0400
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
In-Reply-To: <201003151151.05741.trenn@suse.de>
References: <1268399863.3407.15.camel@localhost>
	 <4B9A552D.6080103@linux.intel.com> <1268408506.3407.17.camel@localhost>
	 <201003151151.05741.trenn@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 08:13:48 +0100
Message-ID: <1268723628.3367.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 15.03.2010, 11:51 +0100 schrieb Thomas Renninger:
> On Friday 12 March 2010 16:41:46 Robert Schöne wrote:
> > Am Freitag, den 12.03.2010, 06:52 -0800 schrieb Arjan van de Ven:
> > > On 3/12/2010 5:17, Robert Schöne wrote:
> > > > This patch fixes the following behaviour:
> > > > Currently, the power_frequency event is reported for the cpu (core) which initiated the frequency change.
> > > > It should be reported for the cpu that actually changes its frequency.
> > > >
> > > > Example: when using
> > > >   taskset -c 0 echo<new_frequency>  >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
> > > > cpu 0 is traced, instead of cpu 1
> > > >
> > > > Signed of by Robert Schoene<robert.schoene@tu-dresden.de>
> > > >
> > > >
> > > > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > index 1b1920f..0a47f10 100644
> > > > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > > > @@ -174,6 +174,7 @@ static void do_drv_write(void *_cmd)
> > > >
> > > >          switch (cmd->type) {
> > > >          case SYSTEM_INTEL_MSR_CAPABLE:
> > > > +               trace_power_frequency(POWER_PSTATE, cmd->val);
> > > >                  rdmsr(cmd->addr.msr.reg, lo, hi);
> > > >                  lo = (lo&  ~INTEL_MSR_RANGE) | (cmd->val&  INTEL_MSR_RANGE);
> > > >                  wrmsr(cmd->addr.msr.reg, lo, hi);
> > > > @@ -363,7 +364,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
> > > >                  }
> > > >          }
> > > >
> > > > -       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
> > > >
> > > >          switch (data->cpu_feature) {
> > > >          case SYSTEM_INTEL_MSR_CAPABLE:
> > > >
> > > >
> > > 
> > > are you sure this is right?
> > > it's moving something from outside a switch statement to inside only one prong of a switch statement...
You are right, it should be in all cases, which execute a frequency change.
> > 
> > I'm pretty sure, since I'm moving it from function acpi_cpufreq_target(...) to do_drv_write(...)
> What exactly is the argument you are pretty sure this is correct?
> 
> I expect Arjan is right.
> You now only trace MSR based and not IO based frequency switching.
> 
> I don't know the tracing stuff, but it seems the cpu that executes
> trace_power_frequency shows up in the statistics as the one on which the
> frequency change happened which currently is wrong and you try to fix this?
Yes
> 
> What exactly is the reason you do not add
> trace_power_frequency(..);
> also in the
> SYSTEM_IO_CAPABLE:
> branch in do_drv_write()?
I don't know system io capable systems and what they are doing, so I ignored it to prevent reporting wrong "frequencies". 
> 
>     Thomas
> 
> 
> 
>    Thomas
I stand corrected and appended the new patch (with an additional trace command for io capable systems)
Robert


diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..4803883 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -174,11 +174,13 @@ static void do_drv_write(void *_cmd)
 
        switch (cmd->type) {
        case SYSTEM_INTEL_MSR_CAPABLE:
+               trace_power_frequency(POWER_PSTATE, cmd->val);
                rdmsr(cmd->addr.msr.reg, lo, hi);
                lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
                wrmsr(cmd->addr.msr.reg, lo, hi);
                break;
        case SYSTEM_IO_CAPABLE:
+               trace_power_frequency(POWER_PSTATE, cmd->val);
                acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
                                cmd->val,
                                (u32)cmd->addr.io.bit_width);
@@ -363,7 +365,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
                }
        }
 
-       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
 
        switch (data->cpu_feature) {
        case SYSTEM_INTEL_MSR_CAPABLE:


