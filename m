Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1KGQWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:22:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52857 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab1KGQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:22:06 -0500
Date: Mon, 7 Nov 2011 08:21:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        casteyde.christian@free.fr
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111107162159.GC13699@google.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
 <1320682230.17809.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682230.17809.11.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 07, 2011 at 05:10:29PM +0100, Peter Zijlstra wrote:
> We could move the key and name pointer to the start of the structure and
> memset everything after that, however wouldn't that leave kmemcheck with
> the same problem? It wouldn't know those two pointers would be
> initialized properly.

At that point, lockdep_map is guaranteed to have passed through
lockdep_init_map(), so I think it should be fine.

> @@ -148,9 +148,9 @@ void clear_lock_stats(struct lock_class *class);
>   * This is embedded into specific lock instances:
>   */
>  struct lockdep_map {
> +	const char			*name;
>  	struct lock_class_key		*key;
>  	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
> -	const char			*name;
>  #ifdef CONFIG_LOCK_STAT
>  	int				cpu;
>  	unsigned long			ip;

Probably fat comment explaining the ordering requirement here w/

#define LOCKDEP_MAP_INIT_OFFSET		offsetof(struct lockdep_map, class_cache)

> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index e69434b..81855cf 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2948,7 +2948,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
>  void lockdep_init_map(struct lockdep_map *lock, const char *name,
>  		      struct lock_class_key *key, int subclass)
>  {
> -	memset(lock, 0, sizeof(*lock));
> +	kmemcheck_mark_initialized(lock, 2*sizeof(void *));
> +	memset(&lock->class_cache[0], 0, sizeof(*lock)-2*sizeof(void *));

And something like the following?

	memset((void *)lock + LOCKDEP_MAP_INIT_OFFSET, 0,
		sizeof(*lock) - LOCKDEP_MAP_INIT_OFFSET);

Thanks.

-- 
tejun
