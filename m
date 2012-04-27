Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab2D0RZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760552Ab2D0RZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:25:29 -0400
Date: Fri, 27 Apr 2012 19:24:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427172444.GA30267@redhat.com>
References: <20120420080914.GF6871@ZenIV.linux.org.uk> <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426231942.GJ6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Al Viro wrote:
>
> On Thu, Apr 26, 2012 at 08:37:42PM +0200, Oleg Nesterov wrote:
>
> > 	+       /* If there's no signal to deliver, we just restore the saved mask.  */
> > 	+       if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
> > 	+               clear_thread_flag(TIF_RESTORE_SIGMASK);
> > 	+               sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
> > 			^^^^^^^^^^^
> >
> > set_current_blocked(&current->saved_sigmask) looks better.
>
> In principle, yes.  FWIW, I think that the entire thing should be a helper
> to go along with set_restore_sigmask().  With
> 	if (test_and_clear_thread_flag(TIF_RESTORE_SIGMASK))
> 		set_current_blocked(&current->saved_sigmask);
> as default implementation.  The only question is where should it go -
> asm/thread_info.h is not a good place due to header dependencies.
> Kinda-sorta solution - in thread_info.h
> {set,clear,test,test_and_clear}_restore_sigmask()
> and in linux/signal.h
> #ifdef HAVE_SET_RESTORE_SIGMASK
> static inline void restore_saved_sigmask(void)
> {
> 	if (test_and_clear_restore_sigmask())
> 		set_current_blocked(&current->saved_mask);
> }
> static inline sigset_t *sigmask_to_save(void)
> {
> 	struct sigset *res = &current->blocked;
> 	if (unlikely(test_restore_sigmask()))
> 		res = current->saved_sigmask;
> 	return res;
> }

Perhaps... but test_*_restore_sigmask() depends on TIF_ or TS_

> Speaking of other helpers, pulling ppc restore_sigmask() into signal.h
> (as static inline) might be a good idea.

Agreed.

> Every sigreturn instance is
> open-coding it...

Not only sigreturn. Just look at sigprocmask(SIG_SETMASK) callers, almost
all should be converted to use set_current_blocked(). For example, pselect.

> We need saner names, though; this set is too easy to
> confuse with each other.

Say, set_current_blocked_careful().

> > Agreed, but why set_restore_sigmask() sets TIF_SIGPENDING? It should be
> > never used without signal_pending() == T.
>
> Umm...  Probably, and as far as I can see all callers are only reached if
> we have SIGPENDING, but that requires at least documenting what's going on.

WARN_ON(!test_bit(TIF_SIGPENDING)) looks like the perfect documentation ;)




OK, I have read the whole series. You do understand that I can't comment
the changes in asm, but I managed to convince myself I can more or less
understand them and I see nothing wrong.

The only comment I have,
38671a3e831ed7327affb24d715f98bb99c80e56 m68k: add TIF_NOTIFY_RESUME and handle it
forgets to unexport do_signal().



The last thing. Matt, could you please look at
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git ? It seems to me
you already sent some of these changes (use set_current_blocked/block_sigmask).
Perhaps there are alreay in -mm or linux-next?

Oleg.

