Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0EZMet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:34:49 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:47269 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0EZMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:34:47 -0400
Date: Wed, 26 May 2010 13:34:44 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Perf trace event parse errors for KVM events
Message-ID: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "perf trace" command produces the following messages:

For kvm:kvm_apic:
$ perf trace
  Warning: Error: expected type 4 but read 7
  Warning: Error: expected type 5 but read 0
  Warning: failed to read event print fmt for kvm_apic

For kvm:kvm_inj_exception:
$ perf trace
  Warning: Error: expected type 4 but read 7
  Warning: Error: expected type 5 but read 0
  Warning: failed to read event print fmt for kvm_inj_exception

For kvm:kvm_emulate_insn:
$ perf trace
  Fatal: bad op token {

The other KVM trace events work fine.

To reproduce this issue (you don't need any actual KVM activity while running):
$ perf record -a -f -e 'kvm:kvm_apic' sleep 1
$ perf trace

Both linux-2.6.git 7e125f7b9cbfce4101191b8076d606c517a73066 and Avi's kvm.git
show this problem.

It appears that the perf.data written by "perf record" cannot be parsed by
"perf trace" run using the same perf binary.  The perf binary was built from
the same kernel tree that I am running (there should be no mismatch between the
kernel and the perf binary).

At the end of this email is a gdb session that shows where the
kvm:kvm_apic "expected type 4 but read 7" error occurs.

Any ideas?

Thanks,
Stefan

$ sudo gdb --args ./perf trace
[...]
(gdb) b warning
Breakpoint 1 at 0x42d000: file util/usage.c, line 74.
(gdb) r
Starting program: /home/stefanha/linux-2.6/tools/perf/perf trace
[Thread debugging using libthread_db enabled]

Breakpoint 1, warning (warn=0x463390 "Error: expected type %d but read %d") at util/usage.c:74
74      {
(gdb) bt
#0  warning (warn=0x463390 "Error: expected type %d but read %d") at util/usage.c:74
#1  0x0000000000443123 in __test_type_token (event=0x9d0d40, list=<value optimized out>, tok=<value optimized out>) at util/trace-event-parse.c:639
#2  test_type_token (event=0x9d0d40, list=<value optimized out>, tok=<value optimized out>) at util/trace-event-parse.c:656
#3  process_fields (event=0x9d0d40, list=<value optimized out>, tok=<value optimized out>) at util/trace-event-parse.c:1499
#4  0x0000000000442598 in process_symbols (event=0x9d0d40, arg=0x9d2110, tok=0x7fffffff9fa8, type=<value optimized out>) at util/trace-event-parse.c:1588
#5  process_arg_token (event=0x9d0d40, arg=0x9d2110, tok=0x7fffffff9fa8, type=<value optimized out>) at util/trace-event-parse.c:1703
#6  0x0000000000443cee in process_arg (event=0x9d0d40) at util/trace-event-parse.c:1034
#7  event_read_print_args (event=0x9d0d40) at util/trace-event-parse.c:1774
#8  event_read_print (event=0x9d0d40) at util/trace-event-parse.c:1853
#9  0x0000000000444c0e in parse_event_file (buf=<value optimized out>, size=<value optimized out>, sys=0x9ccf90 "kvm") at util/trace-event-parse.c:3192
#10 0x0000000000445e3d in read_event_file (fd=<value optimized out>, __repipe=<value optimized out>) at util/trace-event-read.c:236
#11 read_event_files (fd=<value optimized out>, __repipe=<value optimized out>) at util/trace-event-read.c:270
#12 trace_report (fd=<value optimized out>, __repipe=<value optimized out>) at util/trace-event-read.c:514
#13 0x0000000000434c52 in perf_file_section__process (self=0x9cc540, ph=0x9cc9a0, feat=1, fd=5) at util/header.c:777
#14 0x0000000000435ad9 in perf_header__process_sections (self=0x9cc9a0, fd=5, process=0x434b80 <perf_file_section__process>) at util/header.c:618
#15 0x0000000000436c31 in perf_header__read (session=0x9cc9a0, fd=5) at util/header.c:893
#16 0x000000000043d566 in perf_session__open (filename=<value optimized out>, mode=0, force=<value optimized out>, repipe=false) at util/session.c:51
#17 perf_session__new (filename=<value optimized out>, mode=0, force=<value optimized out>, repipe=false) at util/session.c:103
#18 0x00000000004169b7 in cmd_trace (argc=0, argv=0x7fffffffe6e0, prefix=<value optimized out>) at builtin-trace.c:666
#19 0x0000000000404dd7 in run_builtin (p=0x66ee58, argc=1, argv=0x7fffffffe6e0) at perf.c:265
#20 0x0000000000405876 in handle_internal_command (argc=1, argv=0x7fffffffe6e0) at perf.c:336
#21 run_argv (argc=1, argv=0x7fffffffe6e0) at perf.c:380
#22 main (argc=1, argv=0x7fffffffe6e0) at perf.c:464
(gdb) p *(struct event*)0x9d0d40
$1 = {next = 0x0, name = 0x9d0d90 "kvm_apic", id = 762, flags = 0, format = {nr_common = 5, nr_fields = 3, common_fields = 0x9d0df0, fields = 0x9d1d20},
  print_fmt = {format = 0x9d1ef0 "apic_%s %s = 0x%x", args = 0x9d1f30}, system = 0x0}
