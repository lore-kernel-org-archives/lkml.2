Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1EYSVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1EYSVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:21:09 -0400
Date: Wed, 25 May 2011 20:18:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pedro Alves <pedro@codesourcery.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110525181856.GA16575@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <201105241049.58921.pedro@codesourcery.com> <20110524120013.GD10334@htj.dyndns.org> <201105241336.04298.pedro@codesourcery.com> <20110524140215.GF10334@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524140215.GF10334@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay again, I was a bit offline.

On 05/24, Tejun Heo wrote:
>
> Hello,
>
> On Tue, May 24, 2011 at 01:36:03PM +0100, Pedro Alves wrote:
> > On Tuesday 24 May 2011 13:00:13, Tejun Heo wrote:
> > > Hello,
> > >
> > > On Tue, May 24, 2011 at 10:49:58AM +0100, Pedro Alves wrote:
> > > > A couple interface questions that just crossed my mind:
> > > >
> > > >  - on a fork/vfork/clone, if PTRACE_EVENT_FORK|VFORK|CLONE have been
> > > >    enabled, will the tracer still see the new child stop with a
> > > >    SIGSTOP, or will it see a PTRACE_EVENT_INTERRUPT?
> > >
> > > This won't change, so SIGSTOP although we probably want to improve it
> > > such that this can be distinguished from SIGTRAP from userland.
> >
> > (I assume you meant SIGSTOP from userland.)  So that if a SIGSTOPs
> > from userland is sent before the tracer waits for the child, the
> > tracer sees a siginfo corresponding to the userland SIGSTOP?  Sounds
> > like it might work.
>
> Now that thinking more about it, TRAP_STOP (INTERRUPT trap) would
> probably be better.  I'll think more about it.  For fork, it doesn't
> really matter but deliverying SIGSTOP on CLONE isn't too good.  From
> user's POV, TRAP_STOP should work too, right?

I am a bit confused, sorry if I missed/misunderstood the context...

I thought, we already discussed this. Obviously, PT_SEIZED should be
inherited by the child during the auto-attach (and it is indeed copied
by ptrace_init_task). Why should we send SIGSTOP to the child then?
Even in the fork case, this leads to the same problems as the current
PTRACE_ATTACH has with the bogus SIGSTOP it sends. I think TRAP_STOP
is the only sane option, no?


Btw. Speaking of SEIZE->execvd->INTERRUPT which makes the tracee see
a SIGTRAP. Stupid question. Perhaps PTRACE_SEIZE should set
PT_TRACESYSGOOD | PT_TRACE_EXEC along with PT_SEIZED automatically?
PT_SEIZED implies the new behaviour anyway.

Oleg.

