Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2CNPsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:48:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51059 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2CNPsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <1331737268.18960.125.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
 <CAKfTPtAFT-GH2SzE1--XQVaay+bwATcLOqxFpH_z=byo=ix=uw@mail.gmail.com> <1331737268.18960.125.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 14 Mar 2012 08:47:46 -0700
Message-ID: <CAPM31RK6Ft4nPgz0THpjU2Ueq2hTGiGkTsmLdMHK256g1cqozw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 8:01 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-03-13 at 17:57 +0100, Vincent Guittot wrote:
>> >  struct sched_avg {
>> >        u64 runnable_avg_sum, runnable_avg_period;
>> >        u64 last_runnable_update, decay_count;
>> > +       u32 usage_avg_sum;
>>
>> Why usage_avg_sum is 32bits whereas runnable_avg_sum and
>> runnable_avg_period are 64bits long ? You are doing the same
>> computation on these 3 variables. Only the computation need to be done
>> in 64bits but the result could be saved in 32bits ?
>
> Since you can never use more than 100% of cpu time, usage_avg_sum is
> bound to 100% of the period, which (assuming your period < ~4s) should
> thus still fit in the ~4s u32 provides.
>
> Runnable otoh is not bound by that and thus we cannot guarantee the
> value stays within the ~4s value range.

Actually for runnable we can also make such a guarantee since:

runnable_sum <= \Sum 1024 * k^p --> 1024/(1-k) [geometric series, k<1]
--> ~48k for our choice of k.

(We do however need 64-bits on any values that accumulate sums of
loads, e.g. removed_load and *_load_sum.)
