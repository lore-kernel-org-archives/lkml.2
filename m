Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0FKRRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:17:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab0FKRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:17:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s+Bho+OLgrUeBrkuILJ1mwCzuaxPszLp6SUyAH5Q3zYAkoLBmurfhzEKoRrVWx1fWw
         a9+VCUdn3MYerDsZlhCDKXbepAAsklfMuOy7/l9YVqzV49QuRZr+afYiqDec+kwgcIqq
         OyTrIAq2Jy6Ur1ylCS3BbUjrDWEuYioCo1/v4=
Date: Fri, 11 Jun 2010 19:17:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_disable()
Message-ID: <20100611171732.GA5234@nowhere>
References: <1276273784.2077.2055.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276273784.2077.2055.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 06:29:44PM +0200, Peter Zijlstra wrote:
> Hi,
> 
> I've been going over perf_disable() usage in kernel/perf_event.c and
> wondered if we actually need it at all.
> 
> Currently the only thing we seem to require it for is around pmu::enable
> calls (and for that powerpc at least does it itself, on x86 we rely on
> it to call ->enable_all and reprogram the pmu state).
> 
> But I can't really find any NMI races wrt data structures or the like as
> seems implied by some comments. 



I suspect the problem is also on per context integrity. When you adjust
the period, enable or disable a counter, this counter becomes async with
the rest of the group or the rest of the counters in the same context, for
a small bunch of time.

The longer you run your events, the higher is going to be this jitter.

Take an example, when you adjust a period, you:

perf_disable()
perf_event_stop()
left_period = 0
perf_event_start()
perf_enable()

During all this time, the given event is paused, but the whole rest of
the events running on the cpu continue to count.

The problem is the same on context switch.

And I think this high resolution of synchronisation per context is
sensitive, especially with perf start kind of workflows.

(Although software events are not touched by perf_enable()/perf_disable().


> 
> There is a fun little recursion issue with perf_adjust_period(), where
> if we fully removed perf_disable() we could end up calling pmu::stop()
> twice and such.
> 
> But aside from that it looks to me its mostly about optimizing hardware
> writes.
> 
> If nobody else known about/can find anything, I'm going to mostly remove
> perf_disable() for now and later think about how to optimize the
> hardware writes again.


Not sure that's a good idea IMHO.

