Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1BONof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:44:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1BONoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:44:34 -0500
Date: Tue, 15 Feb 2011 11:44:09 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
Message-ID: <20110215134409.GA23092@ghostprotocols.net>
References: <20110208015617.902200587@goodmis.org>
 <20110215044425.GA9994@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215044425.GA9994@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addressing the tools/perf/ suggestions:

Em Tue, Feb 15, 2011 at 05:44:25AM +0100, Ingo Molnar escreveu:
> Here is what i've done. Firstly, i have put my 'naive but curious user trying to 
> make use of filters' hat on.
> 
> I did:
> 
> 	perf list | grep Tracepoint | less
> 
> to get a list of tracepoints.
> 
>  #
>  #  Btw., unrelated feature request, it would be nice if the following shorcut did the 
>  #  obvious thing:
>  #
>  #	perf list Tracepoint
>  #

Will do
 
> I picked one of the interesting looking tracepoints:
> 
>   syscalls:sys_enter_close                   [Tracepoint event]
> 
> first roadblock: 
> 
> I had absolutely no idea how to proceed from here any further. I knew it from 'perf 
> list --help' that I could stick 'syscalls:sys_enter_close' into -e expressions, but 
> i had no idea how to utilize filter expressions at all.

<SNIP>
 
>  aldebaran:~> cat /debug/tracing/events/syscalls/sys_enter_close/format 
>  name: sys_enter_close
>  ID: 404
>  format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 	field:int common_lock_depth;	offset:8;	size:4;	signed:1;
> 
> 	field:int nr;	offset:12;	size:4;	signed:1;
> 	field:unsigned int fd;	offset:16;	size:8;	signed:0;
> 
>  print fmt: "fd: 0x%08lx", ((unsigned long)(REC->fd))
> 
> And putting my kernel tracing hacker hat on i knew that the only interesting piece 
> of information for a filter would be the 'fd' word.

Something in the TUI that allows the user to navigate thru the
tracepoints, grouping them and allowing something like:

    + Hardware
    + Dynamic Probes
    + Software
      + Scheduler
      + Block I/O
      - System Calls
        - close
            entry
            exit

And at any point in the tree allow enabling the tree branch and allowing
filters for fields that are common from that point down, i.e. fd should
be usable as a filter for file system events, allowing to see all events
that have an fd for a given pid.

Worth some experimentation.

<SNIP>

>  aldebaran:~> perf record -e syscalls:sys_enter_close --filter 'fd == 10' ./hackbench 1
>  Time: 0.079
>  [ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.007 MB perf.data (~325 samples) ]
> 
> Cool i thought, it has 325 samples, success!
> 
> Lets look at it via 'perf report' i thought:
> 
>  aldebaran:~> perf report
>  aldebaran:~> 
> 
> ouch. The TUI flickered something which went away immediately (feature request: 
> don't do that - at least try to mumble something about non-existent data or so).

Right, as the tools do when it finds LOST events, they should emit a
warning stating "No EVENT_NAME samples found in file foo.data", will do.

- Arnaldo
