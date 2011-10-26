Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab1JZOWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:22:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1JZOWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <20111026132500.GA23461@elte.hu>
References: <20111026132500.GA23461@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 16:21:51 +0200
X-Google-Sender-Auth: ELY55deWyw4CddV_s7Hd4pZqKyk
Message-ID: <CA+55aFw84RRBxT0QwDT6dg94OqreS8vwMq7Qog+o0QXqR8vgEA@mail.gmail.com>
Subject: Re: [GIT PULL] core/locking changes for v3.2
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 3:25 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Note, you will get a conflict in kernel/posix-cpu-timers.c, which i
> resolved in -tip the following way:
>
>        raw_spin_lock_irqsave(&cputimer->lock, flags);
>        if (!cputimer->running) {
>                cputimer->running = 1;
>                /*
>                 * The POSIX timer interface allows for absolute time expiry
>                 * values through the TIMER_ABSTIME flag, therefore we have
>                 * to synchronize the timer to the clock every time we start
>                 * it.
>                 */
>                thread_group_cputime(tsk, &sum);
>                update_gt_cputime(&cputimer->cputime, &sum);
>        }
>        *times = cputimer->cputime;
>        raw_spin_unlock_irqrestore(&cputimer->lock, flags);

That seems like a completely bogus resolution. You are re-introducing
the incorrect ABBA nesting of cputimer->lock and rq->lock, and
basically undoing commit bcd5cff7216f.

So I did that resolve differently in a way that I believe is correct.
But please do check the end result out. Peter?

                   Linus
