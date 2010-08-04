Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab0HDNiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:38:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:50961 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0HDNiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:38:12 -0400
Message-ID: <4C596D21.4080101@kernel.org>
Date: Wed, 04 Aug 2010 15:37:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Daniel Walker <dwalker@codeaurora.org>, Jeff Garzik <jeff@garzik.org>,
        David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] workqueue for v2.6.36
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 Aug 2010 13:37:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

to receive the concurrencey managed workqueue patches.  The branch
contains 32 patches to prepare for and implement cmwq and 23 patches
fixing bugs and converting libata, async, fscache and other slow-work
users to workqueue and remove slow-work.

The following overview section gives a brief overview.  For more
detailed information, please refer to the last posting of cmwq
patchset.

  http://thread.gmane.org/gmane.linux.kernel/1003710

Most objections have been addressed and all the contained conversions
have been acked by respective subsystem maintainers.

One that wasn't addressed was Daniel Walker's objection on the ground
that cmwq would make it impossible to adjust priorities of workqueue
threads which can be useful as an ad-hoc optimization.  I don't plan
to address this concern (suggested solution is to add userland visible
knobs to adjust workqueue priorities) at this point because it is an
implementation detail that userspace shouldn't diddle with in the
first place.  For details, please read the following thread.

  http://thread.gmane.org/gmane.linux.kernel/998652/focus=999232

Thanks.


OVERVIEW
========

The bulk of changes is concentrated on making all the different
workqueues share per-cpu global worker pools, which greatly lessens
up-front resource requirement per workqueue thus increasing
scalability and reducing use case constraints.

One major restriction which is removed by the use of shared worker
pool is the level of concurrency per workqueue.  Normal workqueues
only provide one execution context per cpu, single cpu workqueues one
per each workqueue.  This often introduces unnecessary and irregular
latencies in work execution and easily creates deadlocks around
execution resources.  With shared worker pool, workqueues can easily
provide high level of concurrency and most of the issues become
marginal.

The 'concurreny-managed' part of name comes from how each per-cpu
global worker pool manages its concurrency.  It hooks into scheduler
code and tracks the number of runnable workers and starts executing
new works iff it reaches zero.  This maintains just enough level of
concurrency without depending on fragile heuristics which are usually
needed for thread pools.  In most cases, workqueues are used as a way
to obtain a sleepable execution context (ie. they don't burn a lot of
cpu cycles) and the minimal level of concurrency fits this usage model
very well - it doesn't add to latency while maximizing batch execution
and reuse of workers.

The basics of cmwq haven't changed much since its initial posting from
about a year ago.  Most of updates were regarding interaction w/
scheduler and features which were necessary to convert users which
were using private pools.  On macro level, the followings are notable.

* WQ_NON_REENTRANT ordering.  By default, workqueues retain the same
  loose execution semantics where only non-reentrancy on the same CPU
  is guaranteed.  WQ_NON_REENTRANT guarantees non-reetrancy across all
  CPUs.  This is useful for single CPU workqueue users which don't
  really need full ordering.

* WQ_CPU_INTENSIVE.  This is created to serve cpu-bound cpu intensive
  workloads.  Works which may consume a lot of cpu cycles shouldn't
  participate in concurrency management as they may block other works
  for a long time.

* WQ_HIGHPRI for highpri workqueues.  Works scheduled on highpri
  workqueues are queued at the head of global work queue.

* Unbound workqueue.  Workqueues created with WQ_UNBOUND is not bound
  to any specific workqueue and basically behaves as simple thread
  pool which spawns and assigns workers on-demand.  This is used for
  cases where there can be a lot of long running cpu intensive workers
  which can be better served by regular thread scheduling.  It's also
  used to serve single cpu workqueues as managing concurrency isn't as
  useful for them and unbound workers are handled as if they all are
  on the same cpu making implementing the ordering requirement
  trivial.


CURRENT STATE AND TODOS
=======================

The core code has been mostly stable for some time and conversions of
different types (libata taking advantage of the flexibility of cmwq,
replacement of backend worker pool for async, replacement of slow-work
mechanism) were successfully done and acked by respective maintainers.
TODO items are...

* Currently, a lot of workqueues needlessly are single CPU and/or have
  WQ_RESCUER set through safe default conversion of create_workqueue()
  wrappers.  Audit each workqueue users and convert them to use new
  alloc_workqueue() function w/ only necessary restrictions and
  features.

* Conversions of other private worker pools.  Writeback worker pool is
  currently being worked on and SCSI EH pool would probably follow.

* Debug facilities using the tracing API.

* (maybe) Better lockdep annotation.  The current lockdep annotation
  still assumes single execution context per cpu.

* Documentation (probably from previous patchset head messages).


MERGE CONFLICTS AND RESOLUSTIONS
================================

