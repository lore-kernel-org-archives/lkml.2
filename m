Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1KHJhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:37:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33505 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1KHJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:37:49 -0500
Date: Tue, 8 Nov 2011 17:37:41 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111108093741.GB4038@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
 <20111108025847.GB11439@zhy>
 <1320739015.2244.0.camel@twins>
 <20111108081433.GA3746@zhy>
 <1320741980.2244.4.camel@twins>
 <20111108090735.GA4038@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111108090735.GA4038@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 05:07:35PM +0800, Yong Zhang wrote:
> On Tue, Nov 08, 2011 at 09:46:20AM +0100, Peter Zijlstra wrote:
> > On Tue, 2011-11-08 at 16:14 +0800, Yong Zhang wrote:
> > > 
> > > But how do we deal with ->class_cache? Always set it in
> > > loop_up_lock_class()? 
> > 
> > Hrm.. good point, aside from that there's another problem as well, I
> > think we can deal with the cache being NULL, but is memset() an atomic
> > write? If not a read could observe an intermediate state and go funny.
> 
> Yup.
> 
> > 
> > I'm tempted to go with the pure kmemcheck_mark_initialized() thing for
> > now.
> 
> me too :)
> 
> So something like below?
> 
> Thanks,
> Yong
> ---
> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH] lockdep: kmemcheck: annotate ->lock in lockdep_init_map()
> 
> Since commit f59de89 [lockdep: Clear whole lockdep_map on initialization],
> lockdep_init_map() will clear all the struct. But it will break
> lock_set_class()/lock_set_subclass(). A typical race condition
> is like below:
> 
>      CPU A                                   CPU B
> lock_set_subclass(lockA);
>  lock_set_class(lockA);
>    lockdep_init_map(lockA);
>      /* lockA->name is cleared */
>      memset(lockA);
>                                      __lock_acquire(lockA);
>                                        /* lockA->class_cache[] is cleared */
>                                        register_lock_class(lockA);
>                                          look_up_lock_class(lockA);
>                                            WARN_ON_ONCE(class->name !=
>                                                      lock->name);
> 
>      lock->name = name;
> 
> So annotate ->lock with kmemcheck_mark_initialized() to cure this problem
> and the one reported in commit f59de89.
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Suggested-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> ---
>  kernel/lockdep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e69434b..08a2b1b 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2948,7 +2948,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
>  void lockdep_init_map(struct lockdep_map *lock, const char *name,
>  		      struct lock_class_key *key, int subclass)
>  {
> -	memset(lock, 0, sizeof(*lock));
> +	kmemcheck_mark_initialized(lock, sizeof(*lock));

But for a lock in initializing stage (like spin_lock_init()), we still
need to guarantee that lock->class_cache[] doesn't contain garbage.

Need more thought here.

Thanks,
Yong

>  
>  #ifdef CONFIG_LOCK_STAT
>  	lock->cpu = raw_smp_processor_id();
> -- 
> 1.7.5.4
> 

-- 
Only stand for myself
