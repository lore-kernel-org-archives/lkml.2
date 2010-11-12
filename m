Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0KLRkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:40:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0KLRkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:40:22 -0500
Date: Fri, 12 Nov 2010 18:34:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] ioprio: grab rcu_read_lock in sys_ioprio_{set,get}()
Message-ID: <20101112173400.GA8659@redhat.com>
References: <1289547167-32675-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289547167-32675-1-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Greg Thelen wrote:
>
> The fix is to:
> a) grab rcu lock in sys_ioprio_{set,get}() and
> b) avoid grabbing tasklist_lock.
> Discussion in: http://marc.info/?l=linux-kernel&m=128951324702889
>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

> ---
>  fs/ioprio.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ioprio.c b/fs/ioprio.c
> index 748cfb9..7da2a06 100644
> --- a/fs/ioprio.c
> +++ b/fs/ioprio.c
> @@ -103,12 +103,7 @@ SYSCALL_DEFINE3(ioprio_set, int, which, int, who, int, ioprio)
>  	}
>  
>  	ret = -ESRCH;
> -	/*
> -	 * We want IOPRIO_WHO_PGRP/IOPRIO_WHO_USER to be "atomic",
> -	 * so we can't use rcu_read_lock(). See re-copy of ->ioprio
> -	 * in copy_process().
> -	 */
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	switch (which) {
>  		case IOPRIO_WHO_PROCESS:
>  			if (!who)
> @@ -153,7 +148,7 @@ free_uid:
>  			ret = -EINVAL;
>  	}
>  
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  	return ret;
>  }
>  
> @@ -197,7 +192,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
>  	int ret = -ESRCH;
>  	int tmpio;
>  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	switch (which) {
>  		case IOPRIO_WHO_PROCESS:
>  			if (!who)
> @@ -250,6 +245,6 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
>  			ret = -EINVAL;
>  	}
>  
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  	return ret;
>  }
> -- 
> 1.7.3.1
> 

