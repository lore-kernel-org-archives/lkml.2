Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2K3It2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:49:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:40531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab2K3It1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:49:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="scan'208";a="255459058"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v2 00/11] x86/microcode: Early load microcode
Date: Thu, 29 Nov 2012 17:47:38 -0800
Message-Id: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

The problem in current microcode loading method is that we load a microcode way,
way too late; ideally we should load it before turning paging on.  This may only
be practical on 32 bits since we can't get to 64-bit mode without paging on,
but we should still do it as early as at all possible.

Similarly, we should load the microcode update as early as possible during AP
bringup and when processors are brought back online after hotplug or S3/S4.

In order to do that, the microcode patch needs to be permanently present in
kernel memory.  Each individual patch is fairly small, so that is OK, but the
entire blob with support for each CPU is too big. Since only CPU's with same
model can be in the same platform, we store microcode with the same model as
BSP. Later on AP's can upload microcode from the saved microcodep patches.

Note, however, that Linux users have gotten used to being able to install a
microcode patch in the field without having a reboot; we support that model too.

v2: Detect vendor before loading microcode. Move some functions from
microcode_intel_early.c to microcode_intel_lib.c. Change some early loading
microcode dependencies in Kconfig. Reword doc.

Fenghua Yu (10):
  Documentation/x86: Early load microcode
  x86/microcode_intel.h: Define functions and macros for early load
    ucode
  x86/microcode_core_early.c: Define interfaces for early load ucode
  x86/microcode_intel_lib.c: Early update ucode on Intel's CPU
  x86/microcode_intel_early.c: Early update ucode on Intel's CPU
  x86/head_32.S: Early update ucode in 32-bit
  x86/head64.c: Early update ucode in 64-bit
  x86/smpboot.c: Early update ucode on AP
  x86/mm/init.c: Copy ucode from initrd image to memory
  x86/Kconfig: Configurations to enable/disable the feature

 Documentation/x86/early-microcode.txt   |   43 +++
 arch/x86/Kconfig                        |   18 ++
 arch/x86/include/asm/microcode.h        |   23 ++
 arch/x86/include/asm/microcode_intel.h  |  106 ++++++++
 arch/x86/kernel/Makefile                |    3 +
 arch/x86/kernel/head64.c                |    6 +
 arch/x86/kernel/head_32.S               |    6 +
 arch/x86/kernel/microcode_core.c        |    7 +-
 arch/x86/kernel/microcode_core_early.c  |   70 +++++
 arch/x86/kernel/microcode_intel.c       |  185 +-------------
 arch/x86/kernel/microcode_intel_early.c |  438 +++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_intel_lib.c   |  174 ++++++++++++
 arch/x86/kernel/smpboot.c               |    7 +
 arch/x86/mm/init.c                      |   10 +
 14 files changed, 915 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/x86/early-microcode.txt
 create mode 100644 arch/x86/include/asm/microcode_intel.h
 create mode 100644 arch/x86/kernel/microcode_core_early.c
 create mode 100644 arch/x86/kernel/microcode_intel_early.c
 create mode 100644 arch/x86/kernel/microcode_intel_lib.c

-- 
1.7.2

