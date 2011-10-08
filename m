Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1JHOzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 10:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab1JHOzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 10:55:45 -0400
Date: Sat, 8 Oct 2011 16:51:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: Tejun Heo <tj@kernel.org>, Mike Christie <michaelc@cs.wisc.edu>,
        Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] Modified workqueue patches for your review
Message-ID: <20111008145147.GA25607@redhat.com>
References: <1314339850-32666-1-git-send-email-bprakash@broadcom.com> <20110826085457.GC2632@htj.dyndns.org> <4E58138A.5050702@broadcom.com> <4E8E378B.30907@broadcom.com> <20111007004824.GA5458@google.com> <4E8E5493.5010804@broadcom.com> <20111007014534.GC5458@google.com> <4E8E6660.8070502@broadcom.com> <20111007062635.GA18562@dhcp-172-17-108-109.mtv.corp.google.com> <4E8F8BE4.2080104@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8F8BE4.2080104@broadcom.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07, Bhanu Prakash Gollapudi wrote:
>
> Ok. I guess I plan to do something like this. This should avoid the race
> condition. I have not compiled or  tested it yet, but will update you
> the progress.

Confused. I was CC'ed in the middle of discussion, I simply do not
understand what are you talking about. And since we discuss this
off-list I can't find the previous messages. I added lkml.

So, what does this patch do? Looks like, it is on top of another patch
which changes the old workqueue code to take get_online_cpus() instead
of cpu_maps_update_begin() in create/destroy.

That previous change was wrong. And how this one can help?

And could you please explain which problem (or problems) you are trying
to solve? I thought that the problem is that work->func() can't use
cpu_hotplug_begin(), in particular this means it can not call
destroy_workqueue().

> @@ -209,6 +220,7 @@ static int __ref _cpu_down(unsigned int cpu, int
> tasks_frozen)
>         if (!cpu_online(cpu))
>                 return -EINVAL;
>
> +       cpu_sync_hotplug_begin();
>         cpu_hotplug_begin();
>         set_cpu_active(cpu, false);
>         err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
> @@ -258,6 +270,7 @@ out_release:
>                                             hcpu) == NOTIFY_BAD)
>                         BUG();
>         }
> +       cpu_sync_hotplug_done();
>         return err;
>  }

So, we add another global lock, it covers CPU_POST_DEAD.

> @@ -930,7 +932,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
>         const struct cpumask *cpu_map = wq_cpu_map(wq);
>         int cpu;
>
> +       cpu_sync_hotplug_begin();
>         get_online_cpus();
> +       cpu_sync_hotplug_done();

OK, we are going to flush the pending works. Since we drop _sync_ lock,
a work->func() can take it again.

Seems to work, but it doesn't. Suppose _cpu_down() is called, suppose
that it takes cpu_sync_hotplug_begin() before that work. Deadlock.

Once again. May be I missed something (or even everything ;) but you
should not blame 3da1c84c00c commit, it was always wrong to destroy_
from work->func(). Note that there is another problem, CPU_POST_DEAD
needs to flush the pending works too and we have another obvious source
of deadlock.

Oleg.

