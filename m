Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1F2XeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:34:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1F2XeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [GIT PULL] perf tools updates
Date: Thu, 30 Jun 2011 01:34:02 +0200
Message-Id: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

It adds the inverted callchains support and let one use
parent filtering with parent sorting at the same time, because
it appears to me that inverted callchains sorted by filtered
parents is pretty useful, and extendable to more cool things.

Anyway inverted callchains used with some different sorting combination
in general can provide some interesting analysis flavours.

Having played with it a bit. It seems to me the callee point
of view (traditional -g callchains) is better suited to
find the precise zoomed-in places where cpu time is most
spent. Spot contention places, etc...

OTOH, caller point of view (-G, inverted callchain), is
for zoomed out observation, of course. It's more suited for
global profiling. To get a big overview of where the hot bulk
of a program is executing for example.

Examples:

- look at the hottest tree of call of a program.

	./perf report -G -s pid --stdio
	
     5.73%               perf:11933
            |
            --- __libc_start_main
               |          
               |--99.18%-- main
               |          run_builtin
               |          cmd_bench
               |          |          
               |          |--89.68%-- bench_sched_messaging
               |          |          |          
               |          |          |--96.11%-- create_worker
               |          |          |          |          
               |          |          |          |--95.10%-- __libc_fork
               |          |          |          |          |          
               |          |          |          |          |--93.99%-- stub_clone
               |          |          |          |          |          sys_clone
               |          |          |          |          |          do_fork
               |          |          |          |          |          |          
               |          |          |          |          |          |--99.09%-- copy_process
               |          |          |          |          |          |          |          
               |          |          |          |          |          |          |--91.62%-- dup_mm

- look at where kernel threads spend their time

	perf report -G -p kernel_thread -s parent --stdio
	
# Overhead  Parent symbol
# ........  .............
#
     0.07%  kernel_thread_helper
            |
            --- kernel_thread_helper
                kthread
               |          
               |--50.00%-- kjournald2
               |          jbd2_journal_commit_transaction
               |          journal_submit_commit_record
               |          submit_bh
               |          submit_bio
               |          generic_make_request
               |          __make_request
               |          __blk_run_queue
               |          scsi_request_fn
               |          scsi_dispatch_cmd
               |          ata_scsi_queuecmd
               |          ata_scsi_translate
               |          ata_qc_issue
               |          ata_bmdma_qc_issue
               |          ata_sff_qc_issue
               |          ata_sff_tf_load
               |          ata_sff_check_status
               |          ioread8
               |          
                --50.00%-- rcu_kthread
                          rcu_process_callbacks
                          delayed_put_task_struct
                          __put_task_struct
                          free_task
                          free_thread_info
                          free_thread_xstate
                          kmem_cache_free
                          __slab_free
                          add_partial
                          _raw_spin_lock
                          lock_acquire
                          
etc...

We could extend that by applying some cut in the callchains.
For example stop a callchain on a given dso and you can profile
which exported function is most called in it.

Anyway, this has some nice potential.


Thanks,
	Frederic
---

Frederic Weisbecker (5):
      perf tools: Make sort operations static
      perf tools: Remove sort print helpers declarations
      perf tools: Don't display ignored entries on stdio ui
      perf tools: Allow sort dimensions to be registered more than once
      perf tools: Only display parent field if explictly sorted

Sam Liao (1):
      perf tools: Add inverted call graph report support.


 tools/perf/Documentation/perf-report.txt |   15 ++-
 tools/perf/builtin-report.c              |   42 +++++-
 tools/perf/util/callchain.h              |    6 +
 tools/perf/util/hist.c                   |    6 +-
 tools/perf/util/session.c                |    7 +-
 tools/perf/util/sort.c                   |  223 ++++++++++++++----------------
 tools/perf/util/sort.h                   |   14 --
 7 files changed, 169 insertions(+), 144 deletions(-)
