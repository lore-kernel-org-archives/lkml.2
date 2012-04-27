Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178Ab2D0Sph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:45:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624Ab2D0Spe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:45:34 -0400
Date: Fri, 27 Apr 2012 19:45:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427184528.GL6871@ZenIV.linux.org.uk>
References: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427172444.GA30267@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 07:24:44PM +0200, Oleg Nesterov wrote:
> > static inline sigset_t *sigmask_to_save(void)
> > {
> > 	struct sigset *res = &current->blocked;
> > 	if (unlikely(test_restore_sigmask()))
> > 		res = current->saved_sigmask;
> > 	return res;
> > }
> 
> Perhaps... but test_*_restore_sigmask() depends on TIF_ or TS_

... and is in thread_info.h; you might want to pull it again ;-)
Right now the signal.git#master is at 349b4565ad9e9b891245590319567c0a042046d9

> > Umm...  Probably, and as far as I can see all callers are only reached if
> > we have SIGPENDING, but that requires at least documenting what's going on.
> 
> WARN_ON(!test_bit(TIF_SIGPENDING)) looks like the perfect documentation ;)

OK, I'm convinced.  Done.

BTW, I've a better name than set_current_blocked_carefully(); the thing
is, only 3 callers out of 63 are _not_ immediately preceded by excluding
SIGKILL/SIGSTOP out of the set.  So I've copied the existing variant
to __set_current_blocked() and folded that sigdelsetmask(...) into the
set_current_blocked().

> The only comment I have,
> 38671a3e831ed7327affb24d715f98bb99c80e56 m68k: add TIF_NOTIFY_RESUME and handle it
> forgets to unexport do_signal().

Meh...  The thing is, there are _two_ of them.  signal_mm.c and signal_no.c
badly need merging, with common stuff moved to signal.c.  I really hate
to see static function that isn't called anywhere in file it's defined in,
leaving one to trace what happens to include that file.  Running into that
in USB code is bloody annoying and I'd rather not add to that pile.  It's
certainly a valid C, but it's hell on casual reader...

	BTW, I'm somewhat tempted to do the following: *ALL* calls of
tracehook_signal_handler() are now immediately preceded by block_signals().
Moreover, tracehook_signal_handler(...., 0) is currently a no-op, so
it could be painlessly added after the remaining block_signals() instances.
How about *folding* block_signals() (along with clear_restore_sigmask())
into tracehook_signal_handler()?  I don't know if anyone has conflicting
plans for that sucker; Roland?

	Even more ambitious variant: take the "setting sigframe up has
failed, send ourselves SIGSEGV" in there as well (adding an extra argument
to tell which one it is).  Hell knows; I know at least one place where
such failure does _not_ lead to SIGSEGV, but there we do do_exit(SIGILL)
right in setup_..._frame() and do_exit() never returns.  There might be
other such suckers...
 
> The last thing. Matt, could you please look at
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git ? It seems to me
> you already sent some of these changes (use set_current_blocked/block_sigmask).
> Perhaps there are alreay in -mm or linux-next?
