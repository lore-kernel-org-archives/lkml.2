Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0IUPfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:35:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:52738 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757519Ab0IUPfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:35:36 -0400
Message-ID: <4C98D0EB.30002@kernel.org>
Date: Tue, 21 Sep 2010 17:36:11 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 15:34:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/21/2010 04:20 PM, Heiko Carstens wrote:
> For some reason the scheduler decided to throttle RT tasks on the runqueue
> of cpu 5 (rt_throttled = 1). So as long as rt_throttled == 1 we won't see the
> migration thread coming back to execution.
> The only thing that would unthrottle the runqueue would be the rt_period_timer.
> The timer is indeed scheduled, however in the dump I have it has been expired
> for more than four hours.
> The reason is simply that the timer is pending on the offlined cpu 0 and
> therefore would never fire before it gets migrated to an online cpu. Before
> the cpu hotplug mechanisms (cpu hotplug notifier with state CPU_DEAD) would
> migrate the timer to an online cpu stop_machine() must complete ---> deadlock.
> 
> The fix _seems_ to be simple: just migrate timers after __cpu_disable() has
> been called and use the CPU_DYING state. The subtle difference is of course
> that the migration code now gets executed on the cpu that actually just is
> going to disable itself instead of an arbitrary cpu that stays online.

I think this is the second time we're seeing deadlock during cpu down
due to RT throttling and timer problem.  The rather delicate
dependency there makes me somewhat nervous.  If possible, I think it
would be better if we can simply turn the RT throttling off when
cpu_stop kicks in.  It's intended to be a mechanism to monopolize all
CPU cycles to begin with.  Would that be difficult?

Thanks.

-- 
tejun