Merging with the current mainline results in the following three
conflicts.  All of them are under fs/cifs/.

1. fs/cifs/cifsfs.c

This is between cmwq conversion dropping slow-work clean up path and
cifs updating DFL_UPCALL cleanup path.  As there's no later failure
path, just removing the updated function in the cleanup path is
enough.

   #ifdef CONFIG_CIFS_DFS_UPCALL
   <<<<<<< HEAD
   =======
	   cifs_exit_dns_resolver();
   >>>>>>> 3a09b1be53d23df780a0cd0e4087a05e2ca4a00c
    out_unregister_key_type:
   #endif

Resolution

   #ifdef CONFIG_CIFS_DFS_UPCALL
    out_unregister_key_type:
   #endif


2. fs/cifs/file.c

This is simple context conflict.

   <<<<<<< HEAD
   void cifs_oplock_break(struct work_struct *work)
   =======
   static int cifs_release_page(struct page *page, gfp_t gfp)
   {
	   if (PagePrivate(page))
		   return 0;

	   return cifs_fscache_release_page(page, gfp);
   }

   static void cifs_invalidate_page(struct page *page, unsigned long offset)
   {
	   struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);

	   if (offset == 0)
		   cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
   }

   static void
   cifs_oplock_break(struct slow_work *work)
   >>>>>>> 3a09b1be53d23df780a0cd0e4087a05e2ca4a00c

Resolution

 static int cifs_release_page(struct page *page, gfp_t gfp)
 {
	 if (PagePrivate(page))
		 return 0;

	 return cifs_fscache_release_page(page, gfp);
 }

 static void cifs_invalidate_page(struct page *page, unsigned long offset)
 {
	 struct cifsInodeInfo *cifsi = CIFS_I(page->mapping->host);

	 if (offset == 0)
		 cifs_fscache_invalidate_page(page, &cifsi->vfs_inode);
 }

 void cifs_oplock_break(struct work_struct *work)


3. fs/cifs/cifsglob.h

Another context conflict.

    <<<<<<< HEAD
    void cifs_oplock_break(struct work_struct *work);
    void cifs_oplock_break_get(struct cifsFileInfo *cfile);
    void cifs_oplock_break_put(struct cifsFileInfo *cfile);
    =======
    extern const struct slow_work_ops cifs_oplock_break_ops;

    #endif	/* _CIFS_GLOB_H */
    >>>>>>> 3a09b1be53d23df780a0cd0e4087a05e2ca4a00c

Resolution

    void cifs_oplock_break(struct work_struct *work);
    void cifs_oplock_break_get(struct cifsFileInfo *cfile);
    void cifs_oplock_break_put(struct cifsFileInfo *cfile);

    extern const struct slow_work_ops cifs_oplock_break_ops;

    #endif	/* _CIFS_GLOB_H */


COMMITS AND CHANGES
===================

Suresh Siddha (1):
      workqueue: mark init_workqueues() as early_initcall()

