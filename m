Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0LCARR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:17:17 -0500
Received: from smtp-out.google.com ([74.125.121.35]:40373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab0LCARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:17:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=X1XaVZlnuECA1GOLUkuIT3YWvaQmDqtHSfqaDATXKwE3a0j5ljrBkR0YdM+QmApm2W
         OSIMSc83HrlLcO70xUJQ==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/6] mlock: do not hold mmap_sem for extended periods of time
Date: Thu,  2 Dec 2010 16:16:46 -0800
Message-Id: <1291335412-16231-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently mlock() holds mmap_sem in exclusive mode while the pages get
faulted in. In the case of a large mlock, this can potentially take a
very long time, during which various commands such as 'ps auxw' will
block. This makes sysadmins unhappy:

real    14m36.232s
user    0m0.003s
sys     0m0.015s
(output from 'time ps auxw' while a 20GB file was being mlocked without
being previously preloaded into page cache)

I propose that mlock() could release mmap_sem after the VM_LOCKED bits
have been set in all appropriate VMAs. Then a second pass could be done
to actually mlock the pages, in small batches, releasing mmap_sem when
we block on disk access or when we detect some contention.

Patches are against v2.6.37-rc4 plus my patches to avoid mlock dirtying
(presently queued in -mm).

Michel Lespinasse (6):
  mlock: only hold mmap_sem in shared mode when faulting in pages
  mm: add FOLL_MLOCK follow_page flag.
  mm: move VM_LOCKED check to __mlock_vma_pages_range()
  rwsem: implement rwsem_is_contended()
  mlock: do not hold mmap_sem for extended periods of time
  x86 rwsem: more precise rwsem_is_contended() implementation

 arch/alpha/include/asm/rwsem.h   |    5 +
 arch/ia64/include/asm/rwsem.h    |    5 +
 arch/powerpc/include/asm/rwsem.h |    5 +
 arch/s390/include/asm/rwsem.h    |    5 +
 arch/sh/include/asm/rwsem.h      |    5 +
 arch/sparc/include/asm/rwsem.h   |    5 +
 arch/x86/include/asm/rwsem.h     |   35 ++++++---
 arch/x86/lib/rwsem_64.S          |    4 +-
 arch/x86/lib/semaphore_32.S      |    4 +-
 arch/xtensa/include/asm/rwsem.h  |    5 +
 include/linux/mm.h               |    1 +
 include/linux/rwsem-spinlock.h   |    1 +
 lib/rwsem-spinlock.c             |   12 +++
 mm/internal.h                    |    3 +-
 mm/memory.c                      |   54 ++++++++++++--
 mm/mlock.c                       |  150 ++++++++++++++++++--------------------
 mm/nommu.c                       |    6 +-
 17 files changed, 201 insertions(+), 104 deletions(-)

-- 
1.7.3.1

