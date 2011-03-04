Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab1CDIw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:52:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36917 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1CDIw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:52:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xzzK4Iz2ppHvfwusi89+yZ46SFtuWiRh6nXzz+euUVcSSlrCy+ejc35HkXLsg/PY+Q
         iUqOvtURWnA5I+0QS7SLj4lpoX2tdQiK7ZIISPIgLbj3XMmD0/BaVOD0jDOrGW5WsPYl
         LQmAIfS5cMF/Izl0aI+UW9Fr96G/XR47VxhYU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
References: <20110303113435.GA2868@balbir.in.ibm.com>
	<20110303140551.GA20677@zhy>
	<AANLkTikHFLoJOZvx2YebKdHt+jjiHgUFasiLTrZ6vBUJ@mail.gmail.com>
	<AANLkTikqC=MNXXavJ_jxhFNQz1uNdABXVhvj82HW=BNA@mail.gmail.com>
	<20110304072517.GC2868@balbir.in.ibm.com>
	<AANLkTikuQKGS2SQArVBDo=5vOkyrNPdqXHPrOyQz3KdP@mail.gmail.com>
	<AANLkTi=gtnZ-uC-t6u9R=pNd_aSKE3YsXi_HUqnu5+VQ@mail.gmail.com>
Date: Fri, 4 Mar 2011 16:52:26 +0800
Message-ID: <AANLkTinMvkuxdrwgj4bS9MfVaimWx-DYaanhUD-bT_wO@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] Fix sched rt group scheduling when hierachy is enabled
From: Yong Zhang <yong.zhang0@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <pzijlstr@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Bharata B Rao <bharata.rao@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 4:35 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Fri, Mar 4, 2011 at 2:02 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> On Fri, Mar 4, 2011 at 3:25 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> * Yong Zhang <yong.zhang0@gmail.com> [2011-03-04 11:43:16]:
>>>
>>>> On Thu, Mar 3, 2011 at 11:29 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>> > No, not really :) It is required, it is a backup check to see if we
>>>> > have queued tasks, rt_time of 0 and the runqueue is not throttled, why
>>>> > should it be dequeued?
>>>>
>>>> But I can't see where that kind of rt_rq is dequeued, mind pointing it out?
>>>>
>>>
>>> So here is what I saw
>>>
>>> 1. sched_dequeue_stack called from the dequeue path dequeues the
>>> queues and sets rt_nr_running to 0
>>> 2. Enqueuing fails because rt_throttled is set for the group_rq
>>> (parent who is throttled)
>>> 3. This causes further enqueue to fail, since rt_nr_running did
>>> not increment in step 2
>>
>> Whose rt_nr_running? group_rq's or parent of group_rq?
>> For parent of group_rq, yes.
>> For group_rq's, no, because we don't touch its rt_nr_running.
>>
>
> For parent of group_rq
>
>>
>>> , eventually the timer decrements rt_time
>>> to 0 and the task is never picked up.
>>
>> If I understand correctly, you mean this:
>>
>> For a group(A) which has one task(b) attached but A is throttled,so
>> A is unqueued now
>> A.throttled == 1 && A.rt_nr_running == 1
>>  deactivate_task(b); /* A.throttled == 1 && A.rt_nr_running == 0 */
>>    do_sched_rt_period_timer(); /* A.run_time == 0 && A.throttled == 0*/
>
> Note at some point rt_time becomes 0 and if enqueue is not set, the

If the group should be add back, it will be at the first
do_sched_rt_period_timer() which decreases run_time;

> next do_sched_rt_period_timer() is a NOP and does not enqueue back the
> group

Otherwise it will be added back when a task is attching to it.

I still can't see how a unthrottled group which has task attched stay
unqueued.

Thanks,
Yong


-- 
Only stand for myself
