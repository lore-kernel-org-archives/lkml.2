Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab2COKwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:52:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:43177 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2COKwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:52:41 -0400
Message-ID: <1331808741.18960.163.camel@twins>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 15 Mar 2012 11:52:21 +0100
In-Reply-To: <CAPM31RK6Ft4nPgz0THpjU2Ueq2hTGiGkTsmLdMHK256g1cqozw@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
	 <CAKfTPtAFT-GH2SzE1--XQVaay+bwATcLOqxFpH_z=byo=ix=uw@mail.gmail.com>
	 <1331737268.18960.125.camel@twins>
	 <CAPM31RK6Ft4nPgz0THpjU2Ueq2hTGiGkTsmLdMHK256g1cqozw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 08:47 -0700, Paul Turner wrote:
> On Wed, Mar 14, 2012 at 8:01 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2012-03-13 at 17:57 +0100, Vincent Guittot wrote:
> >> >  struct sched_avg {
> >> >        u64 runnable_avg_sum, runnable_avg_period;
> >> >        u64 last_runnable_update, decay_count;
> >> > +       u32 usage_avg_sum;
> >>
> >> Why usage_avg_sum is 32bits whereas runnable_avg_sum and
> >> runnable_avg_period are 64bits long ? You are doing the same
> >> computation on these 3 variables. Only the computation need to be done
> >> in 64bits but the result could be saved in 32bits ?
> >
> > Since you can never use more than 100% of cpu time, usage_avg_sum is
> > bound to 100% of the period, which (assuming your period < ~4s) should
> > thus still fit in the ~4s u32 provides.
> >
> > Runnable otoh is not bound by that and thus we cannot guarantee the
> > value stays within the ~4s value range.
> 
> Actually for runnable we can also make such a guarantee since:
> 
> runnable_sum <= \Sum 1024 * k^p --> 1024/(1-k) [geometric series, k<1]
> --> ~48k for our choice of k.
> 
> (We do however need 64-bits on any values that accumulate sums of
> loads, e.g. removed_load and *_load_sum.)

Only for the single entry, right? For the aggregated case the runnable
count can be nr_running times your limit, and IIRC (but my brain is
fuzzy since its been a while since I looked at this stuff) you use the
same structure in both cases.
