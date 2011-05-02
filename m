Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1EBGOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 02:14:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab1EBGOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 02:14:20 -0400
Date: Mon, 2 May 2011 08:14:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikhil Rao <ncrao@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
Message-ID: <20110502061411.GA16682@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikhil Rao <ncrao@google.com> wrote:

> 1. Performance costs
> 
> Ran 50 iterations of Ingo's pipe-test-100k program (100k pipe ping-pongs). 
> See http://thread.gmane.org/gmane.linux.kernel/1129232/focus=1129389 for more 
> info.
> 
> 64-bit build.
> 
>   2.6.39-rc5 (baseline):
> 
>     Performance counter stats for './pipe-test-100k' (50 runs):
> 
>        905,034,914 instructions             #      0.345 IPC     ( +-   0.016% )
>      2,623,924,516 cycles                     ( +-   0.759% )
> 
>         1.518543478  seconds time elapsed   ( +-   0.513% )
> 
>   2.6.39-rc5 + patchset:
> 
>     Performance counter stats for './pipe-test-100k' (50 runs):
> 
>        905,351,545 instructions             #      0.343 IPC     ( +-   0.018% )
>      2,638,939,777 cycles                     ( +-   0.761% )
> 
>         1.509101452  seconds time elapsed   ( +-   0.537% )
> 
> There is a marginal increase in instruction retired, about 0.034%; and marginal
> increase in cycles counted, about 0.57%.

Not sure this increase is statistically significant: both effects are within 
noise and look at elapsed time, it actually went down.

Btw., to best measure context-switching costs you should do something like:

  taskset 1 perf stat --repeat 50 ./pipe-test-100k

to pin both tasks to the same CPU. This reduces noise and makes the numbers 
more relevant: SMP costs do not increase due to your patchset.

So it would be nice to re-run the 64-bit tests with the pipe test bound to a 
single CPU.

> 32-bit build.
> 
>   2.6.39-rc5 (baseline):
> 
>     Performance counter stats for './pipe-test-100k' (50 runs):
> 
>      1,025,151,722 instructions             #      0.238 IPC     ( +-   0.018% )
>      4,303,226,625 cycles                     ( +-   0.524% )
> 
>         2.133056844  seconds time elapsed   ( +-   0.619% )
> 
>   2.6.39-rc5 + patchset:
> 
>     Performance counter stats for './pipe-test-100k' (50 runs):
> 
>      1,070,610,068 instructions             #      0.239 IPC     ( +-   1.369% )
>      4,478,912,974 cycles                     ( +-   1.011% )
> 
>         2.293382242  seconds time elapsed   ( +-   0.144% )
> 
> On 32-bit kernels, instructions retired increases by about 4.4% with this
> patchset. CPU cycles also increases by about 4%.
>
> There is a marginal increase in instruction retired, about 0.034%; and 
> marginal increase in cycles counted, about 0.57%.

These results look more bothersome, a clear increase in both cycles, elapsed 
time, and instructions retired, well beyond measurement noise.

Given that scheduling costs are roughly 30% of that pipe test-case, the cost 
increase to the scheduler is probably around:

	instructions:	+14.5%
	cycles: 	+13.3%

That is rather significant.

Thanks,

	Ingo
