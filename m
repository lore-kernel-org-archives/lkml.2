Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0KNBhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 20:37:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0KNBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 20:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dqHtHvvBORhnFSazyNjcMhMViHXUvtOpfRcl86mPhaqk6aiCPOIMy6CNNeA17lieET
         WAbbMtghIrK8fNkzUXng==
Date: Sat, 13 Nov 2010 17:37:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj
 down
In-Reply-To: <20101113004657.GN7363@google.com>
Message-ID: <alpine.DEB.2.00.1011131735240.27212@chino.kir.corp.google.com>
References: <20101111043541.GA4588@google.com> <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com> <20101111183050.GI7363@google.com> <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com> <20101111222509.GJ7363@google.com>
 <alpine.DEB.2.00.1011111511570.3775@chino.kir.corp.google.com> <20101111235620.GK7363@google.com> <20101113004657.GN7363@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Mandeep Singh Baines wrote:

> We'd like to be able to oom_score_adj a process up/down as its
> enters/leaves the foreground. Currently, it is not possible to oom_adj
> down without CAP_SYS_RESOURCE. This patch allows a task to decrease
> its oom_score_adj back to the value that a CAP_SYS_RESOURCE thread set
> it or its inherited value at fork. Assuming the thread that has forked
> it has oom_score_adj of 0, each tab could decrease it back from 0 upon
> activation unless a CAP_SYS_RESOURCE thread elevated it to something
> higher.
> 

oom_score_adj_min doesn't appear to be inherited at fork in your patch.

> Alternative considered:
> 
> * a setuid binary
> * a daemon with CAP_SYS_RESOURCE
> 
> Since you don't wan't all processes to be able to reduce their
> oom_adj, a setuid or daemon implementation would be complex. The
> alternatives also have much higher overhead.
> 

This behavior should be documented in Documentation/filesystems/proc.txt.

> This patch updated based on feedback from
> David Rientjes <rientjes@google.com>.
> 
> Change-Id: If8f52363fd6c156e1730f43148aee987260e9c72

I know what a Change-Id is , but nobody else here does :)

> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> ---
>  fs/proc/base.c        |    4 +++-
>  include/linux/sched.h |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f3d02ca..e617413 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1164,7 +1164,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>  		goto err_task_lock;
>  	}
>  
> -	if (oom_score_adj < task->signal->oom_score_adj &&
> +	if (oom_score_adj < task->signal->oom_score_adj_min &&
>  			!capable(CAP_SYS_RESOURCE)) {
>  		err = -EACCES;
>  		goto err_sighand;
> @@ -1177,6 +1177,8 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>  			atomic_dec(&task->mm->oom_disable_count);
>  	}
>  	task->signal->oom_score_adj = oom_score_adj;
> +	if (capable(CAP_SYS_RESOURCE))
> +		task->signal->oom_score_adj_min = oom_score_adj;
>  	/*
>  	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
>  	 * always attainable.
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f53cdf2..2a71ee0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -626,6 +626,8 @@ struct signal_struct {
>  
>  	int oom_adj;		/* OOM kill score adjustment (bit shift) */
>  	int oom_score_adj;	/* OOM kill score adjustment */
> +	int oom_score_adj_min;	/* OOM kill score adjustment minimum value.
> +				 * Only settable by CAP_SYS_RESOURCE. */
>  
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
