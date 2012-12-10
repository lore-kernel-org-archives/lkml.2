Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab2LJUKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:10:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63485 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LJUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:10:53 -0500
Date: Mon, 10 Dec 2012 21:10:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [GIT TREE] Unified NUMA balancing tree, v3
Message-ID: <20121210201042.GA15271@gmail.com>
References: <1354839566-15697-1-git-send-email-mingo@kernel.org>
 <alpine.LFD.2.02.1212101902050.4422@ionos>
 <50C62CE7.2000306@redhat.com>
 <20121210191545.GA14412@gmail.com>
 <20121210192828.GL1009@suse.de>
 <20121210200755.GA15097@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210200755.GA15097@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > On Mon, Dec 10, 2012 at 08:15:45PM +0100, Ingo Molnar wrote:
> > > 
> > > * Rik van Riel <riel@redhat.com> wrote:
> > > 
> > > > On 12/10/2012 01:22 PM, Thomas Gleixner wrote:
> > > > 
> > > > > So autonuma and numacore are basically on the same page, 
> > > > > with a slight advantage for numacore in the THP enabled 
> > > > > case. balancenuma is closer to mainline than to 
> > > > > autonuma/numacore.
> > > > 
> > > > Indeed, when the system is fully loaded, numacore does very 
> > > > well.
> > > 
> > > Note that the latest (-v3) code also does well in under-loaded 
> > > situations:
> > > 
> > >    http://lkml.org/lkml/2012/12/7/331
> > > 
> > > Here's the 'perf bench numa' comparison to 'balancenuma':
> > > 
> > >                             balancenuma  | NUMA-tip
> > >  [test unit]            :          -v10  |    -v3
> > > ------------------------------------------------------------
> > >  2x1-bw-process         :         6.136  |  9.647:  57.2%
> > >  3x1-bw-process         :         7.250  | 14.528: 100.4%
> > >  4x1-bw-process         :         6.867  | 18.903: 175.3%
> > >  8x1-bw-process         :         7.974  | 26.829: 236.5%
> > >  8x1-bw-process-NOTHP   :         5.937  | 22.237: 274.5%
> > >  16x1-bw-process        :         5.592  | 29.294: 423.9%
> > >  4x1-bw-thread          :        13.598  | 19.290:  41.9%
> > >  8x1-bw-thread          :        16.356  | 26.391:  61.4%
> > >  16x1-bw-thread         :        24.608  | 29.557:  20.1%
> > >  32x1-bw-thread         :        25.477  | 30.232:  18.7%
> > >  2x3-bw-thread          :         8.785  | 15.327:  74.5%
> > >  4x4-bw-thread          :         6.366  | 27.957: 339.2%
> > >  4x6-bw-thread          :         6.287  | 27.877: 343.4%
> > >  4x8-bw-thread          :         5.860  | 28.439: 385.3%
> > >  4x8-bw-thread-NOTHP    :         6.167  | 25.067: 306.5%
> > >  3x3-bw-thread          :         8.235  | 21.560: 161.8%
> > >  5x5-bw-thread          :         5.762  | 26.081: 352.6%
> > >  2x16-bw-thread         :         5.920  | 23.269: 293.1%
> > >  1x32-bw-thread         :         5.828  | 18.985: 225.8%
> > >  numa02-bw              :        29.054  | 31.431:   8.2%
> > >  numa02-bw-NOTHP        :        27.064  | 29.104:   7.5%
> > >  numa01-bw-thread	:        20.338  | 28.607:  40.7%
> > >  numa01-bw-thread-NOTHP :        18.528  | 21.119:  14.0%
> > > ------------------------------------------------------------
> > > 
> > > More than half of these testcases are under-loaded situations.
> > > 
> > > > The main issues that have been observed with numacore are when 
> > > > the system is only partially loaded. Something strange seems 
> > > > to be going on that causes performance regressions in that 
> > > > situation.
> > > 
> > > I haven't seen such reports with -v3 yet, which is what Thomas 
> > > tested. Mel has not tested -v3 yet AFAICS.
> > > 
> > 
> > Yes, I have. The drop I took and the results I posted to you 
> > were based on a tip/master pull from December 9th. v3 was 
> > released on December 7th and your release said to test based 
> > on tip/master. The results are here 
> > https://lkml.org/lkml/2012/12/9/108 . Look at the columns 
> > marked numafix-20121209 which is tip/master with a bodge on 
> > top to remove the "if (p->nr_cpus_allowed != 
> > num_online_cpus())" check.
> 
> Ah, indeed - I saw those results but the 'numafix' tag threw me 
> off.
> 
> Looks like at least in terms of AutoNUMA-benchmark numbers you 
> measured the best-ever results with the -v3 tree? That aspect 
> is obviously good news.

... at least for the numa01 row. numa02 and numa01-THREAD_ALLOC 
isn't as good yet in your tests.

Thanks,

	Ingo
