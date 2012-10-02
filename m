Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2JBW7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:59:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56008 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab2JBW7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:59:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [GIT PULL] Power management updates for 3.7-rc1
Date: Wed, 03 Oct 2012 01:03:03 +0200
Message-ID: <11080230.Ns4hKOCtiY@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.7-rc1

to receive power management updates for v3.7-rc1 with top-most commit
b9142167a2bb979b58b98ffcd928a311b55cbd9f

  Merge branch 'pm-qos'

on top of commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2

  Linux 3.6-rc6

Included are:

* Improved system suspend/resume and runtime PM handling for the SH TMU, CMT
  and MTU2 clock event devices (also used by ARM/shmobile).  That required
  some changes to be made to the PM core and suspend/resume callbacks for
  clock event devices to be added.

* Generic PM domains framework extensions related to cpuidle support and
  domain objects lookup using names.

* ARM/shmobile power management updates including improved support for the
  SH7372's A4S power domain containing the CPU core, all ACKed by Magnus Damm.

* cpufreq changes related to AMD CPUs support from Matthew Garrett, Andre
  Przywara and Borislav Petkov.  That has a conflict with your tree resulting
  from the clash between commit e1f0b8e (cpufreq: Remove support for hardware
  P-state chips from powernow-k8) and the Tejun's commit 6889125
  (cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to another
  CPU) that was merged after these patches had been added to my tree.

* cpu0 cpufreq driver from Shawn Guo.

* cpufreq governor fixes related to the relaxing of limit from Michal Pecio.

* OMAP cpufreq updates from Axel Lin and Richard Zhao.

* cpuidle ladder governor fixes related to the disabling of states from
  Carsten Emde and me.

* cpuidle cleanups from Daniel Lezcano.

* Runtime PM core updates related to the interactions with the system suspend
  core from Alan Stern and Kevin Hilman.

* Wakeup sources modification allowing more helper functions to be called from
  interrupt context from John Stultz and additional diagnostic code from Todd
  Poynor.

* System suspend error code path fix from Feng Hong.

Thanks!


 Documentation/ABI/testing/sysfs-devices-system-cpu |  11 +
 Documentation/cpu-freq/boost.txt                   |  93 +++++
 Documentation/cpuidle/sysfs.txt                    |  10 +-
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |  55 +++
 Documentation/devicetree/bindings/power/opp.txt    |  25 ++
 arch/arm/kernel/smp.c                              |  54 +++
 arch/arm/mach-shmobile/Makefile                    |   2 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |  21 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   6 +-
 arch/arm/mach-shmobile/board-mackerel.c            |  34 +-
 arch/arm/mach-shmobile/common.c                    |  24 --
 arch/arm/mach-shmobile/cpuidle.c                   |  39 +-
 arch/arm/mach-shmobile/include/mach/common.h       |  14 +-
 arch/arm/mach-shmobile/include/mach/pm-rmobile.h   |  35 +-
 arch/arm/mach-shmobile/include/mach/r8a7740.h      |   6 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h      |  12 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h       |  20 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |  42 ++-
 arch/arm/mach-shmobile/pm-r8a7779.c                |  71 ++--
 arch/arm/mach-shmobile/pm-rmobile.c                |  33 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 | 283 ++++++++------
 arch/arm/mach-shmobile/setup-r8a7740.c             |  27 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |   5 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |  69 ++--
 arch/x86/include/asm/msr-index.h                   |   3 +
 drivers/acpi/processor_driver.c                    |   8 +-
 drivers/acpi/processor_idle.c                      |  40 +-
 drivers/acpi/processor_perflib.c                   |  30 ++
 drivers/base/platform.c                            |   2 +
 drivers/base/power/domain.c                        | 244 ++++++++++---
 drivers/base/power/main.c                          |  66 +++-
 drivers/base/power/opp.c                           |  47 +++
 drivers/base/power/power.h                         |  36 +-
 drivers/base/power/runtime.c                       |   3 +
 drivers/base/power/wakeup.c                        |  46 ++-
 drivers/clocksource/sh_cmt.c                       |  71 +++-
 drivers/clocksource/sh_mtu2.c                      |  41 ++-
 drivers/clocksource/sh_tmu.c                       | 112 +++++-
 drivers/cpufreq/Kconfig                            |  11 +
 drivers/cpufreq/Kconfig.x86                        |  18 +-
 drivers/cpufreq/Makefile                           |   4 +-
 drivers/cpufreq/acpi-cpufreq.c                     | 272 +++++++++++++-
 drivers/cpufreq/cpufreq-cpu0.c                     | 269 ++++++++++++++
 drivers/cpufreq/cpufreq_conservative.c             |   2 +
 drivers/cpufreq/cpufreq_ondemand.c                 |   1 +
 drivers/cpufreq/longhaul.h                         |  26 +-
 drivers/cpufreq/omap-cpufreq.c                     |  39 +-
 drivers/cpufreq/powernow-k8.c                      | 406 ++-------------------
 drivers/cpufreq/powernow-k8.h                      |  32 --
 drivers/cpuidle/driver.c                           |  18 +-
 drivers/cpuidle/governors/ladder.c                 |   6 +-
 drivers/pci/pci-driver.c                           |  17 -
 drivers/xen/xen-acpi-processor.c                   |   1 -
 include/acpi/processor.h                           |   9 +-
 include/linux/clockchips.h                         |   8 +
 include/linux/device.h                             |   7 +
 include/linux/opp.h                                |   8 +
 include/linux/pm.h                                 |   2 +
 include/linux/pm_domain.h                          |  92 ++++-
 kernel/power/Kconfig                               |   4 +
 kernel/power/poweroff.c                            |   2 +-
 kernel/power/process.c                             |   2 +-
 kernel/power/qos.c                                 |   1 +
 kernel/time/clockevents.c                          |  24 ++
 kernel/time/timekeeping.c                          |   2 +
 65 files changed, 2061 insertions(+), 962 deletions(-)

