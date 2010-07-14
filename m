Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab0GNXLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:11:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:38457 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754294Ab0GNXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:11:19 -0400
Date: Wed, 14 Jul 2010 19:11:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100714231117.GA22341@Krystal>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714224853.GC14533@nowhere>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:08:36 up 173 days,  1:45,  6 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Wed, Jul 14, 2010 at 06:31:07PM -0400, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > On Wed, Jul 14, 2010 at 12:54:19PM -0700, Linus Torvalds wrote:
> > > > On Wed, Jul 14, 2010 at 12:36 PM, Frederic Weisbecker
> > > > <fweisbec@gmail.com> wrote:
> > > > >
> > > > > There is also the fact we need to handle the lost NMI, by defering its
> > > > > treatment or so. That adds even more complexity.
> > > > 
> > > > I don't think your read my proposal very deeply. It already handles
> > > > them by taking a fault on the iret of the first one (that's why we
> > > > point to the stack frame - so that we can corrupt it and force a
> > > > fault).
> > > 
> > > 
> > > Ah right, I missed this part.
> > 
> > Hrm, Frederic, I hate to ask that but.. what are you doing with those percpu 8k
> > data structures exactly ? :)
> > 
> > Mathieu
> 
> 
> 
> So, when an event triggers in perf, we sometimes want to capture the stacktrace
> that led to the event.
> 
> We want this stacktrace (here we call that a callchain) to be recorded
> locklessly. So we want this callchain buffer per cpu, with the following
> type:

Ah OK, so you mean that perf now has 2 different ring buffer implementations ?
How about using a single one that is generic enough to handle perf and ftrace
needs instead ?

(/me runs away quickly before the lightning strikes) ;)

Mathieu


> 
> 	#define PERF_MAX_STACK_DEPTH		255
> 
> 	struct perf_callchain_entry {
> 		__u64				nr;
> 		__u64				ip[PERF_MAX_STACK_DEPTH];
> 	};
> 
> 
> That makes 2048 bytes. But per cpu is not enough for the callchain to be recorded
> locklessly, we also need one buffer per context: task, softirq, hardirq, nmi, as
> an event can trigger in any of these.
> Since we disable preemption, none of these contexts can nest locally. In
> fact hardirqs can nest but we just don't care about this corner case.
> 
> So, it makes 2048 * 4 = 8192 bytes. And that per cpu.
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
