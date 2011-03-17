Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1CQUIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:08:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1CQUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:08:22 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=y8ESKaFU93EA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=D7UC-b94AAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=XOkWZoTGFZRzEc2VFloA:9 a=cw_HWSH9-KjvR_b_Me0A:7 a=AlEj2dpzQoG0crQvLGkJsk7hh5cA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=MSl-tDqOz04A:10 a=n35V9SDFXOQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 17 Mar 2011 16:08:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] genirq: incorrect unlock in __setup_irq()
Message-ID: <20110317200820.GF14675@home.goodmis.org>
References: <20110317114307.GJ2008@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317114307.GJ2008@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 02:43:07PM +0300, Dan Carpenter wrote:
> goto out_thread is called before we take the lock.  It causes a gcc
> warning: "kernel/irq/manage.c:858: warning: ???flags??? may be used
> uninitialized in this function"
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index acd599a..cdcdf13 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1065,9 +1065,9 @@ mismatch:
>  
>  out_mask:
>  	free_cpumask_var(mask);
> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  
>  out_thread:
> -	raw_spin_unlock_irqrestore(&desc->lock, flags);

That's more than a warning fix, this is a real bug.

Acked-by: Steven Rostedt <rostedt@goodims.org>

-- Steve

>  	if (new->thread) {
>  		struct task_struct *t = new->thread;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
