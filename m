Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462Ab2AFSBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 13:01:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350Ab2AFSBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 13:01:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120106173014.GB4348@somewhere>
References: <20120105140846.GA32342@elte.hu> <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
 <20120106173014.GB4348@somewhere>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jan 2012 10:00:54 -0800
X-Google-Sender-Auth: H-TTD9OpdryZs4o80UDoEEkYqb8
Message-ID: <CA+55aFx8s8k_VnPAcn84bCEGqCFaTH3snnmyjf8Yt-1Ffs=+Tg@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler changes for v3.3
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 9:30 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Fri, Jan 06, 2012 at 08:58:55AM -0800, Linus Torvalds wrote:
>>
>> Guys, can you take a look? Also double-check my resolve of the
>> set_cpu_sd_state_idle() call in kernel/time/tick-sched.c, please. I've
>> pushed it out, and it seems to work for me, but...
>
> Yes looks good. We want it to be called from idle loop entry but not
> from idle interrupts. So moving it to tick_nohz_idle_enter() is the
> right thing.

So I was pretty sure about that part, but not about *where* in
tick_nohz_idle_enter() it needed to be.

In particular, is it ok to be in the irq-enabled area at the top? It
looked to me like it was - all it needs is preemption disabled which I
*assume* is always true ("enter idle" doesn't seem to make sense
unless it is), but quite frankly, I don't know the code that well. So
I was going by "this seems to be ok without irqs disabled, and if so,
it's better to do it outside the irq-disabled region".

But I'd like somebody who knows the code. Because especially now that
I look at it again, I realize that the old tick_nohz_stop_sched_tick()
used to have irqs disabled and an interrupt could come in and move us
out of idle, so maybe my original thinking when I did the merge was
just totally bogus.

                       Linus
