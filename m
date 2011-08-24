Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HXVdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:33:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18922 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab1HXVdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:33:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=dZskKlx6jpX1g7yLMAjG/zgdfdxgUVKFC/PGU9WyCGwZrGclXJeFMPqWI92zqJxlL
	YQIPrTImXWTCrQdY6r6qA==
MIME-Version: 1.0
In-Reply-To: <4E556CB2.3060502@cs.tu-berlin.de>
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de>
 <1314125615.8002.90.camel@twins> <4E556CB2.3060502@cs.tu-berlin.de>
From: Paul Turner <pjt@google.com>
Date: Wed, 24 Aug 2011 14:32:35 -0700
Message-ID: <CAPM31RK1xvA6pige9zrLce0JeBDpaPa_WfN-bsR9_ZJDRtn87g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
To: =?ISO-8859-1?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> I think splitting the function into two parts would make the thing
>> saner, something like:
>>
>>
>>       LIST_HEAD(leaf_queue);
>>
>>       for_each_sched_entity(se) {
>>               if (se->on_rq)
>>                       break;
>>               cfs_rq = cfs_rq_of(se);
>>               enqueue_entity(cfs_rq, se, flags);
>>               flags = ENQUEUE_WAKEUP;
>>               if (cfs_rq->nr_running == 1)
>>                       leaf_add_queue(cfs_rq, &leaf_queue);
>>       }
>>       /* XXX does ->on_rq imply ->on_list ? */
>>       if (se->on_list)
>>               leaf_splice_queue(cfs_rq, &leaf_queue);
>>
>> that splits the add to queue and add queue to list part and avoids the
>> parent_cfs_rq peeking.
>
> Unfortunately that won't work. The problem here is that some of the
> traversed SEs are on_list and others aren't. And the on_list status
> of one SE is independent from other SEs. So, if we don't want to remove
> on_list elements during the traversal, we need to splice collected
> entries as soon as we find a SE that is on_list.
>
> We might get away with collecting all entries always (removing on_list entries
> temporarily) and splice them after the loop, but that would
> introduce more work than normally necessary. And we should double check
> for new concurrency issues...
>

Let me consider this part more carefully.

>
>> Now I don't really like the above because its hard to make the code go
>> away in the !FAIR_GROUP case, but maybe we can come up with something
>> for that.
>
> Hmmm... you might want to reconsider my original approach to solve this:
> http://lkml.org/lkml/2011/7/18/86
>
> That might have been the cleanest one in this respect.
>
> Paul Turner did not like the introduced in-order removal, but the
> out-of-order removal is causing most problems.
>

Sorry for the delayed reply -- I owe you some feedback on the updated
versions but have been buried with other work.

What I didn't like about the original approach was specifically the
positional dependence on enqueue/dequeue.  If we can't do the splicing
properly then I think we want something like:
https://lkml.org/lkml/2011/7/18/348 to avoid shooting ourselves in the
future later.

See: https://lkml.org/lkml/2011/7/19/178 for why this should be cheap.
