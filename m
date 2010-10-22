Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0JVKDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:03:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:36680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0JVKD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:03:29 -0400
Message-ID: <4CC16150.5090506@kernel.org>
Date: Fri, 22 Oct 2010 12:02:56 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] percpu for v2.6.37-rc1
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 10:02:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive percpu changes for
v2.6.37-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-linus

The branch contains the following notable changes.

* Optimize this_cpu_ptr() on x86 which makes it sequenced by two
  instructions instead of three and removes use of a temp register.
  Also, make get_cpu_var() use this_cpu_ptr() so that it also can
  benefit from the optimization.

* Until now, on UP, percpu allocator wasn't built at all and it
  behaved as a simple wrapper around kmalloc.  This caused the
  following two problems.

  - Unlike percpu allocator, kmalloc can't honor arbitrary alignment
    requirement.  This led to a hacky workaround in cpu_workqueue
    allocation for example.

  - On SMP, percpu allocator is initialized earlier than sl?b
    allocators and their usage of percpu allocator is growing.
    Creating an allocator dependency loop on UP makes special
    workarounds necessary in those allocators.

  So, percpu allocator is now also enabled on UP using the km
  allocator which was originally written for SMP architectures w/o
  mmu.  This will increase memory usage slightly on UP but shouldn't
  be anything noticeable.

Pulling into the current mainline (d4429f60) generates the following
conflict in include/linux/percpu.h caused by get/put_cpu_var()
addition routed through Ingo's tree.

index aeeeef1,0eb5083..5095b83
@@@ -38,10 -38,21 +38,19 @@@
  	(void)&(var);					\
  	preempt_enable();				\
  } while (0)

+ #define get_cpu_ptr(var) ({				\
+ 	preempt_disable();				\
+ 	this_cpu_ptr(var); })
+
+ #define put_cpu_ptr(var) do {				\
+ 	(void)(var);					\
+ 	preempt_enable();				\
+ } while (0)
+
 -#ifdef CONFIG_SMP
 -
  /* minimum unit size, also is the maximum supported allocation size */
 -#define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(64 << 10)
 +#define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(32 << 10)

  /*
   * Percpu allocator can serve percpu allocations before slab is
   * initialized which allows slab to depend on the percpu allocator.

Just in case, the merged tree is available in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git merged

Thanks.

Brian Gerst (2):
      x86, percpu: Optimize this_cpu_ptr
      percpu: Optimize __get_cpu_var()

Tejun Heo (6):
      vmalloc: pcpu_get/free_vm_areas() aren't needed on UP
      percpu: reduce PCPU_MIN_UNIT_SIZE to 32k
      percpu: use percpu allocator on UP too
      percpu: fix build breakage on s390 and cleanup build configuration tests
      percpu: clear memory allocated with the km allocator
      percpu: update comments to reflect that percpu allocations are always zero-filled

 arch/x86/include/asm/percpu.h |   14 ++
 include/asm-generic/percpu.h  |   14 +-
 include/linux/percpu.h        |   31 +---
 include/linux/vmalloc.h       |    2 +
 mm/Kconfig                    |    8 +
 mm/Makefile                   |    7 +-
 mm/percpu-km.c                |    8 +-
 mm/percpu.c                   |  401 ++++++++++++++++++++++++-----------------
 mm/percpu_up.c                |   30 ---
 mm/vmalloc.c                  |    2 +
 10 files changed, 281 insertions(+), 236 deletions(-)
 delete mode 100644 mm/percpu_up.c


-- 
tejun
