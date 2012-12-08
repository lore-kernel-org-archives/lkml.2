Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462Ab2LHSPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 13:15:01 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56480 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab2LHSO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 13:14:59 -0500
Date: Sat, 8 Dec 2012 18:14:58 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
Message-ID: <20121208181458.GD4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
 <20121205171609.GW4939@ZenIV.linux.org.uk>
 <50C07ECE.9070602@imgtec.com>
 <20121206220955.GZ4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206220955.GZ4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 10:09:55PM +0000, Al Viro wrote:

> 	What we need to guarantee is
> * restarts do not happen on signals caught in interrupts or exceptions
> * restarts do not happen on signals caught in sigreturn()
> * restart should happen only once, even if we get through do_signal() many
> times.

BTW, signal caught in sigreturn is *not* something requiring a narrow
race.  It's perfectly normal to have some signals blocked for the
duration of signal handler - the signal itself is blocked by default
unless you have set SA_NODEFER in sa_flags and there's sa_mask allowing
to block an arbitrary set of signals.  Upon return from signal handler
we undo that and if any of the temporary blocked signals has arrived
while we'd been in the handler (e.g. had been raised by the handler itself),
it will be caught as soon as we unblock it, i.e. in sigreturn.

Unfortunately, the testcases are somewhat architecture-dependent.  See, for
example, arm one in commit 653d48b22166db2d8b1515ebe6f9f0f7c95dfc86; there
might be a way to arrange for asm-free equivalent if one played with -O0,
but it's probably not worth the trouble.  That one deals with sigreturn
from signal caught in interrupt; sigreturn from signal caught in syscall
is a bit trickier.  TBH, I don't understand your syscall calling conventions
well enough to cook one up; your restart logics looks really strange.
You leave ->DX[0].U0 modified - fair enough, it doesn't seem to be used
by syscall entry path - *and* you revert ->DX[0].U1 to the state you
used to have on entry.  The thing is, I don't see any place that would
have changed it in between; why do you need that
	regs->REG_SYSCALL = orig_syscall;
in there at all?

BTW, could you (and other folks submitting ports) document the ABI?
See e.g. Documentation/frv/kernel-ABI.txt for fairly decent example...
