Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1KCHUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:20:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61319 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1KCHUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:20:13 -0400
Date: Thu, 3 Nov 2011 10:17:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
Message-ID: <20111103071735.GA3228@swordfish.minsk.epam.com>
References: <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com>
 <20111020190701.GB3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
 <20111020212353.GZ25124@google.com>
 <alpine.DEB.2.00.1110201425560.5552@chino.kir.corp.google.com>
 <20111020213644.GB25124@google.com>
 <20111020230040.GC3586@swordfish.minsk.epam.com>
 <alpine.DEB.2.00.1110210212130.12963@chino.kir.corp.google.com>
 <20111021094520.GA9884@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111021094520.GA9884@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/21/11 17:45), Yong Zhang wrote:
> On Fri, Oct 21, 2011 at 02:14:34AM -0700, David Rientjes wrote:
> > How does it mask the race condition?  Before the memset(), the ->name 
> > field was never _cleared_ in lockdep_init_map() like it is now, it was 
> > only stored.
> 
> A typcal race condition will like this:
> 
> 	CPU A					CPU B
> lock_set_subclass(lockA);
>   lock_set_class(lockA);
>     lockdep_init_map(lockA);
>       /* lockA->name is cleared */
>       memset(lockA);
> 					__lock_acquire(lockA);
> 					  /* lockA->class_cache[] is cleared */
> 					  register_lock_class(lockA);
> 					    look_up_lock_class(lockA);
> 					      WARN_ON_ONCE(class->name !=
> 							lock->name);
> 
>       lock->name = name;
> 
> And a untested patch is below:
> BTW, now the patch could cure (I guess) the very issue reported
> in this thread.
> But it don't cover the case which change the key and the relevant
> lock_class has existed, I don't think out a way how to fix it yet :)
> But the fact is we have no such caller yet, the only call site of
> lock_set_subclass() is double_unlock_balance().
> 

Hello,
Any news on this patch? Do you like it or hate it? With recent kernels
I'm able to hit this problem more often (several time a day) so if any
testing is required I'm willing to help.


	Sergey

> 
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] lockdep: On-demand initialization for lock_set_class()
> 
> Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
> lockdep_init_map() will clear all the struct. But it will break
> lock_set_class()/lock_set_subclass(). A typical race condition
> is like below:
> 
> 	CPU A					CPU B
> lock_set_subclass(lockA);
>   lock_set_class(lockA);
>     lockdep_init_map(lockA);
>       /* lockA->name is cleared */
>       memset(lockA);
> 					__lock_acquire(lockA);
> 					  /* lockA->class_cache[] is cleared */
> 					  register_lock_class(lockA);
> 					    look_up_lock_class(lockA);
> 					      WARN_ON_ONCE(class->name !=
> 							lock->name);
> 
>       lock->name = name;
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/lockdep.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 91d67ce..bc7dd1e 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -3160,7 +3160,10 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
>  	return print_unlock_inbalance_bug(curr, lock, ip);
>  
>  found_it:
> -	lockdep_init_map(lock, name, key, 0);
> +	/* only changing lock->name make no sense */
> +	WARN_ON(lock->key == key && lock->name != name);
> +	if (lock->key != key)
> +		lockdep_init_map(lock, name, key, 0);
>  	class = register_lock_class(lock, subclass, 0);
>  	hlock->class_idx = class - lock_classes + 1;
>  
> -- 
> 1.7.5.4
> 
> 
