Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0KKTIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:08:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50463 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753582Ab0KKTIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:08:45 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX199uGte4XN9nCcASuRvkiknzP9GGj9zMLri5vuHX5
	KlwXGHUR/cirBQ
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <AANLkTinbtfuipoene_M0Om_QtycHGL15Q5E8BOmLU-bh@mail.gmail.com>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net>
	 <AANLkTinbtfuipoene_M0Om_QtycHGL15Q5E8BOmLU-bh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:08:31 -0700
Message-ID: <1289502511.11397.36.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 10:34 -0800, Linus Torvalds wrote:
> On Thu, Nov 11, 2010 at 7:26 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > I _finally_ got back to this yesterday, and implemented your suggestion,
> > though with a couple minor variations.  Putting the autogroup pointer in
> > the signal struct didn't look right to me, so I plugged it into the task
> > struct instead.  I also didn't refcount taskgroups, wanted the patchlet
> > to be as self-contained as possible, so refcounted the autogroup struct
> > instead.  I also left group movement on tty disassociation in place, but
> > may nuke it.
> 
> Ok, the patch looks fine, but I do have a few comments:
> 
>  - the reason I suggested the signal struct was really that I thought
> it would avoid extra (unnecessary) cost in thread creation/teardown.
> 
>    Maybe I should have made that clear, but this seems to
> unnecessarily do the whole atomic_inc/dec for each thread. That seems
> a bit sad.
> 
>    That said, if not having to dereference ->signal simplifies the
> scheduler interaction, I guess the extra atomic ref at thread
> creation/deletion is fine. So I don't think this is wrong, it's just
> something I wanted to bring up.

Ah, ok.  Anything that cuts overhead is worth doing.

>  - You misspelled "detach". That just drives me wild. Please fix.

(well, _somebody_ has to keep the speeling police occupied;)

>  - What I _do_ think is wrong is how I think you're trying to be "too
> precise". I think that's fundamentally wrong, because I think we
> should make it very clear that it's a heuristic. So I dislike seeing
> these functions: sched_autogroup_handler() -  we shouldn't care about
> old state, sched_autogroup_detach() - even with the fixed spelling I
> don't really see why a tty hangup should cause the process to go back
> to the default group, for example.
> 
> IOW, I think you tried a bit _too_ hard to make it a 1:1 relationship
> with the tty. I don't think it needs to be. Just because a process
> loses its tty because of a hangup, I don't think that that should have
> any real implications for the auto-group scheduling. Or maybe it
> should, but that decision should be based on "does it help scheduling
> behavior" rather than on "it always matches the tty".  See what I'm
> saying?

Yeah, and it doesn't in the common case at least.  The handler's
classifier was because a 100% pinned hog would never obey the user's
wishes, but I can whack it along with the hangup.  Less is more in the
scheduler. 

Thanks for the comments.

	-Mike

