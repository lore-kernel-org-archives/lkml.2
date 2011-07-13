Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1GMVPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:15:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1GMVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:15:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=rvfeYEbSwD2qTI/SdpbQux0dhJK5uuKCw8J30r0Z4ySZx81+luM6MmNkeAkudhA0U
	5gWELQupvuMaT23ze7vpw==
MIME-Version: 1.0
In-Reply-To: <1310590968.2586.38.camel@twins>
References: <1310557009.2586.28.camel@twins> <CAPM31R+cS+eRaFHa2ygxF3ADYyo5Tf9R+snky3U8b5_am6Wtjg@mail.gmail.com>
 <1310590968.2586.38.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 13 Jul 2011 14:14:35 -0700
Message-ID: <CAPM31R+SCCA-MwPauZn5Va2vJYNs=FdqX+MZqQ0EpwDeyom_RA@mail.gmail.com>
Subject: Re: [RFT][PATCH] sched, cgroup: Optimize load_balance_fair()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikhil Rao <ncrao@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 2:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-07-13 at 10:13 -0700, Paul Turner wrote:
>> Nice! The continued usage of task_groups had been irking me for a
>> while but I haven't had the time to scratch the itch :).
>>
>> On Wed, Jul 13, 2011 at 4:36 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Subject: sched, cgroup: Optimize load_balance_fair()
>> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> > Date: Wed Jul 13 13:09:25 CEST 2011
>> >
>> > Use for_each_leaf_cfs_rq() instead of list_for_each_entry_rcu(), this
>> > achieves that load_balance_fair() only iterates those task_groups that
>> > actually have tasks on busiest, and that we iterate bottom-up, trying to
>> > move light groups before the heavier ones.
>> >
>> > No idea if it will actually work out to be beneficial in practice, does
>> > anybody have a cgroup workload that might show a difference one way or
>> > the other?
>> >
>> > [ Also move update_h_load to sched_fair.c, loosing #ifdef-ery ]
>> >
>> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>> Reviewed-by: Paul Turner <pjt@google.com>
>
> So you think I should just merge it and see if any cgroup workload
> dislikes it?
>
> OK, I guess I can do that..
>

The task_list order was completely arbitrary anyway and had some
unfair bias against the groups most recently created.

I experimented a while back with a change that built a (task) h_load
ordered heap and chose which group to balance based on that.  It
improved sum(run_delay) on a few workloads and didn't seem to regress
anything.  (Unfortunately this was quite a while back and I don't have
the data available anymore.)

Using for_each_leaf_cfs_rq approximates that which leaves my
expectations somewhere between "can't hurt -- it's already arbitrary"
and "might help".  Moreover, if there are cases that result in bad
behavior under this new ordering then their group creation order can
likely permuted to create the same problem under the former
task_groups ordering making it a bug we have to deal with either way.
