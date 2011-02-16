Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1BPUAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:00:41 -0500
Received: from mail.openrapids.net ([64.15.138.104]:47666 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753997Ab1BPUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:00:39 -0500
Date: Wed, 16 Feb 2011 15:00:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Roland McGrath <roland@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        Peter Zijlstra <peterz@infradead.org>
Subject: Porting "jump labels" to userspace (was: Re: [ltt-dev] LTTng-UST
	vs SystemTap userspace tracing benchmarks)
Message-ID: <20110216200034.GA6066@Krystal>
References: <4D5AA164.1050607@polymtl.ca> <y0mvd0ltgba.fsf@fche.csb> <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com> <1297853778.3224.90.camel@springer.wildebeest.org> <20110216185056.CAD7B1806E0@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216185056.CAD7B1806E0@magilla.sf.frob.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:49:16 up 85 days, 52 min,  3 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding the relevant people in CC for jump label discussion ]

* Roland McGrath (roland@redhat.com) wrote:
> Stefan was referring to #4 in your taxonomy.
> 
> It's indeed the case that what UST uses today is an always-there normal
> C code sequence that loads global variables to decide whether to make
> indirect function calls.  I don't recall off hand how many layers of
> function calls to the libust DSO and such there are in either the
> disabled or enabled cases.  At best, there is the always the overhead of
> several instructions and at least one load in the hot code path, and the
> i-cache pollution that goes with that.
> 
> It's indeed the cast that what Systemtap uses today is a
> sometimes-inserted normal breakpoint instruction, which is indeed a
> software interrupt that requires kernel mediation.  When disabled, there
> is as close to zero overhead as you can have, being a tiny placeholder
> instruction sequence (currently just one nop), so the runtime overhead
> is under a cycle and the i-cache pollution is the smallest possible unit
> (one instruction, being just one byte on x86).
> 
> The "sweet spot" between the two is to have overhead close to
> Systemtap's epsilon for a disabled probe, while having overhead close to
> UST's pure-user method when a probe is enabled.  In the in-kernel
> context, this is what the Linux kernel's latest code (still being hashed
> out, but mostly done) has for kernel tracepoints using the so-called
> "jump label" method.  That is also possible for sdt markers with some
> careful consideration and attention to machine-specific details for each
> machine architecture of concern.  It entails making the placeholder in
> the hot code path slightly larger (at least for x86, it has to be a
> "long nop", being probably neglibly more runtime overhead, and a few
> bytes more i-cache pollution), and adding some additional static code
> outside the hot path.  The work to enable or disable a probe becomes
> just as costly as the current Systemtap method, since it involves
> modifying the program text in place (inserting jump instructions rather
> than breakpoint ones).  Once enabled, the runtime work of the probes
> firing can be very much like what UST does today.

Actually, creating the equivalent of the jump labels for userspace is on our
list of "things to do" for the UST project.

If Jason and other jump label contributors agree to dual-license the jump label
generic and per-arch implementations under both GPLv2 and LGPLv2.1, we could
probably re-use a large part of this code to create a static jump label library
for userspace. The concerned authors are precisely: Jason for generic and x86
code, Steven for some improvements in generic code and David S. Miller for the
sparc port. After things settle down with the current jump label changes
proposed by Peter Zijlstra, we might also want to ask for his permission to
LGPLize his changes.

Thanks,

Mathieu

> 
> 
> Thanks,
> Roland

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
