Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2J2TS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:18:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36217 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2J2TSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <1351518466.8467.65.camel@gandalf.local.home>
References: <1351517296-9173-1-git-send-email-fweisbec@gmail.com>
	<1351517296-9173-2-git-send-email-fweisbec@gmail.com>
	<1351518466.8467.65.camel@gandalf.local.home>
Date: Mon, 29 Oct 2012 20:18:22 +0100
Message-ID: <CAFTL4hxzGV4QFOLnTHYMhvKVsF_CrG7pOyi9hdgPBYLKdMB5zA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/9] irq_work: Fix racy check on work pending flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/29 Steven Rostedt <rostedt@goodmis.org>:
> I wonder if the bug is just a memory barrier missing here? But that also
> suggests that the other CPU used a memory barrier too (or cmpxchg()
> which implies one).
>
> But this change looks fine too.

I fear a memory barrier wouldn't be much helpful here.

Thing is I'm not sure exactly what strict semantics is expected there:
do we allow for concurrent claiming only locally or also across CPUs?
Given that we only disable preemption on work queueing, I assumed we
allow for concurrent claiming across CPUs. Also we have irq work users
that may claim on random CPUs already and thus this can result in
cross-CPUs concurrent claiming. Task wide (not per cpu) perf event are
such examples. May be drivers/acpi/apei/ghes.c and perhaps others.

Also if we allow for cross-CPUs concurrent claiming, we should set
IRQ_WORK_BUSY with cmpxchg() (or xchg() if it's atomic, because nobody
can modify it concurrently at this stage as it's claimed). Otherwise a
CPU can fail its claim whereas the other CPU that claimed it may
actually have executed the work already, or is in the middle of doing
so. The race window stops when we clear the IRQ_WORK_BUSY flag with
cmpxchg so it's very tight. But still it's there.

Also irq_work_sync() should poll with ACCESS_ONCE(). Same problem with
foggy semantics here: do we allow remote sync?
