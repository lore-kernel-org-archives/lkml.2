Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0FXNLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:11:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0FXNLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:11:46 -0400
Subject: Re: [PATCH] fix problem with reschenduling in rest_init
 (2.6.35-rc3)
From: Peter Zijlstra <peterz@infradead.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100624001148.61e9da1c.isloginov@gmail.com>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 15:11:36 +0200
Message-ID: <1277385096.1875.974.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 00:11 +0400, Ilya Loginov wrote:
> 	There is a bug in rest_init function. The problem is that kernel_init
> thread starts before initialization of kthreadd_task when
> CONFIG_PREEMPT_VOLUNTARY is enabled.
> 
> kernel_init thread do wake_up_process(kthreadd_task) and I have kernel Oops in
> try_to_wake_up when I try to get p->state.
> 
> 	I found this problem on 2.6.34 on FPGA. It is very slow, and
> find_task_by_pid is done after reschenduling. I have no this problem on
> 2.6.35-rc3 because kernel code is moved. But if I write simple loop like
> 	volatile int tmp;
> 	for(i = 0; i < preset_lpj; i++)
> 		tmp++;
> right after kernel_thread(kernel_init,.... , I have this problem on
> 2.6.35-rc3 too.
> 
> 	I understand that real problem is reschenduling in init code, but
> I have no ability to fix it.

Ooh, interesting problem, so kernel_init() will indeed spawn all kinds
of kernel threads, and doing so before we create the kthreadd will
result in the oops you observed.

However I suspect the ordering is like it is because we want init to
have pid 1, if we were to re-order like you suggest kthreadd will end up
with pid 1 and init with pid 2.

Humm, how to fix this...

> Signed-off-by: Ilya Loginov <isloginov@gmail.com>
> ---
> diff --git a/init/main.c b/init/main.c
> index 3bdb152..9febd69 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -428,12 +428,12 @@ static noinline void __init_refok rest_init(void)
>  	int pid;
>  
>  	rcu_scheduler_starting();
> -	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>  	rcu_read_lock();
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
>  	rcu_read_unlock();
> +	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	unlock_kernel();
>  
>  	/*

