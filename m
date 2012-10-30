Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab2J3Pxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:53:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab2J3Pxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:53:47 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DP589D6xibcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uakuW5ncBZAA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=cpGsHAT1lXgpjA10TvMA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=LI9Vle30uBYA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=gLTAEdqw5wo_1JzZ:21 a=SkWysUwkmET09t_5:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351612425.8467.105.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] irq_work: Fix racy check on work pending flag
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 30 Oct 2012 11:53:45 -0400
In-Reply-To: <1351611301-3520-2-git-send-email-fweisbec@gmail.com>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	 <1351611301-3520-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 16:35 +0100, Frederic Weisbecker wrote:
> Work claiming semantics require this operation
> to be SMP-safe.
> 
> So we want a strict ordering between the data we
> want the work to handle and the flags that describe
> the work state such that either we claim and we enqueue
> the work that will see our data or we fail the claim
> but the CPU where the work is still pending will
> see the data we prepared when it executes the work:
> 
> CPU 0                   CPU 1
> 
> data = something        claim work
> smp_mb()                smp_mb()
> try claim work          execute work (data)
> 
> The early check for the pending flag in irq_work_claim()
> fails to meet this ordering requirement. As a result,
> when we fail to claim a work, it may have been processed
> by CPU that were previously owning it already, leaving
> our data unprocessed.
> 
> Discussing this with Steven Rostedt, we can use memory
> barriers to fix this or we can rely on cmpxchg() that
> implies full barrier already.
> 
> To fix this, we start by speculating about the value we
> wish to be in the work->flags but we only make any conclusion
> after the value returned by the cmpxchg() call that either
> claims the work or does the ordering such that the CPU
> where the work is pending handles our data.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/irq_work.c |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
> 


