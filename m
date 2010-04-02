Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0DBE7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 00:59:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0DBE7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Rr3PhxTdRjRW2L929k3qCvL+D/SvWZyTyh7uYe7VWi8dO+tdc3MeTXhACMN7dC/6ZR
         vqD32KzBejsZI4OACDKxthmbmObYlf2MUChqmTswrvYK6K0MDJLdG08aLh4SeN3y1iGw
         Uvs1NjYguQtDvQnP0XoasqksWkmTDZY3TkifU=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 0/7] perf: 'live mode'
Date: Thu,  1 Apr 2010 23:59:14 -0500
Message-Id: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a perf session entails two steps: first 'perf record' or
'perf trace record' records the perf data to disk, then 'perf report'
or 'perf trace report' reads the saved data from disk and reports the
results.

This experimental patchset makes some changes to perf that instead
allow the perf data to be piped directly from the record step to the
report step, without ever touching the disk.

This is especially useful for 'perf trace' - adding this capability
means that the trace scripts are no longer relegated to simple
post-processing, but can be run in a continuous 'live mode', forever
processing the event stream and e.g. periodically dumping current
results, essentially becoming special-purpose 'top' applications, or
continuously scanning the event stream for arbitrarily complex
conditions to flag, etc...

Being able to feed the event stream over a pipe also makes it possible
to do things like trace over the network using e.g. netcat.

It turns out that perf is pretty close to being able to do this
already, with the exception of the header data; most of the work of
this patchset deals with changing that.  It does so in a mainly
additive way: it doesn't make any changes to the existing disk format
or normal disk-mode processing, just adds special treatment for the
cases when 'perf [trace] record' records to stdout or 'perf [trace]
report reads from stdin.

v2 changes:

- any script in the 'perf trace -l' list can now be run in 'live mode'
  automatically by simply specifying the script name [with options] e.g.
  
  $ perf trace syscall-counts

  will run both ends of the the syscall-counts script with a pipe in
  between, a more usable shorthand for:

  $ perf trace record syscall-counts -o - | perf trace report syscall-counts -i -

  which itself is shorthand for:

  perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter -o - | perf trace -i - -s ~/libexec/perf-core/scripts/python/syscall-counts.py

- adds and use a term_clear() function for the 'top' scripts (thanks
  to Ingo Monlar for the suggestion)


Here are some quick examples.  Basically using '-' as the filename to
the -o and -i options send/read the data from stdout/stdin:

Here's a simple 'perf record' | 'perf report' run:

root@tropicana:~# perf record -o - -c 1 -f -a -M -R -e raw_syscalls:sys_enter | perf report -i -

^C# Samples: 376819
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
    99.94%             perf  [kernel.kallsyms]  [k] syscall_trace_enter
     0.04%             Xorg  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%  hald-addon-stor  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%      gvfsd-trash  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%         nautilus  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%          firefox  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%  gnome-screensav  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%            wterm  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%           mysqld  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%  gnome-settings-  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%  update-notifier  [kernel.kallsyms]  [k] syscall_trace_enter
     0.00%          apache2  [kernel.kallsyms]  [k] syscall_trace_enter


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

Included in this patchset are a couple of 'top' scripts, rwtop and
sctop, that are essentially just modifications of existing scripts.
The original scripts were modified to add a 3-second timer and a
screen clear after each print iteration.  In the handler for the
timer, the previous screen contents are erased, the current output
summary is printed, and the state is cleared and begun anew, ad
infinitum.

Here are the new scripts as shown in the perf trace list:

root@tropicana:~# perf trace -l
List of available trace scripts:
  workqueue-stats                      workqueue stats (ins/exe/create/destroy)
  wakeup-latency                       system-wide min/max/avg wakeup latency
  rw-by-file <comm>                    r/w activity for a program, by file
  rwtop [interval]                     system-wide r/w top
  failed-syscalls [comm]               system-wide failed syscalls
  rw-by-pid                            system-wide r/w activity
  syscall-counts-by-pid [comm]         system-wide syscall counts, by pid
  failed-syscalls-by-pid [comm]        system-wide failed syscalls, by pid
  sctop [comm] [interval]              syscall top
  syscall-counts [comm]                system-wide syscall counts


