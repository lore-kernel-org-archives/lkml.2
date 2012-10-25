Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760304Ab2JYUx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:53:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36955 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759852Ab2JYUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <20121025124834.467791319@chello.nl>
References: <20121025121617.617683848@chello.nl> <20121025124834.467791319@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 13:53:05 -0700
X-Google-Sender-Auth: IGviMLCYeB_x80kP9yi2mcuZUm0
Message-ID: <CA+55aFwJdn8Kz9UByuRfGNtf9Hkv-=8xB+WRd47uHZU1YMagZw@mail.gmail.com>
Subject: Re: [PATCH 26/31] sched, numa, mm: Add fault driven placement and
 migration policy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 5:16 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> +       /*
> +        * Using runtime rather than walltime has the dual advantage that
> +        * we (mostly) drive the selection from busy threads and that the
> +        * task needs to have done some actual work before we bother with
> +        * NUMA placement.
> +        */

That explanation makes sense..

> +       now = curr->se.sum_exec_runtime;
> +       period = (u64)curr->numa_scan_period * NSEC_PER_MSEC;
> +
> +       if (now - curr->node_stamp > period) {
> +               curr->node_stamp = now;
> +
> +               if (!time_before(jiffies, curr->mm->numa_next_scan)) {

.. but then the whole "numa_next_scan" thing ends up being about
real-time anyway?

So 'numa_scan_period' in in CPU time (msec, converted to nsec at
runtime rather than when setting it), but 'numa_next_scan' is in
wallclock time (jiffies)?

But *both* of them are based on the same 'numa_scan_period' thing that
the user sets in ms.

So numa_scan_period is interpreted as both wallclock *and* as runtime?

Maybe this works, but it doesn't really make much sense. And what is
the impact of this on machines that run lots of loads with delays
(whether due to IO or timers)?

                     Linus
