Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935512Ab1ETJcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:32:33 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:18359 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935502Ab1ETJcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:32:32 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 May 2011 05:32:31 EDT
Message-ID: <4DD62F8A.90208@bfs.de>
Date: Fri, 20 May 2011 11:08:26 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: matt mooney <mfm@muteddisk.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 04/12] staging: usbip: stub_main.c: code cleanup
References: <cover.1305866084.git.mfm@muteddisk.com> <14e39daa97f8475ec12c9ed6a2e95ba344f1c1ee.1305866084.git.mfm@muteddisk.com>
In-Reply-To: <14e39daa97f8475ec12c9ed6a2e95ba344f1c1ee.1305866084.git.mfm@muteddisk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 20.05.2011 06:36, schrieb matt mooney:
> Remove match_find() and replace with get_busid_idx(); change
> get_busid_priv(), add_match_busid(), and del_match_busid() to use
> get_busid_idx(); and cleanup code in the other functions.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  drivers/staging/usbip/stub_main.c |  147 ++++++++++++++++++-------------------
>  1 files changed, 73 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
> index 0ca1462..00398a6 100644
> --- a/drivers/staging/usbip/stub_main.c
> +++ b/drivers/staging/usbip/stub_main.c
> @@ -50,82 +50,90 @@ static void init_busid_table(void)
>  	spin_lock_init(&busid_table_lock);
>  }
>  
> -int match_busid(const char *busid)
> +/*
> + * Find the index of the busid by name.
> + * Must be called with busid_table_lock held.
> + */
> +static int get_busid_idx(const char *busid)
>  {
>  	int i;
> +	int idx = -1;
>  
> -	spin_lock(&busid_table_lock);
>  	for (i = 0; i < MAX_BUSID; i++)
>  		if (busid_table[i].name[0])
>  			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
> -				/* already registerd */
> -				spin_unlock(&busid_table_lock);
> -				return 0;
> +				idx = i;
> +				break;
>  			}
> -	spin_unlock(&busid_table_lock);
> -
> -	return 1;
> +	return idx;
>  }
>  
>  struct bus_id_priv *get_busid_priv(const char *busid)
>  {
> -	int i;
> +	int idx;
> +	struct bus_id_priv *bid = NULL;
>  
>  	spin_lock(&busid_table_lock);
> -	for (i = 0; i < MAX_BUSID; i++)
> -		if (busid_table[i].name[0])
> -			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
> -				/* already registerd */
> -				spin_unlock(&busid_table_lock);
> -				return &(busid_table[i]);
> -			}
> +	idx = get_busid_idx(busid);
> +	if (idx >= 0)
> +		bid = &(busid_table[idx]);
>  	spin_unlock(&busid_table_lock);
>  
> -	return NULL;
> +	return bid;
>  }
>  
>  static int add_match_busid(char *busid)
>  {
>  	int i;
> -
> -	if (!match_busid(busid))
> -		return 0;
> +	int ret = -1;
>  
>  	spin_lock(&busid_table_lock);
> +	/* already registered? */
> +	if (get_busid_idx(busid) >= 0) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	for (i = 0; i < MAX_BUSID; i++)
>  		if (!busid_table[i].name[0]) {
>  			strncpy(busid_table[i].name, busid, BUSID_SIZE);

i am missing an if() here ??


>  			if ((busid_table[i].status != STUB_BUSID_ALLOC) &&
>  			    (busid_table[i].status != STUB_BUSID_REMOV))
>  				busid_table[i].status = STUB_BUSID_ADDED;
> -			spin_unlock(&busid_table_lock);
> -			return 0;
> +			ret = 0;
> +			break;
>  		}
> +





> +out:
>  	spin_unlock(&busid_table_lock);
>  
> -	return -1;
> +	return ret;
>  }
>  
>  int del_match_busid(char *busid)
>  {
> -	int i;
> +	int idx;
> +	int ret = -1;
>  
>  	spin_lock(&busid_table_lock);
> -	for (i = 0; i < MAX_BUSID; i++)
> -		if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
> -			/* found */
> -			if (busid_table[i].status == STUB_BUSID_OTHER)
> -				memset(busid_table[i].name, 0, BUSID_SIZE);
> -			if ((busid_table[i].status != STUB_BUSID_OTHER) &&
> -			    (busid_table[i].status != STUB_BUSID_ADDED)) {
> -				busid_table[i].status = STUB_BUSID_REMOV;
> -			}
> -			spin_unlock(&busid_table_lock);
> -			return 0;
> -		}
> +	idx = get_busid_idx(busid);
> +	if (idx < 0)
> +		goto out;
> +
> +	/* found */
> +	ret = 0;
> +
> +	if (busid_table[idx].status == STUB_BUSID_OTHER)
> +		memset(busid_table[idx].name, 0, BUSID_SIZE);
> +
> +	if ((busid_table[idx].status != STUB_BUSID_OTHER) &&
> +	    (busid_table[idx].status != STUB_BUSID_ADDED))
> +		busid_table[idx].status = STUB_BUSID_REMOV;
> +
> +out:
>  	spin_unlock(&busid_table_lock);
>  
> -	return -1;
> +	return ret;
>  }
>  
>  static ssize_t show_match_busid(struct device_driver *drv, char *buf)
> @@ -138,8 +146,8 @@ static ssize_t show_match_busid(struct device_driver *drv, char *buf)
>  		if (busid_table[i].name[0])
>  			out += sprintf(out, "%s ", busid_table[i].name);
>  	spin_unlock(&busid_table_lock);
> -
>  	out += sprintf(out, "\n");
> +
>  	return out - buf;
>  }
>  
> @@ -162,23 +170,24 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
>  	strncpy(busid, buf + 4, BUSID_SIZE);
>  
>  	if (!strncmp(buf, "add ", 4)) {
> -		if (add_match_busid(busid) < 0)
> +		if (add_match_busid(busid) < 0) {
>  			return -ENOMEM;
> -		else {
> +		} else {
>  			pr_debug("add busid %s\n", busid);
>  			return count;
>  		}
>  	} else if (!strncmp(buf, "del ", 4)) {
> -		if (del_match_busid(busid) < 0)
> +		if (del_match_busid(busid) < 0) {
>  			return -ENODEV;
> -		else {
> +		} else {
>  			pr_debug("del busid %s\n", busid);
>  			return count;
>  		}
> -	} else
> +	} else {
>  		return -EINVAL;
> +	}
>  }
> -static DRIVER_ATTR(match_busid, S_IRUSR|S_IWUSR, show_match_busid,
> +static DRIVER_ATTR(match_busid, S_IRUSR | S_IWUSR, show_match_busid,
>  		   store_match_busid);
>  
>  static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
> @@ -201,36 +210,30 @@ static struct stub_priv *stub_priv_pop(struct stub_device *sdev)
>  	spin_lock_irqsave(&sdev->priv_lock, flags);
>  
>  	priv = stub_priv_pop_from_listhead(&sdev->priv_init);
> -	if (priv) {
> -		spin_unlock_irqrestore(&sdev->priv_lock, flags);
> -		return priv;
> -	}
> +	if (priv)
> +		goto done;
>  
>  	priv = stub_priv_pop_from_listhead(&sdev->priv_tx);
> -	if (priv) {
> -		spin_unlock_irqrestore(&sdev->priv_lock, flags);
> -		return priv;
> -	}
> +	if (priv)
> +		goto done;
>  
>  	priv = stub_priv_pop_from_listhead(&sdev->priv_free);
> -	if (priv) {
> -		spin_unlock_irqrestore(&sdev->priv_lock, flags);
> -		return priv;
> -	}
>  
> +done:
>  	spin_unlock_irqrestore(&sdev->priv_lock, flags);
> -	return NULL;
> +
> +	return priv;
>  }
>  
>  void stub_device_cleanup_urbs(struct stub_device *sdev)
>  {
>  	struct stub_priv *priv;
> +	struct urb *urb;
>  
>  	dev_dbg(&sdev->udev->dev, "free sdev %p\n", sdev);
>  
>  	while ((priv = stub_priv_pop(sdev))) {
> -		struct urb *urb = priv->urb;
> -
> +		urb = priv->urb;
>  		dev_dbg(&sdev->udev->dev, "free urb %p\n", urb);
>  		usb_kill_urb(urb);
>  
> @@ -238,7 +241,6 @@ void stub_device_cleanup_urbs(struct stub_device *sdev)
>  
>  		kfree(urb->transfer_buffer);
>  		kfree(urb->setup_packet);
> -
>  		usb_free_urb(urb);
>  	}
>  }
> @@ -250,34 +252,31 @@ static int __init usb_stub_init(void)
>  	stub_priv_cache = kmem_cache_create("stub_priv",
>  					    sizeof(struct stub_priv), 0,
>  					    SLAB_HWCACHE_ALIGN, NULL);
> -
>  	if (!stub_priv_cache) {
> -		pr_err("create stub_priv_cache error\n");
> +		pr_err("kmem_cache_create failed\n");
>  		return -ENOMEM;
>  	}
>  
>  	ret = usb_register(&stub_driver);
> -	if (ret) {
> +	if (ret < 0) {
>  		pr_err("usb_register failed %d\n", ret);
> -		goto error_usb_register;
> +		goto err_usb_register;
>  	}
>  
> -	pr_info(DRIVER_DESC " " USBIP_VERSION "\n");
> -
> -	init_busid_table();
> -
>  	ret = driver_create_file(&stub_driver.drvwrap.driver,
>  				 &driver_attr_match_busid);
> -
> -	if (ret) {
> -		pr_err("create driver sysfs\n");
> -		goto error_create_file;
> +	if (ret < 0) {
> +		pr_err("driver_create_file failed\n");
> +		goto err_create_file;
>  	}
>  
> +	init_busid_table();
> +	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
>  	return ret;
> -error_create_file:
> +
> +err_create_file:
>  	usb_deregister(&stub_driver);
> -error_usb_register:
> +err_usb_register:
>  	kmem_cache_destroy(stub_priv_cache);
>  	return ret;
>  }
