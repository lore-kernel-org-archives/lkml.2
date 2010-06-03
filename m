Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab0FCAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:38:23 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62490 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933364Ab0FCAiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kASdJpPdUog6q9Ais4DUrBkDlOjzn7vot660+nvr4Z1KScQGaf3A1L0rlf8OIglRzb
         R3xMfn1gi6qq86v504jil2B/6rWkfpO4oX9p36rdZ/l+2AZ65QlCd2jCnD/kYD5/acRd
         gXneWcdo2WDuMVzQC/AMCh8zwKF2XVSGsdjA8=
Date: Thu, 3 Jun 2010 02:38:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 4/5] BKL: use no BKL in llseek
Message-ID: <20100603003826.GD5164@nowhere>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de> <1275523999-27462-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275523999-27462-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:13:18AM +0200, Arnd Bergmann wrote:
> We have shown that the BKL in default_llseek and other
> llseek operations never protects against concurrent access
> from another function:
> 
> * Most drivers never access f_pos
> * Most drivers that access f_pos have their own
>   llseek function
> * Those drivers that use default_llseek and still
>   access f_pos from outside do so without taking the BKL.
> * No file system uses default_llseek.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/pnp/isapnp/proc.c |    6 +++---
>  drivers/usb/core/inode.c  |    1 -
>  drivers/zorro/proc.c      |    6 +++---
>  fs/read_write.c           |    4 ++--
>  4 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
> index 3f94eda..cc22c7c 100644
> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -32,7 +32,7 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>  {
>  	loff_t new = -1;
>  
> -	lock_kernel();
> +	mutex_lock(&file->f_dentry->d_inode->i_mutex);
>  	switch (whence) {
>  	case 0:
>  		new = off;
> @@ -45,10 +45,10 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>  		break;
>  	}
>  	if (new < 0 || new > 256) {
> -		unlock_kernel();
> +		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>  		return -EINVAL;
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>  	return (file->f_pos = new);
>  }
>  
> diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
> index 1a27618..70b1d42 100644
> --- a/drivers/usb/core/inode.c
> +++ b/drivers/usb/core/inode.c
> @@ -39,7 +39,6 @@
>  #include <linux/parser.h>
>  #include <linux/notifier.h>
>  #include <linux/seq_file.h>
> -#include <linux/smp_lock.h>
>  #include <linux/usb/hcd.h>
>  #include <asm/byteorder.h>
>  #include "usb.h"
> diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
> index 3c7046d..8e4c505 100644
> --- a/drivers/zorro/proc.c
> +++ b/drivers/zorro/proc.c
> @@ -23,7 +23,7 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>  {
>  	loff_t new = -1;
>  
> -	lock_kernel();
> +	mutex_lock(&file->f_dentry->d_inode->i_mutex);
>  	switch (whence) {
>  	case 0:
>  		new = off;
> @@ -36,10 +36,10 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>  		break;
>  	}
>  	if (new < 0 || new > sizeof(struct ConfigDev)) {
> -		unlock_kernel();
> +		mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>  		return -EINVAL;
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>  	return (file->f_pos = new);
>  }
>  
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 9c04852..31c0be7 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -124,7 +124,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
>  {
>  	loff_t retval;
>  
> -	lock_kernel();
> +	mutex_lock(&file->f_dentry->d_inode->i_mutex);
>  	switch (origin) {
>  		case SEEK_END:
>  			offset += i_size_read(file->f_path.dentry->d_inode);
> @@ -145,7 +145,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
>  		retval = offset;
>  	}
>  out:
> -	unlock_kernel();
> +	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>  	return retval;
>  }
>  EXPORT_SYMBOL(default_llseek);



This should be simply dropped and we can make use of generic_file_llseek
instead, as the fallback llseek.

