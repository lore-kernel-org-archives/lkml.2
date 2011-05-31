Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1EaOQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:16:05 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:64911 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625Ab1EaOQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:16:01 -0400
X-AuditID: 12074423-b7babae000007c6b-77-4de4f7d7ec60
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 00/10] Remove syscall instructions at fixed addresses
Date: Tue, 31 May 2011 10:13:58 -0400
Message-Id: <cover.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsUixCmqrSvx44mvwb/VNhZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZbT3bGAtuKRUsWjXevYGxqVSXYyc
	HBICJhIv/q1ih7DFJC7cW8/WxcjFISSwj1Fi8fZDLBDOBkaJAxM3sUM4z5gkTrRfZwVpYRNQ
	kehY+oCpi5GDQ0RAX+LqZ0aQGmaBSSwSh/+eZgGpERbwkDjeehXMZhFQleg49IcJxOYFqr/1
	bzYrxGoFiStX5rFMYORZwMiwilE2JbdKNzcxM6c4NVm3ODkxLy+1SNdMLzezRC81pXQTIyis
	2V2UdzD+Oah0iFGAg1GJh5d7/2NfIdbEsuLK3EOMkhxMSqK8Fd+e+ArxJeWnVGYkFmfEF5Xm
	pBYfYpTgYFYS4f3GB5TjTUmsrEotyodJSXOwKInzzpVU9xUSSE8sSc1OTS1ILYLJynBwKEnw
	1oEMFSxKTU+tSMvMKUFIM3FwggznARpeCFLDW1yQmFucmQ6RP8VozHFpzdaDjByNa3ccZBRi
	ycvPS5US5z0KUioAUppRmgc3DZaaXjGKAz0nzGsDUsUDTGtw814BrWICWtX77iHIqpJEhJRU
	A2OEtr6l2dv7tWZP41oietXnCN3uKVxlb327UliD5Z6g/mWLi1uffnvPrHqzyEJVWSks9qZv
	uphBgOfqop4fmxwqO2580Hc9XGucJ/HGdnvyWyP2pZt75G7Mdm4WUq8q43/oYL/zedDH6rR1
	33SyVzS7bhBe+iX7RLgtl7O85lxzNa+G3XFblFiKMxINtZiLihMBy/D2cygDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is just a bugfix from the last vdso series.
The bug should be harmless but it's pretty dumb.  This is almost
certainly 3.0 material.

Patch 2 adds documentation for entry_64.S.  A lot of the magic in there is far from obvious.

Patches 3, 4, and 5 remove a bunch of syscall instructions in kernel space
at fixed addresses that user code can execute.  Several are data that isn't marked NX.  Patch 2 makes vvars NX and
5/10 makes the HPET NX.

The time() vsyscall contains an explicit syscall fallback.  Patch 3/10
removes it.

At this point, there is only one explicit syscall left in the vsyscall
page: the fallback case for vgettimeofday.  The rest of the series is to
remove it and most of the remaining vsyscall code.

Patch 6 is pure cleanup.  venosys (one of the four vsyscalls) has been
broken for years, so patch 6 removes it.

Patch 7 pads the empty parts of the vsyscall page with 0xcc.  0xcc is an
explicit trap.

Patch 8 removes the code implementing the vsyscalls and replaces it with
magic int 0xcc incantations.  These incantations are specifically
designed so that jumping into them at funny offsets will either work
fine or generate some kind of fault.  This is a significant performance
penalty (~220ns here) for all vsyscall users, but there aren't many
left.  Because current glibc still uses the time vsyscall (although it's
fixed in glibc's git), the option CONFIG_UNSAFE_VSYSCALLS (default y)
will leave time() alone.

This patch is also nice because it removes a bunch of duplicated code
from vsyscall_64.s.

Patch 9/10 randomizes the int 0xcc incantation at bootup.  It is pretty
much worthless for security (there are only three choices for the random
number and it's easy to figure out which one is in use) but it prevents
overly clever userspace programs from thinking that the incantation is
ABI.  One instrumentation tool author offered to hard-code special
handling for int 0xcc; I want to discourage this approach.

Patch 10/10 adds CONFIG_UNSAFE_VSYSCALLS to
feature-removal-schedule.txt.  Removing it won't break anything but it
will slow some older code down.


Changes from v3:
 - Rebased onto tip/master (1a0c84d)

Changes from v2:
 - Reordered the patches.
 - Removed the option to leave gettimeofday and getcpu as native code.
 - Clean up the int 0xcc handler and registration.
 - sched_getcpu works now (thanks, Borislav, for catching my blatant arithmetic error).
 - Numerous small fixes from review comments.
 - Abandon my plan to spread turbostat to the masses.

Changes from v1:
 - Patches 6-10 are new.
 - The int 0xcc code is much prettier and has lots of bugs fixed.
 - I've decided to let everyone compile turbostat on their own :)

Andy Lutomirski (10):
  x86-64: Fix alignment of jiffies variable
  x86-64: Document some of entry_64.S
  x86-64: Give vvars their own page
  x86-64: Remove kernel.vsyscall64 sysctl
  x86-64: Map the HPET NX
  x86-64: Remove vsyscall number 3 (venosys)
  x86-64: Fill unused parts of the vsyscall page with 0xcc
  x86-64: Emulate legacy vsyscalls
  x86-64: Randomize int 0xcc magic al values at boot
  x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule

 Documentation/feature-removal-schedule.txt |    9 +
 Documentation/x86/entry_64.txt             |   98 +++++++++
 arch/x86/Kconfig                           |   17 ++
 arch/x86/include/asm/fixmap.h              |    1 +
 arch/x86/include/asm/irq_vectors.h         |    6 +-
 arch/x86/include/asm/pgtable_types.h       |    6 +-
 arch/x86/include/asm/traps.h               |    4 +
 arch/x86/include/asm/vgtod.h               |    1 -
 arch/x86/include/asm/vsyscall.h            |    6 +
 arch/x86/include/asm/vvar.h                |   24 +-
 arch/x86/kernel/Makefile                   |    1 +
 arch/x86/kernel/entry_64.S                 |    4 +
 arch/x86/kernel/hpet.c                     |    2 +-
 arch/x86/kernel/traps.c                    |    4 +
 arch/x86/kernel/vmlinux.lds.S              |   47 ++--
 arch/x86/kernel/vsyscall_64.c              |  327 +++++++++++++++++-----------
 arch/x86/kernel/vsyscall_emu_64.S          |   42 ++++
 arch/x86/vdso/vclock_gettime.c             |   55 ++---
 18 files changed, 448 insertions(+), 206 deletions(-)
 create mode 100644 Documentation/x86/entry_64.txt
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

-- 
1.7.5.1

