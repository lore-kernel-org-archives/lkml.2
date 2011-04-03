Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1DCS53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 14:57:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1DCS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 14:57:28 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=wom5GMh1gUkA:10 a=rTFi3hi61dwA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=ybZZDoGAAAAA:8 a=fxJcL_dCAAAA:8 a=Z4Rwk6OoAAAA:8 a=JIoDnU1e-xCkGDGO4_MA:9 a=8bfkpD5TqYDDm08hROgA:7 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=2eKvNQJKnqYA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Sun, 3 Apr 2011 13:57:27 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: ntl@pobox.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 04/10] Introduce vfs_fcntl() helper
Message-ID: <20110403185727.GC15044@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-5-git-send-email-ntl@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298936432-29607-5-git-send-email-ntl@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting ntl@pobox.com (ntl@pobox.com):
> From: Nathan Lynch <ntl@pobox.com>
> 
> When restoring process state from a checkpoint image, it will be
> necessary to restore file status flags; add vfs_fcntl() for this
> purpose.
> 
> Based on original code by Oren Laadan.
> 
> Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
> [ntl: extracted from "c/r: checkpoint and restart open file descriptors"]
> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/fcntl.c         |   21 +++++++++++++--------
>  include/linux/fs.h |    2 ++
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index ecc8b39..8e797b7 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -426,6 +426,18 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
>  	return err;
>  }
>  
> +int vfs_fcntl(int fd, unsigned int cmd, unsigned long arg, struct file *filp)
> +{
> +	int err;
> +
> +	err = security_file_fcntl(filp, cmd, arg);
> +	if (err)
> +		goto out;
> +	err = do_fcntl(fd, cmd, arg, filp);
> + out:
> +	return err;
> +}
> +
>  SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
>  {	
>  	struct file *filp;
> @@ -435,14 +447,7 @@ SYSCALL_DEFINE3(fcntl, unsigned int, fd, unsigned int, cmd, unsigned long, arg)
>  	if (!filp)
>  		goto out;
>  
> -	err = security_file_fcntl(filp, cmd, arg);
> -	if (err) {
> -		fput(filp);
> -		return err;
> -	}
> -
> -	err = do_fcntl(fd, cmd, arg, filp);
> -
> +	err = vfs_fcntl(fd, cmd, arg, filp);
>   	fput(filp);
>  out:
>  	return err;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 315ded4..175bb75 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1112,6 +1112,8 @@ struct file_lock {
>  
>  #include <linux/fcntl.h>
>  
> +extern int vfs_fcntl(int fd, unsigned cmd, unsigned long arg, struct file *fp);
> +
>  extern void send_sigio(struct fown_struct *fown, int fd, int band);
>  
>  #ifdef CONFIG_FILE_LOCKING
> -- 
> 1.7.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
