Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2BFQhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:37:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44003 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab2BFQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:37:09 -0500
X-Sasl-enc: rKns/oyPlth/A8Qa0ff+lfCfuMVLENUWdaTgjpTNLJzj 1328546228
Date: Mon, 6 Feb 2012 08:35:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/6] oom: Make find_lock_task_mm() sparse-aware
Message-ID: <20120206163542.GA10104@kroah.com>
References: <20120203163056.GA4190@redhat.com>
 <20120206162930.GA5117@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206162930.GA5117@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:29:30PM +0400, Anton Vorontsov wrote:
> This is needed so that callers would not get 'context imbalance'
> warnings from the sparse tool.
> 
> As a side effect, this patch fixes the following sparse warnings:
> 
>   CHECK   mm/oom_kill.c
>   mm/oom_kill.c:201:28: warning: context imbalance in 'oom_badness' -
>   unexpected unlock
>   include/linux/rcupdate.h:249:30: warning: context imbalance in
>   'dump_tasks' - unexpected unlock
>   mm/oom_kill.c:453:9: warning: context imbalance in 'oom_kill_task' -
>   unexpected unlock
>   CHECK   mm/memcontrol.c
>   ...
>   mm/memcontrol.c:1130:17: warning: context imbalance in
>   'task_in_mem_cgroup' - unexpected unlock
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  include/linux/oom.h |   11 ++++++++++-
>  mm/oom_kill.c       |    2 +-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 552fba9..e64bfd2 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -21,6 +21,7 @@
>  
>  #ifdef __KERNEL__
>  
> +#include <linux/compiler.h>
>  #include <linux/sched.h>
>  #include <linux/types.h>
>  #include <linux/nodemask.h>
> @@ -65,7 +66,15 @@ static inline void oom_killer_enable(void)
>  	oom_killer_disabled = false;
>  }
>  
> -extern struct task_struct *find_lock_task_mm(struct task_struct *p);
> +extern struct task_struct *__find_lock_task_mm(struct task_struct *p);
> +
> +#define find_lock_task_mm(p)						\
> +({									\
> +	struct task_struct *__ret;					\
> +									\
> +	__cond_lock(&(p)->alloc_lock, __ret = __find_lock_task_mm(p));	\
> +	__ret;								\
> +})

Please use the proper "do...while" style thing here for multi-line,
complex #defines like the rest of the kernel does so that you don't end
up debugging horrible problems later.

And I would need acks from the -mm developers before I could apply any
of this.

thanks,

greg k-h
