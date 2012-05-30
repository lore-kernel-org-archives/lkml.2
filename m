Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2E3Ima (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:42:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53472 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2E3Im3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:42:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6726"; a="195870499"
Message-ID: <4FC5DD74.4030202@codeaurora.org>
Date: Wed, 30 May 2012 01:42:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <1338017791-9442-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1338017791-9442-2-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2012 12:36 AM, Ohad Ben-Cohen wrote:
>  /* will be called when an rproc is added to the rprocs klist */
>  static void klist_rproc_get(struct klist_node *n)
>  {
>  	struct rproc *rproc = container_of(n, struct rproc, node);
>  
> -	kref_get(&rproc->refcount);
> +	get_device(&rproc->dev);
>  }
>  
>  /* will be called when an rproc is removed from the rprocs klist */
> @@ -1312,7 +1282,7 @@ static void klist_rproc_put(struct klist_node *n)
>  {
>  	struct rproc *rproc = container_of(n, struct rproc, node);
>  
> -	kref_put(&rproc->refcount, rproc_release);
> +	put_device(&rproc->dev);
>  }
>  
>  static struct rproc *next_rproc(struct klist_iter *i)
> @@ -1354,7 +1324,7 @@ struct rproc *rproc_get_by_name(const char *name)
>  	klist_iter_init(&rprocs, &i);
>  	while ((rproc = next_rproc(&i)) != NULL)
>  		if (!strcmp(rproc->name, name)) {
> -			kref_get(&rproc->refcount);
> +			get_device(&rproc->dev);
>  			break;
>  		}
>  	klist_iter_exit(&i);
> @@ -1367,7 +1337,7 @@ struct rproc *rproc_get_by_name(const char *name)
>  
>  	ret = rproc_boot(rproc);
>  	if (ret < 0) {
> -		kref_put(&rproc->refcount, rproc_release);
> +		put_device(&rproc->dev);
>  		return NULL;
>  	}

I was hoping we could use class_for_each_device() and
class_find_device() to replace all this code. Then we wouldn't need all
this klist stuff that the class is taking care of already.

> @@ -1462,10 +1432,23 @@ int rproc_register(struct rproc *rproc)
>  }
>  EXPORT_SYMBOL(rproc_register);
>  
> +/**
> + * rproc_class_release() - release a remote processor instance
> + * @dev: the rproc's device
> + *
> + * This function should _never_ be called directly.
> + *
> + * It will be called by the driver core when no one holds a valid pointer
> + * to @dev anymore.
> + */

Why is this added now and not in the previous patch?

>  static void rproc_class_release(struct device *dev)
>  {
>  	struct rproc *rproc = container_of(dev, struct rproc, dev);
>  
> +	dev_info(&rproc->dev, "releasing %s\n", rproc->name);
> +
> +	rproc_delete_debug_dir(rproc);
> +
>  	idr_remove_all(&rproc->notifyids);
>  	idr_destroy(&rproc->notifyids);
>  
[snip]
> @@ -1603,8 +1584,8 @@ int rproc_unregister(struct rproc *rproc)
>  
>  	device_del(&rproc->dev);
>  
> -	/* the rproc will only be released after its refcount drops to zero */
> -	kref_put(&rproc->refcount, rproc_release);
> +	/* unroll rproc_alloc. TODO: we may want to let the users do that */
> +	put_device(&rproc->dev);

Yes I think we want rproc_free() to actually call put_device() the last
time and free the resources.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

