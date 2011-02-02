Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1BBR4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:56:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1BBR4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:56:15 -0500
Date: Wed, 2 Feb 2011 18:55:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, fweisbec@gmail.com, tzanussi@gmail.com,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: Using ftrace/perf as a basis for generic seccomp
Message-ID: <20110202175556.GA13948@elte.hu>
References: <1294867725.3237.230.camel@localhost.localdomain>
 <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
 <4D494AB1.1040508@hitachi.com>
 <20110202122620.GA11427@elte.hu>
 <1296665124.3145.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296665124.3145.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2011-02-02 at 13:26 +0100, Ingo Molnar wrote:
> > * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> > 
> > > Hi Eric,
> > > 
> > > (2011/02/01 23:58), Eric Paris wrote:
> > > > On Wed, Jan 12, 2011 at 4:28 PM, Eric Paris <eparis@redhat.com> wrote:
> > > >> Some time ago Adam posted a patch to allow for a generic seccomp
> > > >> implementation (unlike the current seccomp where your choice is all
> > > >> syscalls or only read, write, sigreturn, and exit) which got little
> > > >> traction and it was suggested he instead do the same thing somehow using
> > > >> the tracing code:
> > > >> http://thread.gmane.org/gmane.linux.kernel/833556
> > > 
> > > Hm, interesting idea :)
> > > But why would you like to use tracing code? just for hooking?
> > 
> > What I suggested before was to reuse the scripting engine and the tracepoints.
> > 
> > I.e. the "seccomp restrictions" can be implemented via a filter expression - and the 
> > scripting engine could be generalized so that such 'sandboxing' code can make use of 
> > it.
> > 
> > For example, if you want to restrict a process to only allow open() syscalls to fd 4 
> > (a very restrictive sandbox), it could be done via this filter expression:
> > 
> > 	'fd == 4'
> > 
> > etc. Note that obviously the scripting engine needs to be abstracted out somewhat - 
> > but this is the basic idea, to reuse the callbacks and reuse the scripting engine 
> > for runtime filtering of syscall parameters.
> 
> Any pointers on what is involved in this abstraction?  I can work out
> the details, but I don't know the big picture well enough to even start
> to move forwards.....

perf has support for these filters, so would it work with you if I gave you some 
example usage?

First you identify an interesting tracepoint - look at the list of:

   perf list | grep Tracepoint

Say we want to filter sys_close() events, so we pick:

  syscalls:sys_enter_close                     [Tracepoint event]

And record all sys_open (enter) events in the system, for one second:

   perf record -e syscalls:sys_enter_close -a sleep 1

All the recorded data will be in perf.data in cwd.

'perf report' will show a profile, and 'perf script' will show the trace output:

            perf-30558 [002] 117691.065243: sys_enter_close: fd: 0x00000016
            perf-30558 [002] 117691.065406: sys_enter_close: fd: 0x00000016
            perf-30558 [002] 117691.065443: sys_enter_close: fd: 0x00000017
            perf-30558 [002] 117691.065444: sys_enter_close: fd: 0x00000016
            [...]

Now, to record a 'filtered' event, use the --filter parameter when recording:

Available field names can be found in the 'format' file:

 cat /debug/tracing/events/syscalls/sys_close_enter/format 

 name: sys_enter_close
 ID: 402
 format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_lock_depth;	offset:8;	size:4;	signed:1;

	field:int nr;	offset:12;	size:4;	signed:1;
	field:unsigned int fd;	offset:16;	size:8;	signed:0;

 print fmt: "fd: 0x%08lx", ((unsigned long)(REC->fd))

The interesting ones is:

	field:unsigned int fd;	offset:16;	size:8;	signed:0;

This is the field that represents the fd of the close(fd) call. To filter it, simply 
use it symbolically:

   perf record -e syscalls:sys_enter_close --filter 'fd==3' ./hackbench 5

As you can see it in 'perf script' output:

       hackbench-30576 [008] 117802.180002: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222056: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222064: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222065: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222067: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222069: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222070: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222071: sys_enter_close: fd: 0x00000003
       hackbench-30576 [008] 117802.222073: sys_enter_close: fd: 0x00000003

Only fd==3 events were recorded.

The filter expression engine executes in the kernel, when the event happens. The 
user-space perf tool parses the --filter parameter and passes it to the kernel as a 
string in essence. The kerner parses this into atomic predicaments which are linked 
to the event structure. When the event happens the predicaments are executed by the 
filter engine.

The expressions are simple, but rather flexible, so you can do 'fd==0||fd==1' and 
more complex expressions, etc. The engine could also be extended.

The kernel code is mostly in kernel/trace/trace_events_filter.c.

I've Cc:-ed Tom, Frederic, Steve, Li Zefan and Arnaldo who have worked on the filter 
engine, in case something is broken with this functionality or if there are other 
questions :)

Thanks,

	Ingo
