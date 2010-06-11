Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0FKVJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:09:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53860 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753307Ab0FKVJw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:09:52 -0400
Date: Fri, 11 Jun 2010 17:09:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611210950.GB20360@Krystal>
References: <20100611194016.GA5213@Krystal> <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:52:55 up 139 days, 23:30,  7 users,  load average: 0.26, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Fri, Jun 11, 2010 at 12:40 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > Is it just me, or the following code:
> >
> > static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> > {
> >        unsigned ret;
> >
> > repeat:
> >        ret = sl->sequence;
> >        smp_rmb();
> >        if (unlikely(ret & 1)) {
> >                cpu_relax();
> >                goto repeat;
> >        }
> >
> >        return ret;
> > }
> >
> > could use a ACCESS_ONCE() around the sl->sequence read ? I'm concerned about the
> > compiler generating code that reads the sequence number chunkwise.
> 
> What compiler would do that? That would seem to be a compiler bug, or
> a compiler that is just completely crazy.
> 
> But it wouldn't be _wrong_ to make it do ACCESS_ONCE(). I just suspect
> that any compiler that cares is not a compiler worth worrying about,
> and the compiler should be shot in the head rather than us necessarily
> worrying about it.
> 
> There is no way a sane compiler can do anything but one read anyway.
> We do end up using all the bits (for the "return ret") part, so a
> compiler that reads the low bit separately is just being a totally
> moronic one - we wouldn't want to touch such a stupid compiler with a
> ten-foot pole.

If for some reason it is better (faster for -O2, smaller code for -Os) on a
given architecture to read the low bits separately from the rest and populate
two different registers, one for the test and the other for the return value,
then a not-so-moronic compiler might actually do this. One reason I could see
for generating this kind of code is compiling with -Os, if the kind of behavior
I describe above generates smaller code.

> 
> But at the same time, ACCESS_ONCE() ends up being a reasonable hint to
> programmers, so I wouldn't object to it. I just don't think we should
> pander to "compilers can be crazy". If compilers are crazy, we
> shouldn't use them.

I'm just afraid about the possibility that non-crazy compilers might actually
have a good reason to do this we haven't thought of yet.

FWIW, in the userspace RCU library, I wrapped all non-protected accesses to
shared word-sized aligned variables (e.g.  rcu_assign_pointer(),
rcu_dereference_pointer(), ..) with LOAD_SHARED() and STORE_SHARED() accessors,
which are basically just volatile loads and stores.

That's just me making absolutely sure the compiler won't perform anything
chunkwise nor perform multiple loads. It also ensures we are somewhat ready for
upcoming architectures with non-coherent caches. Having all these accesses in a
convenient macro makes it much easier to insert cache flushes whenever needed.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
