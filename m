Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0EQW1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:27:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:25653 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0EQW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:27:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=RA+eSu9f8KJjr82u41DkwLNH4OsZy3CY5gfhQr7VmCcDWaRuu1H1Cec1JGNng/Kar
	rPwVNXvQcjYXA1vx+Y5SA==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 00/10] V3: rwsem changes + down_read_critical() proposal
Date: Mon, 17 May 2010 15:25:44 -0700
Message-Id: <1274135154-24082-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is version 3 of my rwsem changes. Patches 7 and 10 were modified to
address Linus's comments about the API. Please consider for merging.

Changes since V2:

- Rebased to 2.6.34

- Changed patch 07 to address Linus's comments about the API.
  down_read_critical() and up_read_critical() now work as a pair; threads
  using this are allowed to skip over blocked threads when acquiring the
  read lock; however they must make sure to quickly release that lock and
  in particular, they are forbidden to block.

- Changed patch 10 to make use of the down_read_critical()/up_read_critical()
  API when accessing /proc/<pid>/exe and /proc/<pid>/maps files.
  I excluded smaps and numa_maps files, which can actually block while
  being generated (smaps blocks in smaps_pte_range() doing a cond_resched(),
  which seems legitimate as it's a potentially heavy operation. numa_maps
  blocks in show_numa_map() doing a bzalloc of struct numa_maps, which
  should probably get done in do_maps_open() instead).

The motivation for this change was some cluster monitoring software we
use at google; which reads /proc/<pid>/maps files for all running
processes. When the machines are under load, the mmap_sem is often
acquire for reads for long periods of time since do_page_fault() holds
it while doing disk accesses; and fair queueing behavior often ends up
in the monitoring software making little progress. By introducing
unfair behavior in a few selected places, are are able to let the
monitoring software make progress without impacting performance for
the rest of the system. I've made sure not to change the rwsem fast
paths in implementing this proposal.

Michel Lespinasse (10):
  x86 rwsem: minor cleanups
  rwsem: fully separate code pathes to wake writers vs readers
  rwsem: lighter active count checks when waking up readers
  rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
  rwsem: wake queued readers when writer blocks on active read lock
  rwsem: smaller wrappers around rwsem_down_failed_common
  generic rwsem: implement down_read_critical() / up_read_critical()
  rwsem: down_read_critical infrastructure support
  x86 rwsem: down_read_critical implementation
  Use down_read_critical() for /sys/<pid>/exe and /sys/<pid>/maps files

 arch/x86/include/asm/rwsem.h   |   70 ++++++++++++-----
 arch/x86/lib/rwsem_64.S        |   14 +++-
 arch/x86/lib/semaphore_32.S    |   21 +++++-
 fs/proc/base.c                 |    4 +-
 fs/proc/task_mmu.c             |   24 ++++--
 include/linux/proc_fs.h        |    1 +
 include/linux/rwsem-spinlock.h |   10 ++-
 include/linux/rwsem.h          |   12 +++
 kernel/rwsem.c                 |   35 +++++++++
 lib/rwsem-spinlock.c           |   10 ++-
 lib/rwsem.c                    |  160 ++++++++++++++++++++++++++--------------
 11 files changed, 266 insertions(+), 95 deletions(-)
