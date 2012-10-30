Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2J3QZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:25:43 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47730 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab2J3QZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <1351612350.8467.104.camel@gandalf.local.home>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	<1351612350.8467.104.camel@gandalf.local.home>
Date: Tue, 30 Oct 2012 17:25:41 +0100
Message-ID: <CAFTL4hzhTtx_OFeRE+RzsPvMWXr0ncbAjkFhEV-TE_XAFVNbdg@mail.gmail.com>
Subject: Re: [PATCH 0/2] irq_work: A couple fixes
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2012-10-30 at 16:34 +0100, Frederic Weisbecker wrote:
>> Hi,
>
>> And I still wonder if cpu_relax() is enough to prevent the compiler
>> from correctly reloading work->flags in irq_work_sync() loop.
>> Do we need ACCESS_ONCE()?
>
> You mean this loop:
>
>        flags = work->flags & ~IRQ_WORK_PENDING;
>        for (;;) {
>                nflags = flags | IRQ_WORK_FLAGS;
>                oflags = cmpxchg(&work->flags, flags, nflags);
>                if (oflags == flags)
>                        break;
>                if (oflags & IRQ_WORK_PENDING)
>                        return false;
>                flags = oflags;
>                cpu_relax();
>        }
>
> After the first loading of work->flags, you are worried about the
> &work->flags in the cmpxchg()?  The cmpxchg() will handle that itself. I
> don't see any place that a ACCESS_ONCE() is required here. The cmpxchg()
> acts on the address of work->flags, the compiler isn't involved with the
> value at that address.

No I was worried about the cpu_relax() in irq_work_sync()
