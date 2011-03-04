Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab1CDIcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:32:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63430 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1CDIcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vNEnKfNBnVd9Fk2D6nSS2VLKYHhCDhPKgo2FJKo+hJYycy/wbZpuwopPEhhjrlw/pX
         yWYZEtNv9EVHsTtcQLM9AJw8bAOMhecKPzbJ7hbOVpxaf82xaDmZifg5Eb7U4uRBHIVS
         HPN8Et7YBDm9qbQMYEUQBi2HJYwRqGY73Qv0k=
MIME-Version: 1.0
In-Reply-To: <20110304072517.GC2868@balbir.in.ibm.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
	<AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
	<20110304072517.GC2868@balbir.in.ibm.com>
Date: Fri, 4 Mar 2011 16:32:49 +0800
Message-ID: <AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 3:25 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Yong Zhang <yong.zhang0@gmail.com> [2011-03-04 11:43:16]:
>
>> On Thu, Mar 3, 2011 at 11:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> > No, not really :) It is required, it is a backup check to see if we
>> > have queued tasks, rt_time of 0 and the runqueue is not throttled, why
>> > should it be dequeued?
>>
>> But I can't see where that kind of rt_rq is dequeued, mind pointing it out?
>>
>
> So here is what I saw
>
> 1. sched_dequeue_stack called from the dequeue path dequeues the
> queues and sets rt_nr_running to 0
> 2. Enqueuing fails because rt_throttled is set for the group_rq
> (parent who is throttled)
> 3. This causes further enqueue to fail, since rt_nr_running did
> not increment in step 2

Whose rt_nr_running? group_rq's or parent of group_rq?
For parent of group_rq, yes.
For group_rq's, no, because we don't touch its rt_nr_running.


> , eventually the timer decrements rt_time
> to 0 and the task is never picked up.

If I understand correctly, you mean this:

For a group(A) which has one task(b) attached but A is throttled,so
A is unqueued now
A.throttled == 1 && A.rt_nr_running == 1
  deactivate_task(b); /* A.throttled == 1 && A.rt_nr_running == 0 */
    do_sched_rt_period_timer(); /* A.run_time == 0 && A.throttled == 0*/
      sched_rt_rq_enqueue(A); /* fails due to A.rt_nr_running == 0 */

But this doesn't prevent task readded to group A and eventually
group A is added back.

Thanks,
Yong


-- 
Only stand for myself
