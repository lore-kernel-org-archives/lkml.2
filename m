Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0EPWa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:30:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33408 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0EPWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mxhsxrDszqJbvSw8Z+M4udfrvpy4M38EjEU5+0iPkWv/2tVKPeMKuSkxZOm+H4K/mV
         vgrvMUiHXq4/Lo+IzgWKL0MQF+CbzRHtTDY+GzHJr15ugOQi6vWhTSaJyWXmRGW8HfJt
         PYTXb6qByUn2vLhiL8ZHzsxuyxiChvmrvQ+/8=
Date: Mon, 17 May 2010 00:30:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] uml: Convert to unlocked_ioctls to remove implicit BKL
Message-ID: <20100516223054.GA5276@nowhere>
References: <1273246468-11048-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273246468-11048-1-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 05:34:28PM +0200, John Kacur wrote:
> Convert to hostaudio_ioctl and hostmixer_ioctl_mixdev to unlocked_ioctl
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---



Hi John,

The patch looks good and I'm about to queue it, however it lacks
a changelog that properly explains the safety of the conversion.

Are you fine with this?

"We don't do anything except relying the ioctl to the host which
should then take care of the synchronization."

Thanks.




>  arch/um/drivers/hostaudio_kern.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
> index 368219c..ae42695 100644
> --- a/arch/um/drivers/hostaudio_kern.c
> +++ b/arch/um/drivers/hostaudio_kern.c
> @@ -136,7 +136,7 @@ static unsigned int hostaudio_poll(struct file *file,
>  	return mask;
>  }
>  
> -static int hostaudio_ioctl(struct inode *inode, struct file *file,
> +static long hostaudio_ioctl(struct file *file,
>  			   unsigned int cmd, unsigned long arg)
>  {
>  	struct hostaudio_state *state = file->private_data;
> @@ -223,7 +223,7 @@ static int hostaudio_release(struct inode *inode, struct file *file)
>  
>  /* /dev/mixer file operations */
>  
> -static int hostmixer_ioctl_mixdev(struct inode *inode, struct file *file,
> +static long hostmixer_ioctl_mixdev(struct file *file,
>  				  unsigned int cmd, unsigned long arg)
>  {
>  	struct hostmixer_state *state = file->private_data;
> @@ -289,7 +289,7 @@ static const struct file_operations hostaudio_fops = {
>  	.read           = hostaudio_read,
>  	.write          = hostaudio_write,
>  	.poll           = hostaudio_poll,
> -	.ioctl          = hostaudio_ioctl,
> +	.unlocked_ioctl	= hostaudio_ioctl,
>  	.mmap           = NULL,
>  	.open           = hostaudio_open,
>  	.release        = hostaudio_release,
> @@ -298,7 +298,7 @@ static const struct file_operations hostaudio_fops = {
>  static const struct file_operations hostmixer_fops = {
>  	.owner          = THIS_MODULE,
>  	.llseek         = no_llseek,
> -	.ioctl          = hostmixer_ioctl_mixdev,
> +	.unlocked_ioctl	= hostmixer_ioctl_mixdev,
>  	.open           = hostmixer_open_mixdev,
>  	.release        = hostmixer_release,
>  };
> -- 
> 1.6.6.1
> 

