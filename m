Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab1CTN4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 09:56:51 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44842 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1CTN4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 09:56:48 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "M. Mohan Kumar" <mohan@in.ibm.com>, v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] fs/9p: Use updated offset for writing
In-Reply-To: <1300291849-26257-1-git-send-email-mohan@in.ibm.com>
References: <1300291849-26257-1-git-send-email-mohan@in.ibm.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Sun, 20 Mar 2011 19:26:41 +0530
Message-ID: <871v21x5d2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011 21:40:49 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> wrote:
> Use the updated offset given by generic_write_checks. Without this fix,
> even if a file is opened in O_APPEND mode, data will be written at current
> file position instead of end of file.
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Eric, 

I guess this should go in this merge window ?

> ---
>  fs/9p/vfs_file.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 6997eb6..ffed558 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -508,9 +508,12 @@ v9fs_file_write(struct file *filp, const char __user * data,
>  	if (!count)
>  		goto out;
> 
> -	return v9fs_file_write_internal(filp->f_path.dentry->d_inode,
> +	retval = v9fs_file_write_internal(filp->f_path.dentry->d_inode,
>  					filp->private_data,
> -					data, count, offset, 1);
> +					data, count, &origin, 1);
> +	/* update offset on successful write */
> +	if (retval > 0)
> +		*offset = origin;
>  out:
>  	return retval;
>  }
