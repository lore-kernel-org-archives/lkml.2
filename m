Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0F1OTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:19:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab0F1OTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:19:38 -0400
Date: Mon, 28 Jun 2010 16:19:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ilya Loginov <isloginov@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix race between init and kthreadd -v2
Message-ID: <20100628141927.GA9306@elte.hu>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
 <1277385096.1875.974.camel@laptop>
 <20100624172334.ca7e9bef.isloginov@gmail.com>
 <1277715689.1875.1104.camel@laptop>
 <1277725997.3561.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277725997.3561.6.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3495]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> +static __initdata DEFINE_MUTEX(kthreadd_lock);

> +	/*
> +	 * We need to spawn init first so that it obtains pid-1, however
> +	 * the init task will end up wanting to create kthreads, which
> +	 * if we schedule it before we create kthreadd, will OOPS.
> +	 */
> +	mutex_lock(&kthreadd_lock);
>  	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>  	rcu_read_lock();
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
>  	rcu_read_unlock();
> +	mutex_unlock(&kthreadd_lock);
>  	unlock_kernel();
>  
>  	/*
> @@ -847,6 +856,13 @@ static noinline int init_post(void)
>  
>  static int __init kernel_init(void * unused)
>  {
> +	/*
> +	 * We spawned this thread while holding this lock, ensure the
> +	 * locked section in rest_init() is complete before proceeding.
> +	 */
> +	mutex_lock(&kthreadd_lock);
> +	mutex_unlock(&kthreadd_lock);

I think you may be using a mutex as a completion in essence. Why not use 
completions instead?

	Ingo
