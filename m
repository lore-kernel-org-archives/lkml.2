Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2HMSAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:00:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54237 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HMSAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:00:22 -0400
Date: Mon, 13 Aug 2012 11:00:17 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in
 queue_delayed_work_on()
Message-ID: <20120813180017.GJ9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-2-git-send-email-js1304@gmail.com>
 <20120813163219.GA9180@google.com>
 <CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
 <20120813170303.GF9180@google.com>
 <CAAmzW4Nfzq6i-KHky2qb1Qzgg1psVVEAME_mkzLfUWYGBXjH_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4Nfzq6i-KHky2qb1Qzgg1psVVEAME_mkzLfUWYGBXjH_Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 02:43:28AM +0900, JoonSoo Kim wrote:
> >> And, do u mean  @cpu is WORK_CPU_UNBOUND?
> >
> > @cpu could be WORK_CPU_UNBOUND at that point.  The timer will be added
> > to local CPU but @work->data would be pointing to WORK_CPU_UNBOUND,
> > again triggering the condition.  Given that @cpu being
> > WORK_CPU_UNBOUND is far more common than an actual CPU number, the
> > patch would actually increase spurious nrt lookups.  The right thing
> > to do is probably setting cpu to raw_smp_processor_id() beforehand.
> 
> I got your point.
> Thanks for kind illustration.
> 
> Following is a alternative implementation for this.
> I thinks this is too rare case, so it doesn't help in any real workload.
> But how do you thinks?
> 
> @@ -1156,7 +1156,9 @@ int queue_delayed_work_on(int cpu, struct
> workqueue_struct *wq,
>                 if (!(wq->flags & WQ_UNBOUND)) {
>                         struct global_cwq *gcwq = get_work_gcwq(work);
> 
> -                       if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
> +                       if (!gcwq)
> +                               lcpu = cpu;
> +                       else if (gcwq->cpu != WORK_CPU_UNBOUND)
>                                 lcpu = gcwq->cpu;
>                         else
>                                 lcpu = raw_smp_processor_id();

Why not just do

	if (cpu == WORK_CPU_UNBOUND)
		cpu = raw_smp_processor_id();

	if (!(wq->flags...) {
		...
		if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
			lcpu = gcwq->cpu;
		else
			lcpu = cpu;
	}
	...

	add_timer_on(timer, cpu);

Also, can you please base the patches on top of the following git
branch?

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7

Thanks.

-- 
tejun
