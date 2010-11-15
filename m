Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0KOWG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:06:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab0KOWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XsALvaIcR8zVR75LqbI5Pghy5svdbWEPMnjNn1ccUbUuJC4DQgMlisuR9e1Frp04/N
         YfKDECfIk++dcbPRPw5A==
Date: Mon, 15 Nov 2010 14:06:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH v2] oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj
 down
In-Reply-To: <20101115220150.GR7363@google.com>
Message-ID: <alpine.DEB.2.00.1011151404080.17082@chino.kir.corp.google.com>
References: <20101111043541.GA4588@google.com> <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com> <20101111183050.GI7363@google.com> <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com> <20101111222509.GJ7363@google.com>
 <alpine.DEB.2.00.1011111511570.3775@chino.kir.corp.google.com> <20101111235620.GK7363@google.com> <20101113004657.GN7363@google.com> <alpine.DEB.2.00.1011131735240.27212@chino.kir.corp.google.com> <20101115220150.GR7363@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Mandeep Singh Baines wrote:

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

This should be has_capability_noaudit(current, CAP_SYS_RESOURCE) instead, 
we don't want an audit message to be emitted when checking if 
oom_score_adj_min should be set.

Other than that:

Acked-by: David Rientjes <rientjes@google.com>
