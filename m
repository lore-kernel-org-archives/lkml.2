Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2BQLxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:53:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47805 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2BQLxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:53:49 -0500
MIME-Version: 1.0
In-Reply-To: <1329395138.2293.206.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013826.20844.16743.stgit@kitami.mtv.corp.google.com> <1329395138.2293.206.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 03:53:18 -0800
Message-ID: <CAPM31RL6OffvQ5ZfWXo8SPaiY0LsNX=2bHsMkEngVH1_hfdXyg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/14] sched: maintain the load contribution of
 blocked entities
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
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

On Thu, Feb 16, 2012 at 4:25 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>> +static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
>> +                                                long load_contrib)
>> +{
>> +       if (likely(load_contrib < cfs_rq->blocked_load_avg))
>> +               cfs_rq->blocked_load_avg -= load_contrib;
>> +       else
>> +               cfs_rq->blocked_load_avg = 0;
>> +}
>> +
>>  /* Update a sched_entity's runnable average */
>> -static inline void update_entity_load_avg(struct sched_entity *se)
>> +static inline void update_entity_load_avg(struct sched_entity *se,
>> +                                         int update_cfs_rq)
>>  {
>>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
>>         long contrib_delta;
>> @@ -1106,8 +1130,34 @@ static inline void update_entity_load_avg(struct sched_entity *se)
>>                 return;
>>
>>         contrib_delta = __update_entity_load_avg_contrib(se);
>> +
>> +       if (!update_cfs_rq)
>> +               return;
>> +
>>         if (se->on_rq)
>>                 cfs_rq->runnable_load_avg += contrib_delta;
>> +       else
>> +               subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
>> +}
>
> So that last bit is add_blocked_load_contrib(), right?

Yes, although contrib_delta is signed.

I suppose this looks a little funny but there's a good explanation:
When adding or removing a contribution to blocked_load_sum we have to
be careful since rounding errors may mean the delta to our
contribution and the delta to our portion of the blocked_load_sum may
be off by a few bits.  Being low is fine since it's constantly
decaying to zero so any error term is not long for this world -- but
we do want to make sure we don't underflow in the other direction.

This means any time we remove we have to do the whole
	"if (likely(load_contrib < cfs_rq->blocked_load_avg))
		cfs_rq->blocked_load_avg -= load_contrib;
	else
		cfs_rq->blocked_load_avg = 0"
thing.

Typically we only care about doing this on removing load (e.g. local
wake-up); since we have no error going in the opposite direction; so
we end up with subtract_blocked_load_contrib to handle the first case.

Coming back to the use of it here:
Since contrib_delta is on a freshly computed load_contribution we have
to take the same care as when we are removing; but luckily we already
have subtract_blocked_load_contrib from dealing with that everywhere
else.  So we just re-use it and flip the sign.

We could call it add everywhere else (and again flip the sign) but
that's less intuitive since we really are only looking to (safely) remove in
those cases.
