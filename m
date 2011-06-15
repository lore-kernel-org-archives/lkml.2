Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1FORuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:50:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62367 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1FORun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:50:43 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=amiImj7KDpwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=TIEVg4I3ZdatZmPpjW4A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: select eligible run-queue for RT task
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTinmZ1tSpbwV7448usb1nshw=FJXXA@mail.gmail.com>
References: <BANLkTinmZ1tSpbwV7448usb1nshw=FJXXA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Jun 2011 13:50:40 -0400
Message-ID: <1308160240.9218.129.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 22:06 +0800, Hillf Danton wrote:
> When selecting run-queue for a given task, eligible run-queue should be
> returned by checking the CPU affinity of task.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..45b3e0a 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1006,7 +1006,8 @@ select_task_rq_rt(struct task_struct *p, int
> sd_flag, int flags)
>  	int cpu;
> 
>  	if (sd_flag != SD_BALANCE_WAKE)
> -		return smp_processor_id();
> +		return cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed) ?
> +			smp_processor_id() : task_cpu(p);

I wonder if we should bother even dhoing a test here. Perhaps a better
solution is just:

	if (sd_flag != SD_BALANCE_WAKE)
		return task_cpu(p);

-- Steve


