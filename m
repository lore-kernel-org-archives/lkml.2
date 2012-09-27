Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2I0EdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:33:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53657 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277Ab2I0EdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:33:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Pz4457AEPR2BP+jPEkYWxAY9GbUWKyJwPU7YdrO
	eC2UgchpksgNdD
Message-ID: <1348720373.7059.95.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 06:32:53 +0200
In-Reply-To: <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
References: <1348505683.11847.111.camel@twins>
	 <1348511193.6951.44.camel@marge.simpson.net>
	 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	 <20120924192056.GB4082@liondog.tnic>
	 <1348538258.7100.23.camel@marge.simpson.net>
	 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	 <20120925170058.GC30158@x1.osrc.amd.com>
	 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 11:19 -0700, Linus Torvalds wrote: 
> On Wed, Sep 26, 2012 at 9:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Sep 25, 2012 at 10:21:28AM -0700, Linus Torvalds wrote:
> >> How does pgbench look? That's the one that apparently really wants to
> >> spread out, possibly due to user-level spinlocks. So I assume it will
> >> show the reverse pattern, with "kill select_idle_sibling" being the
> >> worst case. Sad, because it really would be lovely to just remove that
> >> thing ;)
> >
> > Yep, correct. It hurts.
> 
> I'm *so* not surprised.

Any other result would have induced mushroom cloud, glazed eyes, and jaw
meets floor here.

> That said, I think your "kill select_idle_sibling()" one was
> interesting, but the wrong kind of "get rid of that logic".
> 
> It always selected target_cpu, but the fact is, that doesn't really
> sound very sane. The target cpu is either the previous cpu or the
> current cpu, depending on whether they should be balanced or not. But
> that still doesn't make any *sense*.
> 
> In fact, the whole select_idle_sibling() logic makes no sense
> what-so-ever to me. It seems to be total garbage.

Oh, it's not _that_ bad.  It does have it's troubles, but if it were
complete shite it wouldn't the make numbers that I showed, and wouldn't
make the even better numbers it does with some other loads. 

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

We start at MC to get the tbench win I showed (Intel) vs loss at SMT.
Riddle me this, why does that produce the wins I showed?  I'm still
hoping someone can shed some light on why the heck there's such a
disparity in processor behaviors.

> But starting from the biggest ("llc" group) is wrong *anyway*, since
> it means that it starts looking at the L3 level, and then if it finds
> an acceptable cpu inside that level, it's all done. But that's
> *crazy*. Once again, it's much better to try to find an idle sibling
> *closeby* rather than at the L3 level. No? So once again, we should
> start at the inner level and if we can't find something really close,
> we work our way out, rather than starting from the outer level and
> working our way in.

Domains on my E5620 look like so when SMT is enabled (seldom):

[    0.473692] CPU0 attaching sched-domain:                                                                                                                                                                                                 
[    0.477616]  domain 0: span 0,4 level SIBLING                                                                                                                                                                                            
[    0.481982]   groups: 0 (cpu_power = 589) 4 (cpu_power = 589)                                                                                                                                                                            
[    0.487805]   domain 1: span 0-7 level MC                                                                                                                                                                                                
[    0.491829]    groups: 0,4 (cpu_power = 1178) 1,5 (cpu_power = 1178) 2,6 (cpu_power = 1178) 3,7 (cpu_power = 1178)
...

I usually have SMT off, which gives me more oomph at the bottom end (smt
affects turboboost gizmo methinks), have only one domain, so say I'm
waking from CPU0.  With cross wire thingy, we'll always wake to CPU1 if
idle.  That demonstrably works well despite it being L3.  Box coughs up
wins at fast movers I too would expect L3 to lose at.  If L2 is my only
viable target for fast movers, I'm stuck with SMT siblings, which I have
measured.  They aren't wonderful for this.  They do improve max
throughput markedly though, so aren't a complete waste of silicon ;-)

I wonder what domains look like on Bulldog. (boot w. sched_debug)
> If I read the code correctly, we can have both "prev" and "cpu" in the
> same L2 domain, but because we start looking at the L3 domain, we may
> end up picking another "affine" CPU that isn't even sharing L2's
> *before* we pick one that actually *is* sharing L2's with the target
> CPU. But that code is confusing enough with the scheduler groups inner
> loop that maybe I am mis-reading it entirely.

Yup, and on Intel, it manages to not suck.

> There are other oddities in select_idle_sibling() too, if I read
> things correctly.
> 
> For example, it uses "cpu_idle(target)", but if we're actively trying
> to move to the current CPU (ie wake_affine() returned true), then
> target is the current cpu, which is certainly *not* going to be idle
> for a sync wakeup. So it should actually check whether it's a sync
> wakeup and the only thing pending is that synchronous waker, no?

Your logic is fine, but the missing element is that the sync wakeup hint
doesn't imply as much as you think it does.

> Maybe I'm missing something really fundamental, but it all really does
> look very odd to me.

Yeah, the sync hint.

> Attached is a totally untested and probably very buggy patch, so
> please consider it a "shouldn't we do something like this instead" RFC
> rather than anything serious. So this RFC patch is more a "ok, the
> patch tries to fix the above oddnesses, please tell me where I went
> wrong" than anything else.
> 
> Comments?

You busted it all to pieces with the sync hint.  Take for example mysql
+oltp, I've run that a zillion times.  It does sync wakeups iirc, been
quite a while, but definitely produced wins on my Q6600.  Those wins can
only exist if there is reclaimable overlap.  Sure, the Q6600 is taking
advantage of its shared L2, but that just moves the breakeven.

-Mike

