Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0FKUgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:36:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48214 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab0FKUgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:36:10 -0400
Date: Fri, 11 Jun 2010 13:36:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611203607.GH2394@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100611194016.GA5213@Krystal>
 <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:07:55PM -0700, Linus Torvalds wrote:
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

The reason that the C standard permits this is to allow for things like
8-bit CPUs, which are simply unable to load or store 32-bit quantities
except by doing it chunkwise.  But I don't expect the Linux kernel to
boot on these, and certainly not on any of the ones that I have used!

I most definitely remember seeing a gcc guarantee that loads and stores
would be done in one instruction whenever the hardware supported this,
but I am not finding it today.  :-(

							Thanx, Paul

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
> 
> But at the same time, ACCESS_ONCE() ends up being a reasonable hint to
> programmers, so I wouldn't object to it. I just don't think we should
> pander to "compilers can be crazy". If compilers are crazy, we
> shouldn't use them.
> 
>                  Linus
