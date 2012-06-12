Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2FLIJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:09:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:4027 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab2FLIJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155157379"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
 atomic context
Thread-Topic: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep in
 atomic context
Thread-Index: AQHNSAYbxEyD+XUzS/eqorQpXCRDr5b2UJwg
Date: Tue, 12 Jun 2012 08:08:54 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335228869@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335221654@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335225796@SHSMSX101.ccr.corp.intel.com>
 <20120611191214.GL14535@phenom.dumpdata.com>
In-Reply-To: <20120611191214.GL14535@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
>>> From db6c0ac9372c6fbc3637ec4216830e7ee01b31aa Mon Sep 17 00:00:00
>>> 2001 
>> From: Liu, Jinsong <jinsong.liu@intel.com>
>> Date: Mon, 11 Jun 2012 19:21:24 +0800
>> Subject: [PATCH] xen/mce: Add mutex lock and buffer to avoid sleep
>> in atomic context 
>> 
>> copy_to_user might sleep and print a stack trace if it is executed
>> in an atomic spinlock context. This patch add a mutex lock and a
>> buffer to avoid the issue.
>> 
>> This patch also change the manipulation of mcelog_lock from
>> spin_lock_irqsave to spin_trylock to avoid deadlock, since
>> mcelog_lock is used at normal process context and
>> mce context (which is async exception context that could
> 
> Could you explain in more details what is 'async exception
> context' and 'mce context' ?

mce context, I meant here is, in mce scenario (originally triggerred and handled by hypervisor mce logic and then virq to dom0 mcelog handler). It's 'async' (unlike other exception which is 'sync'), and could not be protected by spin_lock_irqsave.

> 
>> not protected by spin_lock_irqsave). When fail to get spinlock,
>> mc_info would be transferred by hypervisor next time.
> 
> What does that mean? How would 'mcelog' program get the data?

It fail to get mc_info this time if spin trylock fail. Error info still kept at hypervisor mc data structure. When next mce occur, dom0 mcelog would get these mc_info then. Hmm, ugly.

> 
>> 
>> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com> ---
>>  drivers/xen/mcelog.c |   38 +++++++++++++++++++++++++++++++-------
>>  1 files changed, 31 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/xen/mcelog.c b/drivers/xen/mcelog.c
>> index 72e87d2..fac29e4 100644
>> --- a/drivers/xen/mcelog.c
>> +++ b/drivers/xen/mcelog.c
>> @@ -56,12 +56,14 @@ static struct mcinfo_logical_cpu *g_physinfo; 
>> static uint32_t ncpus; 
>> 
>>  static DEFINE_SPINLOCK(mcelog_lock);
>> +static DEFINE_MUTEX(xen_mce_chrdev_read_mutex);
>> 
>>  static struct xen_mce_log xen_mcelog = {
>>  	.signature	= XEN_MCE_LOG_SIGNATURE,
>>  	.len		= XEN_MCE_LOG_LEN,
>>  	.recordlen	= sizeof(struct xen_mce),
>>  };
>> +static struct xen_mce_log xen_mcelog_u;
>> 
>>  static DEFINE_SPINLOCK(xen_mce_chrdev_state_lock);
>>  static int xen_mce_chrdev_open_count;	/* #times opened */
>> @@ -106,9 +108,19 @@ static ssize_t xen_mce_chrdev_read(struct file
>>  	*filp, char __user *ubuf,  	unsigned num; int i, err;
>> 
>> +	/*
>> +	 * copy_to_user might sleep and print a stack trace
>> +	 * if it is executed in an atomic spinlock context +	 */
>> +	mutex_lock(&xen_mce_chrdev_read_mutex);
>> +
>>  	spin_lock(&mcelog_lock);
>> +	memcpy(&xen_mcelog_u, &xen_mcelog, sizeof(struct xen_mce_log));
>> 
>>  	num = xen_mcelog.next;
>> +	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
>> +	xen_mcelog.next = 0; +	spin_unlock(&mcelog_lock);
>> 
>>  	/* Only supports full reads right now */
>>  	err = -EINVAL;
>> @@ -117,20 +129,20 @@ static ssize_t xen_mce_chrdev_read(struct file
>> *filp, char __user *ubuf, 
>> 
>>  	err = 0;
>>  	for (i = 0; i < num; i++) {
>> -		struct xen_mce *m = &xen_mcelog.entry[i];
>> +		struct xen_mce *m = &xen_mcelog_u.entry[i];
>> 
>>  		err |= copy_to_user(buf, m, sizeof(*m));
>>  		buf += sizeof(*m);
>>  	}
>> 
>> -	memset(xen_mcelog.entry, 0, num * sizeof(struct xen_mce));
>> -	xen_mcelog.next = 0;
>> +	memset(xen_mcelog_u.entry, 0, num * sizeof(struct xen_mce));
>> +	xen_mcelog_u.next = 0; 
>> 
>>  	if (err)
>>  		err = -EFAULT;
>> 
>>  out:
>> -	spin_unlock(&mcelog_lock);
>> +	mutex_unlock(&xen_mce_chrdev_read_mutex);
>> 
>>  	return err ? err : buf - ubuf;
>>  }
>> @@ -313,9 +325,21 @@ static int mc_queue_handle(uint32_t flags)
>>  static irqreturn_t xen_mce_interrupt(int irq, void *dev_id)  {
>>  	int err;
>> -	unsigned long tmp;
>> 
>> -	spin_lock_irqsave(&mcelog_lock, tmp);
>> +	/*
>> +	 * mcelog_lock is used at normal process context and
>> +	 * mce context (which is async exception context that could
>> +	 * not protected by spin_lock_irqsave).
>> +	 *
>> +	 * use spin_trylock to avoid deadlock. When fail to get spinlock,
>> +	 * mc_info would be transferred by hypervisor next time. +	 */
>> +	if (unlikely(!spin_trylock(&mcelog_lock))) {
>> +		pr_err(XEN_MCELOG
>> +		       "Failed to get mcelog_lock, mc_info would "
>> +		       "be transferred by hypervisor next time.\n");
> 
> Ugh. Why the printk? How does this benefit the user? If it
> recovers - which I presume "..next time" means then it should be OK?
> 
> What does 'transferred by hypervisor' mean actually?
> 
> Would it be better to schedule a workqueue to poll the data? Perhaps
> that is how this whole IRQ handler should be done - it kicks of an
> IRQ handler that de-spolls the data?

Yep, much much better!
have updated patch accordingly and sent out.

Thanks,
Jinsong

> 
>> +		return IRQ_NONE;
>> +	}
>> 
>>  	/* urgent mc_info */
>>  	err = mc_queue_handle(XEN_MC_URGENT);
>> @@ -330,7 +354,7 @@ static irqreturn_t xen_mce_interrupt(int irq,
>>  		       void *dev_id)  		pr_err(XEN_MCELOG "Failed to handle
>> nonurgent mc_info queue.\n"); 
>> 
>> -	spin_unlock_irqrestore(&mcelog_lock, tmp);
>> +	spin_unlock(&mcelog_lock);
>> 
>>  	return IRQ_HANDLED;
>>  }
>> --
>> 1.7.1

