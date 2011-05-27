Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1E0Ri7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:38:59 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:60209 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752961Ab1E0Ri4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:38:56 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-44-4ddfe171a275
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 0/5] x86-64: Remove syscall instructions at fixed addresses
Date: Fri, 27 May 2011 13:38:37 -0400
Message-Id: <cover.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsUixCmqrVv48L6vwe5PUhZ9V46yW1zeNYfN
	YsulZlaLzZumMlv82PCY1YHV41bbH2aPnbPusntsWtXJ5vHu3Dl2j8+b5AJYo7hsUlJzMstS
	i/TtErgyzs89zVLQxlex7dIB5gbGs1xdjJwcEgImEtOvH2WBsMUkLtxbz9bFyMUhJLCPUeL7
	+dOMEM4GRol1iz9COc+YJJ6928UM0sImoCLRsfQBE4gtIhAn0TD7NyuIzSzgIHH78RFGEFtY
	wFvi/uPTYCtYBFQlHjcsA6vhFdCX6Ho4iRVitYLElSvzWCYw8ixgZFjFKJuSW6Wbm5iZU5ya
	rFucnJiXl1qka6SXm1mil5pSuokRHDySvDsY3x1UOsQowMGoxMNrcfC+rxBrYllxZe4hRkkO
	JiVRXr8HQCG+pPyUyozE4oz4otKc1OJDjBIczEoivCb7gXK8KYmVValF+TApaQ4WJXHemZLq
	vkIC6YklqdmpqQWpRTBZGQ4OJQne2SBDBYtS01Mr0jJzShDSTBycIMN5gIZPA6nhLS5IzC3O
	TIfIn2LU5Whcu+MgoxBLXn5eqpQ4bxFIkQBIUUZpHtwcWNS/YhQHekuYtx+kigeYMOAmvQJa
	wgS0ROf3XZAlJYkIKakGRnY/g5ZC67a9kc/4L6ywS5v6Y5Kg1Ir/X1fqRaza3uD1ZnlXvuY9
	500ue3m2uWzmFK8p8T3B/PhypPmCwnVnXItLp211tFUVsrtT+7pORqYw1nZC1H6r2lVzZ9Yf
	Ut0Qm7I2b2NMV87xIzwb+NfoLDv1+KffQvu5X+pLLOPrU6TqNaqUL58JVWIpzkg01GIuKk4E
	AEA/LvnVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I lied about taking awhile to do this.

There are a bunch of syscall instructions in kernel space at fixed
addresses that user code can execute.

One is a time() fallback.  Patch 3/5 removes it.

Several are data that isn't marked NX.  Patch 2/5 makes vvars NX and
5/5 makes the HPET NX.

The last one is the gettimeofday fallback.  We need that, but it
doesn't have to be a real syscall.  Patch 3/5 adds int 0xCC (callable
only from the vsyscall page) that implements the gettimeofday fallback
and nothing else.

Patch 1/5 is just a dumb but harmless bug fix from the last vdso
series.

I've only tested this in KVM with a hacked-up initramfs, but Ingo
wanted it for 2.6.40, so here it is.

Andy Lutomirski (5):
  x86-64: Fix alignment of jiffies variable
  x86-64: Give vvars their own page
  x86-64: Remove kernel.vsyscall64 sysctl
  x86-64: Replace vsyscall gettimeofday fallback with int 0xcc
  x86-64: Map the HPET NX

 arch/x86/include/asm/fixmap.h        |    1 +
 arch/x86/include/asm/pgtable_types.h |    6 ++-
 arch/x86/include/asm/traps.h         |    4 ++
 arch/x86/include/asm/vgtod.h         |    1 -
 arch/x86/include/asm/vsyscall.h      |    6 ++
 arch/x86/include/asm/vvar.h          |   24 ++++-----
 arch/x86/kernel/entry_64.S           |    2 +
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/traps.c              |    4 ++
 arch/x86/kernel/vmlinux.lds.S        |   27 ++++++----
 arch/x86/kernel/vsyscall_64.c        |   86 ++++++++++++++++++---------------
 arch/x86/vdso/vclock_gettime.c       |   55 ++++++++-------------
 tools/power/x86/turbostat/turbostat  |  Bin 0 -> 29200 bytes
 13 files changed, 117 insertions(+), 101 deletions(-)
 create mode 100755 tools/power/x86/turbostat/turbostat

-- 
1.7.5.1

