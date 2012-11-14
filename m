Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab2KNHjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:39:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2KNHjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:39:37 -0500
Date: Tue, 13 Nov 2012 23:39:10 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-jeq55qdgby1745bs8r9sscdh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Use hists__link when not pairing just with baseline
Git-Commit-ID: bfaef4b46b17ff053dc38f979cec364b0715cabb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:39:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfaef4b46b17ff053dc38f979cec364b0715cabb
Gitweb:     http://git.kernel.org/tip/bfaef4b46b17ff053dc38f979cec364b0715cabb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 8 Nov 2012 18:08:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 18:08:26 -0300

perf diff: Use hists__link when not pairing just with baseline

Previously there were blind spots because we were not looking at symbols
that didn't ocurred in the latest run:

  # perf record usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.018 MB perf.data (~801 samples) ]
  # perf record usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.018 MB perf.data (~801 samples) ]

Before:

  # perf diff
  # Event 'cycles'
  #
  # Baseline    Delta      Shared Object                         Symbol
  # ........  .......  .................  .............................
  #
              +10.38%  [kernel.kallsyms]  [k] get_empty_filp
               +9.51%  [kernel.kallsyms]  [k] update_sd_lb_stats
               +9.41%  libpopt.so.0.0.0   [.] _init
               +9.29%  [kernel.kallsyms]  [k] vma_interval_tree_insert
       9.05%   +0.12%  [kernel.kallsyms]  [k] do_sys_open
               +9.14%  [kernel.kallsyms]  [k] kfree
               +8.98%  [kernel.kallsyms]  [k] free_pages_and_swap_cache
               +8.78%  [kernel.kallsyms]  [k] unmap_page_range
       9.36%   -0.90%  [kernel.kallsyms]  [k] zap_pte_range
       7.60%   +0.09%  [kernel.kallsyms]  [k] find_next_bit
               +4.37%  [kernel.kallsyms]  [k] place_entity
               +3.38%  [kernel.kallsyms]  [k] __do_page_fault
               +0.80%  [kernel.kallsyms]  [k] native_apic_mem_write
       0.21%   +0.43%  [kernel.kallsyms]  [k] native_write_msr_safe
  #

So 9.05 + 9.36 + 7.60 + 0.21 != 100%

Now using the recently introduced hists__link we can see the whole
picture:

  # perf diff
  # Event 'cycles'
  #
  # Baseline    Delta      Shared Object                         Symbol
  # ........  .......  .................  .............................
  #
       8.44%   -8.44%  [kernel.kallsyms]  [k] _raw_spin_lock
       9.05%   -9.05%  [kernel.kallsyms]  [k] sha_transform
      10.55%  -10.55%  [kernel.kallsyms]  [k] __d_lookup_rcu
              +10.38%  [kernel.kallsyms]  [k] get_empty_filp
      17.70%  -17.70%  [kernel.kallsyms]  [k] kmem_cache_free
               +9.51%  [kernel.kallsyms]  [k] update_sd_lb_stats
               +9.41%  libpopt.so.0.0.0   [.] _init
               +9.29%  [kernel.kallsyms]  [k] vma_interval_tree_insert
       9.05%   +0.12%  [kernel.kallsyms]  [k] do_sys_open
               +9.14%  [kernel.kallsyms]  [k] kfree
               +8.98%  [kernel.kallsyms]  [k] free_pages_and_swap_cache
               +8.78%  [kernel.kallsyms]  [k] unmap_page_range
       9.36%   -0.90%  [kernel.kallsyms]  [k] zap_pte_range
       7.60%   +0.09%  [kernel.kallsyms]  [k] find_next_bit
               +4.37%  [kernel.kallsyms]  [k] place_entity
               +3.38%  [kernel.kallsyms]  [k] __do_page_fault
       4.01%   -4.01%  [kernel.kallsyms]  [k] handle_pte_fault
       9.27%   -9.27%  [kernel.kallsyms]  [k] find_get_page
       0.78%   -0.78%  [kernel.kallsyms]  [k] rcu_irq_enter
       0.57%   -0.57%  [kernel.kallsyms]  [k] finish_task_switch
       4.25%   -4.25%  [kernel.kallsyms]  [k] run_timer_softirq
               +0.80%  [kernel.kallsyms]  [k] native_apic_mem_write
       0.21%   +0.43%  [kernel.kallsyms]  [k] native_write_msr_safe
       9.16%   -9.16%  ld-2.12.so         [.] close
  #

Now:

8.44 + 9.05 + 10.55 + 17.70 + 9.05 + 9.36 +
7.60 + 4.01 + 9.27 + 0.78 + 0.57 + 4.25 + 0.21 + 9.16 == 100%

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jeq55qdgby1745bs8r9sscdh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index e99fb3b..93b852f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -491,6 +491,8 @@ static void hists__process(struct hists *old, struct hists *new)
 
 	if (show_baseline_only)
 		hists__baseline_only(new);
+	else
+		hists__link(new, old);
 
 	if (sort_compute) {
 		hists__precompute(new);
