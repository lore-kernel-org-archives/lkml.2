Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0JNAAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:00:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42000 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753515Ab0JNAAb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:00:31 -0400
Date: Wed, 13 Oct 2010 20:00:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace and ktrace)
Message-ID: <20101014000027.GA15510@Krystal>
References: <AANLkTikfYy-kYb1=KbsYwHd0_vcf20d2nPSfFynugz8z@mail.gmail.com> <AANLkTikKwx6okpX4pxVzTvrVNm=KhUvLQGs0_ziwo6fX@mail.gmail.com> <AANLkTimnjun98phJ_KmwFG_ce3YGpmVGf5rufqPStWR-@mail.gmail.com> <1287013830.3673.224.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1287013830.3673.224.camel@frodo>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:52:22 up 21 days,  3:54,  4 users,  load average: 0.03, 0.06,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-10-13 at 16:19 -0700, David Sharp wrote:
> > Google uses kernel tracing aggressively in the its data centers. We
> 
> Thanks!
> 
> > wrote our own kernel tracer, ktrace. However ftrace, perf and LTTng
> > all have a better feature set than ktrace, so we are abandoning that
> > code.
> 
> Cool!
> 
> > 
> > We see several implementations of tracing aimed at the mainline kernel
> > and wanted a fair comparison of each of them to make sure they will
> > not significantly impact performance. A tracing toolkit that is too
> > expensive is not usable in our environment.
> > 
> 
> [ snip for now (I'm traveling) ]
> 
> > This first set of benchmark results compares ftrace to ktrace. The
> > numbers below are the "on" result minus the "off" result for each
> > configuration.
> > 
> > ktrace: 200ns  (tracepoint: kernel_getuid)
> > ftrace: 224ns   (tracepoint: timer:sys_getuid)
> > ftrace: 587ns   (tracepoint: syscalls:sys_enter_getuid)
> 
> 
> > The last result shows that the syscall tracing is about twice as
> > expensive as a normal tracepoint, which is interesting.
> 
> Argh, the syscall tracing has a lot of overhead. There is only one
> tracepoint that is hooked into the ptrace code, and will save all
> registers before calling the functions. It enables tracing on all
> syscalls and there's a table that decides whether or not to trace the
> syscall.
> 
> So I'm not surprised with the result that the syscall trace point is so
> slow (note, perf uses the same infrastructure).

Yes, the interesting result in this first set of benchmarks is that syscall
tracing is quite slow. We could do better though. I think a different scheme
for syscall tracing that would not rely of saving all registers is needed. We
could do this automatically by adding tracepoints in the actual syscall
functions by modifying the DEFINE_SYSCALL*() macros. I would leave the current
syscall tracing mode as the default though, especially until gcc 4.5 and asm
gotos are more broadly adopted.

So the modified DEFINE_SYSCALL*() macros would generate code that looks like:
(approximately)

static int _syscall_name(type1, name1);

int syscall_name(type1 name1)
{
        int ret;

        trace_syscall_entry_name(name1);
        ret = _syscall_name(name1);
        trace_syscall_exit_name(name1);
        return ret;
}

static int _syscall_name(typê1, name1)


So when we expand:

DEFINE_SYSCALL1(name, type1, name1)
{
  .. actual body ...
}

We have the tracepoints automatically added.

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
