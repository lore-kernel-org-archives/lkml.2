Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1FJPM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:12:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57668 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab1FJPM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kglPyUylRZU/S9LiGjeTJaWh0kQcnpRdOI0Ley+gy3a/VGh6A6Fp7riQ9alU54CAFC
         mLjyDcYMeZD8OQHK8zmAyiDwBBYdJRygCqIrSNoqEgYBoeYxnnZvc6QnpS2e/0+HyJxN
         6R5+xG55FgrKjCVs4aNX5u+DmG879gdjSDeZQ=
MIME-Version: 1.0
In-Reply-To: <1307717917.9218.45.camel@gandalf.stny.rr.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
	<BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
	<1307622863.9218.40.camel@gandalf.stny.rr.com>
	<BANLkTing2boYvDQqcxaqveYhbG2H1Zyvrw@mail.gmail.com>
	<1307717917.9218.45.camel@gandalf.stny.rr.com>
Date: Fri, 10 Jun 2011 23:12:56 +0800
Message-ID: <BANLkTi=nY-wzz1z-2jE1ORi19dJYw+PTsA@mail.gmail.com>
Subject: Re: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 10:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-06-10 at 22:48 +0800, Hillf Danton wrote:
>> On Thu, Jun 9, 2011 at 8:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> Resetting exec_start to zero has no negative functionality in RT scheduling,
>> as shown by Yong.
>>
>> After put_prev_task() is called in schedule(),
>>
>>       put_prev_task(rq, prev);
>>       next = pick_next_task(rq);
>>       clear_tsk_need_resched(prev);
>>
>> next is picked. Lets assume that next is not prev, and prev is still on RQ,
>> then prev's sched_class is changed to CFS while it is waiting on RQ.
>> After sched_class switch, prev is under CFS charge, and the exec_start field
>> could be taken into other games.
>>
>> In task_hot(), called when migrating task, zeroed exec_start is trapped as
>> the following.
>>
>
> How could any of that happen? This is all done under the rq->lock.
> prev's sched class can not change at this time. Everything you stated is
> protected by the rq->lock. I don't see any race conditions here.
>

Hi Steve

Yeah you are right, the snippet in schedule() is under RQ lock, but next could
be a RT task, and if it is FIFO and willing to hog CPU ie. 10 minutes, then
prev has to wait on its RQ. While waiting, however, its sched_class could be
changed at anytime. Here I show it is tiny possible that zeroed exec_start
could rush out of our control.

thanks
           Hillf
