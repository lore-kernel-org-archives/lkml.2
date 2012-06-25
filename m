Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2FYC3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 22:29:42 -0400
Received: from tundra.namei.org ([65.99.196.166]:44525 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2FYC3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 22:29:41 -0400
Date: Mon, 25 Jun 2012 12:29:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ima: use full pathnames in measurement list
In-Reply-To: <1340375022.2464.29.camel@falcor>
Message-ID: <alpine.LRH.2.02.1206251229180.26369@tundra.namei.org>
References: <1340375022.2464.29.camel@falcor>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Mimi Zohar wrote:

> The IMA measurement list contains filename hints, which can be
> ambigious without the full pathname.  This patch replaces the
> filename hint with the full pathname, simplifying for userspace
> the correlating of file hash measurements with files.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Are you posting this for review or do you want it applied to my tree?


> ---
>  security/integrity/ima/ima_main.c |   40 +++++++++++++++++++++++++++++++-----
>  1 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index b17be79..91fa323 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -54,6 +54,7 @@ static void ima_rdwr_violation_check(struct file *file)
>  	fmode_t mode = file->f_mode;
>  	int rc;
>  	bool send_tomtou = false, send_writers = false;
> +	unsigned char *pathname = NULL, *pathbuf = NULL;
>  
>  	if (!S_ISREG(inode->i_mode) || !ima_initialized)
>  		return;
> @@ -75,12 +76,25 @@ static void ima_rdwr_violation_check(struct file *file)
>  out:
>  	mutex_unlock(&inode->i_mutex);
>  
> +	if (!send_tomtou && !send_writers)
> +		return;
> +
> +	/* We will allow 11 spaces for ' (deleted)' to be appended */
> +	pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
> +	if (pathbuf) {
> +		pathname = d_path(&file->f_path, pathbuf, PATH_MAX + 11);
> +		if (IS_ERR(pathname))
> +			pathname = NULL;
> +	}
>  	if (send_tomtou)
> -		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> -				  "ToMToU");
> +		ima_add_violation(inode,
> +				  !pathname ? dentry->d_name.name : pathname,
> +				  "invalid_pcr", "ToMToU");
>  	if (send_writers)
> -		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> -				  "open_writers");
> +		ima_add_violation(inode,
> +				  !pathname ? dentry->d_name.name : pathname,
> +				  "invalid_pcr", "open_writers");
> +	kfree(pathbuf);
>  }
>  
>  static void ima_check_last_writer(struct integrity_iint_cache *iint,
> @@ -123,6 +137,7 @@ static int process_measurement(struct file *file, const unsigned char *filename,
>  {
>  	struct inode *inode = file->f_dentry->d_inode;
>  	struct integrity_iint_cache *iint;
> +	unsigned char *pathname = NULL, *pathbuf = NULL;
>  	int rc = 0;
>  
>  	if (!ima_initialized || !S_ISREG(inode->i_mode))
> @@ -147,8 +162,21 @@ retry:
>  		goto out;
>  
>  	rc = ima_collect_measurement(iint, file);
> -	if (!rc)
> -		ima_store_measurement(iint, file, filename);
> +	if (rc != 0)
> +		goto out;
> +
> +	if (function != BPRM_CHECK) {
> +		/* We will allow 11 spaces for ' (deleted)' to be appended */
> +		pathbuf = kmalloc(PATH_MAX + 11, GFP_KERNEL);
> +		if (pathbuf) {
> +			pathname =
> +			    d_path(&file->f_path, pathbuf, PATH_MAX + 11);
> +			if (IS_ERR(pathname))
> +				pathname = NULL;
> +		}
> +	}
> +	ima_store_measurement(iint, file, !pathname ? filename : pathname);
> +	kfree(pathbuf);
>  out:
>  	mutex_unlock(&iint->mutex);
>  	return rc;
> -- 
> 1.7.7.6
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
