Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0D3RTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:19:12 -0400
Received: from kroah.org ([198.145.64.141]:39649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab0D3RSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:18:33 -0400
Date: Fri, 30 Apr 2010 09:01:53 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: firmware_class: fix memory leak - free allocated pages
Message-ID: <20100430160153.GA11967@kroah.com>
References: <1272565577-26587-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272565577-26587-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 09:26:17PM +0300, David Woodhouse wrote:
> 
> From: David Woodhouse <dwmw2@infradead.org>
> 
> fix memory leak introduced by the patch 6e03a201bbe:
> firmware: speed up request_firmware()
> 
> 1. vfree won't release pages there were allocated explicitly and mapped
> using vmap. The memory has to be vunmap-ed and the pages needs
> to be freed explicitly
> 
> 2. page array is moved into the 'struct
> firmware' so that we can free it from release_firmware()
> and not only in fw_dev_release()
> 
> The fix doesn't break the firmware load speed.

But it does create a ton of compiler warnings due the const * change.  I
had to fix up the patch to get the firmware.c file to build cleanly, but
that then causes a bunch of warnings all over the tree.

So can someone please fix the patch up properly so it doesn't have these
problems and resend it to me?

thanks,

greg k-h

> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Ming Lei <tom.leiming@gmail.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/base/firmware_class.c |   30 +++++++++++++++++++++++-------
>  include/linux/firmware.h      |    5 +++--
>  2 files changed, 26 insertions(+), 9 deletions(-)
> 
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -130,6 +130,20 @@ static ssize_t firmware_loading_show(str
>  	return sprintf(buf, "%d\n", loading);
>  }
>  
> +static void firmware_free_data(struct firmware *fw)
> +{
> +	int i;
> +	vunmap(fw->data);
> +	fw->data = NULL;
> +	if (fw->pages) {
> +		for (i = 0; i < PFN_UP(fw->size); i++)
> +			__free_page(fw->pages[i]);
> +		kfree(fw->pages);
> +	}
> +	fw->pages = NULL;
> +	fw->size = 0;
> +}
> +
>  /* Some architectures don't have PAGE_KERNEL_RO */
>  #ifndef PAGE_KERNEL_RO
>  #define PAGE_KERNEL_RO PAGE_KERNEL
> @@ -162,21 +176,20 @@ static ssize_t firmware_loading_store(st
>  			mutex_unlock(&fw_lock);
>  			break;
>  		}
> -		vfree(fw_priv->fw->data);
> -		fw_priv->fw->data = NULL;
> +		firmware_free_data(fw_priv->fw);
> +		/* If the pages are not owned by 'struct firmware' */
>  		for (i = 0; i < fw_priv->nr_pages; i++)
>  			__free_page(fw_priv->pages[i]);
>  		kfree(fw_priv->pages);
>  		fw_priv->pages = NULL;
>  		fw_priv->page_array_size = 0;
>  		fw_priv->nr_pages = 0;
> -		fw_priv->fw->size = 0;
>  		set_bit(FW_STATUS_LOADING, &fw_priv->status);
>  		mutex_unlock(&fw_lock);
>  		break;
>  	case 0:
>  		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
> -			vfree(fw_priv->fw->data);
> +			vunmap(fw_priv->fw->data);
>  			fw_priv->fw->data = vmap(fw_priv->pages,
>  						 fw_priv->nr_pages,
>  						 0, PAGE_KERNEL_RO);
> @@ -184,7 +197,10 @@ static ssize_t firmware_loading_store(st
>  				dev_err(dev, "%s: vmap() failed\n", __func__);
>  				goto err;
>  			}
> -			/* Pages will be freed by vfree() */
> +			/* Pages are now owned by 'struct firmware' */
> +			fw_priv->fw->pages = fw_priv->pages;
> +			fw_priv->pages = NULL;
> +
>  			fw_priv->page_array_size = 0;
>  			fw_priv->nr_pages = 0;
>  			complete(&fw_priv->completion);
> @@ -568,7 +584,7 @@ request_firmware(const struct firmware *
>   * @fw: firmware resource to release
>   **/
>  void
> -release_firmware(const struct firmware *fw)
> +release_firmware(struct firmware *fw)
>  {
>  	struct builtin_fw *builtin;
>  
> @@ -578,7 +594,7 @@ release_firmware(const struct firmware *
>  			if (fw->data == builtin->data)
>  				goto free_fw;
>  		}
> -		vfree(fw->data);
> +		firmware_free_data(fw);
>  	free_fw:
>  		kfree(fw);
>  	}
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -12,6 +12,7 @@
>  struct firmware {
>  	size_t size;
>  	const u8 *data;
> +	struct page **pages;
>  };
>  
>  struct device;
> @@ -42,7 +43,7 @@ int request_firmware_nowait(
>  	const char *name, struct device *device, gfp_t gfp, void *context,
>  	void (*cont)(const struct firmware *fw, void *context));
>  
> -void release_firmware(const struct firmware *fw);
> +void release_firmware(struct firmware *fw);
>  #else
>  static inline int request_firmware(const struct firmware **fw,
>  				   const char *name,
> @@ -58,7 +59,7 @@ static inline int request_firmware_nowai
>  	return -EINVAL;
>  }
>  
> -static inline void release_firmware(const struct firmware *fw)
> +static inline void release_firmware(struct firmware *fw)
>  {
>  }
>  #endif
