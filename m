Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1KHCWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 21:22:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34601 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1KHCWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 21:22:48 -0500
Date: Tue, 8 Nov 2011 10:22:38 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111108022238.GA11439@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:28:19PM +0100, Vegard Nossum wrote:
> 
> 1. Initialise the thing completely before doing the copy, or
> 2. Ignore the warning.
> 
> The memset() patch (f59de8992aa6dc85e81aadc26b0f69e17809721d) attempts
> to do the first, i.e. to clear the whole struct in lockdep_init_map().
> 
> I think nr. 1 is the best way to go in principle, but I don't know
> what it takes for this to work properly. The blanket-clear memset()
> presumably doesn't work because it clears out something that was
> already initialised by the caller (right?).
> 
> Yong Zhang, can you think of a way to avoid the race you described,
> perhaps by memset()ing only the right/relevant parts of struct
> lockdep_map in lockdep_init_map()?

That could work, but we should take more care on the member 'class_cache',
because under some condition (lock_set_subclass()) we don't need
to initialise it for performance issue, but under other condtion (
set a new valid key to a class) we need to initialise it since it's
invalid anymore.

Another option is always seting ->class_cache if lookup_lock_class()
find the class. Will talk about it with Peter in another thread.

> 
> Peter Zijlstra, if you prefer, we can also just tell kmemcheck that
> this particular copy is fine, but it means that kmemcheck will not be
> able to detect any real bugs in this code. It can be done with
> something like:
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e69434b..08a2b1b 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2948,7 +2948,7 @@ static int mark_lock(struct task_struct *curr,
> struct held_lock *this,
>  void lockdep_init_map(struct lockdep_map *lock, const char *name,
>                       struct lock_class_key *key, int subclass)
>  {
> -       memset(lock, 0, sizeof(*lock));
> +       kmemcheck_mark_initialized(lock, sizeof(*lock));
> 
>  #ifdef CONFIG_LOCK_STAT
>         lock->cpu = raw_smp_processor_id();
> 
> Christian Casteyde, do you mind testing this patch as well?
> 
> (Yong Zhang, do you think this would still be vulnerable to the race
> you described?)

No, this will work because we just retore the previous behavior except
kmemcheck annotation, right?

Thanks,
Yong
