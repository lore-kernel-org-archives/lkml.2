Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1E3DtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:49:24 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:58062 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab1E3DtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:49:22 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-05-4de313b8a8fd
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 00/10] Remove syscall instructions at fixed addresses
Date: Sun, 29 May 2011 23:48:37 -0400
Message-Id: <cover.1306724657.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42IRYrdT190h/NjXoOG1rsWc9WvYLPquHGW3
	mHWN1+Lzhn9sFgd+PWWzeH91O5vF5V1z2CyeNF9ntNhyqZnV4sPEDWwWmzdNZbZ41PeW3eLH
	hsesDrwe31v7WDyOnTnM6HGr7Q+zx85Zd9k9Nq/Q8vj/8gibx6ZVnWwe786dY/c4MeM3i8fx
	M84enzfJBXBHcdmkpOZklqUW6dslcGV035nHVtAvX3Hv7nHmBsZ/4l2MnBwSAiYS0/v2MELY
	YhIX7q1nA7GFBPYxSjTtSexi5AKyNzBKvN1wghXCecYksWpRP1gHm4CKRMfSB0xdjBwcIgL6
	Elc/M4LUMAs8Z5Z48HAXK0iNsICHxNtlD5hBbBYBVYnffzeC2bwg9fdOM0NsVpC4cmUeywRG
	ngWMDKsYZVNyq3RzEzNzilOTdYuTE/PyUot0jfVyM0v0UlNKNzGCAphTkm8H49eDSocYBTgY
	lXh4LYoe+QqxJpYVV+YeYpTkYFIS5X0k+NhXiC8pP6UyI7E4I76oNCe1+BCjBAezkgiv+i+g
	ct6UxMqq1KJ8mJQ0B4uSOO9MSXVfIYH0xJLU7NTUgtQimKwMB4eSBG8YMFKFBItS01Mr0jJz
	ShDSTBycIMN5gIbrgyzmLS5IzC3OTIfIn2LU5Whcu+MgoxBLXn5eqpQ4rw3IIAGQoozSPLg5
	sMTzilEc6C1h3itCQFU8wKQFN+kV0BImoCW97x6CLClJREhJNTBmrmV5xH12wZakn3tb+1Y4
	/Fnqvnia5U7vd28utovzHdXh9wmIvhWerhZ++FV8y225rVf6PpzeNTHvRZxdrD5PTsomrYxn
	CR6f1t74f+mPgsZL/0NTTyfXPXXMcNA3mLnUtMDDM+/iIqaLuxpnHr0QuP/6NB8306nlmiVF
	ETqvFvD3C+79k5KsxFKckWioxVxUnAgABN6u6RcDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is really five different parts.



The first part (patch 1/10) is just a bugfix from the last vdso series.
The bug should be harmless but it's pretty dumb.  This is almost
certainly 3.0 material.



The second part removes a bunch of syscall instructions in kernel space
at fixed addresses that user code can execute.  This is not all that
well tested or inspected at this point.

Several are data that isn't marked NX.  Patch 2/10 makes vvars NX and
5/10 makes the HPET NX.

The time() vsyscall contains an explicit syscall fallback.  Patch 3/10
removes it.

The last one is the gettimeofday fallback.  We need that, but it doesn't
have to be a real syscall.  Patch 4/10 adds int 0xcc (callable only from
the vsyscall page) that implements the gettimeofday fallback and nothing
else.



The third part is a more aggressive cleanup of the vsyscall page.  It
removes the code implementing the vsyscalls and replaces it with magic
int 0xcc incantations.  These incantations are specifically designed so
that jumping into them at funny offsets will either work fine or
generate some kind of fault.  Patch 8/10 is optional and might want to
be hidden away in CONFIG_EMBEDDED for awhile.  This needs some more
testing in CONFIG_UNSAFE_VSYSCALLS=y mode and a lot of careful
inspection in CONFIG_UNSAFE_VSYSCALLS=n mode.

Patch 6/10 removes venosys.  It's been broken (crashes) for a couple
years and it doesn't do anything particularly useful anyway.

Patch 7/10 fills the vsyscall page with 0xcc instead of 0x00.  0xcc is
an explicit trap

Patch 8/10 adds a config option to emulate the vsyscalls.  The int 0xcc
incantation intentionally depends on the config option -- it is not ABI.



Patch 9/10 randomizes the int 0xcc incantation at bootup.  It is pretty
much worthless for security (there are only three choices for the random
number and it's easy to figure out which one is in use) but it prevents
overly clever userspace programs from thinking that the incantation is
ABI.  One instrumentation tool author offered to hard-code special
handling for int 0xcc; I want to discourage this approach.

Patch 10/10 adds some documentation for entry_64.S.  A lot of the magic
in there is far from obvious.


Changes from v1:
 - Patches 6-10 are new.
 - The int 0xcc code is much prettier and has lots of bugs fixed.
 - I've decided to let everyone compile turbostat on their own :)

Andy Lutomirski (10):
  x86-64: Fix alignment of jiffies variable
  x86-64: Give vvars their own page
  x86-64: Remove kernel.vsyscall64 sysctl
  x86-64: Replace vsyscall gettimeofday fallback with int 0xcc
  x86-64: Map the HPET NX
  x86-64: Remove vsyscall number 3 (venosys)
  x86-64: Fill unused parts of the vsyscall page with 0xcc
  x86-64: Emulate vsyscalls
  x86-64: Randomize int 0xcc magic al values at boot
  x86-64: Document some of entry_64.S

 Documentation/x86/entry_64.txt       |   95 +++++++++++
 arch/x86/Kconfig                     |   17 ++
 arch/x86/include/asm/fixmap.h        |    1 +
 arch/x86/include/asm/irq_vectors.h   |    6 +-
 arch/x86/include/asm/pgtable_types.h |    6 +-
 arch/x86/include/asm/traps.h         |    4 +
 arch/x86/include/asm/vgtod.h         |    1 -
 arch/x86/include/asm/vsyscall.h      |    6 +
 arch/x86/include/asm/vvar.h          |   24 ++--
 arch/x86/kernel/Makefile             |    3 +
 arch/x86/kernel/entry_64.S           |    4 +
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/traps.c              |    4 +
 arch/x86/kernel/vmlinux.lds.S        |   47 +++---
 arch/x86/kernel/vsyscall_64.c        |  289 +++++++++++++++++++++++++++++-----
 arch/x86/kernel/vsyscall_emu_64.S    |   40 +++++
 arch/x86/vdso/vclock_gettime.c       |   55 +++----
 17 files changed, 486 insertions(+), 118 deletions(-)
 create mode 100644 Documentation/x86/entry_64.txt
 create mode 100644 arch/x86/kernel/vsyscall_emu_64.S

-- 
1.7.5.1