---------------

Alan Stern (1):
      PM: Prevent runtime suspend during system resume

Amit Daniel Kachhap (1):
      PM / cpufreq: Initialise the cpu field during conservative governor start

Andi Kleen (1):
      sections: fix section conflicts in drivers/cpufreq

Andre Przywara (5):
      acpi-cpufreq: Add quirk to disable _PSD usage on all AMD CPUs
      cpufreq: Add warning message to powernow-k8
      powernow-k8: delay info messages until initialization has succeeded
      acpi-cpufreq: Add support for disabling dynamic overclocking
      acpi-cpufreq: Add compatibility for legacy AMD cpb sysfs knob

Axel Lin (1):
      cpufreq: OMAP: Check IS_ERR() instead of NULL for omap_device_get_by_hwmod_name

Borislav Petkov (1):
      cpufreq / powernow-k8: Fixup missing _PSS objects message

Carsten Emde (1):
      Honor state disabling in the cpuidle ladder governor

Daniel Lezcano (6):
      cpuidle / ACPI : remove power from acpi_processor_cx structure
      ACPI / processor: remove unused function parameter
      ACPI / processor: remove pointless variable initialization
      cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure
      cpuidle: remove some empty lines
      cpuidle: rename function name "__cpuidle_register_driver", v2

Feng Hong (1):
      PM / Sleep: use resume event when call dpm_resume_early

Jan Beulich (1):
      properly __init-annotate pm_sysrq_init()

Jean Pihet (1):
      PM QoS: Use spinlock in the per-device PM QoS constraints code

John Stultz (1):
      PM / wakeup: Use irqsave/irqrestore for events_lock

Kevin Hilman (1):
      PM / Runtime: let rpm_resume() succeed if RPM_ACTIVE, even when disabled, v2

Luis Gonzalez Fernandez (1):
      PM / QoS: Add return code to pm_qos_get_value function.

Matthew Garrett (3):
      acpi-cpufreq: Add support for modern AMD CPUs
      ACPI: Add fixups for AMD P-state figures
      cpufreq: Remove support for hardware P-state chips from powernow-k8

Michal Pecio (2):
      cpufreq / ondemand: update frequency when limits are relaxed
      cpufreq: conservative: update frequency when limits are relaxed

Rafael J. Wysocki (41):
      PM / cpuidle: Make ladder governor use the "disabled" state flag
      PM / Domains: Introduce simplified power on routine for system resume
      PM / Domains: Add power off/on function for system core suspend stage
      timekeeping: Add suspend and resume of clock event devices
      sh: TMU: Introduce clocksource/clock events suspend/resume routines
      sh: CMT: Introduce clocksource/clock events suspend/resume routines
      sh: MTU2: Introduce clock events suspend/resume routines
      PM: Reorganize device PM initialization
      PM / Runtime: Allow helpers to be called by early platform drivers
      PM / Domains: Rename the always_on device flag to syscore
      PM / Domains: Move syscore flag from subsys data to struct device
      PM / Domains: Do not measure start time for "irq safe" devices
      sh: TMU: Basic runtime PM support
      sh: CMT: Basic runtime PM support
      sh: MTU2: Basic runtime PM support
      PM: Do not use the syscore flag for runtime PM
      PM / Domains: Make it possible to use domain names when adding devices
      PM / Domains: Make it possible to use names when adding subdomains
      PM / Domains: Add power-on function using names to identify domains
      PM / Domains: Document cpuidle-related functions and change their names
      PM / Domains: Operations related to cpuidle using domain names
      ARM: shmobile: Use names of power domains for adding devices to them
      ARM: shmobile: Drop r8a7779_add_device_to_domain()
      ARM: shmobile: Use domain names when adding subdomains to power domains
      ARM: shmobile: Add routine for automatic PM domains initialization
      ARM: shmobile: Do not access sh7372 A4S domain internals directly
      ARM: shmobile: Move sh7372's PM domain objects to a table
      ARM: shmobile: Move r8a7740's PM domain objects to a table
      ARM: shmobile: Move r8a7779's PM domain objects to a table
      ARM: shmobile: Make rmobile_init_pm_domain() static
      ARM: shmobile: Set PM domain on/off latencies directly
      ARM: shmobile: Allow device latencies to be specified directly
      ARM: shmobile: Specify device latencies for SH7372 devices directly
      ARM: shmobile: Specify device latencies for Mackerel devices directly
      ARM: shmobile: Rework adding devices to PM domains on Mackerel
      ARM: shmobile: Rework adding devices to PM domains on AP4EVB
      ARM: shmobile: Remove the console check from sh7372_enter_suspend()
      ARM: shmobile: Move definition of shmobile_init_late() to header
      ARM: shmobile: Make sh7372 cpuidle handling more straightforward
      ARM: shmobile: Add A4S cpuidle state on sh7372
      Revert "PM QoS: Use spinlock in the per-device PM QoS constraints code"

Richard Zhao (2):
      ARM: add cpufreq transiton notifier to adjust loops_per_jiffy for smp
      cpufreq: OMAP: remove loops_per_jiffy recalculate for smp

Sachin Kamat (1):
      PM / Domains: Fix compilation warning related to genpd_start_dev_no_timing()

Sedat Dilek (1):
      PM / Freezer: Fix small typo "regrigerator"

Shawn Guo (2):
      PM / OPP: Initialize OPP table from device tree
      cpufreq: Add a generic cpufreq-cpu0 driver

Todd Poynor (1):
      PM / Sleep: Print name of wakeup source that aborts suspend


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
