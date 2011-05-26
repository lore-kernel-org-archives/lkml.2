Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab1E0BHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:07:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41238
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156Ab1E0BHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:07:36 -0400
X-Greylist: delayed 9730 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 21:07:36 EDT
Subject: Re: [PATCH] cpumask: convert cpumask_of_cpu() with cpumask_of()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110427193419.D17F.A69D9226@jp.fujitsu.com>
References: <1303814572.20212.249.camel@twins>
	 <20110426203520.F3AE.A69D9226@jp.fujitsu.com>
	 <20110427193419.D17F.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 22:38:47 +0200
Message-ID: <1306442327.2497.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 19:32 +0900, KOSAKI Motohiro wrote:
> 
> I've made concept proof patch today. The result is better than I expected.
> 
> <before>
>  Performance counter stats for 'hackbench 10 thread 1000' (10 runs):
> 
>          1603777813  cache-references         #     56.987 M/sec   ( +-   1.824% )  (scaled from 25.36%)
>            13780381  cache-misses             #      0.490 M/sec   ( +-   1.360% )  (scaled from 25.55%)
>         24872032348  L1-dcache-loads          #    883.770 M/sec   ( +-   0.666% )  (scaled from 25.51%)
>           640394580  L1-dcache-load-misses    #     22.755 M/sec   ( +-   0.796% )  (scaled from 25.47%)
> 
>        14.162411769  seconds time elapsed   ( +-   0.675% )
> 
> <after>
>  Performance counter stats for 'hackbench 10 thread 1000' (10 runs):
> 
>          1416147603  cache-references         #     51.566 M/sec   ( +-   4.407% )  (scaled from 25.40%)
>            10920284  cache-misses             #      0.398 M/sec   ( +-   5.454% )  (scaled from 25.56%)
>         24666962632  L1-dcache-loads          #    898.196 M/sec   ( +-   1.747% )  (scaled from 25.54%)
>           598640329  L1-dcache-load-misses    #     21.798 M/sec   ( +-   2.504% )  (scaled from 25.50%)
> 
>        13.812193312  seconds time elapsed   ( +-   1.696% )
> 
>  * datail data is in result.txt
> 
> 
> The trick is,
>  - Typical linux userland applications don't use mempolicy and/or cpusets
>    API at all.
>  - Then, 99.99% thread's  tsk->cpus_alloed have cpu_all_mask.
>  - cpu_all_mask case, every thread can share the same bitmap. It may help to
>    reduce L1 cache miss in scheduler.
> 
> What do you think? 

Nice!

If you finish the first patch (sort the TODOs) I'll take it.

I'm unsure about the PF_THREAD_UNBOUND thing though, then again, the
alternative is adding another struct cpumask * and have that point to
the shared mask or the private mask.

But yeah, looks quite feasible.

