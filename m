Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0INXxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:53:15 -0400
Received: from kroah.org ([198.145.64.141]:49523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0INXxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:53:14 -0400
Date: Tue, 14 Sep 2010 16:51:55 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, cyasgadget, remove file system / vfs calls
Message-ID: <20100914235155.GA5339@kroah.com>
References: <1284162953.16135.8.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284162953.16135.8.camel@odc-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 04:55:53PM -0700, David Cross wrote:
> This patch remove file system specific (fat_get_block) and vfs calls
> from the cyasgadget driver. The current implementation expects user
> space to write the file (open, seek to end, 1 byte write), followed by a
> call to clear the dirty pages from the the page cache.
> 
> Signed-off-by: David Cross <david.cross@cypress.com>
> ---
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-10 14:11:05.000000000 -0700
> @@ -1146,11 +1146,9 @@ static int cyasgadget_ioctl(
>  			struct inode *inode = mapping->host;
>  			struct inode *alloc_inode =
>  				file_to_allocate->f_path.dentry->d_inode;
> -			int cluster = 0;
>  			uint32_t num_clusters = 0;
>  			struct buffer_head bh;
>  			struct kstat stat;
> -			struct iattr alloc_iattr;
>  			int nr_pages = 0;
>  			int ret_stat = 0;
>  
> @@ -1185,47 +1183,7 @@ static int cyasgadget_ioctl(
>  			/* block size is arbitrary , we'll use sector size*/
>  			bh.b_size = SECTOR_SIZE ;
>  
> -			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message("%s: getting fat blocks %d "
> -				"size of  %d\n", __func__,
> -				num_clusters, bh.b_size);
> -			#endif
> -			for (cluster = 0; cluster < num_clusters; cluster++)  {
> -				ret_stat = fat_get_block(inode,
> -					cluster, &bh, 1);
> -				if (ret_stat) {
> -					cy_as_hal_print_message(
> -						"%s: unable to get fat block, "
> -						"ret_stat=0x%d\n",
> -						__func__, ret_stat);
> -					goto initsoj_safe_exit;
> -				}
> -			}
> -
> -			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message("%s: allocated clusters "
> -				"successfully (fat_get_block), check bmap..."
> -				"\n", __func__);
> -			#endif
> -
> -			alloc_iattr.ia_valid = ATTR_SIZE;
> -			alloc_iattr.ia_size = k_d.num_bytes;
> -
> -			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message("%s: calling fat_notify_change "
> -				"(ia_valid:%d, ia_size:%d)\n", __func__,
> -				alloc_iattr.ia_valid,
> -				(int)alloc_iattr.ia_size);
> -			#endif
> -
> -			/* adjust the filesize */
> -			ret_stat = alloc_inode->i_op->setattr(
> -				file_to_allocate->f_path.dentry, &alloc_iattr);
> -			#ifndef WESTBRIDGE_NDEBUG
> -			cy_as_hal_print_message("%s: fat_setattr() "
> -				"returned 0x%x\n",
> -				__func__, ret_stat);
> -			#endif
> +			

You added trailing spaces here, please fix your editor to highlight
stuff like this in bright red or something.

I've fixed it by hand, but please don't do it next time.

thanks,

greg k-h
