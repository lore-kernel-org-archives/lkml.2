Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0IWWLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:11:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54114 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0IWWLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:11:42 -0400
Date: Thu, 23 Sep 2010 23:11:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: situation with signals
Message-ID: <20100923221141.GK19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	There are several interesting issues in arch/*/*/*signal* (besides
shoggoths starting to show up when one reads that code) and I'd been crawling
through that area for the last few weeks.  Here are more or less common
issues; there are really arch-specific bugs (e.g. roothole on frv that
used to allow reading kernel memory by setting the right sa_handler), but
that's a separate story.

	1) a bunch of architectures happily block signals even when
setting sigframe up fails.  Obviously bad, since we lose the information
about original mask forever.  Some fixes are in mainline, some are
pending (mips one sent to Ralf, the rest is still in my local queue).

	2) avr32 and microblaze have retained the old bug fixed by sfr in
"[PATCH] convert signal handling of NODEFER to act like other Unix boxes"
back in 2005.  Fixes in local queue, will send shortly.

	3) sigreturn and its ilk should reset ->restart_block.fn to
do_no_restart_syscall(); alpha and parisc had been doing that in the
wrong place (missed race fixes ~5 years ago), frv, microblaze, mn10300,
score and xtensa don't do that at all.  alpha and frv fixes are in mainline,
the rest - in local queue.

	4) SIGSEGV on failure to create a sigframe should be delivered by
force_sigsegv(), not force_sig().  The difference between these two is that
the latter will lead to infinite spin if we have a handler for SIGSEGV.
force_sigsegv() will revert to default handler if the signal we'd failed
to deliver had been SIGSEGV itself.  Vulnerable: frv and mn10300; frv fix
in mainlined, mn10300 in local queue.

	5) minor QOI issue - if we are sending SIGSEGV after failure to set
sigframe up, it's better to avoid mangling registers, so that if we do
handler SIGSEGV (e.g. on altstack) we would have a sane userland state to
return to.  Minor, probably not worth bothering until the merge window;
most of the architectures are very easy to tweak so that the problem would
disappear.

	6) sigsuspend()/rt_sigsuspend() really ought to switch to use
of ->saved_sigmask; it's easy to do and fairly few architectures are
still not using that.  I'll probably leave that until the merge window;
it's not breakage per se.  Exception: m32r fix I'll send today; the damn
thing has switched to sigsuspend()/rt_sigsuspend() using ERESTARTNOHAND
(and setting ->saved_sigmask), but do_signal() doesn't even look at the
->saved_sigmask.  With obvious results.  Breakage has been there for
three years...

	7) sigreturn() should make sure we won't step into signal restart.
arm, frv and ppc fixed (fixes merged).  avr32, cris and score are b0rken the
same way arm is, fixes in local queue.  microblaze seems to be fscked the
same way, unless I'm missing something subtle in their sigreturn wrapper.

	8) no double syscall restarts if we get multiple signals, even if
we handle some or all of them in the kernel.  alpha, ppc, frv and sparc fixes
are in mainline, arm one sits in arm tree.  More is in the local queue and
I'm afraid that there's more to follow.

	9) there's a difference between architectures in the way we handle
multiple signals pending at the same time.  Some deal with all signals that
are there; some usually handle one, but may do more if the stars are right;
some handle only one and that's it.
	The last variant actually used to be common until 5-8 years ago.
There are several problems with it, starting with the obvious "WTF is that
SIGSEGV generated when I failed to set a sigframe up gets delivered only
on the next IRQ or syscall?".  I've looked through the history and apparently
there had been several independent reinventions of the fix (== handle all
pending signals, build all sigframes and let it go).
	I must apologize to davem - sparc is not the only remaining one with
that behaviour; several m68nommu derivatives are also that way.  IMO the right
thing to do is to switch all of them to "call do_signal until there's no
pending signal left" kind of behaviour; sparc patch doing that is pending
review, and I can do the rest (embedded ones) without too much PITA.
	There's one case where the problem has been papered over by kludges
inside do_signal() - itanic.  It's easier to do repeats in asm glue, actually,
(replace p6 = 0 with p6 = 1 in one place) and that'll kill a bunch of stuff
in the ia64/signal.c; similar junk is in place for parisc, with no
justification whatsoever - there we _do_ repeats in entry.S.
