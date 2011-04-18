Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1DRNhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:37:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35978 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1DRNhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dqYpB/fGkfC0OSjdIcyfG1RVPghuanr3s+vAfSSJWZdXCkSrroGRBUfEGIhL+zK+wF
         4ni/ONa6RC6DvkVbTSnkFDG7ytiEo3wLXU+83IPditKwDsKaUn6+nQLsErhZ/u/pfU4g
         9B2FlCm4J8TPqjheDdpzy1l2ODmwyK/FGdaM8=
Date: Mon, 18 Apr 2011 21:37:38 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 6/7] lockdep: Maintain rw_state entries in locklist
Message-ID: <20110418133738.GB2080@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110417094505.865828233@chello.nl>
 <20110417095507.318610186@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110417095507.318610186@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 11:45:11AM +0200, Peter Zijlstra wrote:
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> The dependencies are currently maintained using a structure named
> locklist. For a dependency A --> B, it saves B's lock_class in an
> entry that would be linked to A's locks_after list.
> 
> However, in order to make use of the split chains introduced in the
> previous patch, we need to enhance this infrastructure to save the
> read/write states of A and B for each dependency such that we might
> distinguish between the read and write chains.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/lockdep.h |    6 ++++++
>  kernel/lockdep.c        |   23 +++++++++++++++++------
>  2 files changed, 23 insertions(+), 6 deletions(-)
>
> @@ -1690,6 +1694,8 @@ check_prev_add(struct task_struct *curr,
>  		if (entry->dep_class == hlock_class(next)) {
>  			if (distance == 1)
>  				entry->distance = 1;
> +			entry->this_lock_rw_state |= prev->rw_state;
> +			entry->dep_lock_rw_state |= next->rw_state;

If we could do this and return,

>  			return 2;
>  		}
>  	}
> @@ -1697,19 +1703,24 @@ check_prev_add(struct task_struct *curr,
>  	if (!trylock_loop && !save_trace(&trace))
>  		return 0;
>  
> +	list_for_each_entry(entry, &hlock_class(next)->locks_before, entry) {
> +		if (entry->dep_class == hlock_class(prev)) {
> +			entry->this_lock_rw_state |= next->rw_state;
> +			entry->dep_lock_rw_state |= prev->rw_state;
> +		}
> +	}
> +

Do we have any change to do above?

Or am I missing something?

Thanks,
Yong
