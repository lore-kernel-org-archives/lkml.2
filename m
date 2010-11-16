Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0KPQWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:22:07 -0500
Received: from smtp-out.google.com ([74.125.121.35]:12182 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0KPQWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:22:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sRNWQVAyeupTeDNAiIl6c77w/sgIdVWq/VJok3/DsgmZnxvg4uOqM3QUdmzfadQuVB
         RbXHQs5aHf7EiRMwzqiw==
MIME-Version: 1.0
In-Reply-To: <1289900042.27424.253.camel@debian>
References: <1289900042.27424.253.camel@debian>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 16 Nov 2010 08:21:40 -0800
Message-ID: <AANLkTinU4rbj3VF6WsUE_M08vnECnY=h7L4o8ynaU5SP@mail.gmail.com>
Subject: Re: [performance bug] volanomark regression on 37-rc1
To: "Alex,Shi" <alex.shi@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, linux-kernel@vger.kernel.org,
        "Chen, Tim C" <tim.c.chen@intel.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 1:34 AM, Alex,Shi <alex.shi@intel.com> wrote:
> When do performance testing on 37-rc1 kernel on Core2 machines, we find
> the volanomark loopback performance drop about 30%, that due to
> commit:fab476228ba37907ad7
>
> Volanomark link: http://www.volano.com/benchmarks.html
> Our volanomark testing parameters as following:
> "-count 25000 -rooms 10 "
> JVM is jrockit-R27.3.1-jre1.5.0_11
> java_options is "-Xmx1500m -Xms1500m -Xns750m -XXaggressive -Xlargepages
> -XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k"
> and we set /proc/sys/kernel/sched_compat_yield as "1".
>
> We find if with the following patch, the regression can be recovered.
>
> Signed-off-by:Alex Shi <alex.shi@intel.com>
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f4f6a83..5dca678 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1766,7 +1766,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
>        check_preempt_curr(this_rq, p, 0);
>
>        /* re-arm NEWIDLE balancing when moving tasks */
> -       src_rq->avg_idle = this_rq->avg_idle = 2*sysctl_sched_migration_cost;
>        this_rq->idle_stamp = 0;
>  }
>
>
> It seems some of load_balance() is not necessary that caused by avg_idle
> setting. But do not know more details of the volano running. Anyone like
> to give a comments for this issue?
>

I'm not very familiar with the Volanomark benchmark, but from the
patch you posted it looks like resetting the idle throttle (i.e.
making newidle balance more likely) hurts this benchmark. This is also
evident in the sharp increase in ctx rate in 2.6.37-rc1. Resetting
throttling was a heuristic added to induce more frequent idle
balancing after a migration, and it isn't strictly required to make
the other parts of that patch work. In your patch above, can you
please also remove the comment and idle_stamp reset.


> Ncrao, I have no idea of your benchmarks, but just guess removing the
> avg_idle setting won't bring much wakeup delay for tasks. Could you like
> to show some data of this?
>

The benchmark was pretty simple; run nr_cpu while-1 loops, one of them
niced to -15. I also experimented with some payloads with random
sleep/wakeup times, but nothing with high frequency balancing. I think
removing the reset should be OK for the idle test cases.

-Thanks,
Nikhil
