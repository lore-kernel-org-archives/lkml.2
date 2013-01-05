Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3AEOOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 09:14:48 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47415 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3AEOOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 09:14:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121222005430.997442088@goodmis.org>
References: <20121222003019.433916240@goodmis.org>
	<20121222005430.997442088@goodmis.org>
Date: Sat, 5 Jan 2013 15:14:44 +0100
Message-ID: <CAFTL4hyQ+ws-r_RVxN-G+-vRjedzNJambBM0F4BHt=yzSOhAOA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] sched: Move idle_balance() to post_schedule
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/22 Steven Rostedt <rostedt@goodmis.org>:
> The idle_balance() code is called to do task load balancing just before
> going to idle. This makes sense as the CPU is about to sleep anyway.
> But currently it's called in the middle of the scheduler and in a place
> that must have interrupts disabled. That means, while the load balancing
> is going on, if a task wakes up on this CPU, it wont get to run while
> the interrupts are disabled. The idle task doing the balancing will be
> clueless about it.
>
> There's no real reason that the idle_balance() needs to be called in the
> middle of schedule anyway. The only benefit is that if a task is pulled
> to this CPU, it can be scheduled without the need to schedule the idle
> task. But load balancing and migrating the task makes a switch to idle
> and back negligible.

This cleanup looks nice as it does not only let us enable interrupts
there but also debloats a bit the schedule() code from idle specific
code. So it would be a pity if the optimization that goes away with
your cleanup has any measurable impact. Is there any sensible
benchmark that can be run against this patch? Something that may
involve a lot of back and forth to idle with some bunch of tasks
running around on other CPUs?
