Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2FZREX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:04:23 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:60084 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2FZREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:04:21 -0400
Date: Tue, 26 Jun 2012 17:04:57 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-ID: <20120626170457.GA31175@mail.hallyn.com>
References: <20120626120425.GA10275@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626120425.GA10275@otc-wbsnb-06>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
> Hi,
> 
> Patch to move kern_unmount() out of exit_group() code path is below.
> Dmitry, could you check if it's beneficial for your use-case?

Hi,

sorry, I don't seem to have the thread handy for contest.  What is the
point of this?  The work being moved was not being done under lock,
so what is this meant to gain?

> Results are not that impressive. Microbenchmark:
> 
> #define _GNU_SOURCE
> #include <unistd.h>
> #include <sched.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> 
> int main(int argc, char *argv[])
> {
>         int i;
> 
>         for (i = 0; i < 1000; i++) {
>                 if (fork())
>                         continue;
> 
>                 unshare(CLONE_NEWIPC);
>                 exit(0);
>         }
> 
>         while (wait(NULL) > 0)
>                 ;
> 
>         return 0;
> }
> 
> Before:
> 
>  Performance counter stats for './test' (10 runs):
> 
>        2645.849247 task-clock                #    3.203 CPUs utilized            ( +-  3.43% )
>              2,375 context-switches          #    0.001 M/sec                    ( +-  0.35% )
>              1,579 CPU-migrations            #    0.001 M/sec                    ( +-  0.90% )
>             37,516 page-faults               #    0.014 M/sec                    ( +-  0.44% )
>      5,739,887,800 cycles                    #    2.169 GHz                      ( +-  3.50% ) [84.21%]
>      5,126,092,712 stalled-cycles-frontend   #   89.31% frontend cycles idle     ( +-  3.78% ) [84.47%]
>      3,779,607,146 stalled-cycles-backend    #   65.85% backend  cycles idle     ( +-  4.06% ) [68.26%]
>      1,210,768,660 instructions              #    0.21  insns per cycle
>                                              #    4.23  stalled cycles per insn  ( +-  1.01% ) [86.28%]
>        213,318,802 branches                  #   80.624 M/sec                    ( +-  1.16% ) [84.49%]
>          2,417,038 branch-misses             #    1.13% of all branches          ( +-  0.70% ) [84.55%]
> 
>        0.826165497 seconds time elapsed                                          ( +-  1.26% )
> 
> After:
> 
>  Performance counter stats for './test' (10 runs):
> 
>        4248.846649 task-clock                #    6.370 CPUs utilized            ( +- 13.50% )
>              2,343 context-switches          #    0.001 M/sec                    ( +-  1.51% )
>              1,624 CPU-migrations            #    0.000 M/sec                    ( +-  2.53% )
>             37,416 page-faults               #    0.009 M/sec                    ( +-  0.41% )
>      9,314,096,247 cycles                    #    2.192 GHz                      ( +- 13.64% ) [83.75%]
>      8,482,679,429 stalled-cycles-frontend   #   91.07% frontend cycles idle     ( +- 14.46% ) [83.79%]
>      5,807,497,239 stalled-cycles-backend    #   62.35% backend  cycles idle     ( +- 14.79% ) [67.65%]
>      1,556,594,531 instructions              #    0.17  insns per cycle
>                                              #    5.45  stalled cycles per insn  ( +-  5.41% ) [85.00%]
>        282,682,358 branches                  #   66.532 M/sec                    ( +-  5.56% ) [84.32%]
>          2,610,583 branch-misses             #    0.92% of all branches          ( +-  4.42% ) [83.90%]
> 
>        0.667023551 seconds time elapsed                                          ( +- 12.10% )
> 
> Any thoughts if it makes sense?
> 
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 5499c92..1a4cfd8 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -67,6 +67,8 @@ struct ipc_namespace {
>  
>  	/* user_ns which owns the ipc ns */
>  	struct user_namespace *user_ns;
> +
> +	struct work_struct free_ns_work;
>  };
>  
>  extern struct ipc_namespace init_ipc_ns;
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index f362298c..edbf885 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -16,6 +16,8 @@
>  
>  #include "util.h"
>  
> +static void free_ns(struct work_struct *work);
> +
>  static struct ipc_namespace *create_ipc_ns(struct task_struct *tsk,
>  					   struct ipc_namespace *old_ns)
>  {
> @@ -27,6 +29,7 @@ static struct ipc_namespace *create_ipc_ns(struct task_struct *tsk,
>  		return ERR_PTR(-ENOMEM);
>  
>  	atomic_set(&ns->count, 1);
> +	INIT_WORK(&ns->free_ns_work, free_ns);
>  	err = mq_init_ns(ns);
>  	if (err) {
>  		kfree(ns);
> @@ -116,6 +119,15 @@ static void free_ipc_ns(struct ipc_namespace *ns)
>  	kfree(ns);
>  }
>  
> +static void free_ns(struct work_struct *work)
> +{
> +	struct ipc_namespace *ns = container_of(work, struct ipc_namespace,
> +			free_ns_work);
> +
> +	mq_put_mnt(ns);
> +	free_ipc_ns(ns);
> +}
> +
>  /*
>   * put_ipc_ns - drop a reference to an ipc namespace.
>   * @ns: the namespace to put
> @@ -137,8 +149,7 @@ void put_ipc_ns(struct ipc_namespace *ns)
>  	if (atomic_dec_and_lock(&ns->count, &mq_lock)) {
>  		mq_clear_sbinfo(ns);
>  		spin_unlock(&mq_lock);
> -		mq_put_mnt(ns);
> -		free_ipc_ns(ns);
> +		schedule_work(&ns->free_ns_work);
>  	}
>  }
>  
> -- 
>  Kirill A. Shutemov