And here's a sample of the output of the 'sctop' Python script:

root@tropicana:~# perf trace sctop
syscall events:

event                                          count
----------------------------------------  ----------
sys_read                                      383576
sys_poll                                         144
sys_futex                                         97
sys_brk                                           33
sys_write                                         20
sys_select                                        11
sys_open                                          10
sys_inotify_add_watch                              4
sys_setitimer                                      4
sys_writev                                         4
sys_wait4                                          1
sys_exit                                           1
56                                                 1
sys_alarm                                          1
sys_ioctl                                          1
15                                                 1
sys_rt_sigaction                                   1
sys_close                                          1
^C
perf trace Python script stopped

This shows just the last iteration - the script in real life
continuously erases and displays the previous interval's results.

Note that the scripts in this patchset will only show the syscall
numbers in the output, not the names as shown here - I just happened
to have the 'export some syscall metadata' patches previously posted
applied as well when I ran this script.


Lastly, here's an example that uses netcat to run the 'rwtop' Perl
script over the network:

On the system collecting the data and printing the output every 3
seconds:

root@tropicana:~#  nc -l -p 7777 | perf trace report rwtop -i -

On the system being traced:

root@tropicana:~# perf trace record rwtop -o - | nc localhost 7777

read counts by pid:

   pid                  comm     # reads   bytes_req  bytes_read
------  --------------------  ----------  ----------  ----------
  9580  nc                           606     4964352     5382144
  9578  perf                       72256     3178656     3178448
  9575  nc                           379     3104768     3104768
  5856  Xorg                         148      386320        3980
  6265  metacity                     105      430080        1440
  6325  gnome-screensav              110      450560        1024
  6261  gnome-settings-                3       12288          32
  6678  wterm                          5       20480          32

write counts by pid:

   pid                  comm    # writes  bytes_written
------  --------------------  ----------  -------------
  9580  nc                           657        5382144
  9575  nc                           379        3104768

perf trace Perl script stopped

I just noticed a hashtable error in this script when running it over
netcat just now, which is part of the reason it's an RFC patchset - it
still needs more testing, though other than that I haven't seen many
problems with it.

Tom


Tom Zanussi (11):
  perf: add pipe-specific header read/write and event processing code
  perf record: introduce special handling for pipe output
  perf report: introduce special handling for pipe input
  perf trace: introduce special handling for pipe input
  perf: convert perf header attrs into attr events
  perf: convert perf event types into event type events
  perf: convert perf tracing data into a tracing_data event
  perf: convert perf header build_ids into build_id events
  perf trace/scripting: rwtop and sctop scripts
  perf trace/scripting: enable scripting shell scripts for live mode
  perf trace: invoke live mode automatically if record/report not
    specified

 tools/perf/builtin-record.c                        |   68 ++++-
 tools/perf/builtin-report.c                        |   16 +-
 tools/perf/builtin-trace.c                         |   75 ++++-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    6 +
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-report |    8 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    3 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    8 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +
 tools/perf/scripts/perl/bin/rwtop-report           |   23 ++
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 tools/perf/scripts/perl/rwtop.pl                   |  177 ++++++++++
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    3 +
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    8 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +
 tools/perf/scripts/python/bin/sctop-report         |   24 ++
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    8 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    8 +-
 tools/perf/scripts/python/sctop.py                 |   78 +++++
 tools/perf/util/event.h                            |   35 ++
 tools/perf/util/header.c                           |  361 ++++++++++++++++++--
 tools/perf/util/header.h                           |   38 ++-
 tools/perf/util/session.c                          |  192 ++++++++++-
 tools/perf/util/session.h                          |   10 +-
 tools/perf/util/trace-event-info.c                 |   24 ++
 tools/perf/util/trace-event-read.c                 |   89 +++---
 tools/perf/util/trace-event.h                      |    4 +-
 35 files changed, 1184 insertions(+), 106 deletions(-)
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
 create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
 create mode 100644 tools/perf/scripts/perl/rwtop.pl
 create mode 100644 tools/perf/scripts/python/bin/sctop-record
 create mode 100644 tools/perf/scripts/python/bin/sctop-report
 create mode 100644 tools/perf/scripts/python/sctop.py

