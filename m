Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1JSHOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:14:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:34957 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab1JSHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:14:29 -0400
Date: Wed, 19 Oct 2011 09:14:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 4/5] workqueue: hotplug fix
In-Reply-To: <1318762607-2261-5-git-send-email-yong.zhang0@gmail.com>
Message-ID: <alpine.LFD.2.02.1110190913320.3240@ionos>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com> <1318762607-2261-5-git-send-email-yong.zhang0@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011, Yong Zhang wrote:
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3195,30 +3195,34 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
>  	}
>  
>  	/* some are called w/ irq disabled, don't disturb irq status */
> -	spin_lock_irqsave(&gcwq->lock, flags);
>  
>  	switch (action) {
>  	case CPU_UP_PREPARE:
> +		spin_lock_irqsave(&gcwq->lock, flags);
>  		BUG_ON(gcwq->first_idle);
>  		gcwq->first_idle = new_worker;
> +		spin_unlock_irqrestore(&gcwq->lock, flags);
>  		break;
>  
>  	case CPU_UP_CANCELED:
> +		spin_lock_irqsave(&gcwq->lock, flags);
>  		destroy_worker(gcwq->first_idle);
>  		gcwq->first_idle = NULL;
> +		spin_unlock_irqrestore(&gcwq->lock, flags);
>  		break;
>  
>  	case CPU_ONLINE:
> +		spin_lock_irqsave(&gcwq->lock, flags);
>  		spin_unlock_irq(&gcwq->lock);
>  		kthread_bind(gcwq->first_idle->task, cpu);
>  		spin_lock_irq(&gcwq->lock);
>  		gcwq->flags |= GCWQ_MANAGE_WORKERS;
>  		start_worker(gcwq->first_idle);
>  		gcwq->first_idle = NULL;
> +		spin_unlock_irqrestore(&gcwq->lock, flags);
>  		break;
>  	}
>  
> -	spin_unlock_irqrestore(&gcwq->lock, flags);

This part of the patch is pretty pointless.
  
>  	return notifier_from_errno(0);
>  }
> @@ -3274,14 +3278,14 @@ static void flush_gcwq(struct global_cwq *gcwq)
>  
>  	spin_unlock_irq(&gcwq->lock);
>  
> -	gcwq = get_gcwq(get_cpu());
> +	gcwq = get_gcwq(get_cpu_light());

Right.

>  	spin_lock_irq(&gcwq->lock);
>  	list_for_each_entry_safe(work, nw, &non_affine_works, entry) {
>  		list_del_init(&work->entry);
>  		___queue_work(get_work_cwq(work)->wq, gcwq, work);
>  	}
>  	spin_unlock_irq(&gcwq->lock);
> -	put_cpu();
> +	put_cpu_light();
>  }
>  
>  static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
> -- 
> 1.7.1
> 
> 
