Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2GXXDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:03:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:32042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab2GXXDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:03:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172744033"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Subject: [PATCH 0/3] x86, fpu signal handling code unification
Date: Tue, 24 Jul 2012 16:05:26 -0700
Message-Id: <1343171129-2747-1-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a followup on my previous RFC patch posted last month.
"[RFC] x86, fpu: unify signal handling code paths for x86 and x86_64 kernels"
https://lkml.org/lkml/2012/6/12/555

This series is a cleaned up version of that with a small change in
the strategy. In the previous RFC version, I consolidated both the
x86/x86_64 code paths to follow the x86 version, which is to save/restore
the fpu,xstate from/to the fpu state in the thread struct. In this
version, I changed the logic to take advantage of direct save/restore
of the state if possible. As the xstate grows in future, I didn't want
to give away the performance advantage that comes with the direct
save/restore of the register state to/from the user frame.

New strategy is as follows:

Signal delivery: Both for 32bit/64bit frames, align the core math frame area to
64bytes as needed by xsave (this where the main fpu/extended state gets copied
to and excludes the legacy compatibility fsave header for the 32bit [f]xsave
frames). If the state is live, copy the register state directly to the user
frame. If not live, copy the state in the thread struct to the user frame. And
for 32bit [f]xsave frames, construct the fsave header separately before
the actual [f]xsave area.

Signal return: As the 32-bit frames with [f]xstate has an additional
'fsave' header, copy everything back from the user sigframe to the
fpstate in the task structure and reconstruct the fxstate from the 'fsave'
header (Also user passed pointers may not be correctly aligned for
any attempt to directly restore any partial state). At the next fpstate usage,
everything will be restored to the live CPU registers.
For all the 64-bit frames and the 32-bit fsave frame, restore the state from
the user sigframe directly to the live CPU registers. 64-bit signals always
restored the math frame directly, so we can expect the math frame pointer
to be correctly aligned. For 32bit fsave frames, there are no alignment
requirements, so we can restore the state directly.

Suresh Siddha (3):
  x86, signal: cleanup ifdefs and is_ia32, is_x32
  x86, fpu: consolidate inline asm routines for saving/restoring fpu
    state
  x86, fpu: unify signal handling code paths for x86 and x86_64 kernels

 arch/x86/ia32/ia32_signal.c         |    9 +-
 arch/x86/include/asm/fpu-internal.h |  286 +++++++++++++-----------
 arch/x86/include/asm/signal.h       |    4 +
 arch/x86/include/asm/xsave.h        |   12 +-
 arch/x86/kernel/i387.c              |  246 +--------------------
 arch/x86/kernel/process.c           |   10 -
 arch/x86/kernel/ptrace.c            |    3 -
 arch/x86/kernel/signal.c            |   77 ++-----
 arch/x86/kernel/xsave.c             |  423 +++++++++++++++++++++--------------
 9 files changed, 446 insertions(+), 624 deletions(-)

-- 
1.7.6.5

