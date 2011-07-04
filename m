Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1GDN6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:58:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48686 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1GDN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:58:29 -0400
Date: Mon, 4 Jul 2011 15:58:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110704135820.GD5551@somewhere>
References: <1309362157-6596-1-git-send-email-avi@redhat.com>
 <1309362157-6596-2-git-send-email-avi@redhat.com>
 <20110629160841.GA2032@somewhere>
 <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629162725.GH15521@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 05:27:25PM +0100, Will Deacon wrote:
> Hi Frederic,
> 
> Thanks for including me on CC.
> 
> On Wed, Jun 29, 2011 at 05:08:45PM +0100, Frederic Weisbecker wrote:
> > On Wed, Jun 29, 2011 at 06:42:35PM +0300, Avi Kivity wrote:
> > > The perf_event overflow handler does not receive any caller-derived
> > > argument, so many callers need to resort to looking up the perf_event
> > > in their local data structure.  This is ugly and doesn't scale if a
> > > single callback services many perf_events.
> > >
> > > Fix by adding a context parameter to perf_event_create_kernel_counter()
> > > (and derived hardware breakpoints APIs) and storing it in the perf_event.
> > > The field can be accessed from the callback as event->overflow_handler_context.
> > > All callers are updated.
> > >
> > > Signed-off-by: Avi Kivity <avi@redhat.com>
> > 
> > I believe it can micro-optimize ptrace through register_user_hw_breakpoint() because
> > we could store the index of the breakpoint that way, instead of iterating through 4 slots.
> > 
> > Perhaps it can help in arm too, adding Will in Cc.
> 
> Yes, we could store the breakpoint index in there and it would save us
> walking over the breakpoints when one fires. Not sure this helps us for
> anything else though. My main gripe with the ptrace interface to
> hw_breakpoints is that we have to convert all the breakpoint information
> from ARM_BREAKPOINT_* to HW_BREAKPOINT_* and then convert it all back again
> in the hw_breakpoint code. Yuck!

Agreed, I don't like that either.

Would you like to improve that? We probably need to be able to pass some arch data
through the whole call of breakpoint creation, including perf_event_create_kernel_counter().

There can be a transition step where we can either take generic attr or arch datas, until
every archs are converted. So that you can handle the arm part and other arch developers
can relay.


Another thing I would like to do in the even longer term is to not use perf anymore
for ptrace breakpoints, because that involves a heavy dependency and few people are
happy with that. Instead we should just have a generic hook into the sched_switch()
and handle pure ptrace breakpoints there. The central breakpoint API would still be
there to reserve/schedule breakpoint resources between ptrace and perf.

But beeing able to create ptrace breakpoints without converting to generic perf attr
is a necessary first step in order to achieve this.

Thanks. 
