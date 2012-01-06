Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2AFQ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:59:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34353 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab2AFQ7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:59:17 -0500
MIME-Version: 1.0
In-Reply-To: <20120105140846.GA32342@elte.hu>
References: <20120105140846.GA32342@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 08:58:55 -0800
X-Google-Sender-Auth: UkEgnKH_Xba3Z7g8zdPEKD6jmtE
Message-ID: <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler changes for v3.3
To: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest sched-core-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

Ugh. So I got conflicts on this one.  Big deal, fix them up.

But as I was fixing them up, I hit two problems that I wanted people
to take a look at:

 - some of the code was utter crap. Look at my fixup for
include/asm-generic/cputime.h, for example. Notice how I had to change
__msecs to __usec, and notice the bogus semicolons that I removed?

   This came in through commit 648616343cdb ("[S390] cputime: add
sparse checking and cleanup") which is also mis-named: it's not
S390-specific. Martin, please take a look.

 - I did not do the right thing for the "usecs_to_cputime64()" fixup.
Please take a look at commit 34845636a184 ("procfs: do not confuse
jiffies with cputime64_t") which introduced that "usecs_to_cputime64()
thing, and which clashes badly with the sparse cleanups.

And by "clashes badly", I mean it. The sparse cleanups added a lot of
casts between the types, which means that the mindless

    +#define usecs_to_cputime64(us)         usecs_to_cputime(us)

introduced by that commit 34845636a184 is now likely *wrong*, because
"usecs_to_cputime()" now explicitly casts to a non-64-bit cputime_t.

It may have been wrong before too, but at least on 64-bit
architectures it didn't really matter. Now the sparse fixes have made
"cputime64_t" a separate type that will complain about casting, so it
not only casts the type to a (potentially different and wrong size),
but it also breaks the sparse checks.

I tried to fix up the ones that caused actual conflicts (due to
changes nearby, like the ones in asm-generic), but the ones that
didn't actually cause conflicts (powerpc and s390) I left alone.

Guys, can you take a look? Also double-check my resolve of the
set_cpu_sd_state_idle() call in kernel/time/tick-sched.c, please. I've
pushed it out, and it seems to work for me, but...

                                 Linus
