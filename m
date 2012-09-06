Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446Ab2IFPrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab2IFPru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:47:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [RFC 00/12] perf diff: Factor diff command
Date: Thu,  6 Sep 2012 17:46:54 +0200
Message-Id: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset factors the perf diff command to be usable for
differential profiling following paper from Paul McKenney:
(thanks to Arnaldo for sharing it with me).

  http://www2.rdrop.com/users/paulmck/scalability/paper/profiling.2002.06.04.pdf

The 'perf diff' and 'std/hist' code is now changed to allow computations
mentioned in the paper. Two of them are implemented within this patchset:
  1) ratio differential profiling
  2) weighted differential profiling

The standard ratio delta computation stays as default.

To sum it up:
  - perf diff displays output for matching event pairs within 2 given perf.data files
  - stdio ui code is factored to allow easy insertion of new data column
  - added perf diff '-b' option to display only matched hist entries
    (hist entries found in both files)
  - added perf diff '-c' option to choose diff computation,
    support for:
      delta: the current default one
      ratio: ratio differential profile
      wdiff: weighted differential profile
  - added perf diff '-c+' option to sort entries based on the computation data
  - added perf diff '-F' option to show formula used to compute the data
  - added perf diff '-p' option to display hist entries periods


Attached patches:
  01/12 perf diff: Make diff command work with evsel hists
  02/12 perf tools: Replace sort's standalone field_sep with symbol_conf.field_sep
  03/12 perf hists: Add struct hists pointer to struct hist_entry
  04/12 perf diff: Refactor diff displacement possition info
  05/12 perf diff: Refactor stdio ui data columns output
  06/12 perf diff: Add -b option for perf diff to display paired entries only
  07/12 perf diff: Add ratio computation way to compare hist entries
  08/12 perf diff: Add option to sort entries based on diff computation
  09/12 perf diff: Add weighted diff computation way to compare hist entries
  10/12 perf diff: Add -p option to display period values for hist entries
  11/12 perf diff: Add -F option to display formula for computation
  12/12 perf diff: Add -F option for ratio computation


I'm still testing this, trying to find out useful outputs/computations/options,
so looking for any ideas and recommendations ;)

thanks,
jirka


Eamples:

display default profile
-----------------------------------------------------------------------------------
$ ./perf diff
# Event 'cache-misses:u'
#
#   Baseline     Delta       Shared Object                             Symbol
#   ........  ........  ..................  .................................
#
       0.00%   +63.54%  libc-2.15.so        [.] __dcigettext                 
       0.00%    +5.38%  libc-2.15.so        [.] _dl_addr                     
       0.00%    +5.30%  libc-2.15.so        [.] __register_atfork            
       0.31%    +3.94%  [kernel.kallsyms]   [k] page_fault                   
       0.00%    +4.07%  ld-2.15.so          [.] check_match.11335            
       0.00%    +3.65%  ld-2.15.so          [.] version_check_doit           
       0.00%    +3.56%  ld-2.15.so          [.] _dl_fixup                    
       0.00%    +3.05%  ld-2.15.so          [.] _dl_map_object               
       0.00%    +2.90%  [kernel.kallsyms]   [k] system_call                  
       3.94%    -1.53%  [kernel.kallsyms]   [k] device_not_available         
       0.00%    +1.21%  libc-2.15.so        [.] __GI___libc_write            
       0.00%    +0.54%  libc-2.15.so        [.] __memcpy_ssse3_back          
       0.00%    +0.11%  libc-2.15.so        [.] execvp                       
       7.71%    -7.69%  ld-2.15.so          [.] _dl_start                    
       0.03%    -0.02%  libpthread-2.15.so  [.] __read_nocancel              
       0.20%    -0.18%  perf                [.] perf_evlist__prepare_workload



