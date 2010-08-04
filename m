Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab0HDGa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:30:26 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:45279 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab0HDGaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:30:23 -0400
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop> <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu> <1278745706.4390.2.camel@Palantir> <21AA2C13-8831-47A2-9464-28E84DBD72B0@email.unc.edu> <1280823360.1923.419.camel@laptop>
Message-Id: <40739E62-2CB2-45E7-AE68-1825B542E5D4@cs.unc.edu>
From: Bjoern Brandenburg <bbb@cs.unc.edu>
To: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1280823360.1923.419.camel@laptop>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: periods and deadlines in SCHED_DEADLINE
Date: Wed, 4 Aug 2010 02:30:42 -0400
Cc: Bjoern Brandenburg <bbb@email.unc.edu>, Raistlin <raistlin@linux.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Song Yuan <song.yuan@ericsson.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <lucabe72@email.it>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        "bastoni@cs.unc.edu" <bastoni@cs.unc.edu>,
        Giuseppe Lipari <lipari@retis.sssup.it>, rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 3, 2010, at 4:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2010-07-11 at 08:46 +0200, Bjoern Brandenburg wrote:
>> I'd be hesitant to just assume that it "approximates G-EDF"
>> sufficiently well to apply any of the published G-EDF tests.
> 
> OK, suppose that for each cpu we keep the earliest and next-earliest
> deadline in a table. Then on wakeup (job release) we pick the cpu with
> the currently last deadline to preempt (we push the task).
> 
> On sleep (job completion) we look for the earliest among all
> next-earliest deadlines to select the next runnable task (we pull the
> task).
> 
> If we serialize all this using one big lock around this [ {earliest,
> next-earliest} ] table, we've basically implemented G-EDF, agreed?

Yes, agreed. (Assuming that the next-earliest filed is always kept up-to-date by finding the next-earliest when the task is pulled.)

> 
> Now replace that global lock with an algorithm that looks at the table,
> finds the last-earliest or earliest-next-earliest in a lock-less
> fashion, then locks the target cpu's rq->lock, verifies the result and
> either continues or tries again.

Can this lead to tasks bouncing back-and-forth? Under a strict interpretation of G-EDF, each job arrival should cause at most one migration. Can you bound the maximum number of times that the retry-loop is taken per scheduling decision? Can you prove that the lock-less traversal of the table yields a consistent snapshot, or is it possible to accidentally miss a priority inversion due to concurrent job arrivals?

In practice, repeated retries are probably not much of a problem, but not having a firm bound would violate strict validation rules (you can't prove it terminates), and would also violate academic real-time rules (again, you ought to be able to prove it correct). I realize that these rules may not be something that has a high priority for Linux, but on the other hand some properties such as the max number of migrations may be implicitly assumed in schedulability tests.    

I'm not saying that the proposed implementation is not compatible with published analysis, but I'd be cautious to simply assume that it is. Some of the questions that were raised in this thread make it sound like the border between global and partitioned isn't clearly drawn in the implementation yet (e.g., handling of proc affinity masks), so my opinion may change when the code stabilizes. (This isn't meant as a criticism of Dario et al.'s good work; this is just something very hard to get right, and especially so on the first attempt.)  

> So we replace the global lock with cmpxchg like loops using 2 per-cpu
> locks. Our current SCHED_FIFO balancer does just this and is found to be
> a very good approximation of global-fifo (iirc there's one funny case,
> but I can't remember, maybe Steve or Gregory can remember the details).

Going back to Dario's original comments, when combined with proc. affinities/partitioning you'd either have to move budget allocations from CPU to CPU or track a global utilization sum for admission test purposes.

- Björn
  