Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1JQO6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:58:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52942 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1JQO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <1318847658.6594.40.camel@twins>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
 <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>
 <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>
 <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
 <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
 <1318847658.6594.40.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Oct 2011 07:57:56 -0700
X-Google-Sender-Auth: 7R7-2FH9E9LYww9MbyI7FwFtkYk
Message-ID: <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 3:34 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Well, I thought atomic64_t would be more expensive on 32bit archs, i386
> uses the horridly expensive cmpxchg8b thing to implement it.

Ugh, yes. And some of those paths seem to be hot-paths too.

Perhaps more importantly, there are way more accesses to that
'sum_exec_runtime' than the spinlock-variant of the patch implied.

So now with the atomic64 variant, the readers are protected too, and
that ends up being really expensive. That may be the "right thing" to
do, but I'm not sure if it's really acceptable. Also, I see that some
of the atomic regions (that weren't protected by the spinlock *either*
aren't just simple adds: they are code like

+                       if (atomic64_read(&cputime_expires->sched_exp) == 0 ||
+                           atomic64_read(&cputime_expires->sched_exp)
> exp->sched)
+
atomic64_set(&cputime_expires->sched_exp, exp->sched);

in arm_timer(), which was apparently totally unprotected before, and
which is just inappropriate with atomic accesses.

So seeing this, I'm not confident that atomic64 works at all, after all.

Grrr..

                               Linus
