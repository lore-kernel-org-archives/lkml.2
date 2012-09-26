Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2IZVha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:37:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34823 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab2IZVh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:37:28 -0400
Date: Wed, 26 Sep 2012 23:37:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120926213723.GA27692@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 11:19:42AM -0700, Linus Torvalds wrote:
> I'm *so* not surprised.
> 
> That said, I think your "kill select_idle_sibling()" one was
> interesting, but the wrong kind of "get rid of that logic".

Yeah.

> It always selected target_cpu, but the fact is, that doesn't really
> sound very sane. The target cpu is either the previous cpu or the
> current cpu, depending on whether they should be balanced or not. But
> that still doesn't make any *sense*.
> 
> In fact, the whole select_idle_sibling() logic makes no sense
> what-so-ever to me. It seems to be total garbage.
> 
> For example, it starts with the maximum target scheduling domain, and
> works its way in over the scheduling groups within that domain. What
> the f*ck is the logic of that kind of crazy thing? It never makes
> sense to look at a biggest domain first. If you want to be close to
> something, you want to look at the *smallest* domain first. But
> because it looks at things in the wrong order, it then needs to have
> that inner loop saying "does this group actually cover the cpu I am
> interested in?"
> 
> Please tell me I am mis-reading this?

First of all, I'm so *not* a scheduler guy so take this with a great
pinch of salt.

The way I understand it is, you either want to share L2 with a process,
because, for example, both working sets fit in the L2 and/or there's
some sharing which saves you moving everything over the L3. This is
where selecting a core on the same L2 is actually a good thing.

Or, they're too big to fit into the L2 and they start kicking each-other
out. Then you want to spread them out to different L2s - i.e., different
HT groups in Intel-speak.

Oh, and then there's the userspace spinlocks thingie where Mike's patch
hurts us.

Btw, Mike, you can jump in anytime :-)

So I'd say, this is the hard scheduling problem where fitting the
workload to the architecture doesn't make everyone happy.

A crazy thought: one could go and sample tasks while running their
timeslices with the perf counters to know exactly what type of workload
we're looking at. I.e., do I have a large number of L2 evictions? Yes,
then spread them out. No, then select the other core on the L2. And so
on.

> But starting from the biggest ("llc" group) is wrong *anyway*, since
> it means that it starts looking at the L3 level, and then if it
> finds an acceptable cpu inside that level, it's all done. But that's
> *crazy*. Once again, it's much better to try to find an idle sibling
> *closeby* rather than at the L3 level. No?

Exactly my thoughts a couple of days ago but see above.

> So once again, we should start at the inner level and if we can't find
> something really close, we work our way out, rather than starting from
> the outer level and working our way in.
>
> If I read the code correctly, we can have both "prev" and "cpu" in
> the same L2 domain, but because we start looking at the L3 domain, we
> may end up picking another "affine" CPU that isn't even sharing L2's
> *before* we pick one that actually *is* sharing L2's with the target
> CPU. But that code is confusing enough with the scheduler groups inner
> loop that maybe I am mis-reading it entirely.
>
> There are other oddities in select_idle_sibling() too, if I read
> things correctly.
>
> For example, it uses "cpu_idle(target)", but if we're actively trying
> to move to the current CPU (ie wake_affine() returned true), then
> target is the current cpu, which is certainly *not* going to be idle
> for a sync wakeup. So it should actually check whether it's a sync
> wakeup and the only thing pending is that synchronous waker, no?
>
> Maybe I'm missing something really fundamental, but it all really does
> look very odd to me.
>
> Attached is a totally untested and probably very buggy patch, so
> please consider it a "shouldn't we do something like this instead" RFC
> rather than anything serious. So this RFC patch is more a "ok, the
> patch tries to fix the above oddnesses, please tell me where I went
> wrong" than anything else.
>
> Comments?

Let me look at it tomorrow, on a fresh head. Too late here now.

Thanks.

-- 
Regards/Gruss,
    Boris.
