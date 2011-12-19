Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab1LSLZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:25:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41271 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab1LSLZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:25:27 -0500
Date: Mon, 19 Dec 2011 12:23:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
Message-ID: <20111219112326.GA15090@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> wrote:

>     The following patches implements gang scheduling. These 
>     patches are *highly* experimental in nature and are not 
>     proposed for inclusion at this time.
> 
>     Gang scheduling is an approach where we make an effort to 
>     run related tasks (the gang) at the same time on a number 
>     of CPUs.

The thing is, the (non-)scalability consequences are awful, gang 
scheduling is a true scalability nightmare. Things like this in 
gang_sched():

+               for_each_domain(cpu_of(rq), sd) {
+      	                count = 0;
+                       for_each_cpu(i, sched_domain_span(sd))
+                               count++;

makes me shudder.

So could we please approach this from the benchmarked workload 
angle first? The highest improvement is in ebizzy:

>     ebizzy 2vm (improved 15 times, i.e. 1520%)
>     +------------+--------------------+--------------------+----------+
>     |                               Ebizzy                            |
>     +------------+--------------------+--------------------+----------+
>     | Parameter  |        Basline     |         gang:V2    | % imprv  |
>     +------------+--------------------+--------------------+----------+
>     | EbzyRecords|            1709.50 |           27701.00 |     1520 |
>     |    EbzyUser|              20.48 |             376.64 |     1739 |
>     |     EbzySys|            1384.65 |            1071.40 |       22 |
>     |    EbzyReal|             300.00 |             300.00 |        0 |
>     |     BwUsage|   2456114173416.00 |   2483447784640.00 |        1 |
>     |    HostIdle|              34.00 |              35.00 |       -2 |
>     |     UsrTime|               6.00 |              14.00 |      133 |
>     |     SysTime|              30.00 |              24.00 |       20 |
>     |      IOWait|              10.00 |               9.00 |       10 |
>     |    IdleTime|              51.00 |              51.00 |        0 |
>     |         TPS|              25.00 |              24.00 |       -4 |
>     | CacheMisses|       766543805.00 |      8113721819.00 |     -958 |
>     |   CacheRefs|      9420204706.00 |    136290854100.00 |     1346 |
>     |BranchMisses|      1191336154.00 |     11336436452.00 |     -851 |
>     |    Branches|    618882621656.00 |    459161727370.00 |      -25 |
>     |Instructions|   2517045997661.00 |   2325227247092.00 |        7 |
>     |      Cycles|   7642374654922.00 |   7657626973214.00 |        0 |
>     |     PageFlt|           23779.00 |           22195.00 |        6 |
>     |   ContextSW|         1517241.00 |         1786319.00 |      -17 |
>     |   CPUMigrat|             537.00 |             241.00 |       55 |
>     +-----------------------------------------------------------------+

What's behind this huge speedup? Does ebizzy use user-space 
spinlocks perhaps? Could we do something on the user-space side 
to get a similar speedup?

Thanks,

	Ingo
