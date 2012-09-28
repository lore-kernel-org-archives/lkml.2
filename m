Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab2I1Ckf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:40:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:59822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2I1Ckc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:40:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="215040005"
From: Lv Zheng <lv.zheng@intel.com>
To: Len Brown <len.brown@intel.com>
Cc: <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH v4 0/2] ACPI: DBGP/DBG2 early console support for LPIA.
Date: Fri, 28 Sep 2012 10:39:59 +0800
Message-Id: <cover.1348652044.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1347453194.git.zetalog@gmail.com>
References: <cover.1347453194.git.zetalog@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microsoft Debug Port Table (DBGP or DBG2) is used by the Windows SoC
platforms to describe their debugging facilities.
Recent Low Power Intel Architecture (LPIA) platforms have utilized
this for the SPI UART debug ports that are resident on their debug
boards.

This patch set enables the DBGP/DBG2 debug ports as an Linux early
console launcher.
The SPI UART debug ports support is also refined to co-exist with this
new usage model.

To use this facility on LPIA platforms, you need to enable the following
kernel configurations:
  CONFIG_EARLY_PRINTK_ACPI=y
  CONFIG_EARLY_PRINTK_INTEL_MID_SPI=y
Then you need to append the following kernel parameter to the kernel
command line in your the boot loader configuration file:
  earlyprintk=acpi

There is a dilemma in designing this patch set.  There should be three
steps to enable an early console for an operating system:
1. Probe: In this stage, the Linux kernel can detect the early consoles
          and the base address of their register block can be determined.
          This can be done by parsing the descriptors in the ACPI DBGP/DBG2
          tables.  Note that acpi_table_init() must be called before
          parsing.
2. Setup: In this stage, the Linux kernel can apply user specified
          configuration options (ex. baudrate of serial ports) for the
          early consoles.  This is done by parsing the early parameters
          passed to the kernel from the boot loaders.  Note that
          parse_early_params() is called very early to allow parameters to
          be passed to other kernel subsystems.
3. Start: In this stage, the Linux kernel can make the console available
          to output messages.  Since early consoles are always used for
          kernel boot up debugging, this must be done as early as possible
          to arm the kernel with more testability the kernel subsystems.
          Note that, this stage happens when the register_console() is
          called.
The preferred sequence for the above steps is:
   +-----------------+    +-------------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-----------------+    +-------------------+    +--------------------+
But unfortunately, in the current x86 implementation, early parameters and
early printk initialization are called before acpi_table_init() which
requires early memory mapping facility.
There are some choices for me to design this patch set:
1. Invoking acpi_table_init() before parse_early_param() to maintain the
   sequence:
   +-----------------+    +-------------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-----------------+    +-------------------+    +--------------------+
   This requires other subsystem maintainers' review to ensure no
   regressions will be introduced.  As far as I know, one kind of issue
   might be found in EFI subsystsm:
   The EFI boot services and runtime services are mixed up in the x86
   specific initialization process before the ACPI table initialization.
   Things are much worse that you even cannot disable the runtime services
   while still allow the boot services codes to be executed in the kernel
   compilation stage.  Enabling the early consoles after the ACPI table
   initialization will make it difficult to debug the runtime BIOS bugs.
   If any progress is made to the kernel boot sequences, please let me
   know.  I'll be willing to redesign the ACPI DBGP/DBG2 console probing
   facility.  You can reach me at <zetalog@gmail.com>.
2. Modifying above sequece to make it look like:
   +-------------------+    +-----------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | ACPI DBGP PROBE | -> | EARLY_RPINTK START |
   +-------------------+    +-----------------+    +--------------------+
   Early consoles started in this style will lose some debuggabilities in
   the kernel boot up.  If the system does not crash very early,
   developers still can see the bufferred kernel outputs when the
   register_console() is called.
   Current early console implementation need to be modified to split their
   initialization codes into tow part:
   1. Detecting hardware.  This can be called in the PROBE stage.
   2. Applying user parameters.  This can be called in the SETUP stage.
   Individual early console drver maintainers need to be involved to avoid
   regressions that might occur on this modification as the maintainers
   might offer the real tests rather than I can do. 
3. Introducing a barely new debugging facility that does not relate to the
   current early console implementation to allow automatic detection for
   the early consoles.
   +-------------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-------------------+    +--------------------+
   +-----------------+    +--------------------+
   | ACPI DBGP PROBE | -> | EARLY_RPINTK START |
   +-----------------+    +--------------------+
   This is what the patch set has done to enable this new usage model.
   It is known as "ACPI early console launcher mode".
   Early consoles started in this style will lose some debuggabilities in
   the kernel boot up.  If the system does not crash very early,
   developers still can see the bufferred kernel outputs when the
   register_console() is called.
   Note that the user configuration can not be applied to the registered
   early consoles in this way as the acpi_table_init() is still called
   after the parse_early_param().  Instead, the early consoles should
   derive the hardware settings used in the BIOS/bootloaders.
   As a launcher, ACPI DBGP will not actually output kernel messages
   without the real early console drivers, that's why the
   CONFIG_EARLY_PRINTK_INTEL_MID_SPI is still need to be enabled along
   along with the CONFIG_EARLY_PRINTK_ACPI.
   In order to disable this facility by default and enable it at runtime,
   an kernel parameter "earlyprintk=acpi" is introduced.  This makes the
   actual sequence looks like:
   +-------------------+    +--------------------+
   | EARLY_PARAM SETUP | -> | EARLY_RPINTK START |
   +-------------------+    +....................+    +-----------------+
                            | ACPI DBGP LAUNCH   | -> | ACPI DBGP PROBE | ->
                            +--------------------+    +-----------------+
      +--------------------+
   -> | EARLY_RPINTK START |
      +--------------------+

Version 3 of this patch set is the first version that will be published
in the Linux community.  Earlier versions are reviewed internally in
Intel.  This patch set keeps the version number to track the history
that is known to Intel internal developers.
Version 4 of this patch set fixed bunch of CodingStyle issues.

Lv Zheng (2):
  ACPI: Add early console framework for DBGP/DBG2.
  ACPI: Add Intel MID SPI early console support.

 Documentation/kernel-parameters.txt        |    2 +
 arch/x86/Kconfig.debug                     |   38 +++++
 arch/x86/include/asm/mrst.h                |    2 +-
 arch/x86/kernel/acpi/boot.c                |    1 +
 arch/x86/kernel/early_printk.c             |   25 +++-
 arch/x86/platform/mrst/early_printk_mrst.c |  186 +----------------------
 drivers/acpi/Makefile                      |    2 +
 drivers/acpi/early_printk.c                |  201 +++++++++++++++++++++++++
 drivers/platform/x86/Makefile              |    2 +
 drivers/platform/x86/early/Makefile        |    5 +
 drivers/platform/x86/early/intel_mid_spi.c |  220 ++++++++++++++++++++++++++++
 include/acpi/actbl2.h                      |    1 +
 include/linux/acpi.h                       |   24 +++
 include/linux/intel_mid_early.h            |   12 ++
 14 files changed, 540 insertions(+), 181 deletions(-)
 create mode 100644 drivers/acpi/early_printk.c
 create mode 100644 drivers/platform/x86/early/Makefile
 create mode 100644 drivers/platform/x86/early/intel_mid_spi.c
 create mode 100644 include/linux/intel_mid_early.h

-- 
1.7.10

