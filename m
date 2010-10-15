Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0JONzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:55:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:41578 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0JONzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:55:09 -0400
Subject: Re: [PATCH] perf_events: fix bogus context time tracking
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
References: <4cb856dc.51edd80a.5ae0.38fb@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 15:54:48 +0200
Message-ID: <1287150888.29097.1516.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 15:26 +0200, Stephane Eranian wrote:
> You can only call update_context_time() when the context
> is active, i.e., the thread it is attached to is still running.
> 
> However, perf_event_read() can be called even when the context
> is inactive, e.g., user read() the counters. The call to
> update_context_time() must be conditioned on the status of
> the context, otherwise, bogus time_enabled, time_running may
> be returned. Here is an example on AMD64. The task program
> is an example from libpfm4. The -p prints deltas every 1s.
> 
> $ task -p -e cpu_clk_unhalted sleep 5
>     2,266,610 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
> 	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
> 	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
> 	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
> 	    0 cpu_clk_unhalted (0.00% scaling, ena=2,158,982, run=2,158,982)
> 5,242,358,071 cpu_clk_unhalted (99.95% scaling, ena=5,000,359,984, run=2,319,270)
> 
> Whereas if you don't read deltas, e.g., no call to perf_event_read() until
> the process terminates:
> 
> $ task -e cpu_clk_unhalted sleep 5
>     2,497,783 cpu_clk_unhalted (0.00% scaling, ena=2,376,899, run=2,376,899)
> 
> Notice that time_enable, time_running are bogus in the first example
> causing bogus scaling.
> 
> This patch fixes the problem, by conditionally calling update_context_time()
> in perf_event_read().
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks, tagged it for -stable as well.
