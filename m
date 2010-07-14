Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0GNUjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:39:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51960 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757902Ab0GNUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:39:43 -0400
Date: Wed, 14 Jul 2010 16:39:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20100714203940.GC22096@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:22:09 up 172 days, 22:58,  6 users,  load average: 0.04, 0.06,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote
[...]
> In fact, I wonder if we couldn't just do a software NMI disable
> instead? Hav ea per-cpu variable (in the _core_ percpu areas that get
> allocated statically) that points to the NMI stack frame, and just
> make the NMI code itself do something like
> 
>  NMI entry:

Let's try to figure out how far we can go with this idea. First, to answer
Ingo's critic, let's assume we do a stack frame copy before entering the
"generic" nmi handler routine.

>  - load percpu NMI stack frame pointer
>  - if non-zero we know we're nested, and should ignore this NMI:
>     - we're returning to kernel mode, so return immediately by using
> "popf/ret", which also keeps NMI's disabled in the hardware until the
> "real" NMI iret happens.

Maybe incrementing a per-cpu missed NMIs count could be appropriate here so we
know how many NMIs should be replayed at iret ?

>     - before the popf/iret, use the NMI stack pointer to make the NMI
> return stack be invalid and cause a fault

I assume you mean "popf/ret" here. So assuming we use a frame copy, we should
change the nmi stack pointer in the nesting 0 nmi stack copy, so the nesting 0
NMI iret will trigger the fault.

>   - set the NMI stack pointer to the current stack pointer

That would mean bringing back the NMI stack pointer to the (nesting - 1) nmi
stack copy.

> 
>  NMI exit (not the above "immediate exit because we nested"):
>    clear the percpu NMI stack pointer

This would be rather:
- Copy the nesting 0 stack copy back onto the real nmi stack.
- clear the percpu nmi stack pointer

** !

>    Just do the iret.

Which presumably faults if we changed the return stack for an invalid one and
executes as many NMIs as there are "missed nmis" counted (missed nmis should
probably be read with an xchg() instruction).

So, one question persists, regarding the "** !" comment: what do we do if an NMI
comes in exactly at that point ? I'm afraid it will overwrite the "real" nmi
stack, and therefore drop all the "pending" nmis by setting the nmi stack return
address to a valid one.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
