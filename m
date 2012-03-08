Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2CHV33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab2CHV31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:29:27 -0500
Date: Thu, 8 Mar 2012 16:29:19 -0500
From: Jason Baron <jbaron@redhat.com>
To: roland@hack.frob.com, akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1331238525.git.jbaron@redhat.com>
Subject: [PATCH 0/2 v2] core dump: re-purpose VM_ALWAYSDUMP to user controlled VM_NODUMP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The motivation for this change was that I was looking at a way for a qemu-kvm
process, to exclude the guest memory from its core dump, which can be quite
large. There are already a number of filter flags in
/proc/<pid>/coredump_filter, however, these allow one to specify 'types' of
kernel memory, not specific address ranges (which is needed in this case).

Since there are no more vma flags available, the first patch eliminates the
need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by the kernel to
mark vdso and vsyscall pages. However, it is simple enough to check if a vma
covers a vdso or vsyscall page without the need for this flag.

The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new
'VM_NODUMP' flag, which can be set by userspace using new madvise flags:
'MADV_NODUMP', and unset via 'MADV_CLEAR_NODUMP'. The core dump filters continue
to work the same as before unless 'MADV_NODUMP' is set on the region.

The qemu code which implements this features is at:
http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch

In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.

I also believe that the 'MADV_NODUMP' flag might be useful for security
sensitive apps, which might want to select which areas are dumped.

Thanks,

-Jason 

Changes from v1 to v2:
1. simplified 'always_dump_vma()' logic
2. Removed no longer necessary comments about VM_ALWAYSDUMP
3. Added more comments around these changes
4. renamed:
	VM_DONTDUMP -> VM_NODUMP,
	MADV_DONTDUMP -> MADV_NODUMP,
	MADV_DUMP -> MADV_CLEAR_NODUMP

Jason Baron (2):
  core dump: drop VM_ALWAYSDUMP flag
  core dump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP

 arch/arm/kernel/process.c          |    2 +-
 arch/hexagon/kernel/vdso.c         |    3 +--
 arch/mips/kernel/vdso.c            |    3 +--
 arch/powerpc/kernel/vdso.c         |   10 ++--------
 arch/s390/kernel/vdso.c            |   10 ++--------
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +--
 arch/tile/mm/elf.c                 |    8 +-------
 arch/unicore32/kernel/process.c    |    2 +-
 arch/x86/um/mem_32.c               |    8 --------
 arch/x86/um/vdso/vma.c             |    3 +--
 arch/x86/vdso/vdso32-setup.c       |   17 ++---------------
 arch/x86/vdso/vma.c                |    3 +--
 fs/binfmt_elf.c                    |   30 ++++++++++++++++++++++++++++--
 include/asm-generic/mman-common.h  |    4 ++++
 include/linux/mm.h                 |    2 +-
 mm/madvise.c                       |    8 ++++++++
 mm/memory.c                        |    8 +-------
 17 files changed, 56 insertions(+), 68 deletions(-)

-- 
1.7.7.6

