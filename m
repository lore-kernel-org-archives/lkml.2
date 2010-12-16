Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0LPVas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:30:48 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:35729 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757144Ab0LPVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:30:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACERCk1GNBQZ/2dsb2JhbACkPXTCLYVKBIRl
Date: Thu, 16 Dec 2010 15:45:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
Message-ID: <20101216204540.GA18095@Krystal>
References: <cover.1292522251.git.jbaron@redhat.com> <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com> <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com> <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com> <1292528501.2708.80.camel@laptop> <20101216194852.GD2856@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101216194852.GD2856@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:41:56 up 253 days,  6:32,  5 users,  load average: 0.16, 0.15,
	0.10
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

[Steven:]

Note, I'm fine with this method too. An atomic_read() is extremely fast.
The worse that it does is to prevent gcc from optimizing a little, which
we already cause it to do due to the asm goto that we use.

[my reply to Steven]

How does the asm goto we use prohibit the compiler from moving code in
any way more than an standard branch ? It's not an "asm volatile goto",
just an asm goto.

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
