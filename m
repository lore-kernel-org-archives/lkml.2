Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab2JaAgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:36:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63772 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760115Ab2JaAgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351622024.1504.13.camel@anish-Inspiron-N5050>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	<1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	<1351622024.1504.13.camel@anish-Inspiron-N5050>
Date: Wed, 31 Oct 2012 01:36:37 +0100
Message-ID: <CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: anish kumar <anish198519851985@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 anish kumar <anish198519851985@gmail.com>:
> As I understand without the memory barrier proposed by you the situation
> would be as below:
> CPU 0                                 CPU 1
>
> data = something                     flags = IRQ_WORK_BUSY
> smp_mb() (implicit with cmpxchg      execute_work (sees data from CPU 0)
>            on flags in claim)
> _success_ in claiming and goes
> ahead and execute the work(wrong?)
>                                      cmpxchg cause flag to IRQ_WORK_BUSY
>
> Now knows the flag==IRQ_WORK_BUSY
>
> Am I right?

(Adding Paul in Cc because I'm again confused with memory barriers)

Actually what I had in mind is rather that CPU 0 fails its claim
because it's not seeing the IRQ_WORK_BUSY flag as it should:


CPU 0                                 CPU 1

data = something                  flags = IRQ_WORK_BUSY
cmpxchg() for claim               execute_work (sees data from CPU 0)

CPU 0 should see IRQ_WORK_BUSY but it may not because CPU 1 sets this
value in a non-atomic way.

Also, while browsing Paul's perfbook, I realize my changelog is buggy.
It seems we can't reliably use memory barriers here because we would
be in the following case:

CPU 0                                  CPU 1

store(work data)                    store(flags)
smp_mb()                            smp_mb()
load(flags)                            load(work data)

On top of this barrier pairing, we can't make the assumption that, for
example, if CPU 1 sees the work data stored in CPU 0 then CPU 0 sees
the flags stored in CPU 1.

So now I wonder if cmpxchg() can give us more confidence:


CPU 0                                                CPU 1

store(work data)                                  xchg(flags, IRQ_WORK_BUSY)
cmpxchg(flags, IRQ_WORK_FLAGS)    load(work data)

Can I make this assumption?

- If CPU 0 fails the cmpxchg() (which means CPU 1 has not yet xchg())
then CPU 1 will execute the work and see our data.

At least cmpxchg / xchg pair orders correctly to ensure somebody will
execute our work. Now probably some locking is needed from the work
function itself if it's not per cpu.

>
> Probably a stupid question.Why do we return the bool from irq_work_queue
> when no one bothers to check the return value?Wouldn't it be better if
> this function is void as used by the users of this function or am I
> looking at the wrong code.

No idea. Probably Peter had plans there.
