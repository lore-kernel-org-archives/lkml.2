Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1LUMDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:03:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38200 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1LUMDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:03:36 -0500
MIME-Version: 1.0
In-Reply-To: <1323804803.9082.40.camel@twins>
References: <1323804803.9082.40.camel@twins>
Date: Wed, 21 Dec 2011 13:03:35 +0100
Message-ID: <CAOY=C6HZ23iitPSP1LroxArWFyhYHMb1VNy4k2SND9C2gt-AGg@mail.gmail.com>
Subject: Re: printk() vs tty_io
From: Stijn Devriendt <highguy@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 8:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi tty folks,
>
> I've been poking at reducing the constraints on printk(), like make it
> work under rq->lock etc..
>
> Aside from a fwd port of the patch that abuses the console_sem.lock:
> https://lkml.org/lkml/2011/6/9/298 and a few other not so very pretty
> patches, I ran into the following lockdep splat (using a not so very
> pretty lockdep early_printk() patch):
>
> watchdog/0/10 is trying to acquire lock:
>  ((console_sem).lock){-.-...}, at:
> but task is already holding lock:
>  (&rt_rq->rt_runtime_lock){-.-...}, at:
> which lock already depends on the new lock.
>
> the existing dependency chain (in reverse order) is:
>
> -> #5 (&rt_rq->rt_runtime_lock){-.-...}:
> -> #4 (&rq->lock){-.-.-.}:
> -> #3 (&p->pi_lock){-.-.-.}:
> -> #2 (&tty->write_wait){-.-...}:
> -> #1 (&port_lock_key){-.-...}:
> -> #0 ((console_sem).lock){-.-...}:
>
> It turns out that writing to a console does wakeups due to tty_io.c.
>
> My question is basically, is there a feasible way around doing these
> wakeups from the console::write() path? Everything I thought of was
> really quite horrible... and very likely would break stuff since I'm not
> that well versed in the whole tty thing.
>

Would it be possible to solve the problem by allowing wake-ups from
inside the rq->lock? After all your hard work moving most of the wakeup
work out of the ttwu() code and the ttwu-queuing for cross-cpu wakeups
I believe that allowing wakeups from inside the rq->lock could be doable.

Regards,
Stijn
