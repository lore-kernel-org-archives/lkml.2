Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935302Ab0HFBte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:49:34 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42693 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933217Ab0HFBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:49:27 -0400
Date: Thu, 5 Aug 2010 21:49:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100806014925.GB496@Krystal>
References: <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal> <1280904410.1923.700.camel@laptop> <20100804144539.GA4617@Krystal> <1280933788.1923.1281.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280933788.1923.1281.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 21:42:37 up 195 days,  4:19,  6 users,  load average: 0.19, 0.07,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> 
> > How do you plan to read the data concurrently with the writer overwriting the
> > data while you are reading it without corruption ?
> 
> I don't consider reading while writing (in overwrite mode) a valid case.
> 
> If you want to use overwrite, stop the writer before reading it.

How inconvenient. It happens that the relatively large group of users I am
working for do care for this use-case. They cannot afford to stop tracing as
soon as they hit "one bug". This "bug" could be a simple odd scenario that they
want to snapshot, but in all cases they want tracing to continue.

> 
> >  I think that the stack dump
> > should simply be saved directly to the ring buffer, without copy. The
> > dump_stack() functions might have to be extended so they don't just save text
> > dumbly, but can also be used to save events into the trace in binary format,
> > perhaps with the continuation cookie Linus was proposing.
> 
> Because I don't want to support truncating reservations (because that
> leads to large nops for nested events)

Agreed in this case. Truncating reservations might make sense for filtering, but
even there I have a strong preference for filtering directly on the information
received as parameter, before performing buffer space reservation, whenever
possible.

> and when the event needs to go to
> multiple buffers you can re-use the stack-dump without having to do the
> unwind again.
> 
> The problem with the continuation thing Linus suggested is that it would
> bloat the output 3 fold. A stack entry is a single u64. If you want to
> wrap that in a continuation event you need: a header (u64), a cookie
> (u64) and the entry (u64).

Agreed, it's probably not such a good fit for these small pieces of information.

> 
> Continuation events might make heaps of sense for larger data pieces,
> but I don't see them being practical for such small pieces.

Yep.

What I did in a past life in earlier LTTng versions was to use a 2-pass unwind.
The first pass is the most costly because it brings all the data into the L1
cache. This first pass is used to compute the array size you need to save the
whole stack frame, but it does not copy anything. The second pass performs the
copy. This was surprisingly efficient.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
