Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2BPNcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:32:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2BPNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:32:07 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=cz8CoATgOvsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=jy1oSv4iTQQQKhSNnRUA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH] futex: fix uninitialized warning
From: Steven Rostedt <rostedt@goodmis.org>
To: yad.naveen@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <4f3cce7d.443a440a.2f15.ffffe7ff@mx.google.com>
References: <yad.naveen@gmail.com>
	 <4f3cce7d.443a440a.2f15.ffffe7ff@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Feb 2012 08:32:03 -0500
Message-ID: <1329399124.10311.8.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 15:15 +0530, yad.naveen@gmail.com wrote:
> From: Naveen Yadav <yad.naveen@gmail.com>
> 
> 
> Signed-off-by: Naveen Yadav <yad.naveen@gmail.com>
> ---
>  kernel/futex.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6487e4c..fdb93b0 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1588,7 +1588,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
>  	struct futex_pi_state *pi_state = q->pi_state;
>  	struct task_struct *oldowner = pi_state->owner;
> -	u32 uval, curval, newval;
> +	u32 uval, uninitialized_var(curval), newval;

NAK, an uninitialized_var() macro should not be added unless there's a
really good reason that gcc is not detecting it. Some logic does require
this.

If it ends up being that this macro should be added, then it should have
a comment to why it is added, and why gcc is failing to figure out that
it is initialized.

What gcc version is complaining and what arch is this for? There could
definitely be a case here that it may really be uninitialized, and this
patch would hide that bug.

The cmpxchg_futex_* is arch specific, and if an arch screws it up, we
will never know that this value is uninitialized because this patch
would have hidden that bug. Hiding a bug is much worse than dealing with
some "might be uninitialized" warnings.

-- Steve

>  	int ret;
>  
>  	/* Owner died? */
> @@ -2493,7 +2493,7 @@ err_unlock:
>   */
>  int handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi)
>  {
> -	u32 uval, nval, mval;
> +	u32 uval, uninitialized_var(nval), mval;
>  
>  retry:
>  	if (get_user(uval, uaddr))


