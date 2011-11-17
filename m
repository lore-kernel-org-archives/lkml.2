Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1KQGC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 01:02:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53375 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1KQGCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 01:02:25 -0500
Date: Thu, 17 Nov 2011 14:02:15 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: tom.leiming@gmail.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lockdep: print lock name for lockdep_init_error
Message-ID: <20111117060215.GB15644@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1321508072-23853-1-git-send-email-tom.leiming@gmail.com>
 <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321508072-23853-2-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 01:34:32PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch prints the name of the lock which is acquired
> before lockdep_init is called, so that user can easily find
> which lock trigged the lockdep init error warning.

Should we care about that?

I think lockdep_init() called early enough give more hint.
Such as be the first C function called by arch.

Thanks,
Yong

> 
> This patch also removes the lockdep_init_error message
> of "Arch code didn't call lockdep_init() early enough?" since
> lockdep_init is called in arch independent code now.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/lockdep.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 4e7e672..8141317 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -430,6 +430,7 @@ unsigned int max_lockdep_depth;
>   * about it later on, in lockdep_info().
>   */
>  static int lockdep_init_error;
> +static const char *lock_init_error;
>  static unsigned long lockdep_init_trace_data[20];
>  static struct stack_trace lockdep_init_trace = {
>  	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
> @@ -651,6 +652,7 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
>  	if (unlikely(!lockdep_initialized)) {
>  		lockdep_init();
>  		lockdep_init_error = 1;
> +		lock_init_error = lock->name;
>  		save_stack_trace(&lockdep_init_trace);
>  	}
>  #endif
> @@ -3965,7 +3967,8 @@ void __init lockdep_info(void)
>  
>  #ifdef CONFIG_DEBUG_LOCKDEP
>  	if (lockdep_init_error) {
> -		printk("WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?\n");
> +		printk("WARNING: lockdep init error! lock-%s was acquired"
> +			"before lockdep_init\n", lock_init_error);
>  		printk("Call stack leading to lockdep invocation was:\n");
>  		print_stack_trace(&lockdep_init_trace, 0);
>  	}
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
