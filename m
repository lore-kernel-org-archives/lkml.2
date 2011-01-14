Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab1ANDXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:23:42 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:60024 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1ANDXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:23:35 -0500
Date: Thu, 13 Jan 2011 22:23:10 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT] idle patches for 2.6.38-merge
Message-id: <alpine.LFD.2.02.1101132221150.9760@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.37/idle-release-2.6.37.diff.gz

 arch/arm/mach-omap2/cpuidle34xx.c     |    2 +
 arch/ia64/include/asm/processor.h     |    5 +-
 arch/ia64/kernel/process.c            |    6 +--
 arch/sh/kernel/cpu/shmobile/cpuidle.c |    1 -
 arch/x86/include/asm/processor.h      |    5 +-
 arch/x86/kernel/process.c             |   30 ++++------
 arch/x86/kernel/process_32.c          |    4 --
 arch/x86/kernel/process_64.c          |    6 --
 drivers/acpi/processor_core.c         |    4 +-
 drivers/acpi/processor_idle.c         |   28 ++++------
 drivers/cpuidle/cpuidle.c             |   92 +++++++++++++++++---------------
 drivers/idle/intel_idle.c             |   69 ++++++++++++++++++++++---
 include/linux/cpuidle.h               |    6 --
 13 files changed, 145 insertions(+), 113 deletions(-)

through these commits:

Len Brown (7):
      intel_idle: update Sandy Bridge core C-state residency targets
      ACPI: processor_idle: delete use of NOP CPUIDLE_FLAGs
      cpuidle: delete NOP CPUIDLE_FLAG_POLL
      SH, cpuidle: delete use of NOP CPUIDLE_FLAGS_SHALLOW
      cpuidle: delete unused CPUIDLE_FLAG_SHALLOW, BALANCED, DEEP definitions
      cpuidle: CPUIDLE_FLAG_TLB_FLUSHED is specific to intel_idle
      cpuidle: CPUIDLE_FLAG_CHECK_BM is omap3_idle specific

Rafael J. Wysocki (1):
      cpuidle: Make cpuidle_enable_device() call poll_idle_init()

Shaohua Li (1):
      intel_idle: open broadcast clock event

Thomas Renninger (3):
      ACPI, intel_idle: Cleanup idle= internal variables
      cpuidle: Rename X86 specific idle poll state[0] from C0 to POLL
      cpuidle/x86/perf: fix power:cpu_idle double end events and throw cpu_idle events from the cpuidle layer

with this log:

commit 43952886f0b8b3c344c3392b88de067d5fa5419a
Merge: 56dbed1 f77cfe4
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 18:06:19 2011 -0500

    Merge branch 'cpuidle-perf-events' into idle-test

commit 56dbed129df3fdd4caf9018b6e7599ee258a5420
Merge: 2a2d31c f878133
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 18:06:06 2011 -0500

    Merge branch 'linus' into idle-test

