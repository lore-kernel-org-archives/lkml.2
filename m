Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab1JXC1C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 22:27:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51425 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1JXC1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 22:27:00 -0400
Date: Mon, 24 Oct 2011 10:26:48 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt 4/5] workqueue: hotplug fix
Message-ID: <20111024022648.GA24581@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1318762607-2261-1-git-send-email-yong.zhang0@gmail.com>
 <1318762607-2261-5-git-send-email-yong.zhang0@gmail.com>
 <alpine.LFD.2.02.1110190913320.3240@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110190913320.3240@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 09:14:28AM +0200, Thomas Gleixner wrote:
> On Sun, 16 Oct 2011, Yong Zhang wrote:
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -3195,30 +3195,34 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
> >  	}
> >  
> >  	/* some are called w/ irq disabled, don't disturb irq status */
> > -	spin_lock_irqsave(&gcwq->lock, flags);
> >  
> >  	switch (action) {
> >  	case CPU_UP_PREPARE:
> > +		spin_lock_irqsave(&gcwq->lock, flags);
> >  		BUG_ON(gcwq->first_idle);
> >  		gcwq->first_idle = new_worker;
> > +		spin_unlock_irqrestore(&gcwq->lock, flags);
> >  		break;
> >  
> >  	case CPU_UP_CANCELED:
> > +		spin_lock_irqsave(&gcwq->lock, flags);
> >  		destroy_worker(gcwq->first_idle);
> >  		gcwq->first_idle = NULL;
> > +		spin_unlock_irqrestore(&gcwq->lock, flags);
> >  		break;
> >  
> >  	case CPU_ONLINE:
> > +		spin_lock_irqsave(&gcwq->lock, flags);
> >  		spin_unlock_irq(&gcwq->lock);
> >  		kthread_bind(gcwq->first_idle->task, cpu);
> >  		spin_lock_irq(&gcwq->lock);
> >  		gcwq->flags |= GCWQ_MANAGE_WORKERS;
> >  		start_worker(gcwq->first_idle);
> >  		gcwq->first_idle = NULL;
> > +		spin_unlock_irqrestore(&gcwq->lock, flags);
> >  		break;
> >  	}
> >  
> > -	spin_unlock_irqrestore(&gcwq->lock, flags);
> 
> This part of the patch is pretty pointless.

But CPU_STARTING is called with irq disabled, and it will take
the lock unconditionally. Thus below warning is triggered:
BUG: sleeping function called from invalid context at kernel/rtmutex.c:645
in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: kworker/0:0
Pid: 0, comm: kworker/0:0 Not tainted 3.0.6-rt17-00284-gb76d419 #3
Call Trace:
 [<c06e3b5d>] ? printk+0x1d/0x20
 [<c01390b6>] __might_sleep+0xe6/0x110
 [<c06e633c>] rt_spin_lock+0x1c/0x30
 [<c06cd85b>] workqueue_cpu_up_callback+0x56/0xf3
 [<c06e9d65>] notifier_call_chain+0x45/0x60
 [<c0171cfe>] __raw_notifier_call_chain+0x1e/0x30
 [<c014c9b4>] __cpu_notify+0x24/0x40
 [<c014c9ec>] cpu_notify+0x1c/0x20
 [<c06e1d43>] notify_cpu_starting+0x1e/0x20
 [<c06e0aad>] smp_callin+0xfb/0x10e
 [<c06e0ad9>] start_secondary+0x19/0xd7

Thanks,
Yong

