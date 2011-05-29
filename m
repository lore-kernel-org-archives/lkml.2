Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab1E2IYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:24:49 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:39024 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab1E2IYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:24:41 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 May 2011 04:24:41 EDT
Date: Sun, 29 May 2011 03:24:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT] idle patches for 2.6.40.merge
Message-id: <alpine.LFD.2.02.1105290323460.7577@arrandale.kernel.org>
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

 Documentation/feature-removal-schedule.txt |   36 +++++++++++++++++++++++
 arch/x86/include/asm/acpi.h                |    2 +-
 arch/x86/include/asm/idle.h                |    2 +-
 arch/x86/include/asm/processor.h           |    4 +-
 arch/x86/kernel/apm_32.c                   |    2 +
 arch/x86/kernel/cpu/bugs.c                 |    1 +
 arch/x86/kernel/cpu/common.c               |    2 +-
 arch/x86/kernel/process.c                  |   43 +++++++++++++++-------------
 arch/x86/kernel/smpboot.c                  |    2 +-
 drivers/acpi/processor_idle.c              |    2 +-
 drivers/block/floppy.c                     |    1 +
 drivers/cpuidle/governors/menu.c           |    4 ++-
 include/linux/pm_qos_params.h              |    4 ++
 kernel/pm_qos_params.c                     |   37 ++++++++++++++++--------
 14 files changed, 102 insertions(+), 40 deletions(-)

through these commits:

Len Brown (6):
      x86 idle: clarify AMD erratum 400 workaround
      x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it
      x86 idle floppy: deprecate disable_hlt()
      x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
      x86 idle: deprecate "no-hlt" cmdline param
      x86 idle: deprecate mwait_idle() and "idle=mwait" cmdline param

Tero Kristo (1):
      cpuidle: menu: fixed wrapping timers at 4.294 seconds

Tim Chen (1):
      idle governor: Avoid lock acquisition to read pm_qos before entering idle

with this log:

commit c14d878367418975b2c96e07695377d086f40027
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 15:46:09 2011 -0400

    x86 idle: deprecate mwait_idle() and "idle=mwait" cmdline param
    
    mwait_idle() is a C1-only idle loop intended to be more efficient
    than HLT on SMP hardware that supports it.
    
    But mwait_idle() has been replaced by the more general
    mwait_idle_with_hints(), which handles both C1 and deeper C-states.
    ACPI uses only mwait_idle_with_hints(), and never uses mwait_idle().
    
    Deprecate mwait_idle() and the "idle=mwait" cmdline param
    to simplify the x86 idle code.
    
    After this change, kernels configured with
    (!CONFIG_ACPI=n && !CONFIG_INTEL_IDLE=n) when run on hardware
    that support MWAIT will simply use HLT.  If MWAIT is desired
    on those systems, cpuidle and the cpuidle drivers above
    can be used.
    
    cc: x86@kernel.org
    cc: stable@kernel.org # .39.x
    Signed-off-by: Len Brown <len.brown@intel.com>

commit e5067870594711fde0de485d0c67cf93c7190628
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 15:41:17 2011 -0400

    x86 idle: deprecate "no-hlt" cmdline param
    
    We'd rather that modern machines not check if HLT works on
    every entry into idle, for the benefit of machines that had
    marginal electricals 15-years ago.  If those machines are still running
    the upstream kernel, they can use "idle=poll".  The only difference
    will be that they'll now invoke HLT in machine_hlt().
    
    cc: x86@kernel.org # .39.x
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 15844b48259c643a5ef6f4877ce4c241d7a587b4
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 15:19:23 2011 -0400

    x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
    
    We don't want to export the pm_idle function pointer to modules.
    Currently CONFIG_APM_CPU_IDLE w/ CONFIG_APM_MODULE forces us to.
    
    CONFIG_APM_CPU_IDLE is of dubious value, it runs only on 32-bit
    uniprocessor laptops that are over 10 years old.  It calls into
    the BIOS during idle, and is known to cause a number of machines
    to fail.
    
    Removing CONFIG_APM_CPU_IDLE and will allow us to stop exporting
    pm_idle.  Any systems that were calling into the APM BIOS
    at run-time will simply use HLT instead.
    
    cc: x86@kernel.org
    cc: Jiri Kosina <jkosina@suse.cz>
    cc: stable@kernel.org # .39.x
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 4679268576e84c36080c247a553484ccbd10d4e6
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 15:08:48 2011 -0400

    x86 idle floppy: deprecate disable_hlt()
    
    Plan to remove floppy_disable_hlt in 2012, an ancient
    workaround with comments that it should be removed.
    
    This allows us to remove clutter and a run-time branch
    from the idle code.
    
    WARN_ONCE() on invocation until it is removed.
    
    cc: x86@kernel.org
    cc: stable@kernel.org # .39.x
    Signed-off-by: Len Brown <len.brown@intel.com>