display ratio profile
-----------------------------------------------------------------------------------
$ ./perf diff -cratio
# Event 'cache-misses:u'
#
#   Baseline           Ratio       Shared Object                             Symbol
#   ........  ..............  ..................  .................................
#
       0.00%           0.000  libc-2.15.so        [.] __dcigettext                 
       0.00%           0.000  libc-2.15.so        [.] _dl_addr                     
       0.00%           0.000  libc-2.15.so        [.] __register_atfork            
       0.31%          15.450  [kernel.kallsyms]   [k] page_fault                   
       0.00%           0.000  ld-2.15.so          [.] check_match.11335            
       0.00%           0.000  ld-2.15.so          [.] version_check_doit           
       0.00%           0.000  ld-2.15.so          [.] _dl_fixup                    
       0.00%           0.000  ld-2.15.so          [.] _dl_map_object               
       0.00%           0.000  [kernel.kallsyms]   [k] system_call                  
       3.94%           0.678  [kernel.kallsyms]   [k] device_not_available         
       0.00%           0.000  libc-2.15.so        [.] __GI___libc_write            
       0.00%           0.000  libc-2.15.so        [.] __memcpy_ssse3_back          
       0.00%           0.000  libc-2.15.so        [.] execvp                       
       7.71%           0.002  ld-2.15.so          [.] _dl_start                    
       0.03%           0.500  libpthread-2.15.so  [.] __read_nocancel              
       0.20%           0.077  perf                [.] perf_evlist__prepare_workload



display ratio profile only with entries matched in both files
-----------------------------------------------------------------------------------
$ ./perf diff -cratio -b

# Event 'cache-misses:u'
#
#   Baseline           Ratio       Shared Object                             Symbol
#   ........  ..............  ..................  .................................
#
       0.31%          15.450  [kernel.kallsyms]   [k] page_fault                   
       3.94%           0.678  [kernel.kallsyms]   [k] device_not_available         
       7.71%           0.002  ld-2.15.so          [.] _dl_start                    
       0.03%           0.500  libpthread-2.15.so  [.] __read_nocancel              
       0.20%           0.077  perf                [.] perf_evlist__prepare_workload



display ratio profile only with entries matched in both files and sorted
-----------------------------------------------------------------------------------
$ ./perf diff -c+ratio -b

# Event 'cache-misses:u'
#
#   Baseline           Ratio       Shared Object                             Symbol
#   ........  ..............  ..................  .................................
#
       0.31%          15.450  [kernel.kallsyms]   [k] page_fault                   
       3.94%           0.678  [kernel.kallsyms]   [k] device_not_available         
       0.03%           0.500  libpthread-2.15.so  [.] __read_nocancel              
       0.20%           0.077  perf                [.] perf_evlist__prepare_workload
       7.71%           0.002  ld-2.15.so          [.] _dl_start                    



display weighted profile with weights w1=1 w2=2, with formula, sorted, matching
entries only and with periods displayed
-----------------------------------------------------------------------------------
$ ./perf diff -c+wdiff:1,2 -F -b -p

#   Baseline  Weighted diff                                             Formula  Baseline Period        Period       Shared Object                             Symbol
#   ........  .............  ..................................................  ...............  ............  ..................  .................................
#
       0.31%           +598  (309 * 2) - (20 * 1)                                             20           309  [kernel.kallsyms]   [k] page_fault                   
       3.94%            +92  (175 * 2) - (258 * 1)                                           258           175  [kernel.kallsyms]   [k] device_not_available         
       0.03%             +0  (1 * 2) - (2 * 1)                                                 2             1  libpthread-2.15.so  [.] __read_nocancel              
       0.20%            -11  (1 * 2) - (13 * 1)                                               13             1  perf                [.] perf_evlist__prepare_workload
       7.71%           -503  (1 * 2) - (505 * 1)                                             505             1  ld-2.15.so          [.] _dl_start                    


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>

---
 tools/perf/Documentation/perf-diff.txt |  63 ++++++++++
 tools/perf/builtin-diff.c              | 488 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/builtin-report.c            |   6 +-
 tools/perf/builtin-top.c               |   6 +-
 tools/perf/ui/stdio/hist.c             | 574 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 tools/perf/ui/stdio/hist.h             |  26 ++++
 tools/perf/util/evsel.h                |   7 ++
 tools/perf/util/hist.c                 |   7 +-
 tools/perf/util/hist.h                 |  24 +++-
 tools/perf/util/session.h              |   4 +-
 tools/perf/util/sort.c                 |   6 +-
 tools/perf/util/sort.h                 |  22 +++-
 12 files changed, 957 insertions(+), 276 deletions(-)