Tejun Heo (54):
      kthread: implement kthread_worker
      ivtv: use kthread_worker instead of workqueue
      kthread: implement kthread_data()
      acpi: use queue_work_on() instead of binding workqueue worker to cpu0
      workqueue: kill RT workqueue
      workqueue: misc/cosmetic updates
      workqueue: merge feature parameters into flags
      workqueue: define masks for work flags and conditionalize STATIC flags
      workqueue: separate out process_one_work()
      workqueue: temporarily remove workqueue tracing
      workqueue: kill cpu_populated_map
      workqueue: update cwq alignement
      workqueue: reimplement workqueue flushing using color coded works
      workqueue: introduce worker
      workqueue: reimplement work flushing using linked works
      workqueue: implement per-cwq active work limit
      workqueue: reimplement workqueue freeze using max_active
      workqueue: introduce global cwq and unify cwq locks
      workqueue: implement worker states
      workqueue: reimplement CPU hotplugging support using trustee
      workqueue: make single thread workqueue shared worker pool friendly
      workqueue: add find_worker_executing_work() and track current_cwq
      workqueue: carry cpu number in work data once execution starts
      workqueue: implement WQ_NON_REENTRANT
      workqueue: use shared worklist and pool all workers per cpu
      workqueue: implement worker_{set|clr}_flags()
      workqueue: implement concurrency managed dynamic worker pool
      workqueue: increase max_active of keventd and kill current_is_keventd()
      workqueue: s/__create_workqueue()/alloc_workqueue()/, and add system workqueues
      workqueue: implement several utility APIs
      workqueue: implement high priority workqueue
      workqueue: implement cpu intensive workqueue
      workqueue: use worker_set/clr_flags() only from worker itself
      workqueue: fix race condition in flush_workqueue()
      workqueue: fix incorrect cpu number BUG_ON() in get_work_gcwq()
      workqueue: fix worker management invocation without pending works
      libata: take advantage of cmwq and remove concurrency limitations
      workqueue: prepare for WQ_UNBOUND implementation
      workqueue: implement unbound workqueue
      workqueue: remove WQ_SINGLE_CPU and use WQ_UNBOUND instead
      async: use workqueue for worker pool
      workqueue: fix locking in retry path of maybe_create_worker()
      workqueue: fix build problem on !CONFIG_SMP
      workqueue: fix mayday_mask handling on UP
      workqueue: fix how cpu number is stored in work->data
      fscache: convert object to use workqueue instead of slow-work
      fscache: convert operation to use workqueue instead of slow-work
      fscache: drop references to slow-work
      cifs: use workqueue instead of slow-work
      drm: use workqueue instead of slow-work
      gfs2: use workqueue instead of slow-work
      slow-work: kill it
      fscache: fix build on !CONFIG_SYSCTL
      workqueue: explain for_each_*cwq_cpu() iterators

 Documentation/filesystems/caching/fscache.txt |   10 +-
 Documentation/slow-work.txt                   |  322 ---
 arch/ia64/kernel/smpboot.c                    |    2 +-
 arch/x86/kernel/smpboot.c                     |    2 +-
 drivers/acpi/osl.c                            |   40 +-
 drivers/ata/libata-core.c                     |   20 +-
 drivers/ata/libata-eh.c                       |    4 +-
 drivers/ata/libata-scsi.c                     |   10 +-
 drivers/ata/libata-sff.c                      |    9 +-
 drivers/ata/libata.h                          |    1 -
 drivers/gpu/drm/drm_crtc_helper.c             |   29 +-
 drivers/media/video/ivtv/ivtv-driver.c        |   26 +-
 drivers/media/video/ivtv/ivtv-driver.h        |    8 +-
 drivers/media/video/ivtv/ivtv-irq.c           |   15 +-
 drivers/media/video/ivtv/ivtv-irq.h           |    2 +-
 fs/cachefiles/namei.c                         |   13 +-
 fs/cachefiles/rdwr.c                          |    4 +-
 fs/cifs/Kconfig                               |    1 -
 fs/cifs/cifsfs.c                              |    5 -
 fs/cifs/cifsglob.h                            |    8 +-
 fs/cifs/dir.c                                 |    2 +-
 fs/cifs/file.c                                |   30 +-
 fs/cifs/misc.c                                |   20 +-
 fs/fscache/Kconfig                            |    1 -
 fs/fscache/internal.h                         |    8 +
 fs/fscache/main.c                             |  106 +-
 fs/fscache/object-list.c                      |   11 +-
 fs/fscache/object.c                           |  106 +-
 fs/fscache/operation.c                        |   67 +-
 fs/fscache/page.c                             |   36 +-
 fs/gfs2/Kconfig                               |    1 -
 fs/gfs2/incore.h                              |    3 +-
 fs/gfs2/main.c                                |   14 +-
 fs/gfs2/ops_fstype.c                          |    8 +-
 fs/gfs2/recovery.c                            |   54 +-
 fs/gfs2/recovery.h                            |    6 +-
 fs/gfs2/sys.c                                 |    3 +-
 include/drm/drm_crtc.h                        |    3 +-
 include/linux/cpu.h                           |    2 +
 include/linux/fscache-cache.h                 |   47 +-
 include/linux/kthread.h                       |   65 +
 include/linux/libata.h                        |    1 +
 include/linux/slow-work.h                     |  163 --
 include/linux/workqueue.h                     |  154 +-
 include/trace/events/workqueue.h              |   92 -
 init/Kconfig                                  |   24 -
 init/main.c                                   |    2 -
 kernel/Makefile                               |    2 -
 kernel/async.c                                |  141 +-
 kernel/kthread.c                              |  164 ++
 kernel/power/process.c                        |   21 +-
 kernel/slow-work-debugfs.c                    |  227 --
 kernel/slow-work.c                            | 1068 ---------
 kernel/slow-work.h                            |   72 -
 kernel/sysctl.c                               |    8 -
 kernel/trace/Kconfig                          |   11 -
 kernel/workqueue.c                            | 3160 +++++++++++++++++++++----
 kernel/workqueue_sched.h                      |   13 +-
 58 files changed, 3505 insertions(+), 2942 deletions(-)
 delete mode 100644 Documentation/slow-work.txt
 delete mode 100644 include/linux/slow-work.h
 delete mode 100644 include/trace/events/workqueue.h
 delete mode 100644 kernel/slow-work-debugfs.c
 delete mode 100644 kernel/slow-work.c
 delete mode 100644 kernel/slow-work.h

--
tejun
