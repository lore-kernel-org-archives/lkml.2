Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0KRMjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:39:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0KRMjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tbZZCPKmlzEL7Gp8afNoVyqN/ZkUjYBptQpEfFDhVCWs2M2RTn3EMDUT5qyQ74UH7L
         7Q3WdyjTdwZwdkjiTL/i4JStphtmHu7HHqEOZPz8qRDjf9tuqW+aY4Vykz7PQhVLAipz
         KxZtKsC9nmFGl5lpvsUpzm95HVE6/X9vLoSwg=
Date: Thu, 18 Nov 2010 13:39:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 0/2] tracing: Have trace_printk()s in the events/
	directory
Message-ID: <20101118123940.GA5344@nowhere>
References: <20101118035803.453609353@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118035803.453609353@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 10:58:03PM -0500, Steven Rostedt wrote:
> As suggested in:
> 
> LKML-Reference: <20101116221726.GB26243@nowhere>
>   or
> http://marc.info/?l=linux-kernel&m=128994587230629
> 
> To have trace_printks in the events directory.

(Note, I don't remember who got that idea. Perhaps
that was Ingo while discussing that with him like one year
ago, or may be me, not sure, whatever)...


> This patch set just does it for ftrace, although it can also lay the
> ground work for both perf and trace (are they different tools?)

The trace tool uses perf. But no worry about perf, I can handle the hook
for it.


> This patch set converts the current trace_printk() into ftrace_printk()
> (back to it's original name) and that stays the same.
> 
> The new trace_printk() is off by default (we can change that later
> with a kernel command line option perhaps), but it can be enable now
> with the events directory.

Cool. So disablement/re-enablement are nice features. That said it should
be enabled by default I think, to keep the previous (and intuitive) behaviour.

 
> Each trace_printk() added will get a entry in the debugfs/tracing/events/
> directory as  debugfs/tracing/entry/path/to/trace_printk/
> 
> For example, I added a trace_printk() in kernel/sched.c at line 2180
> and it creates:
> 
> # ls /debug/tracing/events/printk/kernel/sched.c/2180/
> enable  format

Ok, we'll probably need to add the ID as well.

 
> The format is the printk format:
> 
> # cat /debug/tracing/events/printk/kernel/sched.c/2180/format 
> "migrate task %s:%d
> "

Do you think we can make it more compatible with the common pattern?

Like:

Name: sched.c:2180
ID: 120
format:
	field:unsigned long ip;	offset:16;	size:8;	signed:0;
	field:const char * fmt;	offset:24;	size:8;	signed:0; <-- can be retrieved from printk_format
	field:u32 buf;	offset:32;	size:0;	signed:0;

print fmt: "given format", REC->ip, REC->fm


Does that look possible to you or have you run into troubles?

I don't know how much that's possible given the bprintk format. May be
we should first try with the already formatted trace_printk version.


> Every directory has an "enable" file. By echoing 0 or 1 into this
> file, it will enable all the trace_printk's below it.
> 
> This also uses jump_label() to keep overhead down when disabled.
> 
> Note, modules are not (yet) supported.
> 
> This is just the ground work. I'm busy doing other things so
> if you need more, feel free to take this and carry on.
> 
> -- Steve


Thanks a lot!


> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: rfc/event-printk
> 
> 
> Steven Rostedt (2):
>       tracing: Rename trace_printk to ftrace_printk
>       tracing: Make event based trace_printk()
> 
> ----
>  include/asm-generic/vmlinux.lds.h |    7 +-
>  include/linux/kernel.h            |   16 +-
>  include/trace/event_printk.h      |   52 ++++++
>  kernel/trace/Makefile             |    1 +
>  kernel/trace/event_printk.c       |  365 +++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.h              |    1 +
>  kernel/trace/trace_events.c       |    2 +-
>  7 files changed, 435 insertions(+), 9 deletions(-)

