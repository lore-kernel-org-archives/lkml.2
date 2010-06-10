Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab0FJKRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 06:17:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0FJKRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 06:17:01 -0400
Date: Thu, 10 Jun 2010 12:16:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] perf events finer grained context instrumentation /
 context exclusion
Message-ID: <20100610101637.GA10406@elte.hu>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
 <20100610062618.GA20062@elte.hu>
 <20100610073140.GE12752@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610073140.GE12752@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

>  Performance counter stats for './hackbench 5' (10 runs):
> 
>          1313640764  instructions             #      0,241 IPC     ( +-   1,393% )  (scaled from 100,05%)
>           214737441  branches                   ( +-   0,948% )
> 
>          1293802776  instructions             #      0,245 IPC     ( +-   0,343% )
>           209495435  branches                   ( +-   0,392% )

Indeed it's about 4 times less noise, not bad.

Cycles is fundamentally random.

> So yeah, the results look a bit better. Still not perfects:
> 
> - we are still instrumenting the tiny parts between the true interrupt
>   and irq_enter() (same for irq_exit() and the end). Same for softirqs.
> 
> - random randomnesses...

Random randomness shouldnt occur for something like instructions or branches.

Could you try some 'must not be variable' workload, like:

    taskset 1 ./hackbench 1

If the workload is pinned to a single CPU then it ought to not be variable at 
all. (modulo things like hash chain lengths and slab caching details, but 
those should not cause 0.4% kind of noise IMO)

Btw., we could try to record all branches of an execution (using BTS, of a 
relatively short but static-length run), and see where the variance comes 
from. I doubt the current BTS code is ready for that, but it would be 'the' 
magic trace-from-hell that includes all execution of the task, recorded at the 
hardware level.

	Ingo
