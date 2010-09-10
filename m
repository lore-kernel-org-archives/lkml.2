Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0IJFgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 01:36:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37096 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab0IJFgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 01:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=qykV5VtKepJGi5wGcxrcUZtga8x93Z3ER/TdUFEdXRPKld+BQ4kvl0McRRHlNSS+CT
         3FOJNwu5hT+dd4otyDHutaDP3+b0IBNa01jwsJIsTj/ncyfkYf22rszO3u/yMp1ycrOh
         teaMx0w6J8hyzMoyjmDoox6GSiC1Lu/DzzNvw=
Date: Fri, 10 Sep 2010 13:36:13 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Nico Schottelius <nico-nospam@schottelius.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Pritz <flo@xssn.at>, Suresh Siddha <suresh.b.siddha@intel.com>,
        stable@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <Pine.LNX.4.64.1009101324280.3056@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Sep 8, 2010 at 2:21 PM, Nico Schottelius 
<nico-nospam@schottelius.org> wrote:
> Rafael J. Wysocki [Wed, Sep 08, 2010 at 01:28:52AM +0200]:
>> On Wednesday, September 08, 2010, Nico Schottelius wrote:
>> > Rafael J. Wysocki [Tue, Sep 07, 2010 at 11:48:41PM +0200]:
>> > > On Tuesday, September 07, 2010, Jeff Chua wrote:
>> > > > Cool. Thanks for the short-cut! At least now, I can resume, but got a
>> > > > lot of BUGS showing up upon resume after applying the patch.
>> > > This also was reported IIRC, but there's no resolution so far. It's a
>> > > different issue.
>> > Can somebody ping me, as soon as a git pull on linux-2.6
>> > should be as "stable" (or more stable) than 2.6.34?
>> No one can say when that happens for your machine.
> True. I was more wondering, when the bisected issue will
> be fixed, as this may give my machine some more chances
> to work on Linux.


I've bisected and it's pointing to the following commit causing the 
errors after resume. Reverting the commit solves the problem.


commit cd7240c0b900eb6d690ccee088a6c9b46dae815a
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Aug 19 17:03:38 2010 -0700

     x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states

     TSC's get reset after suspend/resume (even on cpu's with invariant TSC
     which runs at a constant rate across ACPI P-, C- and T-states). And in
     some systems BIOS seem to reinit TSC to arbitrary large value (still
     sync'd across cpu's) during resume.

     This leads to a scenario of scheduler rq->clock (sched_clock_cpu()) less
     than rq->age_stamp (introduced in 2.6.32). This leads to a big value
     returned by scale_rt_power() and the resulting big group power set by the
     update_group_power() is causing improper load balancing between busy and
     idle cpu's after suspend/resume.

     This resulted in multi-threaded workloads (like kernel-compilation) go
     slower after suspend/resume cycle on core i5 laptops.

     Fix this by recomputing cyc2ns_offset's during resume, so that
     sched_clock() continues from the point where it was left off during
     suspend.

     Reported-by: Florian Pritz <flo@xssn.at>
     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
     Cc: <stable@kernel.org> # [v2.6.32+]
     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
     LKML-Reference: <1282262618.2675.24.camel@sbsiddha-MOBL3.sc.intel.com>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index c042729..1ca132f 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -59,5 +59,7 @@ extern void check_tsc_sync_source(int cpu);
  extern void check_tsc_sync_target(void);

  extern int notsc_setup(char *);
+extern void save_sched_clock_state(void);
+extern void restore_sched_clock_state(void);

  #endif /* _ASM_X86_TSC_H */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ce8e502..d632934 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -626,6 +626,44 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
  	local_irq_restore(flags);
  }

