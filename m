Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934226Ab2KZRVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:21:44 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:62281 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162Ab2KZRPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:47 -0500
Date: Mon, 26 Nov 2012 09:15:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
Message-ID: <20121126171539.GZ15971@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Tue, Nov 06, 2012 at 04:08:45PM +0530, Viresh Kumar wrote:
> Workqueues queues work on current cpu, if the caller haven't passed a preferred
> cpu. This may wake up an idle CPU, which is actually not required.
> 
> This work can be processed by any CPU and so we must select a non-idle CPU here.
> This patch adds in support in workqueue framework to get preferred CPU details
> from the scheduler, instead of using current CPU.
> 
> Most of the time when a work is queued, the current cpu isn't idle and so we
> will choose it only. There are cases when a cpu is idle when it queues some
> work. For example, consider following scenario:
> - A cpu has programmed a timer and is IDLE now.
> - CPU gets into interrupt handler due to timer and queues a work. As the CPU is
>   currently IDLE, we can queue this work to some other CPU.

I'm pretty skeptical about this.  queue_work() w/o explicit CPU
assignment has always guaranteed that the work item will be executed
on the same CPU.  I don't think there are too many users depending on
that but am not sure at all that there are none.  I asked you last
time that you would at the very least need to audit most users but it
doesn't seem like there has been any effort there.  Given the
seemingly low rate of migration and subtlety of such bugs, things
could get nasty to debug.

That said, if the obtained benefit is big enough, sure, we can
definitely change the behavior, which isn't all that great to begin
with, and try to shake out the bugs quicky by e.g. forcing all work
items to execute on different CPUs, but you're presenting a few
percent of work items being migrated to a different CPU from an
already active CPU, which doesn't seem like such a big benefit to me
even if the migration target CPU is somewhat more efficient.  How much
powersaving are we talking about?

Thanks.

-- 
tejun
