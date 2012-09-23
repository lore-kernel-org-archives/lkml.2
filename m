Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2IWB4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 21:56:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab2IWB4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 21:56:14 -0400
From: Thomas Renninger <trenn@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3.6-rc6] cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to another CPU
Date: Sun, 23 Sep 2012 03:53:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Andre Przywara <andre.przywara@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20120917201721.GJ18677@google.com> <201209172238.21087.rjw@sisk.pl>
In-Reply-To: <201209172238.21087.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209230353.49737.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

better late than never..

On Monday 17 September 2012 22:38:20 Rafael J. Wysocki wrote:
> On Monday, September 17, 2012, Tejun Heo wrote:
> > powernowk8_target() runs off a per-cpu work item and if the
> > cpufreq_policy->cpu is different from the current one, it migrates the
> > kworker to the target CPU by manipulating current->cpus_allowed.  The
> > function migrates the kworker back to the original CPU but this is
> > still broken.  Workqueue concurrency management requires the kworkers
> > to stay on the same CPU and powernowk8_target() ends up triggerring
> > BUG_ON(rq != this_rq()) in try_to_wake_up_local() if it contends on
> > fidvid_mutex and sleeps.
> > 
> > It is unclear why this bug is being reported now.  Duncan says it
> > appeared to be a regression of 3.6-rc1 and couldn't reproduce it on
> > 3.5.  Bisection seemed to point to 63d95a91 "workqueue: use @pool
> > instead of @gcwq or @cpu where applicable" which is an non-functional
> > change.  Given that the reproduce case sometimes took upto days to
> > trigger, it's easy to be misled while bisecting.  Maybe something made
> > contention on fidvid_mutex more likely?  I don't know.
> > 
> > This patch fixes the bug by punting to another per-cpu work item on
> > the target CPU if it isn't the same as the current one.  The code
> > assumes that cpufreq_policy->cpu is kept online by the caller, which
> > Rafael tells me is the case.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Duncan <1i5t5.duncan@cox.net>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> > Cc: stable@kernel.org
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47301
> > ---
> > 
> > While it's very late in the merge cycle, the fix is limited in scope
> > and fairly safe, so it wouldn't be too crazy to merge but then again
> > this can go through the next -rc1 and then -stable.  Linus, Rafael,
> > what do you guys think?
> 
> Well, I don't see much reason to wait with this, although I'd like some
> more people to check it.
> 
> Andre, Thomas, can you please have a look at it?

The cpufreq changes are not really (functional) changes.
I cannot judge the risk of the real change:

> > +	INIT_WORK_ONSTACK(&tw.work, powernowk8_target_on_cpu);
instead of using set_cpus_allowed_ptr.

Changing scheduler behavior of powernow-k8 
sounds rather intrusive for rc6, but I would fully trust
Tejun's advise on this.

I wonder whether more drivers are affected similarly, grepping for:
set_cpus_allowed_ptr
shows quite some hits.

My 2 cents...,

   Thomas
