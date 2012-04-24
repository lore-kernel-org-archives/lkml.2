Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2DXH0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:26:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54876 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2DXH0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:26:20 -0400
Date: Tue, 24 Apr 2012 08:26:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120424072617.GB6871@ZenIV.linux.org.uk>
References: <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
 <20120420025438.GD6871@ZenIV.linux.org.uk>
 <CA+55aFzinX_6DVvDTyxrsP6VEHVY2Q+Y=e+qksnAjR+oT3GZew@mail.gmail.com>
 <20120420080914.GF6871@ZenIV.linux.org.uk>
 <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
 <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423180150.GA6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 07:01:50PM +0100, Al Viro wrote:
> BTW, I've looked into dealing with that; I think I have a tentative solution
> for all these architectures.
> 	* hexagon: just needs tracehook_notify_resume() added, everything
> else is already in place
> 	* score: TIF_NOTIFY_RESUME is defined *and* included into the
> "we need to call do_notify_resume()" logics in assembler glue; just need
> to add the usual boilerplate into said do_notify_resume()
> 	* um: glue in question is in C; easily dealt with, I can do that
> (and test the results) tonight
> 	* m68k: that'll need some glue changes; AFAICS, the easiest solution
> is to put TIF_NOTIFY_RESUME into bit 5 - then nommu glue needs no changes
> at all, and entry_mm.S needs two "jmi do_signal_return" replaced with
> "jne do_signal_return"; the code before those shifts bit 6 to MSBit and
> currently bits 0--5 are unused.  Replacing "most significant bit is set" with
> "some bits are set" would do the right thing, AFAICT - make the sucker
> go into do_signal() handling if either TIF_SIGPENDING (bit 6) or
> TIF_NOTIFY_RESUME (bit 5) is set (at that point it has already checked that
> TIF_NEED_RESCHEDULE is not set).  On top of that it will need the obvious
> changes in do_signal() itself - boilerplate added and current contents
> made conditional on TIF_SIGPENDING being set.  I can only test that
> on aranym, though - all real m68k hardware I have is pining for fjords right
> now.
> 	* microblaze: TIF_NOTIFY_RESUME is defined, but not hooked anywhere.
> Fortunately, the glue is easy enough there - all relevant spots have the
> same form
>         lwi     r11, r11, TI_FLAGS;     /* get flags in thread info */
>         andi    r11, r11, _TIF_SIGPENDING;
>         beqi    r11, 1f;                /* Signals to handle, handle them */
> and replacing that _TIF_SIGPENDING with _TIF_SIGPENDING | _TIF_NOTIFY_RESUME
> will do the right thing; of course, do_signal() itself will need to be
> taught about TIF_NOTIFY_RESUME - same as in case of m68k.  No hardware, no
> emulators set up, but then it's less intrusive in the glue part than m68k
> counterpart.
> 	* xtensa: TIF_NOTIFY_RESUME needs to be defined (bit 7 would do,
> AFAICS) and there the glue does need some change:
>         l32i    a4, a2, TI_FLAGS
> 
>         _bbsi.l a4, TIF_NEED_RESCHED, 3f
>         _bbci.l a4, TIF_SIGPENDING, 4f
> should be replaced with (if I'm not misreading their ISA documentation)
>         l32i    a4, a2, TI_FLAGS
> 
>         _bbsi.l a4, TIF_NEED_RESCHED, 3f
>         _bbsi.l a4, TIF_SIGPENDING, 2f
>         _bbci.l a4, TIF_NOTIFY_RESUME, 4f
> 2:
> (and do_signal() changes, of course).  That's the most intrusive one and
> again, I've neither hw nor emulators for that sucker.
> 
> I'll post the patches for all of those tonight; if everything ends up working,
> at least we can get rid of the ifdefs on TIF_NOTIFY_RESUME.

Untested variants pushed into signal.git#master; will test tomorrow.  In
the meanwhile, any code review (and testing of the entire thing on as many
targets as possible) would be very welcome.

Next target in signal fixes: handling of multiple signal arrivals.  We really
need to handle all of them (i.e. build a stack frame for each, with sigcontext
pointing to the entry into the previous one); otherwise we are risking to get
things like e.g. SIGSEGV on failure to build a sigframe being handled at
random point - we handle one arriving signal, send ourselves SIGSEGV in
process and return to userland (without actually going into the signal
handler stack frame we'd failed to build).  Broken architectures: blackfin,
cris, h8300, hexagon, microblaze and probably ia64...

And then there's a lovely issue of what syscall restarts - both on multiple
arriving signals (we want the restart to apply on the _first_ signal being
processed, TYVM, since the rest of those signals are not interrupting
a syscall - conceptually, they are interrupting the previous signal handlers
at the point of entry) and on {rt_,}sigreturn(2) (where we might get a value
in the register normally used to return sys_whatever() value that would look
like one of restart-related special errors, except that it's simply what that
register used to have when e.g. a timer interrupt had hit while we had a signal
pending; hell to debug, since it looks e.g. like one register in userland
process getting its value randomly replaced with -EINTR if it happened to
contain -ERESTARTSYS when an interrupt had happened).  I'd fixed one like
that on arm a couple of years ago, but AFAICS we still have several on
other architectures ;-/

BTW, another fun issue is FUBAR assembler variant of rt_sigprocmask() on
itanic; it's missing the fixes done to set_current_blocked() in commit
e6fa16ab "signal: sigprocmask() should do retarget_shared_pending()".
I'm _not_ about to transpose those fixes into ia64 assembler, thank you
very much - Itanic maintainers are whole-heartedly welcome to deal with
that one.  The horror in question is fsys_rt_sigprocmask()...
