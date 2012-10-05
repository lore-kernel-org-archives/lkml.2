Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab2JEJHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:07:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab2JEJHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <xm26zk4fbats.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <20120823141422.444396696@google.com> <50602849.70506@cs.tu-berlin.de>
 <xm26zk4fbats.fsf@sword-of-the-dawn.mtv.corp.google.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 5 Oct 2012 02:07:08 -0700
Message-ID: <CAPM31RJOzCBE6N6v-oRV+O=LC_NVAg6Y6LCgYXYrdOyrpLD2kA@mail.gmail.com>
Subject: Re: [patch 00/16] sched: per-entity load-tracking
To: Benjamin Segall <bsegall@google.com>
Cc: =?ISO-8859-1?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:16 AM, Benjamin Segall <bsegall@google.com> wrote:
> "Jan H. Schönherr" <schnhrr@cs.tu-berlin.de> writes:
>
>> Hi Paul.
>>
>> Am 23.08.2012 16:14, schrieb pjt@google.com:
>>> Please find attached the latest version for CFS load-tracking.
>>
>> Originally, I thought, this series also takes care of
>> the leaf-cfs-runqueue ordering issue described here:
>>
>> http://lkml.org/lkml/2011/7/18/86
>>
>> Now, that I had a closer look, I see that it does not take
>> care of it.
>>
>> Is there still any reason why the leaf_cfs_rq-list must be sorted?
>> Or could we just get rid of the ordering requirement, now?
>
> Ideally yes, since a parent's __update_cfs_rq_tg_load_contrib and
> update_cfs_shares still depend on accurate values in
> runnable_load_avg/blocked_load_avg from its children. That said, nothing
> should completely fall over, it would make load decay take longer to
> propogate to the root.
>>
>> (That seems easier than to fix the issue, as I suspect that
>> __update_blocked_averages_cpu() might still punch some holes
>> in the hierarchy in some edge cases.)
>
> Yeah, I suspect it's possible that the parent ends up with a slightly
> lower runnable_avg_sum if they're both hovering around the max value
> since it isn't quite continuous, and it might be the case that this
> difference is large enough to require one more tick to decay to zero.

OK so coming back to this.  I had a look at this last week and
realized I'd managed to pervert my original intent.

Specifically, the idea here was barring numerical rounding errors
about LOAD_AVG_MAX we can guarantee a parent's runnable average is
greater than or equal to its child, since a parent is runnable
whenever its child is runnable by definition.  Provided we fix up
possible rounding errors (e.g. with a clamp) this then guarantees
we'll always remove child nodes before parent.

So I did this.  Then I thought: oh dear.  When I'd previously proposed
the above as a resolution for out-of-order removal I had not tackled
the problem of correct accounting on bandwidth constrained entities.
It turns out we end up having to "stop" time to handle this
efficiently / correctly.  But this means that we can then no longer
depend on the constraint above as the sums on a sub-tree can
potentially become out of sync.

So I got back to this again tonight and just spent a few hours tonight
looking at some alternate approaches to resolve this.  There's a few
games we can play here but after all of that I now re-realize we still
won't handle an on-list grand-parent correctly when the parent/child
are not on tree; and that this is fundamentally an issue with
enqueue's ordering -- no hole punching from parent before child
removal required.

I suspect we might want to do a segment splice on enqueue after all.
Let me sleep on it.

- Paul
