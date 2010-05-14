Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0ENMlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:41:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0ENMlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:41:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=M5NAPypWQWCYlPpO6zTdloMZycBIkbgCV0AB5LKQDINAOw4/zFWKkgQVj8E3bCwGz
	Gnm/VZtLUBJoaB+eWJhpQ==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>,
       Michel Lespinasse <walken@google.com>
Subject: [PATCH 00/10] V2: rwsem changes + down_read_unfair() proposal
Date: Fri, 14 May 2010 05:39:32 -0700
Message-Id: <1273840782-5920-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to sollicit comments regarding the following changes
against 2.6.34-rc7 + 91af708 (from V1 proposal) already applied.

The motivation for this change was some cluster monitoring software we
use at google; which reads /proc/<pid>/maps files for all running
processes. When the machines are under load, the mmap_sem is often
acquire for reads for long periods of time since do_page_fault() holds
it while doing disk accesses; and fair queueing behavior often ends up
in the monitoring software making little progress. By introducing
unfair behavior in a few selected places, are are able to let the
monitoring software make progress without impacting performance for
the rest of the system.

In general, I've made sure to implement this proposal without touching
the rwsem fast paths. Also, the first 8 patches of this series should
be of general applicability even if not taking the down_read_unfair()
changes, addressing minor issues such as situations where reader
threads can get blocked at the head of the waiting list even though
the rwsem is currently owned for reads.

Changes since v1:
- Keep the active count check when trying to wake readers in the up_xxxx()
  slow path (I had suppressed it in v1). However, I did try to lighten the
  check (this is patch 3 of the series).
- Added priviledge check before making use of unfair behavior in
  /proc/<pid>/exe and /proc/<pid>/maps files.
- Applied David Howell's many small suggestions (I hope I did not miss any).

Michel Lespinasse (10):
  x86 rwsem: minor cleanups
  rwsem: fully separate code pathes to wake writers vs readers
  rwsem: lighter active count checks when waking up readers
  rwsem: let RWSEM_WAITING_BIAS represent any number of waiting threads
  rwsem: wake queued readers when writer blocks on active read lock
  rwsem: smaller wrappers around rwsem_down_failed_common
  generic rwsem: implement down_read_unfair
  rwsem: down_read_unfair infrastructure support
  x86 rwsem: down_read_unfair implementation
  Use down_read_unfair() for /sys/<pid>/exe and /sys/<pid>/maps files

 arch/x86/include/asm/rwsem.h   |   70 ++++++++++++-----
 arch/x86/lib/rwsem_64.S        |   14 +++-
 arch/x86/lib/semaphore_32.S    |   21 +++++-
 fs/proc/base.c                 |    2 +-
 fs/proc/task_mmu.c             |    2 +-
 fs/proc/task_nommu.c           |    2 +-
 include/linux/capability.h     |    1 +
 include/linux/rwsem-spinlock.h |   10 ++-
 include/linux/rwsem.h          |   13 +++
 kernel/rwsem.c                 |   31 ++++++++
 lib/rwsem-spinlock.c           |   10 ++-
 lib/rwsem.c                    |  160 ++++++++++++++++++++++++++--------------
 12 files changed, 247 insertions(+), 89 deletions(-)

