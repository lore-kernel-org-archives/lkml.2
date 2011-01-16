Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1APWyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 17:54:21 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:60883 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1APWyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 17:54:20 -0500
Subject: Re: [PATCH] target: Fix memory leak in
	fd_set_configfs_dev_params().
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <alpine.LNX.2.00.1101162006410.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162006410.13377@swampdragon.chaosbits.net>
Content-Type: text/plain
Date: Sun, 16 Jan 2011 14:54:16 -0800
Message-Id: <1295218456.22813.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 20:17 +0100, Jesper Juhl wrote:
> match_strdup() dynamically allocates memory and it is the responsabillity 
> of the caller to free that memory. In 
> drivers/target/target_core_file.c::fd_set_configfs_dev_params() two calls 
> are made to match_strdup() and in neither case is the allocated memory 
> freed, but instead it is leaked.
> 
> This patch should take care of the problem by kfree()'ing the allocated 
> memory once it is no longer needed. It also makes sure to return -ENOMEM 
> if the memory allocation in match_strdup() should fail.
> 
> Please review and consider for inclusion.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Ugh, this was my fault during the recent v4.0 configfs parameter
conversion.  Committed as 5c45b37 in lio-core-2.6.git/linus-38-rc1 and I
will fix up the other handful of match_strdup() breakage and carry into
scsi-post-merge-2.6.git/for-jejb shortly.

Thanks for catching this..

--nab

> ---
>  target_core_file.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
>   compile tested only.
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 0aaca88..676a010 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -537,15 +537,26 @@ static ssize_t fd_set_configfs_dev_params(
>  		token = match_token(ptr, tokens, args);
>  		switch (token) {
>  		case Opt_fd_dev_name:
> +			arg_p = match_strdup(&args[0]);
> +			if (!arg_p) {
> +				ret = -ENOMEM;
> +				break;
> +			}
>  			snprintf(fd_dev->fd_dev_name, FD_MAX_DEV_NAME,
> -					"%s", match_strdup(&args[0]));
> +					"%s", arg_p);
> +			kfree(arg_p);
>  			printk(KERN_INFO "FILEIO: Referencing Path: %s\n",
>  					fd_dev->fd_dev_name);
>  			fd_dev->fbd_flags |= FBDF_HAS_PATH;
>  			break;
>  		case Opt_fd_dev_size:
>  			arg_p = match_strdup(&args[0]);
> +			if (!arg_p) {
> +				ret = -ENOMEM;
> +				break;
> +			}
>  			ret = strict_strtoull(arg_p, 0, &fd_dev->fd_dev_size);
> +			kfree(arg_p);
>  			if (ret < 0) {
>  				printk(KERN_ERR "strict_strtoull() failed for"
>  						" fd_dev_size=\n");
> 
> 

