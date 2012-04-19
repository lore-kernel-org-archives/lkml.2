Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2DSIaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:30:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:38027 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2DSIaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:30:01 -0400
Date: Thu, 19 Apr 2012 10:29:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, mingo@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, svenjoac@gmx.de, rjw@sisk.pl,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Fix oneshot broadcast setup really
In-Reply-To: <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
Message-ID: <alpine.LFD.2.02.1204191028510.2542@ionos>
References: <alpine.LFD.2.02.1204181205540.2542@ionos>  <tip-b435092f70ec5ebbfb6d075d5bf3c631b49a51de@git.kernel.org>  <CAMQu2gx4-4kbgEHXUbU0SR=Xj6pe5FxjYJJ_dZD5D=jZs7f03A@mail.gmail.com>  <4F8ECD39.3080900@ti.com> <alpine.LFD.2.02.1204181723350.2542@ionos>
 <1334802459.28674.209.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Suresh Siddha wrote:
> On Wed, 2012-04-18 at 17:31 +0200, Thomas Gleixner wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: tick: Fix the spurious broadcast timer ticks
> 
> During resume, tick_resume_broadcast() programs the broadcast timer
> in oneshot mode unconditionally. On the platforms where broadcast timer
> is not really required, this will generate spurious broadcast timer ticks
> upon resume. For example, on the always running apic timer platforms with
> HPET, I see spurious hpet tick once every ~5minutes (which is the 32-bit
> hpet counter wraparound time).
> 
> Similar to boot time, during resume make the oneshot mode setting of
> the broadcast clock event device conditional on the state of active broadcast
> users. 
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Sven, Santosh, can you confirm that this works for you on top of the
other two patches?

> ---
>  kernel/time/tick-broadcast.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index bf57abd..766cd82 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -346,7 +346,8 @@ int tick_resume_broadcast(void)
>  						     tick_get_broadcast_mask());
>  			break;
>  		case TICKDEV_MODE_ONESHOT:
> -			broadcast = tick_resume_broadcast_oneshot(bc);
> +			if (!cpumask_empty(tick_get_broadcast_mask()))
> +				broadcast = tick_resume_broadcast_oneshot(bc);
>  			break;
>  		}
>  	}
> 
> 
> 
