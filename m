Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1ITJQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:16:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:53068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1ITJQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:16:23 -0400
Subject: Re: [PATCH 3/4] perf_events: Support a lock_parent event flag
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Tue, 20 Sep 2011 11:16:00 +0200
In-Reply-To: <1316127412-1912-3-git-send-email-andi@firstfloor.org>
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
	 <1316127412-1912-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316510160.11841.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 15:56 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a new lock_parent flag to the event attribute. When it is set
> account spinlocks to the parent.  This is similar to how oprofile
> behaves on x86. This just reuses the oprofile code for this.
> 
> The main advantage is that it allows to make more sense of locking
> problems without requiring full callgraphs.
> 
> Right now only implemented on x86.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    3 +++
>  include/linux/perf_event.h       |    3 ++-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 373a614..f2caa6e 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1933,6 +1933,9 @@ unsigned long perf_instruction_pointer(struct pt_regs *regs,
>  	else
>  		ip = instruction_pointer(regs);
>  
> +	if (event->attr.lock_parent)
> +		ip = __profile_pc(ip, regs);
> +
>  	return ip;
>  }
>  
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index f8b93ec..51da085 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -219,8 +219,9 @@ struct perf_event_attr {
>  				precise_ip     :  2, /* skid constraint       */
>  				mmap_data      :  1, /* non-exec mmap data    */
>  				sample_id_all  :  1, /* sample_type all events */
> +				lock_parent    :  1, /* count locks in parent */
>  

This all just sucks horridly. So this name tells us we need inherited
counters so that whenever we encounter a lock it will be accounted in
the parent process, or whatever -- which doesn't make any sense.

Furthermore, the sole reason you want this is because you don't want
callchains, supposedly because they're too expensive, but then you don't
say that.

How about you provide means of limiting the callchain depth, and then
frob the in_lock_function() and unwind 1 crap in userspace?
