Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0LAMUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:20:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49741 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0LAMUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:20:14 -0500
Subject: Re: [patch 3/3] nohz/s390: fix arch_needs_cpu() return value on
 offline cpus
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>, stable@kernel.org
In-Reply-To: <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
	 <20101126120235.738301376@de.ibm.com> <1290773647.2145.140.camel@laptop>
	 <20101201091109.GA8984@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 13:19:09 +0100
Message-ID: <1291205949.32004.1398.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 10:11 +0100, Heiko Carstens wrote:
> 
> Subject: [PATCH] nohz: fix get_next_timer_interrupt() vs cpu hotplug
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This fixes a bug as seen on 2.6.32 based kernels where timers got enqueued
> on offline cpus.
> 
> If a cpu goes offline it might still have pending timers. These will be
> migrated during CPU_DEAD handling after the cpu is offline.
> However while the cpu is going offline it will schedule the idle task
> which will then call tick_nohz_stop_sched_tick().
> That function in turn will call get_next_timer_intterupt() to figure out
> if the tick of the cpu can be stopped or not. If it turns out that the
> next tick is just one jiffy off (delta_jiffies == 1)
> tick_nohz_stop_sched_tick() incorrectly assumes that the tick should not
> stop and takes an early exit and thus it won't update the load balancer
> cpu.
> Just afterwards the cpu will be killed and the load balancer cpu could
> be the offline cpu.
> On 2.6.32 based kernel get_nohz_load_balancer() gets called to decide on
> which cpu a timer should be enqueued (see __mod_timer()). Which leads
> to the possibility that timers get enqueued on an offline cpu. These will
> never expire and can cause a system hang.
> 
> This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
> get_nohz_timer_target() which doesn't have that problem. However there might
> be other problems because of the too early exit tick_nohz_stop_sched_tick()
> in case a cpu goes offline.
> 
> The easiest and probably safest fix seems to be to let
> get_next_timer_interrupt() just lie and let it say there isn't any pending
> timer if the current cpu is offline.
> I also thought of moving migrate_[hr]timers() from CPU_DEAD to CPU_DYING,
> but seeing that there already have been fixes at least in the hrtimer code
> in this area I'm afraid that this could add new subtle bugs.
> 
> Cc: stable@kernel.org
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> --- 

Thanks Heiko, I queued this one as well.
