Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1HXWk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:40:28 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:43385 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HXWk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:40:27 -0400
Message-ID: <4E557DCC.5050308@cs.tu-berlin.de>
Date: Thu, 25 Aug 2011 00:40:12 +0200
From: =?ISO-8859-1?Q?=22Jan_H=2E_Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110508 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
References: <1313503666-13726-1-git-send-email-schnhrr@cs.tu-berlin.de> <1313503666-13726-3-git-send-email-schnhrr@cs.tu-berlin.de> <1314125615.8002.90.camel@twins> <4E556CB2.3060502@cs.tu-berlin.de> <CAPM31RK1xvA6pige9zrLce0JeBDpaPa_WfN-bsR9_ZJDRtn87g@mail.gmail.com>
In-Reply-To: <CAPM31RK1xvA6pige9zrLce0JeBDpaPa_WfN-bsR9_ZJDRtn87g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.08.2011 23:32, schrieb Paul Turner:
>>> Now I don't really like the above because its hard to make the code go
>>> away in the !FAIR_GROUP case, but maybe we can come up with something
>>> for that.
>>
>> Hmmm... you might want to reconsider my original approach to solve this:
>> http://lkml.org/lkml/2011/7/18/86
>>
>> That might have been the cleanest one in this respect.
>>
>> Paul Turner did not like the introduced in-order removal, but the
>> out-of-order removal is causing most problems.
>>
> 
> Sorry for the delayed reply -- I owe you some feedback on the updated
> versions but have been buried with other work.

No problem.

> What I didn't like about the original approach was specifically the
> positional dependence on enqueue/dequeue. 

Maybe I misunderstood you, then.

If we can guarantee in-order removal of leaf_cfs_rqs, then there is
no positional dependency. Any SE can be enqueued and dequeued anytime.

OTOH, the RCU splice variant has a positional dependence: calling
enqueue_entity() outside of enqueue_task_fair() can go wrong easily as it
depends on being called bottom-up and requires its caller to maintain state.

This is also partly true for the leaf_insertion_point variant: if a caller
maintains state, then the pair enqueue_entity/enqueue_leaf_cfs_rq() also
depends on being called bottom up.


> If we can't do the splicing
> properly then I think we want something like:
> https://lkml.org/lkml/2011/7/18/348 to avoid shooting ourselves in the
> future later.
> 
> See: https://lkml.org/lkml/2011/7/19/178 for why this should be cheap.

As far as I can tell, all three variants proposed so far work.

It is probably a matter of taste in the end. I'll happily help with
whatever version tastes best. :)

Regards
Jan
