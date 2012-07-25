Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2GYN7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:59:55 -0400
Received: from osrc3.amd.com ([217.9.48.20]:35631 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2GYN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:59:53 -0400
Date: Wed, 25 Jul 2012 15:59:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/13] driver core: firmware loader: introduce
 firmware_buf
Message-ID: <20120725135948.GD11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-6-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1343149213-10160-6-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:05AM +0800, Ming Lei wrote:
> This patch introduces struct firmware_buf to describe the buffer
> which holds the firmware data, which will make the following
> cache_firmware/uncache_firmware implemented easily.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |  176 +++++++++++++++++++++++------------------
>  1 file changed, 101 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 0b343b8..986d9df 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -89,7 +89,7 @@ static inline long firmware_loading_timeout(void)
>   * guarding for corner cases a global lock should be OK */
>  static DEFINE_MUTEX(fw_lock);
>  
> -struct firmware_priv {
> +struct firmware_buf {
>  	struct completion completion;
>  	struct firmware *fw;
>  	unsigned long status;
> @@ -98,10 +98,14 @@ struct firmware_priv {
>  	struct page **pages;
>  	int nr_pages;
>  	int page_array_size;
> +	char fw_id[];
> +};
> +
> +struct firmware_priv {
>  	struct timer_list timeout;
> -	struct device dev;
>  	bool nowait;
> -	char fw_id[];
> +	struct device dev;
> +	struct firmware_buf *buf;
>  };
>  
>  static struct firmware_priv *to_firmware_priv(struct device *dev)
> @@ -111,8 +115,10 @@ static struct firmware_priv *to_firmware_priv(struct device *dev)
>  
>  static void fw_load_abort(struct firmware_priv *fw_priv)
>  {
> -	set_bit(FW_STATUS_ABORT, &fw_priv->status);
> -	complete(&fw_priv->completion);
> +	struct firmware_buf *buf = fw_priv->buf;
> +
> +	set_bit(FW_STATUS_ABORT, &buf->status);
> +	complete(&buf->completion);
>  }
>  
>  static ssize_t firmware_timeout_show(struct class *class,
> @@ -152,16 +158,23 @@ static struct class_attribute firmware_class_attrs[] = {
>  	__ATTR_NULL
>  };
>  
> -static void fw_dev_release(struct device *dev)
> +static void fw_free_buf(struct firmware_buf *buf)
>  {
> -	struct firmware_priv *fw_priv = to_firmware_priv(dev);
>  	int i;
>  
> -	/* free untransfered pages buffer */
> -	for (i = 0; i < fw_priv->nr_pages; i++)
> -		__free_page(fw_priv->pages[i]);
> -	kfree(fw_priv->pages);
> +	if (!buf)
> +		return;

This is subtle: the caller of fw_free_buf might forget to assign NULL to
the buf ptr.

Why not pass struct firmware_priv *fw_priv to the function instead and ...

> +
> +	for (i = 0; i < buf->nr_pages; i++)
> +		__free_page(buf->pages[i]);
> +	kfree(buf->pages);

assign NULL to the ptr as a last step, when all is done:

	fw_priv->buf = NULL;

This way you're making sure ->buf is NULL after all pages are freed and
your check above is always correct.

> +}
> +
> +static void fw_dev_release(struct device *dev)
> +{
> +	struct firmware_priv *fw_priv = to_firmware_priv(dev);
>  
> +	kfree(fw_priv->buf);
>  	kfree(fw_priv);
>  
>  	module_put(THIS_MODULE);
> @@ -171,7 +184,7 @@ static int firmware_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
>  
> -	if (add_uevent_var(env, "FIRMWARE=%s", fw_priv->fw_id))
> +	if (add_uevent_var(env, "FIRMWARE=%s", fw_priv->buf->fw_id))
>  		return -ENOMEM;
>  	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
>  		return -ENOMEM;
> @@ -192,7 +205,7 @@ static ssize_t firmware_loading_show(struct device *dev,
>  				     struct device_attribute *attr, char *buf)
>  {
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> -	int loading = test_bit(FW_STATUS_LOADING, &fw_priv->status);
> +	int loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
>  
>  	return sprintf(buf, "%d\n", loading);
>  }
> @@ -231,32 +244,33 @@ static ssize_t firmware_loading_store(struct device *dev,
>  				      const char *buf, size_t count)
>  {
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> +	struct firmware_buf *fw_buf = fw_priv->buf;
>  	int loading = simple_strtol(buf, NULL, 10);
>  	int i;
>  
>  	mutex_lock(&fw_lock);
>  
> -	if (!fw_priv->fw)
> +	if (!fw_buf)
>  		goto out;
>  
>  	switch (loading) {
>  	case 1:
>  		/* discarding any previous partial load */
> -		if (!test_bit(FW_STATUS_DONE, &fw_priv->status)) {
> -			for (i = 0; i < fw_priv->nr_pages; i++)
> -				__free_page(fw_priv->pages[i]);
> -			kfree(fw_priv->pages);
> -			fw_priv->pages = NULL;
> -			fw_priv->page_array_size = 0;
> -			fw_priv->nr_pages = 0;
> -			set_bit(FW_STATUS_LOADING, &fw_priv->status);
> +		if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
> +			for (i = 0; i < fw_buf->nr_pages; i++)
> +				__free_page(fw_buf->pages[i]);
> +			kfree(fw_buf->pages);
> +			fw_buf->pages = NULL;
> +			fw_buf->page_array_size = 0;
> +			fw_buf->nr_pages = 0;
> +			set_bit(FW_STATUS_LOADING, &fw_buf->status);
>  		}
>  		break;
>  	case 0:
> -		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
> -			set_bit(FW_STATUS_DONE, &fw_priv->status);
> -			clear_bit(FW_STATUS_LOADING, &fw_priv->status);
> -			complete(&fw_priv->completion);
> +		if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
> +			set_bit(FW_STATUS_DONE, &fw_buf->status);
> +			clear_bit(FW_STATUS_LOADING, &fw_buf->status);
> +			complete(&fw_buf->completion);
>  			break;
>  		}
>  		/* fallthrough */
> @@ -280,21 +294,21 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
>  {
>  	struct device *dev = kobj_to_dev(kobj);
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> -	struct firmware *fw;
> +	struct firmware_buf *buf;
>  	ssize_t ret_count;
>  
>  	mutex_lock(&fw_lock);
> -	fw = fw_priv->fw;
> -	if (!fw || test_bit(FW_STATUS_DONE, &fw_priv->status)) {
> +	buf = fw_priv->buf;
> +	if (!buf || test_bit(FW_STATUS_DONE, &buf->status)) {
>  		ret_count = -ENODEV;
>  		goto out;
>  	}
> -	if (offset > fw_priv->size) {
> +	if (offset > buf->size) {
>  		ret_count = 0;
>  		goto out;
>  	}
> -	if (count > fw_priv->size - offset)
> -		count = fw_priv->size - offset;
> +	if (count > buf->size - offset)
> +		count = buf->size - offset;
>  
>  	ret_count = count;
>  
> @@ -304,11 +318,11 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
>  		int page_ofs = offset & (PAGE_SIZE-1);
>  		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
>  
> -		page_data = kmap(fw_priv->pages[page_nr]);
> +		page_data = kmap(buf->pages[page_nr]);
>  
>  		memcpy(buffer, page_data + page_ofs, page_cnt);
>  
> -		kunmap(fw_priv->pages[page_nr]);
> +		kunmap(buf->pages[page_nr]);
>  		buffer += page_cnt;
>  		offset += page_cnt;
>  		count -= page_cnt;
> @@ -320,12 +334,13 @@ out:

While you're at it, you can indent this "out:" label one space to the
right so that the diff can pick up the function name in the hunk tag
above instead of the label.

@@ -329,7 +329,7 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
                offset += page_cnt;
                count -= page_cnt;
        }
-out:
+ out:
        mutex_unlock(&fw_lock);
        return ret_count;
 }

>  static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
>  {
> +	struct firmware_buf *buf = fw_priv->buf;
>  	int pages_needed = ALIGN(min_size, PAGE_SIZE) >> PAGE_SHIFT;
>  
>  	/* If the array of pages is too small, grow it... */
> -	if (fw_priv->page_array_size < pages_needed) {
> +	if (buf->page_array_size < pages_needed) {
>  		int new_array_size = max(pages_needed,
> -					 fw_priv->page_array_size * 2);
> +					 buf->page_array_size * 2);
>  		struct page **new_pages;
>  
>  		new_pages = kmalloc(new_array_size * sizeof(void *),
> @@ -334,24 +349,24 @@ static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
>  			fw_load_abort(fw_priv);
>  			return -ENOMEM;
>  		}
> -		memcpy(new_pages, fw_priv->pages,
> -		       fw_priv->page_array_size * sizeof(void *));
> -		memset(&new_pages[fw_priv->page_array_size], 0, sizeof(void *) *
> -		       (new_array_size - fw_priv->page_array_size));
> -		kfree(fw_priv->pages);
> -		fw_priv->pages = new_pages;
> -		fw_priv->page_array_size = new_array_size;
> +		memcpy(new_pages, buf->pages,
> +		       buf->page_array_size * sizeof(void *));
> +		memset(&new_pages[buf->page_array_size], 0, sizeof(void *) *
> +		       (new_array_size - buf->page_array_size));
> +		kfree(buf->pages);
> +		buf->pages = new_pages;
> +		buf->page_array_size = new_array_size;
>  	}
>  
> -	while (fw_priv->nr_pages < pages_needed) {
> -		fw_priv->pages[fw_priv->nr_pages] =
> +	while (buf->nr_pages < pages_needed) {
> +		buf->pages[buf->nr_pages] =
>  			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
>  
> -		if (!fw_priv->pages[fw_priv->nr_pages]) {
> +		if (!buf->pages[buf->nr_pages]) {
>  			fw_load_abort(fw_priv);
>  			return -ENOMEM;
>  		}
> -		fw_priv->nr_pages++;
> +		buf->nr_pages++;
>  	}
>  	return 0;
>  }
> @@ -374,15 +389,15 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
>  {
>  	struct device *dev = kobj_to_dev(kobj);
>  	struct firmware_priv *fw_priv = to_firmware_priv(dev);
> -	struct firmware *fw;
> +	struct firmware_buf *buf;
>  	ssize_t retval;
>  
>  	if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>  
>  	mutex_lock(&fw_lock);
> -	fw = fw_priv->fw;
> -	if (!fw || test_bit(FW_STATUS_DONE, &fw_priv->status)) {
> +	buf = fw_priv->buf;
> +	if (!buf || test_bit(FW_STATUS_DONE, &buf->status)) {
>  		retval = -ENODEV;
>  		goto out;
>  	}
> @@ -399,17 +414,17 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
>  		int page_ofs = offset & (PAGE_SIZE - 1);
>  		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
>  
> -		page_data = kmap(fw_priv->pages[page_nr]);
> +		page_data = kmap(buf->pages[page_nr]);
>  
>  		memcpy(page_data + page_ofs, buffer, page_cnt);
>  
> -		kunmap(fw_priv->pages[page_nr]);
> +		kunmap(buf->pages[page_nr]);
>  		buffer += page_cnt;
>  		offset += page_cnt;
>  		count -= page_cnt;
>  	}
>  
> -	fw_priv->size = max_t(size_t, offset, fw_priv->size);
> +	buf->size = max_t(size_t, offset, buf->size);
>  out:
>  	mutex_unlock(&fw_lock);
>  	return retval;
> @@ -434,20 +449,31 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>  		   struct device *device, bool uevent, bool nowait)
>  {
>  	struct firmware_priv *fw_priv;
> +	struct firmware_buf *buf;
>  	struct device *f_dev;
>  
> -	fw_priv = kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
> +	fw_priv = kzalloc(sizeof(*fw_priv), GFP_KERNEL);
>  	if (!fw_priv) {
>  		dev_err(device, "%s: kmalloc failed\n", __func__);
> -		return ERR_PTR(-ENOMEM);
> +		fw_priv = ERR_PTR(-ENOMEM);
> +		goto exit;
>  	}
>  
> -	fw_priv->fw = firmware;
> +	buf = kzalloc(sizeof(*buf) + strlen(fw_name) + 1, GFP_KERNEL);
> +	if (!buf) {
> +		dev_err(device, "%s: kmalloc failed\n", __func__);
> +		kfree(fw_priv);
> +		fw_priv = ERR_PTR(-ENOMEM);
> +		goto exit;
> +	}
> +
> +	buf->fw = firmware;
> +	fw_priv->buf = buf;
>  	fw_priv->nowait = nowait;
> -	strcpy(fw_priv->fw_id, fw_name);
> -	init_completion(&fw_priv->completion);
>  	setup_timer(&fw_priv->timeout,
>  		    firmware_class_timeout, (u_long) fw_priv);
> +	strcpy(buf->fw_id, fw_name);
> +	init_completion(&buf->completion);
>  
>  	f_dev = &fw_priv->dev;
>  
> @@ -455,7 +481,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>  	dev_set_name(f_dev, "%s", fw_name);
>  	f_dev->parent = device;
>  	f_dev->class = &firmware_class;
> -
> +exit:

Ditto: please indent label names one position to the right.

[ … ]

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
