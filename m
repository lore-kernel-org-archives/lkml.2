Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1HLEf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 00:35:56 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:50959
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750726Ab1HLEfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 00:35:53 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPVD:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 12 Aug 2011 00:35:33 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sam wang <linux.swang@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
In-Reply-To: <20110811081525.GA3802@elte.hu>
Message-ID: <alpine.DEB.2.00.1108120009560.12863@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu> <20110810183306.GA32695@e102144-lin.cambridge.arm.com> <alpine.DEB.2.00.1108101452510.25186@cl320.eecs.utk.edu> <20110810220727.GA5270@e102144-lin.cambridge.arm.com>
 <20110811081525.GA3802@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Ingo Molnar wrote:

> 
> * Will Deacon <will.deacon@arm.com> wrote:
> So what you and Vince are suggesting, to dumb down the kernel parts 
> of perf and force users into raw or microarchitecture specific events 
> actually *reduces* the user-base very significantly - while in 
> practice even just cycles, instructions and branches level analysis 
> handles 99% of the everyday performance analysis needs ...

No, what I want are the generalized events to accurately describe what is 
being measured.

To do this properly you need a lot more granularity.  PAPI for example has 
100+ generalized events, some of which require multiple hardware events 
to be combined to get the desired outcome.

Having a "branch" event like that on ARM that ignores not-taken events is 
going to drive you nuts when you are trying to sample in your code to 
find out why the branch miss rate is so high and you want to find the loop 
exits that are predicted poorly (but can't find them because loop exits 
tend to be not-taken branches).

Having a "L1-dcache-load" event that includes stores (like on current AMD) 
will drive you nuts if you are debugging code and it shows that somehow
these loads are triggering cache-coherency invalidates when you know that 
usually only stores can do so, and why would a load only event count 
stores.

Having a tool that gives misleading names to things would be like if I 
gave some poor user a copy of gdb that silently set breakpoints a random
offset from where the actueal breakpoint.  Sure it probably correlates to 
where you want the code to stop, but it's not what the tool says it is 
doing..

So either come up with finer-grained generalized events, or else do a 
better job of picking them.  The fact that my _extremely_ simple 
validation tests keep turning up problems like this indicate that no one 
bothered checking these events before they shoved them in the kernel.

Once in, these bad events linger for years and it's not even possible
to tell from userspace what raw even a generalized event maps to.
So anyone who cares is going to use a tool that uses raw events anyway.

(Note I am not saying they'll calculate the raw hex vaue themselves.
 They'll use a pre-existing tool written by your maligned 1% power
 users that will pick the proper raw event for them.)

> We saw how the "push CPU specific events to users and tooling" 
> concept didn't work with oprofile - why do we have to re-discuss this 
> part of failed Linux history again and again?

No one is arguing for oprofile.  libpfm4/PAPI or a tool like pfmon, sure.

> The approach Vince and you are suggesting is literally sacrificing 
> 99% of utility for 1% of the users - a not very smart approach. I 
> don't mind accomodating the needs of 1% of power-users (at all), but:
> 
>    *NOT AT THE EXPENSE OF THE COMMON CASE*.
>
> [...]
> 
> We literally have more than 7 million lines of drivers/* code that 
> provides generic abstractions - not just a few thousand lines of raw 
> PCI operations space where user-space can write magic values to ...
>
> [...]
>
> It's the *job* of the kernel to abstract things away, we don't shy 
> away from that ...

I get the impression if you were the graphics maintainer you'd specify all 
drivers should use a 1024x768x16bpp generic abstraction and dither or 
scale all devices to match this.  This would be a nice abstraction that 
would make graphics programming oh so much easier for the casual 
programmer and it provides 99% of what most users want.  The 1% of power
users are unimportant.

Also one could only use officialy blessed list of colors appearing in 
some obscure file under /sys.

Also access to 3D functionality would be blocked until the people wanting 
3D had properly developed a generic concept of the color "mauve" that 
could be applied across the board, even on black+white only hardware.

> So having generic events is not some fancy, unused property, but a 
> pretty important measurement aspect of perf.

perf the userspace tool or perf_event the kernel ABI?

Vince

