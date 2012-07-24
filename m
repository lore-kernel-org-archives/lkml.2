Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933723Ab2GXSKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:10:54 -0400
Received: from osrc3.amd.com ([217.9.48.20]:59810 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933576Ab2GXSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:10:50 -0400
Date: Tue, 24 Jul 2012 20:10:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/13] driver core: firmware loader: simplify pages
 ownership transfer
Message-ID: <20120724181044.GC25671@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343149213-10160-2-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:01AM +0800, Ming Lei wrote:
> This patch doesn't transfer ownership of pages' buffer to the
> instance of firmware until the firmware loading is completed,
> which will simplify firmware_loading_store a lot, so help
> to introduce the following cache_firmware and uncache_firmware
> mechanism during system suspend-resume cycle.
> 
> In fact, this patch fixes one bug: if writing data into
> firmware loader device is bypassed between writting 1 and 0 to
> 'loading', OOPS will be triggered without the patch.
> 
> Also add some comments to make code more readable.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |   57 ++++++++++++++++++++++++-----------------
>  1 file changed, 34 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 803cfc1..f789bbd 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -93,6 +93,8 @@ struct firmware_priv {
>  	struct completion completion;
>  	struct firmware *fw;
>  	unsigned long status;
> +	void *data;
> +	size_t size;
>  	struct page **pages;
>  	int nr_pages;
>  	int page_array_size;
> @@ -156,9 +158,11 @@ static void fw_dev_release(struct device *dev)
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
>  	int i;
>  
> +	/* free untransfered pages buffer */
>  	for (i = 0; i < fw_priv->nr_pages; i++)
>  		__free_page(fw_priv->pages[i]);
>  	kfree(fw_priv->pages);
> +
>  	kfree(fw_priv);
>  
>  	module_put(THIS_MODULE);
> @@ -194,6 +198,7 @@ static ssize_t firmware_loading_show(struct device *dev,
>  	return sprintf(buf, "%d\n", loading);
>  }
>  
> +/* firmware holds the ownership of pages */
>  static void firmware_free_data(const struct firmware *fw)
>  {
>  	int i;
> @@ -237,9 +242,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>  
>  	switch (loading) {
>  	case 1:
> -		firmware_free_data(fw_priv->fw);
> -		memset(fw_priv->fw, 0, sizeof(struct firmware));
> -		/* If the pages are not owned by 'struct firmware' */
> +		/* discarding any previous partial load */
>  		for (i = 0; i < fw_priv->nr_pages; i++)
>  			__free_page(fw_priv->pages[i]);
>  		kfree(fw_priv->pages);
> @@ -250,20 +253,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>  		break;
>  	case 0:
>  		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
> -			vunmap(fw_priv->fw->data);
> -			fw_priv->fw->data = vmap(fw_priv->pages,
> -						 fw_priv->nr_pages,
> -						 0, PAGE_KERNEL_RO);
> -			if (!fw_priv->fw->data) {
> -				dev_err(dev, "%s: vmap() failed\n", __func__);
> -				goto err;
> -			}
> -			/* Pages are now owned by 'struct firmware' */
> -			fw_priv->fw->pages = fw_priv->pages;
> -			fw_priv->pages = NULL;
> -
> -			fw_priv->page_array_size = 0;
> -			fw_priv->nr_pages = 0;
>  			complete(&fw_priv->completion);
>  			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
>  			break;
> @@ -273,7 +262,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>  		dev_err(dev, "%s: unexpected value (%d)\n", __func__, loading);
>  		/* fallthrough */
>  	case -1:
> -	err:
>  		fw_load_abort(fw_priv);
>  		break;
>  	}
> @@ -299,12 +287,12 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
>  		ret_count = -ENODEV;
>  		goto out;
>  	}
> -	if (offset > fw->size) {
> +	if (offset > fw_priv->size) {
>  		ret_count = 0;
>  		goto out;
>  	}
> -	if (count > fw->size - offset)
> -		count = fw->size - offset;
> +	if (count > fw_priv->size - offset)
> +		count = fw_priv->size - offset;
>  
>  	ret_count = count;
>  
> @@ -396,6 +384,7 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
>  		retval = -ENODEV;
>  		goto out;
>  	}
> +
>  	retval = fw_realloc_buffer(fw_priv, offset + count);
>  	if (retval)
>  		goto out;
> @@ -418,7 +407,7 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
>  		count -= page_cnt;
>  	}
>  
> -	fw->size = max_t(size_t, offset, fw->size);
> +	fw_priv->size = max_t(size_t, offset, fw_priv->size);
>  out:
>  	mutex_unlock(&fw_lock);
>  	return retval;
> @@ -504,6 +493,24 @@ static void _request_firmware_cleanup(const struct firmware **firmware_p)
>  	*firmware_p = NULL;
>  }
>  
> +/* transfer the ownership of pages to firmware */
> +static void fw_set_page_data(struct firmware_priv *fw_priv)
> +{
> +	struct firmware *fw = fw_priv->fw;
> +
> +	fw_priv->data = vmap(fw_priv->pages, fw_priv->nr_pages,
> +				0, PAGE_KERNEL_RO);

We don't need to check the return value of vmap() here like we do above?

> +	fw->data = fw_priv->data;
> +	fw->pages = fw_priv->pages;
> +	fw->size = fw_priv->size;

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
