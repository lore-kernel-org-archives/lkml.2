Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2LYDvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 22:51:46 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:47089 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2LYDvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 22:51:44 -0500
X-AuditID: 85900ec0-d4a78b900000152f-46-50d922cd8a27
Message-ID: <50D922C9.3020706@hitachi.com>
Date: Tue, 25 Dec 2012 12:51:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 10/25] kprobes: fix wait_for_kprobe_optimizer()
References: <1356141435-17340-1-git-send-email-tj@kernel.org> <1356141435-17340-11-git-send-email-tj@kernel.org>
In-Reply-To: <1356141435-17340-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/22 10:57), Tejun Heo wrote:
> wait_for_kprobe_optimizer() seems largely broken.  It uses
> optimizer_comp which is never re-initialized, so
> wait_for_kprobe_optimizer() will never wait for anything once
> kprobe_optimizer() finishes all pending jobs for the first time.

Thank you for fixing that!
I must misunderstand that the DECLARE_COMPLETION() macro.

> Also, aside from completion, delayed_work_pending() is %false once
> kprobe_optimizer() starts execution and wait_for_kprobe_optimizer()
> won't wait for it.
>
> Reimplement it so that it flushes optimizing_work until
> [un]optimizing_lists are empty.  Note that this also makes
> optimizing_work execute immediately if someone's waiting for it, which
> is the nicer behavior.

I think your enhancement is reasonable and GOOD for me.

Thanks again!

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.
> 
> Thanks.
> 
>  kernel/kprobes.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 098f396..f230e81 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -471,7 +471,6 @@ static LIST_HEAD(unoptimizing_list);
>  
>  static void kprobe_optimizer(struct work_struct *work);
>  static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
> -static DECLARE_COMPLETION(optimizer_comp);
>  #define OPTIMIZE_DELAY 5
>  
>  /*
> @@ -552,8 +551,7 @@ static __kprobes void do_free_cleaned_kprobes(struct list_head *free_list)
>  /* Start optimizer after OPTIMIZE_DELAY passed */
>  static __kprobes void kick_kprobe_optimizer(void)
>  {
> -	if (!delayed_work_pending(&optimizing_work))
> -		schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
> +	schedule_delayed_work(&optimizing_work, OPTIMIZE_DELAY);
>  }
>  
>  /* Kprobe jump optimizer */
> @@ -592,16 +590,25 @@ static __kprobes void kprobe_optimizer(struct work_struct *work)
>  	/* Step 5: Kick optimizer again if needed */
>  	if (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list))
>  		kick_kprobe_optimizer();
> -	else
> -		/* Wake up all waiters */
> -		complete_all(&optimizer_comp);
>  }
>  
>  /* Wait for completing optimization and unoptimization */
>  static __kprobes void wait_for_kprobe_optimizer(void)
>  {
> -	if (delayed_work_pending(&optimizing_work))
> -		wait_for_completion(&optimizer_comp);
> +	mutex_lock(&kprobe_mutex);
> +
> +	while (!list_empty(&optimizing_list) || !list_empty(&unoptimizing_list)) {
> +		mutex_unlock(&kprobe_mutex);
> +
> +		/* this will also make optimizing_work execute immmediately */
> +		flush_delayed_work(&optimizing_work);
> +		/* @optimizing_work might not have been queued yet, relax */
> +		cpu_relax();
> +
> +		mutex_lock(&kprobe_mutex);
> +	}
> +
> +	mutex_unlock(&kprobe_mutex);
>  }
>  
>  /* Optimize kprobe if p is ready to be optimized */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


