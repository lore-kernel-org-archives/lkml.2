Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0FJGtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:49:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0FJGtG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:49:06 -0400
Subject: Re: [tip:sched/core] sched: Fix capacity calculations for SMT4
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <12629.1276124617@neuling.org>
References: <20100608045702.21D03CC895@localhost.localdomain>
	 <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org>
	 <12629.1276124617@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 08:48:56 +0200
Message-ID: <1276152536.2046.2479.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 09:03 +1000, Michael Neuling wrote:
> Peter,
> 
> It looks like when this was pushed to Ingo, some of the logic was
> changed.  rt_freq_influence() became fix_small_capacity() but the return
> values for these two functions are opposite (return 1 => return 0 and
> visa versa]]).
> 
> This was changed in the sibling test (return 1 => return 0), but the
> check for the change in cpu power due to freq and rt was not.
> 
> So either the return values need to be changed at the end of
> fix_small_capacity() or the cpu_power test needs to be the other way
> around.  Below changes the cpu_power test as it brings it more inline
> with the comment above it.
> 
> Without this the asymmetric packing doesn't work.

D'oh fully my fault for cleaning up.

Thanks, I'll make sure it gets fixed.

> Subject: sched: fix the CPU power test for fix_small_capacity
> 
> The CPU power test is the wrong way around in fix_small_capacity.
> 
> This was due to a small changes made in the posted patch on lkml to what
> was was taken upstream.
> 
> This patch fixes asymmetric packing for POWER7.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> Index: linux-2.6-ozlabs/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> +++ linux-2.6-ozlabs/kernel/sched_fair.c
> @@ -2354,7 +2354,7 @@ fix_small_capacity(struct sched_domain *
>  	/*
>  	 * If ~90% of the cpu_power is still there, we're good.
>  	 */
> -	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
> +	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
>  		return 1;
>  
>  	return 0;
> 

