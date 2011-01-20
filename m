Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1ATEDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 23:03:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57690 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1ATEDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 23:03:12 -0500
Date: Wed, 19 Jan 2011 20:03:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110120040308.GD8476@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110118235236.GA14087@quack.suse.cz>
 <AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
 <20110119132123.GC4246@quack.suse.cz>
 <x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
 <x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
 <AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
 <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
 <AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
 <x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 08:20:00AM +1100, Nick Piggin wrote:
> On Thu, Jan 20, 2011 at 8:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Nick Piggin <npiggin@gmail.com> writes:
> >
> >> On Thu, Jan 20, 2011 at 7:32 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >>> Nick Piggin <npiggin@gmail.com> writes:
> >>>
> >>>> On Thu, Jan 20, 2011 at 6:46 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >>>>> Jeff Moyer <jmoyer@redhat.com> writes:
> >>>>>
> >>>>>> Jan Kara <jack@suse.cz> writes:
> >>>>>>
> >>>>>>>  But there's the second race I describe making it possible
> >>>>>>> for new IO to be created after io_destroy() has waited for all IO to
> >>>>>>> finish...
> >>>>>>
> >>>>>> Can't that be solved by introducing memory barriers around the accesses
> >>>>>> to ->dead?
> >>>>>
> >>>>> Upon further consideration, I don't think so.
> >>>>>
> >>>>> Given the options, I think adding the synchronize rcu to the io_destroy
> >>>>> path is the best way forward.  You're already waiting for a bunch of
> >>>>> queued I/O to finish, so there is no guarantee that you're going to
> >>>>> finish that call quickly.
> >>>>
> >>>> I think synchronize_rcu() is not something to sprinkle around outside
> >>>> very slow paths. It can be done without synchronize_rcu.
> >>>
> >>> I'm not sure I understand what you're saying.  Do you mean to imply that
> >>> io_destroy is not a very slow path?  Because it is.  I prefer a solution
> >>> that doesn't re-architecht things in order to solve a theoretical issue
> >>> that's never been observed.
> >>
> >> Even something that happens once per process lifetime, like in fork/exit
> >> is not necessarily suitable for RCU.
> >
> > Now you've really lost me.  ;-)  Processes which utilize the in-kernel
> > aio interface typically create an ioctx at process startup, use that for
> > submitting all of their io, then destroy it on exit.  Think of a
> > database.  Every time you call io_submit, you're doing a lookup of the
> > ioctx.
> >
> >> I don't know exactly how all programs use io_destroy -- of the small
> >> number that do, probably an even smaller number would care here. But I
> >> don't think it simplifies things enough to use synchronize_rcu for it.
> >
> > Above it sounded like you didn't think AIO should be using RCU at all.
> 
> synchronize_rcu of course, not RCU (typo).

I think that Nick is suggesting that call_rcu() be used instead.
Perhaps also very sparing use of synchronize_rcu_expedited(), which
is faster than synchronize_rcu(), but which which uses more CPU time.

							Thanx, Paul

> > Here it sounds like you are just against synchronize_rcu.  Which is it?
> > And if the latter, then please tell me in what cases you feel one would
> > be justified in calling synchronize_rcu.  For now, I simply disagree
> > with you.  As I said before, you're already potentially waiting for disk
> > I/O to complete.  It doesn't get much worse than that for latency.
> 
> I think synchronize_rcu should firstly not be used unless it gives a good
> simplification, or speedup in fastpath.
> 
> When that is satified, then it is a question of exactly what kind of slow
> path it should be used in. I don't think it should be used in process-
> synchronous code (eg syscalls) except for error cases, resource
> exhaustion, management syscalls (like module unload).
> 
> For example "it's waiting for IO anyway" is not a good reason, IMO.
> Firstly because it may not be waiting for a 10ms disk IO, it may be
> waiting for anything up to an in-RAM device. Secondly because it
> could be quite slow depending on the RCU model used.
