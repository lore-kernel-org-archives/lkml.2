Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1HQQrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:47:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:41602 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1HQQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:47:47 -0400
Date: Wed, 17 Aug 2011 18:47:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20110817160759.GA3482@sgi.com>
Message-ID: <alpine.LFD.2.02.1108171819120.2807@ionos>
References: <20110817160759.GA3482@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011, Dimitri Sivanich wrote:

> Reposting this, as this was posted 2 weeks ago with no replies.

It's still in my vacation backlog :)

> Jiffies updates are currently done by the tick_do_timer_cpu.  This has a
> non-deterministic value that can be any running cpu on the system.  It
> changes dynamically in nohz mode.  When nohz mode is off, it gets set to
> a more static, but still non-deterministic value.
> 
> While the nohz behavior is necessary, is there a reason why the nohz off
> case can't have a specific value, say 0 as it was on earlier kernels?

Yes, we had troubles when switching over to highres/oneshot mode when
the first cpu which did the switch did not take the do_timer duty. See
changelogs.

> If the cpu is offlined, let the value change at that time (note that the
> x86 arch disallows offlining cpu 0).
> 
> There are certain cases where this would be advantageous, especially where
> timely jiffies updates may not necessarily occur on specific processors.

Huch? How about fixing those long interrupt disabled regions instead?
And honestly jiffies update being delayed for a bit is not really a
problem.

> The following sample patch presents one way that this could be done.
> Processors wait for the selected cpu to enter high resolution mode before
> they do so.

That's a horrible hack.

> Note that this patch is not hotplug aware (however, should the
> tick_static_do_timer_cpu be offlined, the tick_do_timer_cpu simply becomes
> another cpu anyway).
> 
> Comments on this idea, or the sample patch?

I still have no idea why a random assignment is so harmful. Also if
there is really a reason to make that assignment static, what about
using a sysfs file, which lets you read out the assignment and update
it in the NOHZ off case ?

Thanks,

	tglx
