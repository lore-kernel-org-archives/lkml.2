Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1CITRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:17:17 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:29322
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab1CITRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:17:15 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz146fKzz1202hzzz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LHT1H7-01-KUZ-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <brgerst@gmail.com>,
        <robert.richter@amd.com>, <Andreas.Herrmann3@amd.com>,
        <eranian@google.com>, <suresh.b.siddha@intel.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 0/8] rework of extended state handling, LWP support
Date: Wed, 9 Mar 2011 20:14:54 +0100
Message-ID: <1299698102-972771-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a general cleanup and rework of the code related to
handling of FPU and otherextended states.

All handling of extended states, including the FPU state, is now handled
by xsave/xrstor wrappers that fall back to fxsave/fxrstor, or even
fsave/frstor, if hardware support for those features is lacking.

Non-lazy xstates, which cannot be restored lazily, can now be easily
supported with almost no processing overhead. This makes adding basic
support for AMDs LWP almost trivial.

Since non-lazy xstates are inherently incompatible with lazy allocation
of the xstate area, the complete removal of lazy allocation to further
reduce code complexity should be considered. Since SSE-optimized library
functions are widely used today, most processes would have an xstate
area anyway, so the memory overhead wouldn't be big enough to be much of
an issue.


Hans Rosenfeld (8):
  x86, xsave: cleanup fpu/xsave support
  x86, xsave: rework fpu/xsave support
  x86, xsave: cleanup fpu/xsave signal frame setup
  x86, xsave: remove unused code
  x86, xsave: more cleanups
  x86, xsave: add support for non-lazy xstates
  x86, xsave: add kernel support for AMDs Lightweight Profiling (LWP)
  x86, xsave: remove lazy allocation of xstate area

 arch/x86/ia32/ia32_signal.c        |    4 +-
 arch/x86/include/asm/i387.h        |  226 +++++++-------------------
 arch/x86/include/asm/processor.h   |   12 ++
 arch/x86/include/asm/sigcontext.h  |   12 ++
 arch/x86/include/asm/thread_info.h |    4 +-
 arch/x86/include/asm/xsave.h       |   99 ++---------
 arch/x86/kernel/i387.c             |  310 ++++--------------------------------
 arch/x86/kernel/process_32.c       |   29 ++---
 arch/x86/kernel/process_64.c       |   28 +---
 arch/x86/kernel/signal.c           |    4 +-
 arch/x86/kernel/traps.c            |   47 +-----
 arch/x86/kernel/xsave.c            |  313 +++++++++++++++++++++++-------------
 arch/x86/kvm/vmx.c                 |    2 +-
 arch/x86/kvm/x86.c                 |   11 +-
 arch/x86/math-emu/fpu_entry.c      |    8 +-
 drivers/lguest/x86/core.c          |    2 +-
 16 files changed, 373 insertions(+), 738 deletions(-)


