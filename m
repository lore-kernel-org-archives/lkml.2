Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab2IUTnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:43:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:49306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab2IUTnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225201981"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: =?UTF-8?q?=5BPATCH=2000/11=5D=20x86=3A=20Supervisor=20Mode=20Access=20Prevention?=
Date: Fri, 21 Sep 2012 12:43:04 -0700
Message-Id: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supervisor Mode Access Prevention (SMAP) is a new security feature
disclosed by Intel in revision 014 of the Intel® Architecture
Instruction Set Extensions Programming Reference:

http://software.intel.com/sites/default/files/319433-014.pdf

When SMAP is active, the kernel cannot normally access pages that are
user space (U=1).  Since the kernel does have the need to access user
space pages under specific circumstances, an override is provided: the
kernel can access user space pages if EFLAGS.AC=1.  For system data
structures, e.g. descriptor tables, that are accessed by the processor
directly, SMAP is active even in CPL 3 regardless of EFLAGS.AC.

SMAP also includes two new instructions, STAC and CLAC, to flip the AC
flag more quickly.

Note: patch 01/11 is already in tip:x86/cpufeature.

List of patches:
      x86, cpufeature: Add feature bit for SMAP
      x86-32, mm: The WP test should be done on a kernel page
      x86, smap: Add CR4 bit for SMAP
      x86, alternative: Use .pushsection/.popsection
      x86, alternative: Add header guards to <asm/alternative-asm.h>
      x86, smap: Add a header file with macros for STAC/CLAC
      x86, uaccess: Merge prototypes for clear_user/__clear_user
      x86, smap: Add STAC and CLAC instructions to control user space access
      x86, smap: Turn on Supervisor Mode Access Prevention
      x86, smap: A page fault due to SMAP is an oops
      x86, smap: Reduce the SMAP overhead for signal handling

Diff stat:

 Documentation/kernel-parameters.txt    |    6 ++-
 arch/x86/Kconfig                       |   11 ++++
 arch/x86/ia32/ia32_signal.c            |   12 +++--
 arch/x86/ia32/ia32entry.S              |    6 ++
 arch/x86/include/asm/alternative-asm.h |    9 +++-
 arch/x86/include/asm/alternative.h     |   32 ++++++------
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/include/asm/fpu-internal.h    |   10 ++--
 arch/x86/include/asm/futex.h           |   19 +++++--
 arch/x86/include/asm/processor-flags.h |    1 +
 arch/x86/include/asm/smap.h            |   91 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/uaccess.h         |   28 ++++++----
 arch/x86/include/asm/uaccess_32.h      |    3 -
 arch/x86/include/asm/uaccess_64.h      |    3 -
 arch/x86/include/asm/xsave.h           |   10 ++--
 arch/x86/kernel/cpu/common.c           |   29 ++++++++++-
 arch/x86/kernel/entry_64.S             |   11 ++++-
 arch/x86/kernel/signal.c               |   24 +++++----
 arch/x86/lib/copy_user_64.S            |    7 +++
 arch/x86/lib/copy_user_nocache_64.S    |    3 +
 arch/x86/lib/getuser.S                 |   10 ++++
 arch/x86/lib/putuser.S                 |    8 +++-
 arch/x86/lib/usercopy_32.c             |   13 ++++-
 arch/x86/lib/usercopy_64.c             |    3 +
 arch/x86/mm/fault.c                    |   18 ++++++
 arch/x86/mm/init_32.c                  |    2 +-
 26 files changed, 301 insertions(+), 69 deletions(-)