commit f77cfe4ea21760268c0277fa3e4b02dfd2a2c2f4
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Jan 7 11:29:44 2011 +0100

    cpuidle/x86/perf: fix power:cpu_idle double end events and throw cpu_idle events from the cpuidle layer
    
    Currently intel_idle and acpi_idle driver show double cpu_idle "exit idle"
    events -> this patch fixes it and makes cpu_idle events throwing less complex.
    
    It also introduces cpu_idle events for all architectures which use
    the cpuidle subsystem, namely:
      - arch/arm/mach-at91/cpuidle.c
      - arch/arm/mach-davinci/cpuidle.c
      - arch/arm/mach-kirkwood/cpuidle.c
      - arch/arm/mach-omap2/cpuidle34xx.c
      - arch/drivers/acpi/processor_idle.c (for all cases, not only mwait)
      - arch/x86/kernel/process.c (did throw events before, but was a mess)
      - drivers/idle/intel_idle.c (did throw events before)
    
    Convention should be:
    Fire cpu_idle events inside the current pm_idle function (not somewhere
    down the the callee tree) to keep things easy.
    
    Current possible pm_idle functions in X86:
    c1e_idle, poll_idle, cpuidle_idle_call, mwait_idle, default_idle
    -> this is really easy is now.
    
    This affects userspace:
    The type field of the cpu_idle power event can now direclty get
    mapped to:
    /sys/devices/system/cpu/cpuX/cpuidle/stateX/{name,desc,usage,time,...}
    instead of throwing very CPU/mwait specific values.
    This change is not visible for the intel_idle driver.
    For the acpi_idle driver it should only be visible if the vendor
    misses out C-states in his BIOS.
    Another (perf timechart) patch reads out cpuidle info of cpu_idle
    events from:
    /sys/.../cpuidle/stateX/*, then the cpuidle events are mapped
    to the correct C-/cpuidle state again, even if e.g. vendors miss
    out C-states in their BIOS and for example only export C1 and C3.
    -> everything is fine.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: Robert Schoene <robert.schoene@tu-dresden.de>
    CC: Jean Pihet <j-pihet@ti.com>
    CC: Arjan van de Ven <arjan@linux.intel.com>
    CC: Ingo Molnar <mingo@elte.hu>
    CC: Frederic Weisbecker <fweisbec@gmail.com>
    CC: linux-pm@lists.linux-foundation.org
    CC: linux-acpi@vger.kernel.org
    CC: linux-kernel@vger.kernel.org
    CC: linux-perf-users@vger.kernel.org
    CC: linux-omap@vger.kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2a2d31c8dc6f1ebcf5eab1d93a0cb0fb4ed57c7c
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Mon Jan 10 09:38:12 2011 +0800

    intel_idle: open broadcast clock event
    
    Intel_idle driver uses CLOCK_EVT_NOTIFY_BROADCAST_ENTER
    CLOCK_EVT_NOTIFY_BROADCAST_EXIT
    for broadcast clock events. The _ENTER/_EXIT doesn't really open broadcast clock
    events, please see processor_idle.c for an example. In some situation, this will
    cause boot hang, because some CPUs enters idle but local APIC timer stalls.
    
    Reported-and-tested-by: Yan Zheng <zheng.z.yan@intel.com>
    Signed-off-by: Shaohua Li <shaohua.li@intel.com>
    cc: stable@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5392083748a340f68052c0b83a7ce28b10324972
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:56:15 2011 -0500

    cpuidle: CPUIDLE_FLAG_CHECK_BM is omap3_idle specific
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 956d033fb2eb3f8818260cdf01644bf4dc1a9e33
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:51:20 2011 -0500

    cpuidle: CPUIDLE_FLAG_TLB_FLUSHED is specific to intel_idle
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 642f11c53f17aee991d97d14e6922172849ef227
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:45:00 2011 -0500

    cpuidle: delete unused CPUIDLE_FLAG_SHALLOW, BALANCED, DEEP definitions
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 03d8b083511a7be2c69b750b8a4e412a21189291
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:43:26 2011 -0500

    SH, cpuidle: delete use of NOP CPUIDLE_FLAGS_SHALLOW
    
    set but not checked.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d247632c08c674864d438733280422ddb7130ff8
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:34:59 2011 -0500

    cpuidle: delete NOP CPUIDLE_FLAG_POLL
    
    it serves no purpose
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0aae9f923bcc476a8e4725dd3ac37547b9816ee5
Author: Len Brown <len.brown@intel.com>
Date:   Wed Jan 12 02:22:56 2011 -0500

    ACPI: processor_idle: delete use of NOP CPUIDLE_FLAGs
    
    CPUIDLE_FLAG_SHALLOW
    CPUIDLE_FLAG_BALANCED
    CPUIDLE_FLAG_DEEP
    CPUIDLE_FLAG_CHECK_BM
    
    were set by acpi_processor_setup_cpuidle(),
    but never used by cpuidle or by acpi_idle.
    So stop setting them.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 720f1c3010db6a411358b962a2007969117840bc
Author: Thomas Renninger <trenn@suse.de>
Date:   Fri Jan 7 11:29:43 2011 +0100

    cpuidle: Rename X86 specific idle poll state[0] from C0 to POLL
    
    C0 means and is well know as "not idle".
    All documentation out there uses this term as "running"/"not idle"
    state. Also Linux userspace tools (e.g. cpufreq-aperf and turbostat)
    show C0 residency which there is correct, but means something totally
    else than cpuidle "POLL" state.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d18960494f65ca4fa0d67c865aaca99452070d15
Author: Thomas Renninger <trenn@suse.de>
Date:   Wed Nov 3 17:06:14 2010 +0100

    ACPI, intel_idle: Cleanup idle= internal variables
    
    Having four variables for the same thing:
      idle_halt, idle_nomwait, force_mwait and boot_option_idle_overrides
    is rather confusing and unnecessary complex.
    
    if idle= boot param is passed, only set up one variable:
    boot_option_idle_overrides
    
    Introduces following functional changes/fixes:
      - intel_idle driver does not register if any idle=xy
        boot param is passed.
      - processor_idle.c will also not register a cpuidle driver
        and get active if idle=halt is passed.
        Before a cpuidle driver with one (C1, halt) state got registered
        Now the default_idle function will be used which finally uses
        the same idle call to enter sleep state (safe_halt()), but
        without registering a whole cpuidle driver.
    
    That means idle= param will always avoid cpuidle drivers to register
    with one exception (same behavior as before):
    idle=nomwait
    may still register acpi_idle cpuidle driver, but C1 will not use
    mwait, but hlt. This can be a workaround for IO based deeper sleep
    states where C1 mwait causes problems.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    cc: x86@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit d8c216cfa57e8a579f41729cbb88c97835d9ac8d
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Jan 8 00:29:20 2011 +0100

    cpuidle: Make cpuidle_enable_device() call poll_idle_init()
    
    The following scenario is possible with the current cpuidle code and
    the ACPI cpuidle driver:
    (1) acpi_processor_cst_has_changed() is called,
    (2) cpuidle_disable_device() is called,
    (3) cpuidle_remove_state_sysfs() is called to remove the (presumably
        outdated) states info from sysfs,
    (3) acpi_processor_get_power_info() is called, the first entry in the
        pr->power.states[] table is filled with zeros,
    (4) acpi_processor_setup_cpuidle() is called and it doesn't fill the
        first entry in pr->power.states[],
    (5) cpuidle_enable_device() is called,
    (6) __cpuidle_register_device() is _not_ called, since the device has
        already been registered,
    (7) Consequently, poll_idle_init() is _not_ called either,
    (8) cpuidle_add_state_sysfs() is called to create the sysfs attributes
        for the new states and it uses the bogus first table entry from
        acpi_processor_get_power_info() for creating state0.
    
    This problem is avoided if cpuidle_enable_device()
    unconditionally calls poll_idle_init().
    
    Reported-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
    cc: stable@kernel.org

commit ddbd550d503c9cdefcd6674a0ef168d57d3f0917
Author: Len Brown <len.brown@intel.com>
Date:   Mon Dec 13 18:28:22 2010 -0500

    intel_idle: update Sandy Bridge core C-state residency targets
    
    Signed-off-by: Len Brown <len.brown@intel.com>
