Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992644Ab2JYUEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:04:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992570Ab2JYUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:04:08 -0400
Date: Thu, 25 Oct 2012 13:04:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: tsk->comm is an array
In-Reply-To: <20121025150056.17719.94347.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1210251300140.17938@chino.kir.corp.google.com>
References: <20121025150056.17719.94347.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Alan Cox wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> More relevantly what about termination and locks ?
> 

The string is always properly terminated with a trailing zero no matter 
how it is written.  For threads other than current, the locking is 
task_lock(task); for current, there are hundreds of places without locking 
and it is generally considered acceptable for a race to print a mangled 
string from a concurrent write to /proc/pid/comm.

> Anyway the array check is useless so remove it.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  kernel/irq/manage.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 4c69326..ea39714 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -792,8 +792,9 @@ static void irq_thread_dtor(struct callback_head *unused)
>  
>  	action = kthread_data(tsk);
>  
> +	/* FIXME: locking */
>  	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
> -	       tsk->comm ? tsk->comm : "", tsk->pid, action->irq);
> +	       tsk->comm, tsk->pid, action->irq);

Ack without the comment, no locking necessary.

>  
>  
>  	desc = irq_to_desc(action->irq);
