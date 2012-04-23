Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2DWSB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:01:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41522 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2DWSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:01:54 -0400
Date: Mon, 23 Apr 2012 19:01:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120423180150.GA6871@ZenIV.linux.org.uk>
References: <20120420004303.GB6871@ZenIV.linux.org.uk>
 <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420180748.GI6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 07:07:48PM +0100, Al Viro wrote:
> On Fri, Apr 20, 2012 at 10:21:35AM -0700, Linus Torvalds wrote:

> > This is why I suggested you look at Oleg's patches. If we guarantee
> > that things won't be delayed past re-entering user mode, all those
> > issues go away.
> 
> I've looked at them.  One obvious problem is that it tracehook_notify_resume()
> is not universally called.  AFAICS, hexagon, m68k, microblaze, score, um
> and xtensa never call tracehook_notify_resume().  Out of those, hexagon is
> manually checking TIF_NOTIFY_RESUME and does key_replace_session_keyring(),
> so the call could be easily added into the same place; the rest of those
> guys don't even look at TIF_NOTIFY_RESUME anywhere near their signal*.c
> and m68k/um/xtensa don't even have it defined, let alone handled.  So this
> stuff depends on some amount of asm glue hacking on several architectures ;-/

BTW, I've looked into dealing with that; I think I have a tentative solution
for all these architectures.
	* hexagon: just needs tracehook_notify_resume() added, everything
else is already in place
	* score: TIF_NOTIFY_RESUME is defined *and* included into the
"we need to call do_notify_resume()" logics in assembler glue; just need
to add the usual boilerplate into said do_notify_resume()
	* um: glue in question is in C; easily dealt with, I can do that
(and test the results) tonight
	* m68k: that'll need some glue changes; AFAICS, the easiest solution
is to put TIF_NOTIFY_RESUME into bit 5 - then nommu glue needs no changes
at all, and entry_mm.S needs two "jmi do_signal_return" replaced with
"jne do_signal_return"; the code before those shifts bit 6 to MSBit and
currently bits 0--5 are unused.  Replacing "most significant bit is set" with
"some bits are set" would do the right thing, AFAICT - make the sucker
go into do_signal() handling if either TIF_SIGPENDING (bit 6) or
TIF_NOTIFY_RESUME (bit 5) is set (at that point it has already checked that
TIF_NEED_RESCHEDULE is not set).  On top of that it will need the obvious
changes in do_signal() itself - boilerplate added and current contents
made conditional on TIF_SIGPENDING being set.  I can only test that
on aranym, though - all real m68k hardware I have is pining for fjords right
now.
	* microblaze: TIF_NOTIFY_RESUME is defined, but not hooked anywhere.
Fortunately, the glue is easy enough there - all relevant spots have the
same form
        lwi     r11, r11, TI_FLAGS;     /* get flags in thread info */
        andi    r11, r11, _TIF_SIGPENDING;
        beqi    r11, 1f;                /* Signals to handle, handle them */
and replacing that _TIF_SIGPENDING with _TIF_SIGPENDING | _TIF_NOTIFY_RESUME
will do the right thing; of course, do_signal() itself will need to be
taught about TIF_NOTIFY_RESUME - same as in case of m68k.  No hardware, no
emulators set up, but then it's less intrusive in the glue part than m68k
counterpart.
	* xtensa: TIF_NOTIFY_RESUME needs to be defined (bit 7 would do,
AFAICS) and there the glue does need some change:
        l32i    a4, a2, TI_FLAGS

        _bbsi.l a4, TIF_NEED_RESCHED, 3f
        _bbci.l a4, TIF_SIGPENDING, 4f
should be replaced with (if I'm not misreading their ISA documentation)
        l32i    a4, a2, TI_FLAGS

        _bbsi.l a4, TIF_NEED_RESCHED, 3f
        _bbsi.l a4, TIF_SIGPENDING, 2f
        _bbci.l a4, TIF_NOTIFY_RESUME, 4f
2:
(and do_signal() changes, of course).  That's the most intrusive one and
again, I've neither hw nor emulators for that sucker.

I'll post the patches for all of those tonight; if everything ends up working,
at least we can get rid of the ifdefs on TIF_NOTIFY_RESUME.

Oleg, where does your tree live?  I've walked through the signal handling
on all targets over this weekend (and it's still not complete - there are
fun bugs re multiple sigframes and restart handling on many of those) and
my current queue is at git.kernel.org/pub/scm/linux/kernel/git/viro/signal;
I don't promise that it even builds on everything, so it's *not* a pull
request.  Besides, it's still growing and will be reordered...  The issues
dealt with by now:
[done] don't open-code force_sigsegv()
[done] don't open-code block_sigmask()
[done] If we have failed to set sigframe up, we should send SIGSEGV with
force_sigsegv() (or force_sigsegv_info()) and leave the sigmask alone;
otherwise we need to call block_sigmask() and clear RESTORE_SIGMASK
[done] looking at SA_ONESHOT is pointless (it's a rudiment of very old things;
these days kernel/signal.c does it properly and arch/* code doesn't need to
and actually can't - it only gets a local copy filled, so clearing sa_handler
in it is bloody pointless)
[done] all sigsuspend variants should use sigsuspend() helper (i.e. be based
on use of ->saved_sigmask; see the first patch in queue introducing the helper
in question)
[done] restart_block.fn should be reset on sigreturn, not on signal delivery
[done] sigreturn variants should use set_current_blocked(); make sure to remove KILL/STOP from the set first
[mostly done; parisc and blackfin left] check __get_user()/__put_user() results

I really want to get arch/*/*/*signal* more or less in sync wrt fixes; having
TIF_NOTIFY_RESUME working fits nicely into that.  I'd appreciate a look through
that stuff...

PS: I don't think I'll be posting any pull requests on that tree; it's just
a staging ground for future linux-arch patchbomb(s).
