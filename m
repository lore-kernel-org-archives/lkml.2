Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902Ab0GOWat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:30:49 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60490 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934838Ab0GOWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:30:48 -0400
Date: Thu, 15 Jul 2010 18:30:46 -0400
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
Message-ID: <20100715223046.GA19403@Krystal>
References: <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com> <20100714222115.GA30122@Krystal> <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com> <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com> <20100715183153.GA9276@Krystal> <AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com> <AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com> <20100715220117.GA1499@Krystal> <AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:19:44 up 174 days, 56 min,  6 users,  load average: 0.24,
	0.13, 0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Thu, Jul 15, 2010 at 3:01 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> >                 . NMI exit code
> > and fake NMI entry are made reentrant with respect to NMI handler interruption
> > by testing, at the very beginning of the NMI handler, if a NMI is nested over
> > the whole nmi_atomic .. nmi_atomic_end code region.
> 
> That is totally bogus. The NMI can be nested by exceptions and
> function calls - the whole _point_ of this thing. So testing "rip" for
> anything else than the specific final "iret" is meaningless. You will
> be in an NMI region regardless of what rip is.

There are 2 tests done on NMI handler entry:

1) test if nested over nmi_atomic region (which is a very restrained region
around nmi_exit, which does not do any function call nor take traps).
2) test if the per-cpu nmi_nesting flag is set.

Test #2 takes care of NMIs nested over functions called and traps.

> 
> > This code assumes NMIs have a separate stack.
> 
> It also needs to be made per-cpu (and the flags be per-cpu).

Sure, that was implied ;)

> 
> Then you could in fact possibly test the stack pointer for whether it
> is in the NMI stack area, and use the value of %rsp itself as the
> flag. So you could avoid the flag entirely. Because testing %rsp is
> valid - testing %rip is not.

That could be used as a way to detect "nesting over NMI", but I'm not entirely
sure it would deal with the "we need a fake NMI" flag set/clear (more or less
equivalent to setting CS to 0 in your implementation and then back to some other
value). The "set" is done with NMIs disabled, but the "clear" is done at fake
NMI entry, where NMIs are active.

> 
> That would also avoid the race, because %rsp (as a flag) now gets
> cleared atomically by the "iret". So that might actually solve things.

Well, I'm still unconvinced there is anything to solve, as I built my NMI entry
with 2 tests: one for "nmi_atomic" code range and the other for per-cpu nesting
flag. Given that I set/clear the per-cpu nesting flag either with NMIs off or
within the nmi_atomic code range, this should all work fine.

Unless I am missing something else ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
