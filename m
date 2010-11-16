Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0KPT1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:27:44 -0500
Received: from smtp-out.google.com ([74.125.121.35]:3954 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0KPT1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:27:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nRmzx81PKgSuQnkmtNRnphPewN/nLcXBWTNEpjpTlMMQd8T+D+uBnr0L7VQ78qq+HS
         QJVFb6DvFdvwaL9ym61g==
MIME-Version: 1.0
In-Reply-To: <1289928732.5169.211.camel@maggy.simson.net>
References: <1289900042.27424.253.camel@debian> <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
 <1289921196.5169.176.camel@maggy.simson.net> <AANLkTinrtz36tDZT2C39aVRsws-wmRraLGsMZ8_zxFA+@mail.gmail.com>
 <1289928732.5169.211.camel@maggy.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 16 Nov 2010 11:27:18 -0800
Message-ID: <AANLkTinah0wj56cG9sjTu9W0nAQ3hU=h85d7MZLfj9X4@mail.gmail.com>
Subject: Re: [performance bug] volanomark regression on 37-rc1
To: Mike Galbraith <efault@gmx.de>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, "Alex,Shi" <alex.shi@intel.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 9:32 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2010-11-16 at 08:31 -0800, Nikhil Rao wrote:
>> On Tue, Nov 16, 2010 at 7:26 AM, Mike Galbraith <efault@gmx.de> wrote:
>> > On Tue, 2010-11-16 at 20:38 +0600, Rakib Mullick wrote:
>> >
>> >> Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
>> >> I don't think it directly relates to scheduler benchmarking.
>> >
>> > It's not generally considered to be a wonderful benchmark, but it is a
>> > good indicator, and worth keeping an eye on IMHO.
>> >
>> > I don't recall whether that patch works with the idle testcase without
>> > resetting the throttle, or if it's only a bit less effective.  If it's
>> > only a little less effective, I'd be inclined to just whack the reset as
>> > Alex did.  Whatever is done has to prevent high frequency balancing.
>> >
>>
>> >From what I recall, I think removing the reset makes the original
>> patch a little less effective. I agree that we can remove the reset if
>> it hurts high frequency balancing.
>
> Ok, let's do that.  I added your ack, OK?
>

Yes, thanks for the patch.

> From: Alex Shi <alex.shi@intel.com>
> Date: Tue, 16 Nov 2010 17:34:02 +0800
>
>    sched: volanomark regression fix
>
>    Commit fab4762 triggers excessive idle balancing, causing a ~30% loss in
>    volanomark throughput.  Remove idle balancing throttle reset.
>
>    Signed-off-by: Mike Galbraith <efault@gmx.de>
>    Acked-by: Nikhil Rao <ncrao@google.com>
>    Reported-by: Alex Shi <alex.shi@intel.com>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>    LKML-Reference: <new-submission>
>
> ---
>  kernel/sched_fair.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1758,10 +1758,6 @@ static void pull_task(struct rq *src_rq,
>        set_task_cpu(p, this_cpu);
>        activate_task(this_rq, p, 0);
>        check_preempt_curr(this_rq, p, 0);
> -
> -       /* re-arm NEWIDLE balancing when moving tasks */
> -       src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
> -       this_rq->idle_stamp = 0;
>  }
>
>  /*
>
>
>
