Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab0F1Q0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:26:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53291 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0F1Q0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:26:06 -0400
Date: Mon, 28 Jun 2010 09:23:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ilya Loginov <isloginov@gmail.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix race between init and kthreadd -v3
Message-Id: <20100628092341.5b011a0a.randy.dunlap@oracle.com>
In-Reply-To: <1277736661.3561.110.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
	<20100624172334.ca7e9bef.isloginov@gmail.com>
	<1277715689.1875.1104.camel@laptop>
	<1277725997.3561.6.camel@laptop>
	<20100628141927.GA9306@elte.hu>
	<1277736661.3561.110.camel@laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C28CD02.0254:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010 16:51:01 +0200 Peter Zijlstra wrote:

> On Mon, 2010-06-28 at 16:19 +0200, Ingo Molnar wrote:
> 
> > I think you may be using a mutex as a completion in essence. Why not use 
> > completions instead?
> 
> Totally forgot about those things.. Yes they fit perfectly.
> 
> ---
> Subject: init: Fix race between init and kthreadd -v2
> 
> Ilya reported that on a very slow machine he could reliably reproduce a
> race between forking init and kthreadd. We first fork init so that it 
> obtains pid-1, however since the scheduler is already fully running at
> this point it can preempt and run the init thread before we spawn and
> set kthreadd_task.
> 
> The init thread can then attempt spawning kthreads without kthreadd
> being present which results in an OOPS.
> 
> Reported-by: Ilya Loginov <isloginov@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  init/main.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index e2a2bf3..2280f63 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -420,18 +420,26 @@ static void __init setup_command_line(char *command_line)
>   * gcc-3.4 accidentally inlines this function, so use noinline.
>   */
>  
> +static __initdata DECLARE_COMPLETION(kthreadd_done);
> +
>  static noinline void __init_refok rest_init(void)
>  	__releases(kernel_lock)
>  {
>  	int pid;
>  
>  	rcu_scheduler_starting();
> +	/*
> +	 * We need to spawn init first so that it obtains pid-1, however

Would be better to say "pid 1" or "pid=1".
"pid-1" seems odd to me.


> +	 * the init task will end up wanting to create kthreads, which, if
> +	 * we schedule it before we create kthreadd, will OOPS.
> +	 */
>  	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>  	rcu_read_lock();
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
>  	rcu_read_unlock();
> +	complete(&kthreadd_done);
>  	unlock_kernel();
>  
>  	/*
> @@ -847,6 +855,10 @@ static noinline int init_post(void)
>  
>  static int __init kernel_init(void * unused)
>  {
> +	/*
> +	 * Wait until kthreadd is all set-up.
> +	 */
> +	wait_for_completion(&kthreadd_done);
>  	lock_kernel();
>  
>  	/*
> 
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