commit f07911145ceb74a7b971d0dff252d8be637bb8a9
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 15:28:09 2011 -0400

    x86 idle: EXPORT_SYMBOL(default_idle, pm_idle) only when APM demands it
    
    In the long run, we don't want default_idle() or (pm_idle)() to
    be exported outside of process.c.  Start by not exporting them
    to modules, unless the APM build demands it.
    
    cc: x86@kernel.org
    cc: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 51a52dded2e825b962f25319dee0713d7782f6e7
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 16:59:53 2011 -0400

    x86 idle: clarify AMD erratum 400 workaround
    
    The workaround for AMD erratum 400 uses the term "c1e" falsely suggesting:
    1. Intel C1E is somehow involved
    2. All AMD processors with C1E are involved
    
    Use the string "amd_c1e" instead of simply "c1e" to clarify that
    this workaround is specific to AMD's version of C1E.
    Use the string "e400" to clarify that the workaround is specific
    to AMD processors with Erratum 400.
    
    This patch is text-substitution only, with no functional change.
    
    cc: x86@kernel.org
    Acked-by: Borislav Petkov <borislav.petkov@amd.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 333c5ae9948194428fe6c5ef5c088304fc98263b
Author: Tim Chen <tim.c.chen@linux.intel.com>
Date:   Fri Feb 11 12:49:04 2011 -0800

    idle governor: Avoid lock acquisition to read pm_qos before entering idle
    
    Thanks to the reviews and comments by Rafael, James, Mark and Andi.
    Here's version 2 of the patch incorporating your comments and also some
    update to my previous patch comments.
    
    I noticed that before entering idle state, the menu idle governor will
    look up the current pm_qos target value according to the list of qos
    requests received.  This look up currently needs the acquisition of a
    lock to access the list of qos requests to find the qos target value,
    slowing down the entrance into idle state due to contention by multiple
    cpus to access this list.  The contention is severe when there are a lot
    of cpus waking and going into idle.  For example, for a simple workload
    that has 32 pair of processes ping ponging messages to each other, where
    64 cpu cores are active in test system, I see the following profile with
    37.82% of cpu cycles spent in contention of pm_qos_lock:
    
    -     37.82%          swapper  [kernel.kallsyms]          [k]
    _raw_spin_lock_irqsave
       - _raw_spin_lock_irqsave
          - 95.65% pm_qos_request
               menu_select
               cpuidle_idle_call
             - cpu_idle
                  99.98% start_secondary
    
    A better approach will be to cache the updated pm_qos target value so
    reading it does not require lock acquisition as in the patch below.
    With this patch the contention for pm_qos_lock is removed and I saw a
    2.2X increase in throughput for my message passing workload.
    
    cc: stable@kernel.org
    Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
    Acked-by: Andi Kleen <ak@linux.intel.com>
    Acked-by: James Bottomley <James.Bottomley@suse.de>
    Acked-by: mark gross <markgross@thegnar.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 7467571f4480b273007517b26297c07154c73924
Author: Tero Kristo <tero.kristo@nokia.com>
Date:   Thu Feb 24 17:19:23 2011 +0200

    cpuidle: menu: fixed wrapping timers at 4.294 seconds
    
    Cpuidle menu governor is using u32 as a temporary datatype for storing
    nanosecond values which wrap around at 4.294 seconds. This causes errors
    in predicted sleep times resulting in higher than should be C state
    selection and increased power consumption. This also breaks cpuidle
    state residency statistics.
    
    cc: stable@kernel.org # .32.x through .39.x
    Signed-off-by: Tero Kristo <tero.kristo@nokia.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
