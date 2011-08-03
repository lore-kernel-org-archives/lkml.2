Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1HCUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:54:46 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:36853 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1HCUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:54:42 -0400
Date: Wed, 03 Aug 2011 16:54:23 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [GIT PULL] idle patches for Linux 3.1
Message-id: <alpine.LFD.2.02.1108031627060.19398@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

A new power management driver for Moorestown
(essentially a platform idle driver).

Plus some small cpuidle cleanups that were on the list in April.

The cpuidle patches set the stage for adding p-series
support to cpuidle -- possibly by 3.2.

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

ps. individual patches are available on linux-pm@lists.linux-foundation.org

 Documentation/kernel-parameters.txt |    3 +
 MAINTAINERS                         |    6 +
 arch/arm/kernel/process.c           |    4 +-
 arch/sh/kernel/idle.c               |    6 +-
 arch/x86/include/asm/processor.h    |    2 -
 arch/x86/kernel/acpi/cstate.c       |   23 +
 arch/x86/kernel/process.c           |   23 -
 arch/x86/kernel/process_32.c        |    4 +-
 arch/x86/kernel/process_64.c        |    4 +-
 arch/x86/platform/mrst/Makefile     |    1 +
 arch/x86/platform/mrst/pmu.c        |  817 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/mrst/pmu.h        |  234 ++++++++++
 arch/x86/xen/setup.c                |    3 +-
 drivers/cpuidle/cpuidle.c           |   50 ++-
 drivers/cpuidle/cpuidle.h           |    1 +
 drivers/cpuidle/driver.c            |    3 +
 drivers/cpuidle/governor.c          |    3 +
 include/linux/cpuidle.h             |    4 +
 18 files changed, 1141 insertions(+), 50 deletions(-)
 create mode 100644 arch/x86/platform/mrst/pmu.c
 create mode 100644 arch/x86/platform/mrst/pmu.h

through these commits:

Len Brown (5):
      mrst_pmu: driver for Intel Moorestown Power Management Unit
      cpuidle: create bootparam "cpuidle.off=1"
      cpuidle: replace xen access to x86 pm_idle and default_idle
      x86 idle: move mwait_idle_with_hints() to where it is used
      cpuidle: stop depending on pm_idle

with this log:

commit 619b3f9e65307529dd4bbc98efe9d2f3b632646c
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 19:34:59 2011 -0400

    cpuidle: stop depending on pm_idle
    
    cpuidle users should call cpuidle_call_idle() directly
    rather than via (pm_idle)() function pointer.
    
    Architecture may choose to continue using (pm_idle)(),
    but cpuidle need not depend on it:
    
      my_arch_cpu_idle()
    	...
    	if(cpuidle_call_idle())
    		pm_idle();
    
    cc: x86@kernel.org
    cc: Kevin Hilman <khilman@deeprootsystems.com>
    cc: Paul Mundt <lethal@linux-sh.org>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 779d881fbcdf840e23a9bd3e237aebca4e0376e8
Author: Len Brown <len.brown@intel.com>
Date:   Wed Mar 30 23:52:29 2011 -0400

    x86 idle: move mwait_idle_with_hints() to where it is used
    
    ...and make it static
    
    no functional change
    
    cc: x86@kernel.org
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0c70c6b12c37ececbfa9b7734495835514f273a4
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 18:28:35 2011 -0400

    cpuidle: replace xen access to x86 pm_idle and default_idle
    
    When a Xen Dom0 kernel boots on a hypervisor, it gets access
    to the raw-hardware ACPI tables.  While it parses the idle tables
    for the hypervisor's beneift, it uses HLT for its own idle.
    
    Rather than have xen scribble on pm_idle and access default_idle,
    have it simply disable_cpuidle() so acpi_idle will not load and
    architecture default HLT will be used.
    
    cc: xen-devel@lists.xensource.com
    Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 3928f8d7ba2df07e391e390f9526c06774b84063
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 18:13:10 2011 -0400

    cpuidle: create bootparam "cpuidle.off=1"
    
    useful for disabling cpuidle to fall back
    to architecture-default idle loop
    
    cpuidle drivers and governors will fail to register.
    on x86 they'll say so:
    
    intel_idle: intel_idle yielding to (null)
    ACPI: acpi_idle yielding to (null)
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 8e24ed2af46a5d008d85bfeb128d25efc394a3fd
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 12 22:29:32 2011 -0400

    mrst_pmu: driver for Intel Moorestown Power Management Unit
    
    The Moorestown (MRST) Power Management Unit (PMU) driver
    directs the SOC power states in the "Langwell" south complex (SCU).
    
    It hooks pci_platform_pm_ops[] and thus observes all PCI ".set_state"
    requests.  For devices in the SC, the pmu driver translates those
    PCI requests into the appropriate commands for the SCU.
    
    The PMU driver helps implement S0i3, a deep system idle power idle state.
    Entry into S0i3 is via cpuidle, just like regular processor c-states.
    S0i3 depends on pre-conditions including uni-processor, graphics off,
    and certain IO devices in the SC must be off.  If those pre-conditions
    are met, then the PMU allows cpuidle to enter S0i3, otherwise such requests
    are demoted, either to Atom C4 or Atom C6.
    
    This driver is based on prototype work by Bruce Flemming,
    Illyas Mansoor, Rajeev D. Muralidhar, Vishwesh M. Rudramuni,
    Hari Seshadri and Sujith Thomas.  The current driver also
    includes contributions from H. Peter Anvin, Arjan van de Ven,
    Kristen Accardi, and Yong Wang.
    
    Thanks for additional review feedback from Alan Cox and Randy Dunlap.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Acked-by: Alan Cox <alan@linux.intel.com>
