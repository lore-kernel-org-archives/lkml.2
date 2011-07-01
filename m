Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1GAM2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:28:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab1GAM2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:28:50 -0400
Date: Fri, 1 Jul 2011 14:28:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110701122824.GE28008@elte.hu>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
 <20110626103526.GA11093@elte.hu>
 <20110629040521.GG4186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629040521.GG4186@localhost.localdomain>
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


* Hu Tao <hutao@cn.fujitsu.com> wrote:

> > Yeah, these numbers look pretty good. Note that the percentages 
> > in the third column (the amount of time that particular event was 
> > measured) is pretty low, and it would be nice to eliminate it: 
> > i.e. now that we know the ballpark figures do very precise 
> > measurements that do not over-commit the PMU.
> > 
> > One such measurement would be:
> > 
> > 	-e cycles -e instructions -e branches
> > 
> > This should also bring the stddev percentages down i think, to 
> > below 0.1%.
> > 
> > Another measurement would be to test not just the feature-enabled 
> > but also the feature-disabled cost - so that we document the 
> > rough overhead that users of this new scheduler feature should 
> > expect.
> > 
> > Organizing it into neat before/after numbers and percentages, 
> > comparing it with noise (stddev) [i.e. determining that the 
> > effect we measure is above noise] and putting it all into the 
> > changelog would be the other goal of these measurements.
> 
> Hi Ingo,
> 
> I've tested pipe-test-100k in the following cases: base(no patch), 
> with patch but feature-disabled, with patch and several 
> periods(quota set to be a large value to avoid processes 
> throttled), the result is:
> 
> 
>                                             cycles                   instructions            branches
> -------------------------------------------------------------------------------------------------------------------
> base                                        7,526,317,497           8,666,579,347            1,771,078,445
> +patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%)
> +patch, 10000000000/1000(quota/period)      7,856,873,327 (4.39%)   8,822,227,540 (1.80%)    1,801,766,182 (1.73%)
> +patch, 10000000000/10000(quota/period)     7,797,711,600 (3.61%)   8,754,747,746 (1.02%)    1,788,316,969 (0.97%)
> +patch, 10000000000/100000(quota/period)    7,777,784,384 (3.34%)   8,744,979,688 (0.90%)    1,786,319,566 (0.86%)
> +patch, 10000000000/1000000(quota/period)   7,802,382,802 (3.67%)   8,755,638,235 (1.03%)    1,788,601,070 (0.99%)
> -------------------------------------------------------------------------------------------------------------------

ok, i had a quick look at the stddev numbers as well and most seem 
below the 0.1 range, well below the effects you managed to measure. 
So i think this table is pretty accurate and we can rely on it for 
analysis.

So we've got a +1.1% incrase in overhead with cgroups disabled, while 
the instruction count went down by 1.1%. Is this expected? If you 
profile stalled cycles and use perf diff between base and patched 
kernels, does it show you some new hotspot that causes the overhead?

To better understand the reasons behind that result, could you try to 
see whether the cycles count is stable across reboots as well, or 
does it vary beyond the ~1% value that you measure?

One thing that can help validating the measurements is to do:

  echo 1 > /proc/sys/vm/drop_caches

Before testing. This helps re-establish the whole pagecache layout 
(which gives a lot of the across-boot variability of such 
measurements).

Thanks,

	Ingo
