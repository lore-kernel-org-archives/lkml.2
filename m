Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1FCOTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:19:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab1FCOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:19:29 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=IEGT9Ul9ajIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=k6fttIazc8Wu-YlDuqEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT
 scheduling
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 10:19:27 -0400
Message-ID: <1307110767.3667.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 21:58 +0800, Hillf Danton wrote:

> And checking for cache-hot is also added to confirm the comment there.

Please read that comment.

>  	cpu = task_cpu(p);
> @@ -1253,7 +1253,8 @@ static int find_lowest_rq(struct task_struct *task)
>  	 * We prioritize the last cpu that the task executed on since
>  	 * it is most likely cache-hot in that location.
>  	 */
> -	if (cpumask_test_cpu(cpu, lowest_mask))
> +	if (cpumask_test_cpu(cpu, lowest_mask) &&
> +	    task_hot(task, task_rq(task)->clock_task, NULL))
>  		return cpu;

What task_hot() checks for and what we are assuming are two different
things. In fact, we can disable task_hot() so it always fails. That's
not what we want.

If the task happens to have ran on a CPU that is in the lowest_mask, we
want that CPU. Time may not matter. If we know a task ran on a
particular CPU last, we want to run it there if possible. It may still
have cache lines for it, even if it has been a long time since it last
ran.

-- Steve


