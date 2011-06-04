Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1FDEos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 00:44:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1FDEor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 00:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EBTgfb1iYSlLaSclx04snuR+YaJpoPyHoMCYyUWaQIl30rovno2YbMv3Eb32YXdxut
         JfX/7pNptz4BqghmG3Y9+KO4AzROG4bMt0/2bFj+6HigIpIMRYCy7m2Qho1AtSjiBeuU
         xr/KRZjwc2BuhfD3tP0HWrWwxPOcBKHbOEJ3o=
MIME-Version: 1.0
In-Reply-To: <1306852804.11899.19.camel@gandalf.stny.rr.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
	<1306852804.11899.19.camel@gandalf.stny.rr.com>
Date: Sat, 4 Jun 2011 12:44:45 +0800
Message-ID: <BANLkTikzjVd69XRb6psBm1aYSem126YynA@mail.gmail.com>
Subject: Re: [PATCH] sched: remove the next highest_prio in RT scheduling
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Sat, 2011-05-28 at 22:25 +0800, Hillf Danton wrote:
>> The next highest_prio element in rt_rq structure, is only used when pulling
>> RT task. As shown by the following snippet (in diff format for clearity),
>>
>> -             if (src_rq->rt.highest_prio.next >=
>> +             if (src_rq->rt.highest_prio.curr >=
>>                   this_rq->rt.highest_prio.curr)
>>                       continue;
>>
>> the "next" could be replaced with "curr" in the above comparison, since
>> the next is no less than curr by definition.
>
> But it completely misses the point of what we are doing. We will never
> pull a running task, but we can pull a waiting task. That's the point of
> the "next" field. We want to know if a high priority task is waiting to
> run, and if so, then we will pull it over to this CPU because this CPU
> is about to switch to a task with a lower priority. If a waiting task of
> higher priority than this CPU is on another CPU, we want to pull it
> over.
>
> This patch totally breaks this. We don't care about "curr" we care about
> "next".
>
Hi Steven

Both the next and curr reach same result, or incorrect result, before locking
RQ, as the comment says, it is racy. After locking RQ, priority is checked again
to pull the correct tasks with no running task included. The difference between
the next and curr before locking RQ is the core of the patch that incorrect
result could be achieved with no updating the next field.

thanks
           Hillf
