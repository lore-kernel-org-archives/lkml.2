Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab2AGSn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:43:57 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48780 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2AGSn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:43:56 -0500
Date: Sat, 7 Jan 2012 19:43:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andreas Schwab <schwab@linux-m68k.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.3
Message-ID: <20120107194348.77b42573@de.ibm.com>
In-Reply-To: <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
References: <20120105140846.GA32342@elte.hu>
	<CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12010718-0542-0000-0000-00000097E41E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jan 2012 08:58:55 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 5, 2012 at 6:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest sched-core-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus
> 
> Ugh. So I got conflicts on this one.  Big deal, fix them up.
> 
> But as I was fixing them up, I hit two problems that I wanted people
> to take a look at:
> 
>  - some of the code was utter crap. Look at my fixup for
> include/asm-generic/cputime.h, for example. Notice how I had to change
> __msecs to __usec, and notice the bogus semicolons that I removed?

Yes, the semicolons had been crap and the parameter name suboptimal.

>    This came in through commit 648616343cdb ("[S390] cputime: add
> sparse checking and cleanup") which is also mis-named: it's not
> S390-specific. Martin, please take a look.

Yeah, I had that patch in the s390 tree before it got moved to a tip tree.
I tend to tag everything in my tree with [S390].
 
>  - I did not do the right thing for the "usecs_to_cputime64()" fixup.
> Please take a look at commit 34845636a184 ("procfs: do not confuse
> jiffies with cputime64_t") which introduced that "usecs_to_cputime64()
> thing, and which clashes badly with the sparse cleanups.

There had been some fallout from the two changes.
 
> And by "clashes badly", I mean it. The sparse cleanups added a lot of
> casts between the types, which means that the mindless
> 
>     +#define usecs_to_cputime64(us)         usecs_to_cputime(us)
> 
> introduced by that commit 34845636a184 is now likely *wrong*, because
> "usecs_to_cputime()" now explicitly casts to a non-64-bit cputime_t.

Surprisingly sparse does not give a warning if the base type of two
__nowarn types is the same. All three VIRT_CPU_ACCOUNTING architectures
use u64 or unsigned long long for cputime_t and cputime64_t. It does
work but I agree that an explicit cast to cputime64_t would be better.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

