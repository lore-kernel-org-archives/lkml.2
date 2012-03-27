Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2C0VpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:45:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab2C0VpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:45:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/2] firmware_class: Move request_firmware_nowait() to workqueues
Date: Tue, 27 Mar 2012 23:49:24 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
References: <1332883710-7486-1-git-send-email-sboyd@codeaurora.org> <1332883710-7486-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1332883710-7486-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201203272349.24291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 27, 2012, Stephen Boyd wrote:
> Oddly enough a work_struct was already part of the firmware_work
> structure but nobody was using it. Instead of creating a new
> kthread for each request_firmware_nowait() call just schedule the
> work on the long system workqueue. This should avoid some overhead
> in forking new threads when they're not strictly necessary.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Is it better to use alloc_workqueue() and not put these on the system
> long workqueue?

I think if that happens to interfere destructively with something,
we can always use a new workqueue.  For now, let's try to avoid
adding yet another one if possible.

Thanks,
Rafael


>  drivers/base/firmware_class.c |   27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index ae00a2f..4d8cb8b 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -16,10 +16,11 @@
>  #include <linux/interrupt.h>
>  #include <linux/bitops.h>
>  #include <linux/mutex.h>
> -#include <linux/kthread.h>
> +#include <linux/workqueue.h>
>  #include <linux/highmem.h>
>  #include <linux/firmware.h>
>  #include <linux/slab.h>
> +#include <linux/sched.h>
>  
>  #define to_dev(obj) container_of(obj, struct device, kobj)
>  
> @@ -630,19 +631,15 @@ struct firmware_work {
>  	bool uevent;
>  };
>  
> -static int request_firmware_work_func(void *arg)
> +static void request_firmware_work_func(struct work_struct *work)
>  {
> -	struct firmware_work *fw_work = arg;
> +	struct firmware_work *fw_work;
>  	const struct firmware *fw;
>  	struct firmware_priv *fw_priv;
>  	long timeout;
>  	int ret;
>  
> -	if (!arg) {
> -		WARN_ON(1);
> -		return 0;
> -	}
> -
> +	fw_work = container_of(work, struct firmware_work, work);
>  	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
>  			fw_work->uevent, true);
>  	if (IS_ERR_OR_NULL(fw_priv)) {
> @@ -667,8 +664,6 @@ static int request_firmware_work_func(void *arg)
>  
>  	module_put(fw_work->module);
>  	kfree(fw_work);
> -
> -	return ret;
>  }
>  
>  /**
> @@ -694,7 +689,6 @@ request_firmware_nowait(
>  	const char *name, struct device *device, gfp_t gfp, void *context,
>  	void (*cont)(const struct firmware *fw, void *context))
>  {
> -	struct task_struct *task;
>  	struct firmware_work *fw_work;
>  
>  	fw_work = kzalloc(sizeof (struct firmware_work), gfp);
> @@ -713,15 +707,8 @@ request_firmware_nowait(
>  		return -EFAULT;
>  	}
>  
> -	task = kthread_run(request_firmware_work_func, fw_work,
> -			    "firmware/%s", name);
> -	if (IS_ERR(task)) {
> -		fw_work->cont(NULL, fw_work->context);
> -		module_put(fw_work->module);
> -		kfree(fw_work);
> -		return PTR_ERR(task);
> -	}
> -
> +	INIT_WORK(&fw_work->work, request_firmware_work_func);
> +	queue_work(system_long_wq, &fw_work->work);
>  	return 0;
>  }
>  
> 

