Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2CGRAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2CGRAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:00:51 -0500
Date: Wed, 7 Mar 2012 12:00:46 -0500
From: Jason Baron <jbaron@redhat.com>
To: mcgrathr@google.com
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Message-Id: <cover.1331137504.git.jbaron@redhat.com>
Subject: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to user controlled VM_DONTDUMP
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
'VM_DONTDUMP' flag, which can be set by userspace using new madvise flags:
'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters continue to
work the same as before unless 'MADV_DONTDUMP' is set on the region.

The qemu code which implements this features is at:
http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch

In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.

I also believe that the 'MADV_DONTDUMP' flag might be useful for security
sensitive apps, which might want to select which areas are dumped.

Thanks,

-Jason 


Jason Baron (2):
  core dump: drop VM_ALWAYSDUMP flag
  core dump: add a new VM_DONTDUMP flag

 arch/arm/kernel/process.c          |    2 +-
 arch/hexagon/kernel/vdso.c         |    3 +--
 arch/mips/kernel/vdso.c            |    3 +--
 arch/powerpc/kernel/vdso.c         |    3 +--
 arch/s390/kernel/vdso.c            |    3 +--
 arch/sh/kernel/vsyscall/vsyscall.c |    3 +--
 arch/tile/mm/elf.c                 |    3 +--
 arch/unicore32/kernel/process.c    |    2 +-
 arch/x86/um/mem_32.c               |    8 --------
 arch/x86/um/vdso/vma.c             |    3 +--
 arch/x86/vdso/vdso32-setup.c       |   11 ++---------
 arch/x86/vdso/vma.c                |    3 +--
 fs/binfmt_elf.c                    |   23 +++++++++++++++++++++--
 include/asm-generic/mman-common.h  |    3 +++
 include/linux/mm.h                 |    2 +-
 mm/madvise.c                       |    8 ++++++++
 mm/memory.c                        |    8 +-------
 17 files changed, 46 insertions(+), 45 deletions(-)

-- 
1.7.7.6

