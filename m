Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1EJNGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:06:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1EJNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:06:45 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ByyYqwdOL9Jr66vC1UsA:9 a=sKz0MMkeu_5usmGbDfoA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=BXx-uAuGVdS99mPS:21 a=rgf58rEVdTxgS5lU:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110510084158.GC27426@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
	 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
	 <20110507144402.GC2859@elte.hu> <1304788829.11129.57.camel@frodo>
	 <20110507190033.GA11465@elte.hu> <1304996847.2969.151.camel@frodo>
	 <20110510084158.GC27426@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 09:06:37 -0400
Message-ID: <1305032797.2943.34.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 10:41 +0200, Ingo Molnar wrote: 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Check whether there's any feature missing from it that you'd like to see, add 
> > > it. Rinse, repeat.
> > 
> > Again, the design of trace/perf is task oriented. Ftrace is system
> > oriented. Could we agree on that?
> 
> Like i said in the previous mail, i don't know where you got this nonsensical 
> idea from. ftrace is indeed system oriented and that's hardcoded at the design 
> - i.e. its a design mistake.

Actually, it would not be too hard to implement some of the same ideas
of perf into ftrace for user focused tracing. The design is flexible
enough to do so. The only reason I never submitted patches to allow
ftrace to do so was because that would have been a direct competition
with perf, and unnecessary.

> 
> perf is fundamentally *event* oriented - and various levels of grouping and 
> buffering can be applied to events.

How do you trace all events for the entire system? There is no "enable
all events" in perf (that I know of). But I see that it can't even
handle all syscalls:

[root@bxf perf]# ~/bin/perf record -a -e 'syscalls:*'

  Error: sys_perf_event_open() syscall returned with 24 (Too many open files).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

[root@bxf perf]# dmesg | tail
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present


And yes CONFIG_PERF_EVENTS is enabled and a record -a -e 'sched:*' works.


With ftrace, this has never been an issue:

[root@bxf perf]# trace-cmd record -e all
[root@bxf perf]# trace-cmd report
version = 6
cpus=4
       trace-cmd-3016  [003]  1007.136631: lock_release:         0xffff88003fe72c98 &(&zone->lru_lock)->rlock
       trace-cmd-3017  [001]  1007.136631: lock_acquire:         0xffff88003d6f00c8 &(&fs->lock)->rlock
       trace-cmd-3015  [002]  1007.136633: lock_acquire:         0xffffffff825df1d8 read &fsnotify_mark_srcu
       trace-cmd-3018  [000]  1007.136635: mm_page_alloc:        page=0xffffea00005a13c0 pfn=5903296 order=0 migratetype=1 gfp_flags=GFP_TEMPORARY|GFP_NOWARN|GFP_NORETRY|GFP_THISNODE
       trace-cmd-3017  [001]  1007.136643: lock_acquire:         0xffff880039f91348 &(&dentry->d_lock)->rlock
       trace-cmd-3015  [002]  1007.136644: lock_release:         0xffffffff825df1d8 &fsnotify_mark_srcu
       trace-cmd-3016  [003]  1007.136645: lock_acquire:         0xffff88003fe72c98 &(&zone->lru_lock)->rlock
       trace-cmd-3018  [000]  1007.136648: lock_acquire:         0xffff88003d5fd948 &(&parent->list_lock)->rlock



> 
> 'system wide', 'per cpu', 'per workload', 'per task' or 'per cgroup' are just 
> one of the many natural groupings of events that users/developers would like to 
> see - and we offer these.
> 
>  - that is why sysprof is using perf events to collect system-wide events.
> 
>  - that is why PowerTOP uses perf events in system-wide event collection mode.
> 
>  - that is why 'perf top' uses system wide profiling by default (but can do per 
>    CPU or per task profiling as well)
> 
>  - that is why 'perf record' defaults to a per workload (not a per task as you 
>    claim) mode of event collection
> 
>  - that is why 'perf stat' defalts to per workload events

I should have been more specific of not just system wide events, but
many more types of events. It will be interesting to see how perf
handles function tracing.

Also, the tools that you show are usually used by non critical paths.
I've done the benchmarks before (I'll post the LKML link if you like)
and perf has significant overhead. This is something I tried hard in
ftrace to avoid.

> 
> Do you see that it is ftrace that remained behind the times, by stubbornly 
> forcing some nonsensical global view and encoding it not only in its design but 
> in its APIs as well?

There's nothing in the ABI that keeps it global focused. It would be
easy to make ftrace user/event focused, but I just never did because I
did not want us to fight any more. Would you have accepted patches from
me that extended ftrace to do this?

