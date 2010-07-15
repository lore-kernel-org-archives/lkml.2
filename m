Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab0GOSb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:31:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37961 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934057Ab0GOSbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:31:55 -0400
Date: Thu, 15 Jul 2010 14:31:53 -0400
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
Message-ID: <20100715183153.GA9276@Krystal>
References: <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com> <20100714222115.GA30122@Krystal> <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com> <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:06:48 up 173 days, 20:43,  6 users,  load average: 0.04, 0.05,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Jul 14, 2010 at 6:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So this is what I think it might look like, with the %rip in place.
> >  [ ...]
> > Hmm?
> 
> I didn't fill in the iret fault details, because I thought that would
> be trivial. We get an exception, it's a slow case, how hard can it be
> to just call the NMI code?

I'm wondering if we really have to handle this with a fault. Couldn't we just
send iret to the following nmi handler instead ? (chaining nmis)

I think we can even find a way to handle the fact that the fake nmi does not run
with nmis disabled. We could keep the nmi nested bit set if we find out that
iret will branch to the fake nmi. We would then have to make sure the fake nmi
entry point is a little further than the standard nmi entry point: somewhere
after the initial nmi nesting check.

> 
> But thinking some more about it, it doesn't feel as trivial any more.
> We want to set up that same nesting code for the faked NMI call, but
> now I made it be two separate variables, and they need to be set in an
> NMI-safe way without us actually having access to the whole NMI
> blocking that the CPU does for a real NMI.
> 
> So there's a few subtleties there too. Probably need to make the two
> percpu values adjacent, and use cmpxchg16b in the "emulate NMI on
> exception" code to set them both atomically. Or something. So I think
> it's doable, but it's admittedly more complicated than I thought it
> would be.

Hrm, we could probably get away with only keeping the nmi_stack_nested per-cpu
variable. The nmi_stack_ptr could be known statically if we set it at a fixed
offset from the bottom of stack rather than using an offset relative to the top
(which can change depending if we are nested over the kernel or userspace).
We just have to reserve enough space for the bottom of stack.

> 
> .. and obviously there's nothing that guarantees that the code I
> already posted is correct either. The whole concept might be total
> crap.

Call me optimistic if you want, but I think we're really getting somewhere. :)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
