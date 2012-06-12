Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2FLMro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:47:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32419 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2FLMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:47:43 -0400
Date: Tue, 12 Jun 2012 08:40:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/mce: schedule a workqueue to avoid sleep
 in atomic context
Message-ID: <20120612124015.GB559@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335228748@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:51:03AM +0000, Liu, Jinsong wrote:
> >From aa2ce7440f16002266dc8464f749992d0c8ac0e5 Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Tue, 12 Jun 2012 23:11:16 +0800
> Subject: [PATCH] xen/mce: schedule a workqueue to avoid sleep in atomic context
> 
> copy_to_user might sleep and print a stack trace if it is executed
> in an atomic spinlock context.
> 
> This patch schedule a workqueue for IRQ handler to poll the data,
> and use mutex instead of spinlock, so copy_to_user sleep in atomic
> context would not occur.

Ah much better. Usually one also includes the report of what the
stack trace was. So I've added that in.

> 
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Suggested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
> ---
>  drivers/xen/mcelog.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
> index 72e87d2..804aa3c 100644
> --- a/drivers/xen/mcelog.c
> +++ b/drivers/xen/mcelog.c
> @@ -55,7 +55,7 @@ static struct mc_info g_mi;
>  static struct mcinfo_logical_cpu *g_physinfo;
>  static uint32_t ncpus;
>  
> -static DEFINE_SPINLOCK(mcelog_lock);
> +static DEFINE_MUTEX(mcelog_lock);
>  
>  static struct xen_mce_log xen_mcelog = {
>  	.signature	= XEN_MCE_LOG_SIGNATURE,
> @@ -106,7 +106,7 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, char __user *ubuf,
>  	unsigned num;
>  	int i, err;
>  
> -	spin_lock(&mcelog_lock);
> +	mutex_lock(&mcelog_lock);
>  
>  	num = xen_mcelog.next;
>  
> @@ -130,7 +130,7 @@ static ssize_t xen_mce_chrdev_read(struct file *filp, char __user *ubuf,
>  		err = -EFAULT;
>  
>  out:
> -	spin_unlock(&mcelog_lock);
> +	mutex_unlock(&mcelog_lock);
>  
>  	return err ? err : buf - ubuf;
>  }
> @@ -310,12 +310,11 @@ static int mc_queue_handle(uint32_t flags)
>  }
>  
>  /* virq handler for machine check error info*/
> -static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
> +static void xen_mce_work_fn(struct work_struct *work)
>  {
>  	int err;
> -	unsigned long tmp;
>  
> -	spin_lock_irqsave(&mcelog_lock, tmp);
> +	mutex_lock(&mcelog_lock);
>  
>  	/* urgent mc_info */
>  	err = mc_queue_handle(XEN_MC_URGENT);
> @@ -330,8 +329,13 @@ static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
>  		pr_err(XEN_MCELOG
>  		       "Failed to handle nonurgent mc_info queue.\n");
>  
> -	spin_unlock_irqrestore(&mcelog_lock, tmp);
> +	mutex_unlock(&mcelog_lock);
> +}
> +static DECLARE_WORK(xen_mce_work, xen_mce_work_fn);
>  
> +static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)
> +{
> +	schedule_work(&xen_mce_work);
>  	return IRQ_HANDLED;
>  }
>  
> -- 
> 1.7.1


> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

