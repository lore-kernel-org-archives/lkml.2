Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0CYCvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 22:51:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45380 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0CYCvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 22:51:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Anfei Zhou <anfei.zhou@gmail.com>
Subject: Re: [PATCH] oom killer: break from infinite loop
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       rientjes@google.com, nishimura@mxp.nes.nec.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
Message-Id: <20100325100302.9457.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 25 Mar 2010 11:51:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In multi-threading environment, if the current task(A) have got
> the mm->mmap_sem semaphore, and the thread(B) in the same process
> is selected to be oom killed, because they shares the same semaphore,
> thread B can not really be killed.  So __alloc_pages_slowpath turns
> to be a infinite loop.  Here set all the threads in the group to
> TIF_MEMDIE, it gets a chance to break and exit.
> 
> Signed-off-by: Anfei Zhou <anfei.zhou@gmail.com>

I like this patch very much.
Thanks, Anfei!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> ---
>  mm/oom_kill.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 9b223af..aab9892 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -381,6 +381,8 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
>   */
>  static void __oom_kill_task(struct task_struct *p, int verbose)
>  {
> +	struct task_struct *t;
> +
>  	if (is_global_init(p)) {
>  		WARN_ON(1);
>  		printk(KERN_WARNING "tried to kill init!\n");
> @@ -412,6 +414,8 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
>  	 */
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
> +	for (t = next_thread(p); t != p; t = next_thread(t))
> +		set_tsk_thread_flag(t, TIF_MEMDIE);
>  
>  	force_sig(SIGKILL, p);
>  }
> -- 
> 1.6.4.rc1
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



