Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab0LPVVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:21:12 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:34668 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756903Ab0LPVVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:21:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACERCk1GNBQZ/2dsb2JhbACkPXTCLYVKBIRl
Date: Thu, 16 Dec 2010 15:36:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, athieu.desnoyers@polymtl.ca,
        hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
Message-ID: <20101216203603.GA15610@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com> <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com> <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com> <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com> <1292528501.2708.80.camel@laptop> <20101216194852.GD2856@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101216194852.GD2856@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:25:56 up 253 days,  6:16,  5 users,  load average: 0.06, 0.15,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Thu, Dec 16, 2010 at 08:41:41PM +0100, Peter Zijlstra wrote:
> > On Thu, 2010-12-16 at 14:36 -0500, Jason Baron wrote:
> > > On Thu, Dec 16, 2010 at 08:33:51PM +0100, Peter Zijlstra wrote:
> > > > On Thu, 2010-12-16 at 14:23 -0500, Jason Baron wrote:
> > > > > 
> > > > > For the jump label disabled case, perf is using atomic_inc/dec and atomic_read
> > > > > to check if enabled. While other consumers (tracepoints) are just using an
> > > > > 'int'. I didn't want hurt the jump label disabled case for tracepoints.
> > > > > If we can agree to use atomic ops for tracepoints, or drop atomics from
> > > > > perf, that would simplify things. 
> > > > 
> > > > I had a quick look at the tracepoint stuff but got lost, but surely it
> > > > has a reference count somewhere as well, it needs to know when the last
> > > > probe goes away.. or does it check if the list is empty?
> > > > 
> > > > Anyway, tracepoint enable/disable isn't a real fast-path, surely it
> > > > could suffer an atomic op?
> > > 
> > > It is the atomic_read() at the tracepoint site that I am concerned
> > > about.
> > 
> > Look at the implementation :-), its just wrapper foo, its a regular read
> 
> i did.
> 
> > for everything except some really weird archs (you really shouldn't care
> > about).
> 
> right, I wasn't sure how much those mattered.
> 
> > 
> > static inline int atomic_read(const atomic_t *v)
> > {
> >         return (*(volatile int *)&(v)->counter);
> > }
> > 
> > The volatile simply forces a load to be emitted.
> 
> Mathieu, what do you think? Are you ok with an atomic_read() for
> checking if a tracepoint is enabled, when jump labels are disabled?

volatiles are also ordered one with respect to another by the compiler,
so I'd like to avoid doing the volatile read on the fast path unless
utterly necessary for architectures not supporting static jump patching
yet.

Tracepoints keep their own reference counts for enable/disable, so a
simple "enable/disable" is fine as far as tracepoints are concerned. Why
does perf need that refcounting done by the static jumps ?

I'd be tempted to use a "char" instead of a int/atomic_t for the key,
and keep the reference counter out of the picture (and leave that to the
caller). A single byte can be updated and read atomically. This should
save memory for the jump label tables.

Thoughts ?

Thanks,

Mathieu

> 
> thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
