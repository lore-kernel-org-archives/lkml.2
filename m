Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1EFHSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:18:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52838 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1EFHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:18:44 -0400
Date: Fri, 6 May 2011 09:18:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Nikhil Rao <ncrao@google.com>, Mike Galbraith <efault@gmx.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: fix erroneous sysct_sched_nr_migrate logic
Message-ID: <20110506071830.GD23166@elte.hu>
References: <1304536548-3052-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304536548-3052-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vladimir Davydov <vdavydov@parallels.com> wrote:

> During load balance, the scheduler must not iterate more than
> sysctl_sched_nr_migrate (32 by default) tasks, but at present this limit is held
> only for tasks in a task group. That means if there is the only task group in
> the system, the scheduler never iterates more than 32 tasks in a single balance
> run, but if there are N task groups, it can iterate up to N * 32 tasks. This
> patch makes the limit system-wide as it should be.
> ---
>  kernel/sched_fair.c |   35 +++++++++++++++++------------------
>  1 files changed, 17 insertions(+), 18 deletions(-)

Well, you are right that we currently scale "nr_groups*32", but changing this 
will have an effect on default scheduling behavior, especially if there are a 
lot of groups.

So either it has to be shown (measured, demonstrated) that the current behavior 
is catastrophic or clearly bad in some workloads, or it has to be shown 
(measured) that it has no bad effect on the balancing quality of workloads 
involving a lot of groups.

What was the motivation for the patch - have you noticed it via review, or have 
you run into a workload that demonstrated it? Such details need to be in 
changelogs.

If there's adverse effect on balancing quality we might still do something 
about the number of iterations, but it all has to be done a lot more carefully 
than just capping it to 32 globally, without any numbers and analysis ...

Thanks,

	Ingo
