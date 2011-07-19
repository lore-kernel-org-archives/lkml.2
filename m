Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab1GSRtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 13:49:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29617 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1GSRtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 13:49:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=IPn/Ozkzib+Srw6UZFeAeA9R3HqZncFswpOusVjQEdJus5lNMj5wqCxLja078xIgF
	Nfq3ZNDqiho08D9zpjCvQ==
MIME-Version: 1.0
In-Reply-To: <1311080921.13765.203.camel@twins>
References: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de>
 <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com> <1311080921.13765.203.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 19 Jul 2011 10:48:44 -0700
Message-ID: <CAPM31RK1cFCLZ=KrNs2Q2KamQ8PLfMHaUrhf49hSj-=cmEaHvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Jan H." <schnhrr@cs.tu-berlin.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 6:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-07-18 at 16:24 -0700, Paul Turner wrote:
>
>> Subject: [PATCH] sched: handle on_list ancestor in leaf_add_cfs_rq()
>> From: Paul Turner <pjt@google.com>
>> Date: Mon, 18 Jul 2011 16:08:10 -0700
>>
>> Jan H. Schönherr found that in the case of an on_list ancestor we may
>> incorrectly place the child to the right of a great-ancestor on the list.
>>
>> Consider:
>>
>>       A
>>      / \     Here, t1A results in A->cfs_rq being on_list, however when
>>     B  t1A   we start enqueuing from C this will not be visible.  This is
>>    /         compounded by the fact that on_list expiration may also be out
>>   C          of order, punching holes in the tree.
>>  /
>> t1C
>>
>> Prevent this by making additions to the leaf_cfs_rq_list position independent.
>> This is done by maintaining additions to this list within the
>> enqueue_task_fair() path, which allows us to always enqueue against the
>> current entity's first on_list ancestor.
>
> The problem I have with this is that it makes the enqueue more
> expensive. We're now optimizing a relatively slow path (load-balance) at
> the cost of the hottest path in the kernel (enqueue/dequeue).
>

So this is a concern that I kept in mind.  I don't think this should
actually add any measurable overhead:

- on_rq always implies on_list so we are guaranteed never to go past
where we have to go for enqueuing; moreover we're touching the same
lines that enqueue will use for continuing it s walk
- it takes on_list ~40ms+ to expire so the extra walk above can only
happen on this order.

I can't think of any benchmark that's going to measure anything for
this.  pipe-bench et al are just going to always hit the single
on_list branch which should be the same cost as the previous == 1
check.

>
>
