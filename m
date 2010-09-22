Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0IVTxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:53:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54411 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0IVTxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:53:53 -0400
Date: Wed, 22 Sep 2010 20:53:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100922195349.GF19804@ZenIV.linux.org.uk>
References: <20100922.111019.200357319.davem@davemloft.net>
 <20100922183200.GC19804@ZenIV.linux.org.uk>
 <AANLkTi=DWk2_=wMqcM1jgJEuNRj_ni2OkM3osYCUg57Y@mail.gmail.com>
 <20100922185328.GD19804@ZenIV.linux.org.uk>
 <AANLkTi=pJUKRUQhpcVV8XAJF+BO1440v1Py5Opr34DR1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=pJUKRUQhpcVV8XAJF+BO1440v1Py5Opr34DR1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 12:08:53PM -0700, Linus Torvalds wrote:
> On Wed, Sep 22, 2010 at 11:53 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Um, no. ?You've *already* called get_signal_to_deliver(). ?There had been
> > no SIGSEGV in sight. ?You happily went on to set a sigframe for e.g.
> > SIGHUP, but ran out of stack. ?At that point you get force_sigsegv()
> > from handle_signal(). ?_NOW_ you have a pending SIGSEGV
> 
> Ahh. Ok. Different case from the one I thought you were worried about.
> And yeah, I guess that one does require us to mess with the low-level
> asm code (although I do wonder if we could not make the whole
> do_notify_resume + reschedule code be generic C code - it's a lot of
> duplicated subtle asm as it is).

Worse than just that...  Note that on sparc you need to deal with
fault_in_user_windows(), which can also trigger signals.  So much
for merging it cross-architecture, even if we ignore the differences
between the ways we pass data required for restart to do_signal().
Note that e.g. on alpha we pass _two_ values - one for overwritten
v0 (syscall number), another for overwritten a3 (error flag), etc.

Worse, quite a few targets do not save all registers on syscall entry.
Callee-saved stuff doesn't have to be in pt_regs.  Except that you
want *all* of them saved on stack when it's time to fill sigframes.
And once you've entered a C function you can't guarantee that compiler
hasn't already modified them; sure, they'll be restored on return, but
that doesn't help you to get to their values.  So you get switch_stack
built on stack around calling do_notify_resume() on those.  And you
really want to avoid doing that if you've got no signals - remember,
we hit that on exit from irqs as well, so it's one hell of a hot path.
For processors with big flat register file it can get very ugly.

There is a lot of ugly almost-duplication in there, no arguments about that.
Asm glue is actually not the worst part...
