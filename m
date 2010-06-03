Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab0FCBIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:08:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873Ab0FCBH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:07:58 -0400
X-Authority-Analysis: v=1.1 cv=DT5lrGikL/lNZzMKzbmp3iVCACewI9NZ3q1CIi1KGbI= c=1 sm=0 a=YdTYFX7fcrAA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=BNBCL7ZmXDo9X6TOmqIA:9 a=Z297bneFejyi61UtlMoA:7 a=VdxQ55IkDHpgXThGpATEz6ldjbQA:4 a=PUjeQqilurYA:10 a=JTMqrY5UvyEA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC 2/5] BKL: remove the BKL from kernel init code
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <1275523999-27462-3-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
	 <1275523999-27462-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 02 Jun 2010 21:07:55 -0400
Message-ID: <1275527275.15884.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 02:13 +0200, Arnd Bergmann wrote:
> I have shown by code review that no driver takes
> the BKL at init time any more, so whatever the
> init code was locking against is no longer there
> and it is now safe to remove the BKL there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  init/main.c          |    5 -----
>  kernel/trace/trace.c |    8 --------
>  2 files changed, 0 insertions(+), 13 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 3bdb152..81821e1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -434,7 +434,6 @@ static noinline void __init_refok rest_init(void)
>  	rcu_read_lock();
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
>  	rcu_read_unlock();
> -	unlock_kernel();
>  
>  	/*
>  	 * The boot idle thread must execute schedule()
> @@ -555,7 +554,6 @@ asmlinkage void __init start_kernel(void)
>   * Interrupts are still disabled. Do necessary setups, then
>   * enable them
>   */
> -	lock_kernel();
>  	tick_init();
>  	boot_cpu_init();
>  	page_address_init();
> @@ -819,7 +817,6 @@ static noinline int init_post(void)
>  	/* need to finish all async __init code before freeing the memory */
>  	async_synchronize_full();
>  	free_initmem();
> -	unlock_kernel();
>  	mark_rodata_ro();
>  	system_state = SYSTEM_RUNNING;
>  	numa_default_policy();
> @@ -855,8 +852,6 @@ static noinline int init_post(void)
>  
>  static int __init kernel_init(void * unused)
>  {
> -	lock_kernel();
> -
>  	/*
>  	 * init can allocate pages on any node
>  	 */
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 086d363..8047ca5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -734,13 +734,6 @@ __acquires(kernel_lock)
>  		return -1;
>  	}
>  
> -	/*
> -	 * When this gets called we hold the BKL which means that
> -	 * preemption is disabled. Various trace selftests however
> -	 * need to disable and enable preemption for successful tests.
> -	 * So we drop the BKL here and grab it after the tests again.
> -	 */
> -	unlock_kernel();

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  	mutex_lock(&trace_types_lock);
>  
>  	tracing_selftest_running = true;
> @@ -822,7 +815,6 @@ __acquires(kernel_lock)
>  #endif
>  
>   out_unlock:
> -	lock_kernel();
>  	return ret;
>  }
>  


