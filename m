Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab2CTUW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:22:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33899 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab2CTUW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:22:58 -0400
From: Robert Lee <rob.lee@linaro.org>
To: len.brown@intel.com
Cc: akpm@linux-foundation.org, rjw@sisk.pl, khilman@ti.com,
        robherring2@gmail.com, Baohua.Song@csr.com, amit.kucheria@linaro.org,
        nicolas.ferre@atmel.com, linux@maxim.org.za, kgene.kim@samsung.com,
        amit.kachhap@linaro.org, magnus.damm@gmail.com, nsekhar@ti.com,
        daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v8 0/8] Consolidate cpuidle functionality
Date: Tue, 20 Mar 2012 15:22:41 -0500
Message-Id: <1332274969-15782-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.9.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series moves various functionality duplicated in platform 
cpuidle drivers to the core cpuidle driver. Also, the platform irq
disabling was removed as it appears that all calls into 
cpuidle_call_idle will have already called local_irq_disable().

These changes have been pulled into linux-next.

Len, Andrew, can a request be made for Linus to pull these changes?

Acked-by: Jean Pihet<j-pihet@ti.com>  (v6)
Tested-by: Jean Pihet<j-pihet@ti.com>  (v6, omap3)
Tested-by: Amit Daniel<amit.kachhap@linaro.org>  (v6, Exynos4)
Tested-by: Robert Lee<rob.lee@linaro.org>  (imx51, imx6q)
Reviewed-by: Kevin Hilman <khilman@ti.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reviewed-by: Deepthi Dharwar<deepthi@linux.vnet.ibm.com> (core cpuidle only)

v8 changes:
* v7 testing in linux-next revealed a bug reported by Hugh Dickins on x86
platforms.  Investigated and fixed by Daniel Lezcano.
* Made a slight change to the defaut ARM WFI state macro as Daniel Lezcano
suggested the previous interface was prone to mis-use by platforms that 
set power_specified to 1.
* updated to kernel v3.3

These v8 fixes have been applied to the pull tree being used by linux-next:
git://git.linaro.org/people/rob_lee/linux.git cpuidle_consol_pull

v7 submission can be found here:
http://www.spinics.net/lists/arm-kernel/msg162290.html

v7 changes:
* Made some  struct whitespace alignment changes.
* Fixed a coding style violation (thanks Jean Pihet)
* Fixed a bug in davinci cpuidle (thanks Jean Pihet)
* Corrected the common ARM cpuidle WFI state description to be ARM platform
 agnostic (thanks Kevin Hilman)
* Fixed the problem causing x86 and PPC builds to fail (thanks Deepthi)
* Re-added a line of code that was mistakenly removed (thanks Deepthi)

v6 submission can be found here:
http://www.spinics.net/lists/arm-kernel/msg162018.html

v6 changes:
* Fixed mindless bug in CONFIG_ARCH_HAS_RELAX code in drivers/cpuidle/cpuidle.c
* Removed inline from wrapper function (thanks Mike Turquette and Rob Herring)
* Add zeroing out of last_residency if error value is returned (thanks Mike)
* Made drivers/cpuidle/cpuidle.c more intelligently handle en_core_tk_irqen
flag allowing removal of the if (en_core_tk_irqen) in cpuidle_idle_call (thanks
Daniel Lezcano)
* Moved CPUIDLE_ARM_WFI_STATE macro to arch/arm/include/asm/cpuidle.h (thanks
Jean Pihet)
* Cleaned up some comments and a stray change (thanks Jean)

v5 submission can be found here:
http://www.spinics.net/lists/arm-kernel/msg161596.html

v5 changes:
* Added common cpu_do_idle function to core cpuidle
* Added time keep irq en wrapper to core cpuidle
* Removed pre/post enter
* Re-added platforms that can use new common code.

v4 submission can be found here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-January/082742.html

v4 changes:
* Removed drivers/cpuidle/common.c
** Removed the initialization helper functions
** Removed the wrapper used to consolidate time keeping and irq enable/disable
* Add time keeping and local_irq_disable handling in cpuidle_call_idle().
* Made necessary modifications to a few platforms that required the most changes
** Note on omap3: changed structure of omap3_idle_drvdata and added
 per_next_state and per_saved_state vars to accomodate new framework.

v3 submission can be found here:
http://www.spinics.net/lists/arm-kernel/msg156751.html

v3 changes:
* Made various code organization and style changes as suggested in v2 review.
 (thanks Mark Brown, Rob Herring, Mike Turquette, Kevin Hillman, Daniel Lezcano)
* Removed at91 use of common code.  A separate effort is underway to clean
at91 code and the author has offered to convert to common interface as part
of those changes (if this common interface is accepted in time).
* Made platform cpuidle_driver objects __initdata and dynamically added one
persistent instance of this object in common code.
* Removed imx5 pm usage of gpc_dvfs clock as it is no longer needed after
being enabled during clock initialization.
* Re-organized patches.

v2 submission can be found here:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/144199

v2 changes:
* Common interface moved to drivers/cpuidle and made non arch-specific.
* Made various fixes and suggested additions to the common cpuidle
code from v1 review. (Thanks Rob Herring and Mark Brown)
* Added callback for filling in driver_data field as needed.
* Modified the various platforms with these changes.

v1 submission can be found here:
http://comments.gmane.org/gmane.linux.ports.arm.kernel/142791

Robert Lee (8):
  cpuidle: Add common time keeping and irq enabling
  ARM: at91: Consolidate time keeping and irq enable
  ARM: kirkwood: Consolidate time keeping and irq enable
  ARM: davinci: Consolidate time keeping and irq enable
  ARM: omap: Consolidate OMAP3 time keeping and irq enable
  ARM: omap: Consolidate OMAP4 time keeping and irq enable
  ARM: shmobile: Consolidate time keeping and irq enable
  SH: shmobile: Consolidate time keeping and irq enable

 arch/arm/include/asm/cpuidle.h        |   30 ++++++++++++
 arch/arm/kernel/Makefile              |    2 +-
 arch/arm/kernel/cpuidle.c             |   21 +++++++++
 arch/arm/mach-at91/cpuidle.c          |   67 ++++++++++-----------------
 arch/arm/mach-davinci/cpuidle.c       |   82 +++++++++++++--------------------
 arch/arm/mach-kirkwood/cpuidle.c      |   72 +++++++++--------------------
 arch/arm/mach-omap2/cpuidle34xx.c     |   42 +++++++----------
 arch/arm/mach-omap2/cpuidle44xx.c     |   21 ++-------
 arch/arm/mach-shmobile/cpuidle.c      |   31 +++----------
 arch/sh/kernel/cpu/shmobile/cpuidle.c |   10 ++--
 drivers/cpuidle/cpuidle.c             |   66 +++++++++++++++++++++++---
 include/linux/cpuidle.h               |   13 +++++-
 12 files changed, 231 insertions(+), 226 deletions(-)
 create mode 100644 arch/arm/include/asm/cpuidle.h
 create mode 100644 arch/arm/kernel/cpuidle.c

-- 
1.7.9.4

