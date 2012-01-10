Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2AJQRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:17:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55808 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab2AJQRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <1326183371.6638.6.camel@edumazet-laptop>
References: <1326171444.6638.3.camel@edumazet-laptop> <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 08:16:53 -0800
X-Google-Sender-Auth: t7Z8POvedg8994bkpTHDS9J8imk
Message-ID: <CA+55aFwvGQjN42CqjmsUuFGPbPz3kKvasMwd9Sup3mp43KdNjA@mail.gmail.com>
Subject: Re: [BUG] kernel freezes with latest tree
To: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Ingo & co to the cc, so I'm leaving things quoted. ]

On Tue, Jan 10, 2012 at 12:16 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 10 janvier 2012 à 06:03 +0100, Eric Dumazet a écrit :
>> Le mardi 10 janvier 2012 à 05:57 +0100, Eric Dumazet a écrit :
>> > Hi Linus
>> >
>> > I got some freezes on two different machines, using latest kernel.
>> >
>> > while :; do hackbench 10 thread 4000; done
>> >
>> > Not sure I'll have time today to find the problem.
>> >
>> > It might be related to "perf top" also being run at least once.
>> >
>>
>> Hmm, I can trigger the bug without ever using "perf".
>
> OK I managed to bisect it, but I have to run now.

Good. The bisection certainly helps.

> $ git bisect log
[ snipped ]
> Could it be a merge error ?
>
> commit 0db49b72bce26341274b74fd968501489a361ae3
> Merge: 35b740e 1ac9bc6
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jan 6 08:33:28 2012 -0800
>
>    Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

That's one of the merges this window that I sent out a query message
for, because I wasn't happy with it, and stopped at that point waiting
for people to validate the end result.

Nobody complained about it, but the first thing to try would be one of
my questions about that merge: can you move the call to

  set_cpu_sd_state_idle();

(along with the comment above it) in tick_nohz_idle_enter()
(kernel/time/tick-sched.c) to just *below* the "local_irq_disable()"?

I also questioned the interaction between the sparse cleanups and
usecs_to_cputime64(), but people said they were fine.. But your report
will probably make people double-check.

Guys?

                          Linus
