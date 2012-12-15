Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2LORHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:07:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2LORHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:07:44 -0500
Date: Sat, 15 Dec 2012 17:07:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonas Bonn <jonas.bonn@gmail.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
Message-ID: <20121215170741.GU4939@ZenIV.linux.org.uk>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
 <1354723742-6195-20-git-send-email-james.hogan@imgtec.com>
 <20121205171609.GW4939@ZenIV.linux.org.uk>
 <50C07ECE.9070602@imgtec.com>
 <20121206220955.GZ4939@ZenIV.linux.org.uk>
 <20121208074429.GC4939@ZenIV.linux.org.uk>
 <CACM3HyGHQRkqyqV=X8HKGhh-x3izA9Utr2F_C9nJjPvrxd85+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACM3HyGHQRkqyqV=X8HKGhh-x3izA9Utr2F_C9nJjPvrxd85+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 05:26:30PM +0100, Jonas Bonn wrote:

> That said, let me point again to the series I posted for review a year
> ago that attempts to make the restart logic more generic:
> 
> https://lkml.org/lkml/2011/10/23/80
> 
> The entires patch series, which doesn't necessarily even apply to
> Linux master anymore due to other changes along the way, can be found
> at:
> 
> git://openrisc.net/~jonas/linux  ('signal-arch' branch)
> 
> Commit 4aa1797d978fe2d45ececceee535257e19374df8 is the interesting one there.
> 
> Al, what do you think?

In principle that's a nice cleanup, but...  For one thing, I really do not
believe that we should be returning to userland for handlerless restarts.
At all.  In that respect s390 and arm do it right.  Moreover, the loop calling
do_notify_resume() is better off in C (see e.g. alpha and arm for examples of
that approach).

Another thing is interplay with ptrace ;-/  And ptrace ABI is pretty much
"whatever gdb and its ilk happen to rely upon" - it's not formalized at
all and by now it's too late for existing ports.  Worse, we get to keep it
working as is; old binaries shall not be broken.

Hell knows...  ptrace vs. signals is a thing of horror, indeed - I had a damn
good reason for not including it into this braindump.  Note that there are
several aspects of behaviour that vary between the architectures:
	* get_signal_to_deliver() is a chance for tracer to play with our
state; what instruction pointer value should it see in case of possible
restart?
	* Does the change of instruction pointer done by tracer cancel
restart?  Or is there some other way for tracer to signal the need of
such cancel?
	* Does the change of syscall return value done by tracer affect
(or cancel) the restart?
And that's just for starters - I'm leaving aside the unholy mess around
single-stepping vs. signals.  The question here is not just "what behaviour
would make sense if we designed it from scratch", it's "what behaviour is
demonstrated by this architecture".  gdb is chock-full of arch-dependent
workarounds and yes, we need to keep that working.  Moreover, gdb isn't
the only thing tied to that crap.

	What we need is a decent review of what's in there for all
architectures.  And that'll take cooperation from maintainers -
it's far too easy to miss things on 3rd-party review in that area ;-/
