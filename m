Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0E0Wkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:40:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34003 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab0E0WkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CrteGs5OSowq3qsqV8Jv3IwLBcblIiay9qfqoitrb/c5SRw4+5pVyYiJgqhKBP4Uc8
         AZoiKLvnkf9LuqtuaZdgWuVW41lCzpo3p17iat+ANGP4coCFkpGAOLjSWRjk8UgJFKoj
         yopkCLmtj/klxOApd7xm5LhsQCKt9Ys3Sgdcg=
Date: Fri, 28 May 2010 00:40:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH]: mutex: Fix !CONFIG_MUTEX_SPIN_ON_OWNER compile warning
Message-ID: <20100527224022.GE5390@nowhere>
References: <20100527190336.24665.22701.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100527190336.24665.22701.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 03:07:40PM -0400, Prarit Bhargava wrote:
> Fixes linux-next !CONFIG_MUTEX_SPIN_ON_OWNER compile warning:
> 
> kernel/mutex.c: In function ‘__mutex_lock_common’:
> kernel/mutex.c:148: error: unused variable ‘timeout’
> 
> timeout is only used if CONFIG_MUTEX_SPIN_ON_OWNER is on.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 7d4626b..c262942 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -145,7 +145,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
>  	unsigned long flags;
> +#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>  	unsigned long timeout;
> +#endif
>  
>  	preempt_disable();
>  	mutex_acquire(&lock->dep_map, subclass, 0, ip);



In fact the situation is a bit more complicated.

There are two things that are related to this build warning:

- the lock inversion prevention against the bkl
- the timeout for other purposes, basically to limit too long spins

And the lock inversion fix needs to be standalone because it should
be backported to the stable branches.

So it seems that the plans are more:

1) have a clean patch that only prevents from the bkl lock inversion
2) thinking about the timeout, may be find something better if we can

All in one, I suspect these patches will be refactored rather than
improved incrementally, to make the backport of 1) easier.

So the warning issue will probably disappear in the meantime.

