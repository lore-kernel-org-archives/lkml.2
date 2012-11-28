Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2K1N5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:57:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab2K1Nxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH/RFC 00/14] perf, tool: Fix endian issues
Date: Wed, 28 Nov 2012 14:52:35 +0100
Message-Id: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to display diff for more than 2 perf.data files.
Sending as RFC, since the change touches lot of hists code,
so I might be breaking something I missed.. still testing.

Also it could colide with Namhyung changes for group report
wrt patches 7 and 8, where I changed the linking of matching
hists entries.

The doc was updated with info about current perf diff processing.

Attached patches:
  01/14 perf tool: Introduce perf_hpp__list for period related columns
  02/14 perf tool: Add struct perf_hpp_fmt into hpp callbacks
  03/14 perf tool: Fix period symbol_conf.field_sep display
  04/14 perf diff: Remove displacement from struct hist_entry_diff
  05/14 perf diff: Change compute methods to work with pair directly
  06/14 perf diff: Change formula methods to work with pair directly
  07/14 perf diff: Add callback to hists__match/hists__link functions
  08/14 perf diff: Change diff command to work over multiple data files
  09/14 perf diff: Update perf diff documentation for multiple data comparison
  10/14 perf tool: Centralize default columns init in perf_hpp__init
  11/14 perf diff: Making compute functions static
  12/14 perf diff: Display data file info ahead of the diff output
  13/14 perf diff: Display zero calculation results
  14/14 perf diff: Add generic order option for compute sorting

Example of multiple perf diff output:

  $ perf diff perf.data.[123456]
  # Event 'cycles:u'
  #
  # Data files:
  #  [0] perf.data.1
  #  [1] perf.data.2
  #  [2] perf.data.3
  #  [3] perf.data.4
  #  [4] perf.data.5
  #  [5] perf.data.6
  #
  # Baseline/0  Delta/1  Delta/2  Delta/3  Delta/4  Delta/5      Shared Object                     Symbol
  # ..........  .......  .......  .......  .......  .......  .................  .........................
  #
                                                    +73.05%  [kernel.kallsyms]  [k] page_fault           
                                                    +26.16%  ld-2.15.so         [.] _dl_next_ld_env_entry
                         +15.40%                             ld-2.15.so         [.] _dl_sysdep_start     
        71.48%           -26.52%                             libc-2.15.so       [.] __strcmp_sse2        
        27.69%   -1.65%            -4.83%   -4.68%           ld-2.15.so         [.] dl_main              
         0.82%   -0.05%   -0.34%   -0.15%   -0.13%   -0.03%  ld-2.15.so         [.] _start               
                         +39.15%                             libc-2.15.so       [.] error_tail           
                +73.18%                                      libc-2.15.so       [.] __strcasecmp_l_sse2  
                                           +76.30%           libc-2.15.so       [.] __stpcpy_sse2        
                                  +76.46%                    libc-2.15.so       [.] _IO_getline_info     

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt |  77 ++++++++--
 tools/perf/builtin-diff.c              | 747 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 tools/perf/ui/browsers/hists.c         |  22 +--
 tools/perf/ui/gtk/browser.c            |  26 +---
 tools/perf/ui/hist.c                   | 392 ++++++++++++++---------------------------------
 tools/perf/ui/stdio/hist.c             |  17 +--
 tools/perf/util/hist.c                 |  29 ++--
 tools/perf/util/hist.h                 |  42 ++---
 tools/perf/util/sort.h                 |  38 ++---
 9 files changed, 855 insertions(+), 535 deletions(-)