+static unsigned long long cyc2ns_suspend;
+
+void save_sched_clock_state(void)
+{
+	if (!sched_clock_stable)
+		return;
+
+	cyc2ns_suspend = sched_clock();
+}
+
+/*
+ * Even on processors with invariant TSC, TSC gets reset in some the
+ * ACPI system sleep states. And in some systems BIOS seem to reinit TSC to
+ * arbitrary value (still sync'd across cpu's) during resume from such sleep
+ * states. To cope up with this, recompute the cyc2ns_offset for each cpu so
+ * that sched_clock() continues from the point where it was left off during
+ * suspend.
+ */
+void restore_sched_clock_state(void)
+{
+	unsigned long long offset;
+	unsigned long flags;
+	int cpu;
+
+	if (!sched_clock_stable)
+		return;
+
+	local_irq_save(flags);
+
+	get_cpu_var(cyc2ns_offset) = 0;
+	offset = cyc2ns_suspend - sched_clock();
+
+	for_each_possible_cpu(cpu)
+		per_cpu(cyc2ns_offset, cpu) = offset;
+
+	local_irq_restore(flags);
+}
+
  #ifdef CONFIG_CPU_FREQ

  /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index e7e8c5f..87bb35e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -113,6 +113,7 @@ static void __save_processor_state(struct saved_context *ctxt)
  void save_processor_state(void)
  {
  	__save_processor_state(&saved_context);
+	save_sched_clock_state();
  }
  #ifdef CONFIG_X86_32
  EXPORT_SYMBOL(save_processor_state);
@@ -229,6 +230,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
  void restore_processor_state(void)
  {
  	__restore_processor_state(&saved_context);
+	restore_sched_clock_state();
  }
  #ifdef CONFIG_X86_32
  EXPORT_SYMBOL(restore_processor_state);




Errors like the one below:

cpi_ds_exec_end_op+0x8e/0x3cd
  [<ffffffff8121497d>] ? acpi_ps_parse_loop+0x7dd/0x96c
  [<ffffffff81213af7>] ? acpi_ps_parse_aml+0x8e/0x29a
  [<ffffffff8121512e>] ? acpi_ps_execute_method+0x1bf/0x28d
  [<ffffffff81210741>] ? acpi_ns_evaluate+0xdd/0x19a
  [<ffffffff812101f3>] ? acpi_evaluate_object+0x145/0x246
  [<ffffffff811f79b2>] ? acpi_os_signal_semaphore+0x23/0x27
  [<ffffffff811fa41e>] ? acpi_device_resume+0x0/0x2b
  [<ffffffff81222892>] ? acpi_battery_get_state+0x7f/0x121
  [<ffffffff812118c2>] ? acpi_get_handle+0x7b/0x99
  [<ffffffff81222b99>] ? acpi_battery_update+0x265/0x26e
  [<ffffffff81222c70>] ? acpi_battery_resume+0x25/0x2a
  [<ffffffff81295c8d>] ? legacy_resume+0x1e/0x55
  [<ffffffff81295d24>] ? device_resume+0x60/0xdd
  [<ffffffff811c2102>] ? kobject_get+0x12/0x17
  [<ffffffff812963e1>] ? dpm_resume_end+0xf2/0x349
  [<ffffffff8105c9a4>] ? suspend_devices_and_enter+0x15b/0x188
  [<ffffffff8105ca6a>] ? enter_state+0x99/0xcb
  [<ffffffff8105c2da>] ? state_store+0xb1/0xcf
  [<ffffffff810e9f0f>] ? sysfs_write_file+0xd6/0x112
  [<ffffffff810a2f82>] ? vfs_write+0xad/0x132
  [<ffffffff810a30bd>] ? sys_write+0x45/0x6e
  [<ffffffff81001f02>] ? system_call_fastpath+0x16/0x1b
BUG: scheduling while atomic: lid/2486/0x00000002



In short, to solve resume problem, revert these 2 commits ...
         drm/i915: Enable RC6 on Ironlake
                 ce17178094f368d9e3f39b2cb4303da5ed633dd4

         x86, tsc, sched: Recompute cyc2ns_offset's during resume ...
                 cd7240c0b900eb6d690ccee088a6c9b46dae815a



Thanks,
Jeff
