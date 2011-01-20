Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1ATUCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:02:45 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59664 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1ATUCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:02:43 -0500
Date: Thu, 20 Jan 2011 12:02:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110120200237.GC17752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110119132123.GC4246@quack.suse.cz>
 <x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
 <x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
 <AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
 <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
 <AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
 <x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
 <20110120040308.GD8476@linux.vnet.ibm.com>
 <AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 05:31:53AM +1100, Nick Piggin wrote:
> On Thu, Jan 20, 2011 at 3:03 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Jan 20, 2011 at 08:20:00AM +1100, Nick Piggin wrote:
> >> On Thu, Jan 20, 2011 at 8:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >> >> I don't know exactly how all programs use io_destroy -- of the small
> >> >> number that do, probably an even smaller number would care here. But I
> >> >> don't think it simplifies things enough to use synchronize_rcu for it.
> >> >
> >> > Above it sounded like you didn't think AIO should be using RCU at all.
> >>
> >> synchronize_rcu of course, not RCU (typo).
> >
> > I think that Nick is suggesting that call_rcu() be used instead.
> > Perhaps also very sparing use of synchronize_rcu_expedited(), which
> > is faster than synchronize_rcu(), but which which uses more CPU time.
> 
> call_rcu() is the obvious alternative, yes.
> 
> Basically, once we give in to synchronize_rcu() we're basically giving
> up. That's certainly a very good tradeoff for something like filesystem
> unregistration or module unload, it buys big simplifications in real
> fastpaths. But I just don't think it should be taken lightly.

Makes sense to me!

BTW, on your earlier usage classification:

> I think synchronize_rcu should firstly not be used unless it gives a good
> simplification, or speedup in fastpath.
>
> When that is satified, then it is a question of exactly what kind of slow
> path it should be used in. I don't think it should be used in process-
> synchronous code (eg syscalls) except for error cases, resource
> exhaustion, management syscalls (like module unload).

I don't have any feedback either way on your guidance to where
synchronize_rcu() should be used, as I believe that it depends a lot
on the details of usage, and would vary from one part of the kernel
to another, and possibly also over time.

But I am very glad to see that you have been thinking about it and
that you are putting forth some clear guidelines!

							Thanx, Paul
