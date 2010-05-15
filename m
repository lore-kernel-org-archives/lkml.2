Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0EOO2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:28:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:49755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab0EOO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:28:44 -0400
Subject: Re: commit e9e9250b: sync wakeup bustage when waker is an RT task
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1273924628.10630.24.camel@marge.simson.net>
References: <1273924628.10630.24.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 May 2010 14:04:12 +0200
Message-ID: <1273925052.1674.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-15 at 13:57 +0200, Mike Galbraith wrote:
> Hi Peter,
> 
> This commit excluded RT tasks from rq->load, was that intentional?  The
> comment in struct rq states that load reflects *all* tasks, but since
> this commit, that's no longer true.

Right, because a static load value does not accurately reflect a RT task
which can run as long as it pretty well pleases. So instead we measure
the time spend running !fair tasks and scale down the cpu_power
proportionally.

> Looking at lmbench lat_udp in a PREEMPT_RT kernel, I noticed that
> wake_affine() is failing for sync wakeups when it should not.  It's
> doing so because the waker in this case is an RT kernel thread
> (sirq-net-rx) - we subtract the sync waker's weight, when it was never
> added in the first place, resulting in this_load going gaga.  End result
> is quite high latency numbers due to tasks jabbering cross-cache.
> 
> If the exclusion was intentional, I suppose I can do a waker class check
> in wake_affine() to fix it.

So basically make all RT wakeups sync?

