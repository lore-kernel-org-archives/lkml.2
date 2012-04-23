Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2DWLnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:43:03 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59425 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab2DWLnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:43:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
Date: Mon, 23 Apr 2012 13:47:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201204231347.38232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 23, 2012, Linus Walleij wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> If !dev->class, device_move() does not respect the dpm_order.
> Fix it to do so.
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> [Fixed a small dangling label compile warning]
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/base/core.c |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index e28ce98..f428321 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1753,25 +1753,25 @@ int device_move(struct device *dev, struct device *new_parent,
>  		set_dev_node(dev, dev_to_node(new_parent));
>  	}
>  
> -	if (!dev->class)
> -		goto out_put;
> -	error = device_move_class_links(dev, old_parent, new_parent);
> -	if (error) {
> -		/* We ignore errors on cleanup since we're hosed anyway... */
> -		device_move_class_links(dev, new_parent, old_parent);
> -		if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
> -			if (new_parent)
> -				klist_remove(&dev->p->knode_parent);
> -			dev->parent = old_parent;
> -			if (old_parent) {
> -				klist_add_tail(&dev->p->knode_parent,
> -					       &old_parent->p->klist_children);
> -				set_dev_node(dev, dev_to_node(old_parent));
> +	if (dev->class) {
> +		error = device_move_class_links(dev, old_parent, new_parent);
> +		if (error) {
> +			/* We ignore errors on cleanup since we're hosed anyway... */
> +			device_move_class_links(dev, new_parent, old_parent);
> +			if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
> +				if (new_parent)
> +					klist_remove(&dev->p->knode_parent);
> +				dev->parent = old_parent;
> +				if (old_parent) {
> +					klist_add_tail(&dev->p->knode_parent,
> +						       &old_parent->p->klist_children);
> +					set_dev_node(dev, dev_to_node(old_parent));
> +				}
>  			}
> +			cleanup_glue_dir(dev, new_parent_kobj);
> +			put_device(new_parent);
> +			goto out;
>  		}
> -		cleanup_glue_dir(dev, new_parent_kobj);
> -		put_device(new_parent);
> -		goto out;
>  	}
>  	switch (dpm_order) {
>  	case DPM_ORDER_NONE:
> @@ -1786,7 +1786,7 @@ int device_move(struct device *dev, struct device *new_parent,
>  		device_pm_move_last(dev);
>  		break;
>  	}
> -out_put:
> +
>  	put_device(old_parent);
>  out:
>  	device_pm_unlock();
> 

