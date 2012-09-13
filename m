Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab2IMH1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:05 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab2IMH1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:01 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-ae-50518ac22f00
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC/PATCHSET 00/15] perf report: Add support to accumulate hist periods
Date: Thu, 13 Sep 2012 16:19:56 +0900
Message-Id: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my first attempt to implement cumulative hist period report.
This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
rewrote it from scratch.

It basically adds period in a sample to every node in the callchain.
A hist_entry now has an additional fields to keep the cumulative
period if --cumulate option is given on perf report.

Let me show you an example:

  $ cat abc.c
  #define barrier() asm volatile("" ::: "memory")
  
  void a(void)
  {
  	int i;
  
  	for (i = 0; i < 1000000; i++)
  		barrier();
  }
  
  void b(void)
  {
  	a();
  }
  
  void c(void)
  {
  	b();
  }
  
  int main(void)
  {
  	c();
  
  	return 0;
  }
  
With this simple program I ran perf record and report:

  $ perf record -g -e cycles:u ./abc
  $ perf report -g none --stdio
  [snip]
  # Overhead  Command       Shared Object                      Symbol
  # ........  .......  ..................  ..........................
  #
      93.35%      abc  abc                 [.] a                     
       5.17%      abc  ld-2.15.so          [.] _dl_map_object_from_fd
       1.13%      abc  ld-2.15.so          [.] _dl_start             
       0.29%      abc  libpthread-2.15.so  [.] __libc_close          
       0.07%      abc  [kernel.kallsyms]   [k] page_fault            
       0.00%      abc  ld-2.15.so          [.] _start                
  
When --cumulate option is given, it'll be shown like this:

   $ perf report --cumulate
   (...)
   +  93.63%  abc  libc-2.15.so        [.] __libc_start_main
   +  93.35%  abc  abc                 [.] main
   +  93.35%  abc  abc                 [.] c
   +  93.35%  abc  abc                 [.] b
   +  93.35%  abc  abc                 [.] a
   +   5.17%  abc  ld-2.15.so          [.] _dl_map_object
   +   5.17%  abc  ld-2.15.so          [.] _dl_map_object_from_fd
   +   1.13%  abc  ld-2.15.so          [.] _dl_start_user
   +   1.13%  abc  ld-2.15.so          [.] _dl_start
   +   0.29%  abc  perf                [.] main
   +   0.29%  abc  perf                [.] run_builtin
   +   0.29%  abc  perf                [.] cmd_record
   +   0.29%  abc  libpthread-2.15.so  [.] __libc_close
   +   0.07%  abc  ld-2.15.so          [.] _start
   +   0.07%  abc  [kernel.kallsyms]   [k] page_fault
   
(This output came from TUI since stdio bothered by callchains)

As you can see __libc_start_main -> main -> c -> b -> a callchain show
up in the output.

It might have some rough edges or even bugs, but I really want to
release it and get reviews.  In fact I saw some very large percentage
or 'inf' on some callchain nodes when expanding.

It currently ignores samples don't have symbol info when accumulating
periods along the callchain.  Otherwise it resulted in very strangely
large output since every node in the callchain would be added into a
single entry which has NULL dso/sym.  Simply ignoring them solved the
problem and I couldn't come up with a better solution.

This patchset is based on current acme/perf/core + my small fixes [2],[3].
You can also get this series on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/cumulate-v1

Any comments are welcome, thanks.
Namhyung

[1] https://lkml.org/lkml/2012/3/31/6
[2] https://lkml.org/lkml/2012/9/11/546
[3] https://lkml.org/lkml/2012/9/12/51


Namhyung Kim (15):
  perf hists: Add missing period_* fields when collapsing a hist entry
  perf hists: Introduce struct he_stat
  perf hists: Move he->stat.nr_events initialization to a template
  perf hists: Convert hist entry functions to use struct he_stat
  perf hists: Add more helpers for hist entry stat
  perf hists: Add support for accumulated stat of hist entry
  perf hists: Check if accumulated when adding a hist entry
  perf callchain: Add a couple of callchain helpers
  perf hists: Let add_hist_entry to make a hist entry template
  perf hists: Accumulate hist entry stat based on the callchain
  perf hists: Sort hist entries by accumulated period
  perf ui/hist: Add support to accumulated hist stat
  perf ui/browser: Add support to accumulated hist stat
  perf ui/gtk: Add support to accumulated hist stat
  perf report: Add --cumulate option

 tools/perf/builtin-report.c    |   8 ++
 tools/perf/ui/browsers/hists.c |  12 +-
 tools/perf/ui/gtk/browser.c    |   5 +-
 tools/perf/ui/hist.c           |  74 ++++++++++---
 tools/perf/ui/stdio/hist.c     |   2 +-
 tools/perf/util/callchain.c    |  15 +++
 tools/perf/util/callchain.h    |  17 +++
 tools/perf/util/hist.c         | 242 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/sort.h         |  17 ++-
 tools/perf/util/symbol.h       |   1 +
 10 files changed, 318 insertions(+), 75 deletions(-)

-- 
1.7.11.4

