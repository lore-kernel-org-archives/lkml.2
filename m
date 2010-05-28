Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0E1Upw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:45:52 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:55370 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab0E1Upu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:45:50 -0400
Date: Fri, 28 May 2010 16:45:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] idle patches for 2.6.35-merge
Message-id: <alpine.LFD.2.00.1005281643400.4045@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

The new intel_idle driver provides a method to use an optimized
idle loop on machines without using ACPI.

This will update the files shown below.

thanks!
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.34/idle-release-2.6.34.diff.gz

 MAINTAINERS                        |    7 +
 arch/x86/include/asm/thread_info.h |    4 +-
 drivers/Makefile                   |    2 +-
 drivers/acpi/acpi_pad.c            |    9 -
 drivers/acpi/processor_driver.c    |   15 +-
 drivers/acpi/processor_idle.c      |   28 ++-
 drivers/cpuidle/cpuidle.c          |   12 +-
 drivers/cpuidle/cpuidle.h          |    1 -
 drivers/cpuidle/driver.c           |   16 +-
 drivers/cpuidle/sysfs.c            |    5 +-
 drivers/idle/Kconfig               |   11 +
 drivers/idle/Makefile              |    1 +
 drivers/idle/intel_idle.c          |  461 ++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h            |    8 +-
 14 files changed, 538 insertions(+), 42 deletions(-)
 create mode 100755 drivers/idle/intel_idle.c

through these commits:

Len Brown (8):
      cpuidle: fail to register if !CONFIG_CPU_IDLE
      cpuidle: add cpuidle_unregister_driver() error check
      cpuidle: make cpuidle_curr_driver static
      ACPI: allow a native cpuidle driver to displace ACPI
      sched: clarify commment for TS_POLLING
      acpi_pad: uses MONITOR/MWAIT, so it doesn't need to clear TS_POLLING
      ACPI: acpi_idle: touch TS_POLLING only in the non-MWAIT case
      intel_idle: native hardware cpuidle driver for latest Intel processors

with this log:

commit 2671717265ae6e720a9ba5f13fbec3a718983b65
Author: Len Brown <len.brown@intel.com>
Date:   Mon Mar 8 14:07:30 2010 -0500

    intel_idle: native hardware cpuidle driver for latest Intel processors
    
    This EXPERIMENTAL driver supersedes acpi_idle on
    Intel Atom Processors, Intel Core i3/i5/i7 Processors
    and associated Intel Xeon processors.
    
    It does not support the Intel Core2 processor or earlier.
    
    For kernels configured with ACPI, CONFIG_INTEL_IDLE=y
    allows intel_idle to probe before the ACPI processor driver.
    Booting with "intel_idle.max_cstate=0" disables intel_idle
    and the system will fall back on ACPI's "acpi_idle".
    
    Typical Linux distributions load ACPI processor module early,
    making CONFIG_INTEL_IDLE=m not easily useful on ACPI platforms.
    
    intel_idle probes all processors at module_init time.
    Processors that are hot-added later will be limited
    to using C1 in idle.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 02cf4f9808382af7265cafc33dc86ec5875526aa
Author: Len Brown <len.brown@intel.com>
Date:   Mon May 24 14:27:44 2010 -0400

    ACPI: acpi_idle: touch TS_POLLING only in the non-MWAIT case
    
    commit d306ebc28649b89877a22158fe0076f06cc46f60
    (ACPI: Be in TS_POLLING state during mwait based C-state entry)
    fixed an important power & performance issue where ACPI c2 and c3 C-states
    were clearing TS_POLLING even when using MWAIT (ACPI_STATE_FFH).
    That bug had been causing us to receive redundant scheduling interrups
    when we had already been woken up by MONITOR/MWAIT.
    
    Following up on that...
    
    In the MWAIT case, we don't have to subsequently
    check need_resched(), as that c heck was there
    for the TS_POLLING-clearing case.
    
    Note that not only does the cpuidle calling function
    already check need_resched() before calling us, the
    low-level entry into monitor/mwait calls it twice --
    guaranteeing that a write to the trigger address
    can not go un-noticed.
    
    Also, in this case, we don't have to set TS_POLLING
    when we wake, because we never cleared it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Venkatesh Pallipadi <venki@google.com>

commit a7d27c37533524e23bbdc9ba1d78e3241b7483ea
Author: Len Brown <len.brown@intel.com>
Date:   Mon May 24 11:41:00 2010 -0400

    acpi_pad: uses MONITOR/MWAIT, so it doesn't need to clear TS_POLLING
    
    api_pad exclusively uses MONITOR/MWAIT to sleep in idle,
    so it does not need the wakeup IPI during idle sleep
    that is provoked by clearing TS_POLLING.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Cc: Shaohua Li <shaohua.li@intel.com>

commit e45b7fa23097332508730123ac6d59227e7bd7f8
Author: Len Brown <len.brown@intel.com>
Date:   Mon May 24 11:34:36 2010 -0400

    sched: clarify commment for TS_POLLING
    
    TS_POLLING set tells the scheduler an idle_task will poll
    need_resched() to look for work.
    
    TS_POLLING clear tells resched_task() and wake_up_idle_cpu()
    that the remote CPU's idle_task is now sleeping in idle,
    and thus requires a reschedule interrupt notice work.
    
    Update the description of TS_POLLING to reflect how it works.
    "idle task polling need_resched, skip sending interrupt"
    
    Wordsmithing-by: Milton Miller <miltonm@bga.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Peter Zijlstra <peterz@infradead.org>

commit 541adf7cd937b3895c7645406a9b060504df453b
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 17:03:29 2010 -0400

    ACPI: allow a native cpuidle driver to displace ACPI
    
    The ACPI driver would fail probe when it found that
    another driver had previously registered with cpuidle.
    
    But this is a natural situation, as a native hardware
    cpuidle driver should be able to bind instead of ACPI,
    and the ACPI processor driver should be able to handle
    yielding control of C-states while still handling
    P-states and T-states.
    
    Add a KERN_DEBUG line showing when acpi_idle
    does successfully register.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 752138df0dc2daaae09379c754caeb08c97905dc
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:57:26 2010 -0400

    cpuidle: make cpuidle_curr_driver static
    
    cpuidle_register_driver() sets cpuidle_curr_driver
    cpuidle_unregister_driver() clears cpuidle_curr_driver
    
    We should't expose cpuidle_curr_driver to
    potential modification except via these interfaces.
    So make it static and create cpuidle_get_driver() to observe it.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c0d64cb031c21f163a0ec15cf10844bcf0ceedcf
Author: Len Brown <len.brown@intel.com>
Date:   Sat May 22 16:34:10 2010 -0400

    cpuidle: add cpuidle_unregister_driver() error check
    
    Assure that cpuidle_unregister_driver() will not clobber
    the registered driver if unregistered by somebody else.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6b2c676bf32be91f43215d5874c07c1becaba013
Author: Len Brown <len.brown@intel.com>
Date:   Tue May 11 16:50:52 2010 -0400

    cpuidle: fail to register if !CONFIG_CPU_IDLE
    
    Signed-off-by: Len Brown <len.brown@intel.com>
