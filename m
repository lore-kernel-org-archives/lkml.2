Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab0LPTtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:49:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0LPTtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:49:43 -0500
Date: Thu, 16 Dec 2010 14:48:53 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, athieu.desnoyers@polymtl.ca
Cc: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
Message-ID: <20101216194852.GD2856@redhat.com>
References: <cover.1292522251.git.jbaron@redhat.com> <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com> <1292526602.2708.57.camel@laptop> <20101216192303.GB2856@redhat.com> <1292528031.2708.77.camel@laptop> <20101216193635.GC2856@redhat.com> <1292528501.2708.80.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292528501.2708.80.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 08:41:41PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 14:36 -0500, Jason Baron wrote:
> > On Thu, Dec 16, 2010 at 08:33:51PM +0100, Peter Zijlstra wrote:
> > > On Thu, 2010-12-16 at 14:23 -0500, Jason Baron wrote:
> > > > 
> > > > For the jump label disabled case, perf is using atomic_inc/dec and atomic_read
> > > > to check if enabled. While other consumers (tracepoints) are just using an
> > > > 'int'. I didn't want hurt the jump label disabled case for tracepoints.
> > > > If we can agree to use atomic ops for tracepoints, or drop atomics from
> > > > perf, that would simplify things. 
> > > 
> > > I had a quick look at the tracepoint stuff but got lost, but surely it
> > > has a reference count somewhere as well, it needs to know when the last
> > > probe goes away.. or does it check if the list is empty?
> > > 
> > > Anyway, tracepoint enable/disable isn't a real fast-path, surely it
> > > could suffer an atomic op?
> > 
> > It is the atomic_read() at the tracepoint site that I am concerned
> > about.
> 
> Look at the implementation :-), its just wrapper foo, its a regular read

i did.

> for everything except some really weird archs (you really shouldn't care
> about).

right, I wasn't sure how much those mattered.

> 
> static inline int atomic_read(const atomic_t *v)
> {
>         return (*(volatile int *)&(v)->counter);
> }
> 
> The volatile simply forces a load to be emitted.

Mathieu, what do you think? Are you ok with an atomic_read() for
checking if a tracepoint is enabled, when jump labels are disabled?

thanks,

-Jason
