Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab0FYULy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:11:54 -0400
Received: from www.tglx.de ([62.245.132.106]:57597 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0FYULx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:11:53 -0400
Date: Fri, 25 Jun 2010 22:11:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ulrich Drepper <drepper@redhat.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: sys_futex() && timespec_valid()
In-Reply-To: <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-ID: <alpine.LFD.2.00.1006252159370.18683@localhost.localdomain>
References: <2054433814.959851277495348646.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Ulrich Drepper wrote:

Can you please use a mail client with proper line breaks ?

> ----- "Darren Hart" <dvhltc@us.ibm.com> wrote:
> > Unless there is some good reason to object to breaking the API that I
> > am  missing, I don't mind changing it to -ETIMEDOUT (although -EINVAL
> > seems more intuitive to me).
> 
> It's only not intuitive because Oleg misrepresented or at least
> didn't describe the issue.

> The kernel already catches invalid timespec values.  Unfortunately
> the code used comes from the time when all timeouts where specified
> with relative values.  In such situations negative tv_sec values
> were in fact invalid and rejected with EINVAL.

> But for absolute timeouts tv_sec = -1 means a time before Epoch.
> This is not an invalid value, it just is one of many points in time
> which have passed and therefore the kernel has to respond with
> ETIMEDOUT.

That's simply wrong.

  ... or the TIMER_ABSTIME flag was specified in flags and the rqtp
  argument is outside the range for the clock specified by clock_id;

And I consider anything before the EPOCH or before the computer booted
outside of the range. Simply because that's outside the range which we
can read back from the clock, out of the range to which we can set the
clock.

And it's completely illogical to treat relative and abolute timeouts
different. If we'd accept that before the EPOCH or before the computer
started is valid for ABSTIME, then there is no freaking reason to
treat relative timeouts any different.

> This is no semantic change or anything like that.  It pure and
> simply a bug fix.  When Thomas worked on that come we simply missed
> updating the test for invalid timespec values.

No, that's how we treat every damned timespec in the
syscalls. clock_nanosleep(ABSTIME) has this behaviour forever and we
have this behaviour in sys_futex since we merged PI futex support way
before we added the BITSET stuff.

So just because you messed up your glibc implementation you want us to
fix glibc in the kernel based on some backwards arguments ?

> The kernel code should be fixed to always check tv_nsec for < 0 and
> > 1000000000.  But the tv_sec test for < 0 should be skipped if the
> timeout value is interpreted as an absolute time value.

Definitely NOT!

	   tglx