I was never asked to have it user focused before perf came around, and
by then, the thing preventing ftrace from being user focused was more
social than technical.

> 
> I really meant it when i told you that perf events were the natural next step 
> after ftrace, in the evolution of Linux tracing/instrumentation.

I know you meant that, but I don't see nor feel it myself. Maybe I'm
mistaken but I don't have the belief that I can just jump on faith into
perf and abandon all the work of current ftrace. But I'm happy to help
unify the kernel infrastructure. That is the important part.

> 
> > > > Now that perf has entered the tracing field, I would be happy to bring 
> > > > the two together. [...]
> > > 
> > > Great - please see tip:tmp.perf/trace, that would be a very good point to 
> > > start. It's a working prototype for an ftrace-alike tracing workflow.
> > 
> > I'll do it, if we can agree about the ftrace as system tracing/debugging, and 
> > trace can focus on user specific tracing.
> 
> Ok, you've finally admitted that you do not really want 'unification' between 
> ftrace and perf - which was my suspicion all along. I really prefer 100% honest 
> discussions with people from whom i pull and it took quite some time for you to 
> admit to this position ...


Ingo, I think this is a communication problem more than an honesty
problem. This is why we really need to speak face to face. I'm not
always the best at expressing my thoughts through email and IRC. It's
too easy to get into flames and start attacking each other personally.
Having a discussion over a beer is probably something that would help
us.

I've always been 100% honest with you, but when I've tried to express
myself we end up flaming each other. I'll admit, I've avoided having
more conversations with you because I'm tired of the flames. I don't
know what it is between us, but for some reason we can push each other's
buttons just right and the conversation moves from being technical to
personal.

I'm not conspiring to under mind either you nor perf. The problem with
us is that we have two different ideas of where we want to go. From day
one, I've fought for the debugfs interface. I've said that I will let it
disappear if (and only if) perf is so convenient that it is totally
unneeded. But this point has always caused us to fight with each other.

trace-cmd started as a proof of concept for perf, but you and Peter
nak'd the idea of using the ftrace ring buffer. I still find (and
others, like Google also) that the ftrace ring buffer is superior in
tracing than perf's. Maybe it's not just the ring buffer itself, but the
other overhead of recording perf data. I don't know, the perf ring
buffer is extremely coupled with perf so it's hard to measure without
the rest of perf.

I'll be truly honest here. I continued with trace-cmd hoping that it
would eventually impress you and the two tools could merge. Obviously
that didn't occur, and you took it that I did the trace-cmd work as a
way to compete against perf. That was not my intent.

I've mentioned earlier, that I broke up trace-cmd (libparsevent.so) so
that perf could *use* the features of trace-cmd. Heck, Frederic ported
the code from it to perf. I was hoping for perf to use the library but
I'm not sure why it never did. libparsevent.so is totally agnostic to
ftrace as it only focuses on the event data parsing. I have a separate
libtracecmd.so that implemented the ftrace side. I was hoping that
libperf.so would do the perf side.

Now that trace-cmd is out, and used by many users, its interface is an
ABI, so we are stuck with it regardless. I don't think this really did
hurt perf. In fact, I think it can help perf.

> 
> Despite what you say perf and 'trace' can do system-wide tracing just fine:
> 
>   $ trace record -a
>   ^C
>   # trace recorded [205.108 MB] - try 'trace summary' to get an overview
> 
> ( and note that the code in tip:tmp.perf/trace2 is a very early prototype, 
>   barely tested - it just demonstrates the idea. )
> 
> In fact we could make 'trace' default to system-wide tracing by default and it 
> would fall back to workload level tracing only if it does not have the 
> privileges to trace the whole system.
> 
> Why not use the correctly designed tracing approach and enhance it, and merge 
> all the remaining useful bits of ftrace into it?

The problem we have is that we disagree on what a correctly designed
tracing approach is. Tracing is one of those things that everyone has a
different idea of what is important. As you stated, you do not care
about 4 bytes in an event. If you have 4 million events that is 4
million bytes. A typical event size could be 20 bytes, that 4 bytes is
1/5th of the event that is wasted space.

I believing in an evolutionary approach to merging as suppose to an
intellectual design. I've always said, lets start merging piece by
piece, and hopefully we end up with a great product. I don't care if
this end product is perf or ftrace, but if it is designed properly I'd
be happy with it.

But we need to take it step by step. You are correct that lately I've
been avoiding working directly on perf, but instead started working on
the ftrace side to make it easier to integrate the two. The reason is
that I'm scared to email you anymore, because I don't know what email is
going to trigger another flame war.

-- Steve
 

