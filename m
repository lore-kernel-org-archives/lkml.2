Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1HJPPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:15:50 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:50208 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab1HJPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:15:49 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-45-4e42a0363979
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/3] vsyscall emulation compatibility fixes
Date: Wed, 10 Aug 2011 11:15:29 -0400
Message-Id: <cover.1312988155.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsUixCmqrGu2wMnPYPtrfYu+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNaPOp7y27xY8NjVgcuj++tfSwet9r+MHvM
	3/mR0WPnrLvsHptWdbJ5nJjxm8Xj8yY5j1mzDjN5nGj5whrAGcVlk5Kak1mWWqRvl8CV8XHG
	LJaCIyIV2/4kNjBOF+hi5OSQEDCR2PHwDiOELSZx4d56ti5GLg4hgX2MEqtW3AdLCAlsYJTY
	86UcIvGMSeJCYzcTSIJNQEWiY+kDIJuDQ0RASGLp3TqQGmaBjUwSDQuegzULC1hLbDn/FMxm
	EVCVmLPmGpjNK6Av8f/IYhaIzXISRy4/Z5rAyLOAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqR
	rrFebmaJXmpK6SZGcDhK8u1g/HpQ6RCjAAejEg/vjWWOfkKsiWXFlbmHGCU5mJREefvnO/kJ
	8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuGVmgeU401JrKxKLcqHSUlzsCiJ867e4eAnJJCeWJKa
	nZpakFoEk5Xh4FCS4L0JMlSwKDU9tSItM6cEIc3EwQkynAdo+ASQGt7igsTc4sx0iPwpRkUp
	cd7nIAkBkERGaR5cLyxdvGIUB3pFmDcUpIoHmGrgul8BDWYCGlx/xwFkcEkiQkqqgVHwnb4S
	2/r8fOdrTbt76g7LCjefXlcxc/m/xd+YFdKsz95OP3mhepv5lVU1YfXMOhoGl/k9a+PrNOpu
	P5plslp3rxtfHcMCT2enLbP7uJV3MPgdPiz7o2BW/U4+9gu+m7v4NE+yzmYzPSlZaslkIOOa
	9GJbit+7I70h/c6fPvxl7LwWVh50W4mlOCPRUIu5qDgRAAioDXnyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest attempt to make vsyscall emulation compatible with
dynamic insrumentation tools like DynamoRIO and pin
(http://pintool.org).  They make assumptions about how the int
instruction works that were false with the original vsyscall emulation
code.

There is now a vsyscall boot parameter.  In "native" mode, vsyscalls are
just syscall instructions.  Emulation works fine.  In "emulate" mode
(default), vsyscalls appear to be syscall instructions, but attempts to
execute them are trapped by the NX bit and the instructions are emulated
instead.  This is slower than the old interrupt-based code (because I
hooked a slow path in the page fault code) but it means that nothing too
sneaky goes on behind the backs of the tools.  In "none" mode, vsyscalls
send SIGSEGV just like any other attempt to execute from an NX page.

This still has corner cases.  For example, single-stepping through a
vsyscall will step across the whole thing instead of across just one
instruction.  I suspect that nothing cares.  Somewhat more
significantly, if an exploit (or exploit-like program) jumps to a
syscall instruction in the vsyscall page under pin, then it will work,
whereas without pin in vsyscall=emulate mode, it would receive SIGSEGV.
Pin is welcome to fix this corner case if it cares.

If this still causes problems, we can just default the vsyscall
parameter to native for 3.1

The first patch is pure cleanup and is not required.  The second patch
wires up the getcpu syscall and is required for the native code to work.
The third patch is the meat.

For extra points, if you ignore the documentation in
kernel-parameters.txt, this patch set removes more lines than it adds.

Andy Lutomirski (3):
  x86: Remove unnecessary compile flag tweaks for vsyscall code
  x86-64: Wire up getcpu syscall
  x86-64: Rework vsyscall emulation and add vsyscall= parameter

 Documentation/kernel-parameters.txt |   21 +++++++++
 arch/x86/include/asm/irq_vectors.h  |    4 --
 arch/x86/include/asm/traps.h        |    2 -
 arch/x86/include/asm/unistd_64.h    |    2 +
 arch/x86/include/asm/vsyscall.h     |    6 +++
 arch/x86/kernel/Makefile            |   13 ------
 arch/x86/kernel/entry_64.S          |    1 -
 arch/x86/kernel/traps.c             |    6 ---
 arch/x86/kernel/vmlinux.lds.S       |   33 --------------
 arch/x86/kernel/vsyscall_64.c       |   82 +++++++++++++++++++++--------------
 arch/x86/kernel/vsyscall_emu_64.S   |   36 ++++++++++------
 arch/x86/mm/fault.c                 |   12 +++++
 12 files changed, 113 insertions(+), 105 deletions(-)

-- 
1.7.6

