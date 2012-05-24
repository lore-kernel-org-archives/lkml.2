Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab2EXSZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:25:01 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35375 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab2EXSZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:25:00 -0400
Date: Thu, 24 May 2012 15:24:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf tools: Preserving event modifiers
Message-ID: <20120524182453.GD2336@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

We need to preserve the original event name so that we can show it on the TUI,
for instance. Humm, when rebuilding it from perf.data we'll need to look at
perf_event_attr.precise bits too...

(gdb) run top -e cycles:p
Starting program: /root/bin/perf top -e cycles:p
[Thread debugging using libthread_db enabled]

Breakpoint 1, perf_evsel__init (evsel=0x909c50, attr=0x7fffffffad30, idx=0) at util/evsel.c:50
50	{
(gdb) n
51		evsel->idx	   = idx;
(gdb) n
52		evsel->attr	   = *attr;
(gdb) 
53		INIT_LIST_HEAD(&evsel->node);
(gdb) 
54		hists__init(&evsel->hists);
(gdb) 
55	}
(gdb) 
perf_evsel__new (attr=0x7fffffffad30, idx=0) at util/evsel.c:64
64		return evsel;
(gdb) 
65	}
(gdb) 
add_event (_list=0x7fffffffadc0, idx=0x7fffffffb6c0, attr=0x7fffffffad30, name=0x54598b "cycles") at util/parse-events.c:376
376		if (!evsel) {
(gdb) 
381		evsel->name = strdup(name);
(gdb) p name
$5 = 0x54598b "cycles"
(gdb) p name
$6 = 0x54598b "cycles"
(gdb) bt
#0  add_event (_list=0x7fffffffadc0, idx=0x7fffffffb6c0, attr=0x7fffffffad30, name=0x54598b "cycles") at util/parse-events.c:381
#1  0x000000000044e483 in parse_events_add_numeric (list=0x7fffffffadc0, idx=0x7fffffffb6c0, type=0, config=0, head_config=0x0) at util/parse-events.c:674
#2  0x000000000047667d in parse_events_parse (list_all=0x7fffffffb6a0, idx=0x7fffffffb6c0) at util/parse-events.y:117
#3  0x000000000044e9fd in parse_events (evlist=0x9083c0, str=0x7fffffffe899 "cycles:p", unset=0) at util/parse-events.c:807
#4  0x000000000044eaf1 in parse_events_option (opt=0x7fffffffba10, str=0x7fffffffe899 "cycles:p", unset=0) at util/parse-events.c:833
#5  0x000000000044b68f in get_value (p=0x7fffffffb840, opt=0x7fffffffba10, flags=1) at util/parse-options.c:112
#6  0x000000000044ba8b in parse_short_opt (p=0x7fffffffb840, options=0x7fffffffba10) at util/parse-options.c:191
#7  0x000000000044c0bd in parse_options_step (ctx=0x7fffffffb840, options=0x7fffffffba10, usagestr=0x53f9f0) at util/parse-options.c:342
#8  0x000000000044c46e in parse_options (argc=3, argv=0x7fffffffe640, options=0x7fffffffba10, usagestr=0x53f9f0, flags=0) at util/parse-options.c:417
#9  0x000000000042eead in cmd_top (argc=3, argv=0x7fffffffe640, prefix=0x0) at builtin-top.c:1250
#10 0x0000000000415359 in run_builtin (p=0x79b8a8, argc=3, argv=0x7fffffffe640) at perf.c:273
#11 0x000000000041555c in handle_internal_command (argc=3, argv=0x7fffffffe640) at perf.c:345
#12 0x00000000004156a8 in run_argv (argcp=0x7fffffffe52c, argv=0x7fffffffe520) at perf.c:389
#13 0x000000000041592e in main (argc=3, argv=0x7fffffffe640) at perf.c:487
(gdb)
