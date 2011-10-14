Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1JNHR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:17:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab1JNHR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:17:56 -0400
Date: Fri, 14 Oct 2011 09:16:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/6] perf/core fixes and improvements
Message-ID: <20111014071610.GA20648@elte.hu>
References: <1318518504-23299-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318518504-23299-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (5):
>   perf hists browser: Recalculate browser pointers after resort/decay
>   perf hists: Don't free decayed entries if in the annotation browser
>   perf ui browser: Handle SIGWINCH
>   perf ui browser: Remove ui_browser__add_exit_keys
>   perf top: Remove entries from entries_collapsed on decay
> 
> Stephane Eranian (1):
>   perf hists: Fix compilation when NO_NEWT_SUPPORT is set
> 
>  tools/perf/builtin-top.c               |   23 ++++-
>  tools/perf/perf.c                      |   24 +++++
>  tools/perf/perf.h                      |    2 +
>  tools/perf/util/hist.c                 |   24 ++++-
>  tools/perf/util/hist.h                 |   11 ++-
>  tools/perf/util/sort.h                 |    1 +
>  tools/perf/util/ui/browser.c           |  176 ++++++++++++++++++++------------
>  tools/perf/util/ui/browser.h           |    9 +-
>  tools/perf/util/ui/browsers/annotate.c |   17 +--
>  tools/perf/util/ui/browsers/hists.c    |   55 +++-------
>  tools/perf/util/ui/browsers/map.c      |    6 +-
>  tools/perf/util/ui/helpline.h          |    2 +
>  12 files changed, 216 insertions(+), 134 deletions(-)

Hm, got a segfault with a plain 'perf top' on a 3.0-0.rc7.git3-ish 
box:

 ./perf top
 Segmentation fault (core dumped)

It took about 20 attempts to reproduce the segfault, and it always 
occured right after the first refresh (which, unlike the working 
cases showed zero samples):

Program received signal SIGSEGV, Segmentation fault.                                                    
[Switching to Thread 0x7ffff13a3700 (LWP 21657)]
ui_browser__hists_seek (whence=<optimized out>, offset=0, 
self=0x7fffec0008c0)
    at util/ui/browsers/hists.c:682
682		h->row_offset = 0;
(gdb) 

(gdb) bt
#0  ui_browser__hists_seek (whence=<optimized out>, offset=0, self=0x7fffec0008c0)
    at util/ui/browsers/hists.c:682
#1  ui_browser__hists_seek (self=0x7fffec0008c0, offset=0, whence=<optimized out>)
    at util/ui/browsers/hists.c:652
#2  0x0000000000472ab5 in hist_browser__run (delay_secs=2, arg=0x7602a0, 
    timer=0x420cc0 <perf_top__sort_new_samples>, ev_name=0x8f5dd0 "cycles", self=0x7fffec0008c0)
    at util/ui/browsers/hists.c:324
#3  perf_evsel__hists_browse (evsel=0x8f5b50, nr_events=1, helpline=<optimized out>, 
    ev_name=0x8f5dd0 "cycles", left_exits=false, timer=0x420cc0 <perf_top__sort_new_samples>, 
    arg=0x7602a0, delay_secs=2) at util/ui/browsers/hists.c:850
#4  0x0000000000473554 in perf_evlist__tui_browse_hists (evlist=0x8c4460, 
    help=0x50ab20 "For a higher level overview, try: perf top --sort comm,dso", 
    timer=0x420cc0 <perf_top__sort_new_samples>, arg=0x7602a0, delay_secs=2)
    at util/ui/browsers/hists.c:1178
#5  0x0000000000420ea3 in display_thread_tui (arg=<optimized out>) at builtin-top.c:567
#6  0x00000035f5807d31 in start_thread () from /lib64/libpthread.so.0
#7  0x00000035f54efdfd in clone () from /lib64/libc.so.6

(gdb) i r
rax            0x9118b8	9509048
rbx            0x7fffec0008c0	140737152813248
rcx            0x0	0
rdx            0x1	1
rsi            0x0	0
rdi            0x8f5bf0	9395184
rbp            0x7ffff13a2b90	0x7ffff13a2b90
rsp            0x7ffff13a2b70	0x7ffff13a2b70
r8             0x0	0
r9             0x0	0
r10            0xe6fe58	15138392
r11            0x0	0
r12            0x0	0
r13            0x2	2
r14            0x50ab20	5286688
r15            0x7602a0	7733920
rip            0x470f80	0x470f80 <ui_browser__hists_seek+128>
eflags         0x10246	[ PF ZF IF RF ]
cs             0x33	51
ss             0x2b	43
ds             0x0	0
es             0x0	0
fs             0x0	0
gs             0x0	0

The tree i pulled was 18eaf0b8e60a.

Btw., a side note: could we try to reset the console on segfaults and 
similar crashes? TUI crashes tend to leave the console in a messed up 
(blue, etc.) state.

Thanks,

	Ingo
