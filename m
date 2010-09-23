Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0IWE71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:59:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50249 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0IWE7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:59:25 -0400
Date: Thu, 23 Sep 2010 05:59:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100923045921.GJ19804@ZenIV.linux.org.uk>
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

BTW, there's an interesting idea in s390 implementation (and I have to say
that I'm bloody impressed by them - it's the only architecture besides x86
where I haven't found serious holes in signal handling yet; there are QOI
issues, but that's it so far).  What they do with syscall restarts is unusual
and they might have a good point there.

1) They deal with restart immediately on the entry to do_signal(); if
restarts are not suppressed and if the error is one of the restart-worthy
ones, they do what should be done for no-handler case.

2) They store the pre-restart address, post-restart address and error.  Then
they call get_signal_to_deliver().  Of course, it may return us a positive
signal number.  In that case they may need to discard the restart they'd
done.  And they do it, but only if the address has remained equal to
post-restart one.

3) They ignore ERESTART_RESTARTBLOCK if the address has changed.  Actually,
I suspect that they might need to clear the ->restart_block.fn in that case,
but I haven't done analysis of that yet.

They do have a reason for doing it that way and it's worth considering on
other platforms.  Think what happens if we are getting traced.  We'll be
stopped and tracer will be notified.  Normally it'll tell us to continue
execution, possibly with a different signal *AND* with a different userland
address to return to.  Suppose we've got a different return address set
for us (e.g. with PTRACE_POKEUSR).  Should we ever shift it back by what
hopefully is a size of syscall insn?
