Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1K2Mnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:43:45 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:1636
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239Ab1K2Mmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:42:55 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz146fKzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVF9ZA-02-H4N-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 0/9] rework of extended state handling, LWP support
Date: Tue, 29 Nov 2011 13:41:19 +0100
Message-ID: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a general cleanup and rework of the code related to
handling of FPU and other extended states. All handling of extended
states, including the FPU state, is now handled by xsave/xrstor wrappers
that fall back to fxsave/fxrstor, or even fsave/frstor, if hardware
support for those features is lacking. The code handling xstates in
signal frames has been unified and cleaned up.

The lazy allocation of the xstate area has been removed. The support for
extended states that cannot be saved/restored lazily, like AMD's LWP,
need this. Since optimized library functions using SSE etc. are widely
used today, most processes would have an xstate area anyway, making the
memory overhead negligible.


Changes since the last RFC:
 * added patch to catch #NM exceptions caused by the kernel
 * reordered the patches in a way that seemed more logical, with the
   side-effect of reducing the size of some of the patches
 * two bugfixes in the preallocation of the xstate area
 * explicitly disable LWP in new tasks (required by the LWP spec)


These patches were built and tested against 3.1. The older RFC patches
that have been lingering in tip/x86/xsave for the last few months should
be removed.


Hans Rosenfeld (9):
  x86, xsave: warn on #NM exceptions caused by the kernel
  x86, xsave: cleanup fpu/xsave support
  x86, xsave: cleanup fpu/xsave signal frame setup
  x86, xsave: rework fpu/xsave support
  x86, xsave: remove unused code
  x86, xsave: more cleanups
  x86, xsave: remove lazy allocation of xstate area
  x86, xsave: add support for non-lazy xstates
  x86, xsave: add kernel support for AMDs Lightweight Profiling (LWP)

 arch/x86/ia32/ia32_signal.c        |    4 +-
 arch/x86/include/asm/i387.h        |  251 ++++++++--------------------
 arch/x86/include/asm/msr-index.h   |    1 +
 arch/x86/include/asm/processor.h   |   12 ++
 arch/x86/include/asm/sigcontext.h  |   12 ++
 arch/x86/include/asm/thread_info.h |    6 +-
 arch/x86/include/asm/xsave.h       |  102 +++--------
 arch/x86/kernel/i387.c             |  300 +++------------------------------
 arch/x86/kernel/process.c          |   14 ++
 arch/x86/kernel/process_32.c       |   29 +---
 arch/x86/kernel/process_64.c       |   28 +---
 arch/x86/kernel/signal.c           |    4 +-
 arch/x86/kernel/traps.c            |   48 +-----
 arch/x86/kernel/xsave.c            |  325 +++++++++++++++++++++++------------
 arch/x86/kvm/vmx.c                 |    2 +-
 arch/x86/kvm/x86.c                 |   11 +-
 arch/x86/math-emu/fpu_entry.c      |    8 +-
 drivers/lguest/x86/core.c          |    2 +-
 fs/exec.c                          |    8 +
 19 files changed, 423 insertions(+), 744 deletions(-)

-- 
1.7.5.4


