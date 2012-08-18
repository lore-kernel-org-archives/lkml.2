Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2HRI36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 04:29:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:10632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2HRI3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 04:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,790,1336374000"; 
   d="scan'208";a="182264733"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
        "Andreas Herrmann" <andreas.herrmann3@amd.com>,
        "Borislav Petkov" <borislav.petkov@amd.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 00/11] x86/microcode: Early load microcode
Date: Sat, 18 Aug 2012 01:15:18 -0700
Message-Id: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
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

Fenghua Yu (11):
  Documentation/x86: Early load microcode
  x86/lib/cpio.c: Find cpio data by its file name
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

 Documentation/x86/earlyucode.txt        |   43 +++
 arch/x86/Kconfig                        |   22 ++
 arch/x86/include/asm/cpio.h             |   10 +
 arch/x86/include/asm/microcode.h        |   23 ++
 arch/x86/include/asm/microcode_intel.h  |  103 +++++++
 arch/x86/kernel/Makefile                |    3 +
 arch/x86/kernel/head64.c                |    6 +
 arch/x86/kernel/head_32.S               |    6 +
 arch/x86/kernel/microcode_core.c        |    7 +-
 arch/x86/kernel/microcode_core_early.c  |   74 +++++
 arch/x86/kernel/microcode_intel.c       |  185 +------------
 arch/x86/kernel/microcode_intel_early.c |  482 +++++++++++++++++++++++++++++++
 arch/x86/kernel/microcode_intel_lib.c   |  163 +++++++++++
 arch/x86/kernel/smpboot.c               |    7 +
 arch/x86/lib/Makefile                   |    2 +
 arch/x86/lib/cpio.c                     |  179 ++++++++++++
 arch/x86/mm/init.c                      |   10 +
 17 files changed, 1144 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/x86/earlyucode.txt
 create mode 100644 arch/x86/include/asm/cpio.h
 create mode 100644 arch/x86/include/asm/microcode_intel.h
 create mode 100644 arch/x86/kernel/microcode_core_early.c
 create mode 100644 arch/x86/kernel/microcode_intel_early.c
 create mode 100644 arch/x86/kernel/microcode_intel_lib.c
 create mode 100644 arch/x86/lib/cpio.c

-- 
1.7.2

