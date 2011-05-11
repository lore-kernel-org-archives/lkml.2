Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1EKP5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:57:24 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60111 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1EKPzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nHRpYWXiG3DbsePXomwaWVBRdiHIGVvnh3LanbcdTr+8IkFUo3D6NsUPR2ui8Cc9A4
         HIhMpjzrcBuAy0ULIpzNWklazOV4ImmjaCWAgf9XRDUk4ANJolHbFm8Z6yHZL/yAgJ9i
         IXcw1/CQSu/ndTBf+AP/74QfN8YtdUHRfOLbg=
MIME-Version: 1.0
In-Reply-To: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
Date: Wed, 11 May 2011 16:43:49 +0800
Message-ID: <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 9:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When picking RT task for given CPU,
> [1] if the cpu is invalid for cpumask test, right result could not be

'cpu is invalid' means weather we care it or not, it's not real 'invalid'

> reached even by further checking nr_cpus_allowed,
> on the other hand, the input cpu is valid in two cases that
> pick_next_highest_task_rt() is called, thus the invalid input cpu
> looks over-concern.
> [2] if the cpu is valid for cpumask test, further checking
> nr_cpus_allowed looks overwork, since it is computed based on
> cpus_allowed,

No, cpumask_test_cpu(cpu, &p->cpus_allowed) doesn't mean
p->rt.nr_cpus_allowed > 1.

Thanks,
Yong

> what is more, the combination of cpus_allowed and nr_cpus_allowed
> could lead to incorrect result if the input cpu == rq->cpu, as in the
> case of next_prio() where no pulling task is concerned.
>
> In this work, invalid cpu is not removed but leads to negative result,
> but nr_cpus_allowed is.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_rt.c 2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c 2011-05-10 20:30:38.000000000 +0800
> @@ -1149,10 +1149,12 @@ static void deactivate_task(struct rq *r
>
>  static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
>  {
> -       if (!task_running(rq, p) &&
> -           (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
> -           (p->rt.nr_cpus_allowed > 1))
> -               return 1;
> +       if (!task_running(rq, p)) {
> +               if (cpu < 0)
> +                       return 0;
> +               if (cpumask_test_cpu(cpu, &p->cpus_allowed))
> +                       return 1;
> +       }
>        return 0;
>  }
>



-- 
Only stand for myself
