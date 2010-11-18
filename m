Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893Ab0KRPTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:19:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:47139 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab0KRPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:19:08 -0500
Message-ID: <4CE543BB.2010903@windriver.com>
Date: Thu, 18 Nov 2010 09:18:19 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, gorcunov@gmail.com
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <20101112154231.GN4823@redhat.com> <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com> <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com> <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com> <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com> <1290086232.2109.1507.camel@laptop> <20101118143232.GC18100@redhat.com>
In-Reply-To: <20101118143232.GC18100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 15:18:22.0378 (UTC) FILETIME=[D69B60A0:01CB8733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 08:32 AM, Don Zickus wrote:
> On Thu, Nov 18, 2010 at 02:17:12PM +0100, Peter Zijlstra wrote:
>> On Thu, 2010-11-18 at 06:47 -0600, Jason Wessel wrote:
>>> More specifically
>>> when another subsystem injects an NMI event the perf NMI code returns
>>> NOTIFY_STOP. 
>> Not unconditionally, right? We only do so when the previous NMI was from
>> the PMU and nobody claimed this one (NOTIFY_STOP from DIE_NMIUNKNOWN).
>>
>> Or are you hitting the other one, where !handled but pmu_nmi.handled >
>> 1 ?
> 
> On my Nehalem box, the kgdb tests work fine, no issues there.  On my P4
> box, the p4 handler really thinks the NMIs are from the perf counter and
> returns handled==1 and starves the kgdb tests.
> 
> I haven't gotten around to checking Jason's kvm setup to determine which
> handler his setup is calling.
> 
> Jason, could you snip part of your dmesg log that shows the output with
> "Performance Events:" (or just send me the whole thing :-) ).
> 

I can see the hang in 3 of 4 qemu / kvm configurations running with
"-smp 2".

  qemu == Performance Events: p6 PMU driver.

  qemu-system-x86_64 == Performance Events: AMD PMU driver.

  kvm on RHEL 5 == Performance Events: p6 PMU driver.

kgdb tests pass with 64 bit kvm on unbutu 10.10 test system and it prints:

  Performance Events: unsupported p6 CPU model 2 no PMU driver, software
  events only.

I suspect it works because of the "unsupported".  The real p4 system I
have also duplicates the hang just like what you are seeing.

I don't believe this is the right way to fix the problem, but it does
work around the problem using the following patch (found below).  I
made that patch simply so I could execute some more testing and fix
some of the other regressions I did not know about.  The patch is
merely a crude way to say this NMI here really doesn't belong to the
perf call back.  The problem with this is that it would be exteremely
racy if you are starting and stopping the debugger.  There would be
the possibility for lost events etc...

Jason.

--

---
 arch/x86/kernel/cpu/perf_event.c |    3 ++-
 include/linux/kgdb.h             |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/kgdb.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -1221,7 +1222,7 @@ perf_event_nmi_handler(struct notifier_b
 	unsigned int this_nmi;
 	int handled;
 
-	if (!atomic_read(&active_events))
+	if (!atomic_read(&active_events) || in_debug_core())
 		return NOTIFY_DONE;
 
 	switch (cmd) {
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -307,12 +307,15 @@ extern int kgdb_nmicallback(int cpu, voi
 
 extern int			kgdb_single_step;
 extern atomic_t			kgdb_active;
+#define in_debug_core() \
+	(atomic_read(&kgdb_active) != -1)
 #define in_dbg_master() \
 	(raw_smp_processor_id() == atomic_read(&kgdb_active))
 extern bool dbg_is_early;
 extern void __init dbg_late_init(void);
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
+#define in_debug_core() (0)
 #define dbg_late_init()
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
