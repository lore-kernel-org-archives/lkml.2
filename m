Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0FETl4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:41:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36679 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0FETly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AAL4FjA0J0PO1oxVfKRXDRmm4se0wcUQyAhOB7ceF43E2VngD1Z2jP/L6xXExYMIsI
         nI7joISlmxbBmlbpGhqjX53yd3kJOhGnlJfYcGVyDhDvqGJePCvSQQj5DXtK6/pq0INh
         kBMgmfZx6FwZb6XyhODt0Kt0GQN91crjt8Aeo=
Date: Sat, 5 Jun 2010 21:41:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zorro: BKL removal
Message-ID: <20100605194149.GC5368@nowhere>
References: <alpine.DEB.2.00.1006052121550.12934@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006052121550.12934@ayla.of.borg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 09:23:01PM +0200, Geert Uytterhoeven wrote:
> Remove BKL use from proc_bus_zorro_lseek(), like was done for
> proc_bus_pci_lseek() a long time ago.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---


Cool.

I suspect you'll queue it in your tree? Or should I?

Thanks.



>  drivers/zorro/proc.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
> index 3c7046d..4f4ea88 100644
> --- a/drivers/zorro/proc.c
> +++ b/drivers/zorro/proc.c
> @@ -22,8 +22,9 @@ static loff_t
>  proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>  {
>  	loff_t new = -1;
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	switch (whence) {
>  	case 0:
>  		new = off;
> @@ -35,12 +36,12 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>  		new = sizeof(struct ConfigDev) + off;
>  		break;
>  	}
> -	if (new < 0 || new > sizeof(struct ConfigDev)) {
> -		unlock_kernel();
> -		return -EINVAL;
> -	}
> -	unlock_kernel();
> -	return (file->f_pos = new);
> +	if (new < 0 || new > sizeof(struct ConfigDev))
> +		new = -EINVAL;
> +	else
> +		file->f_pos = new;
> +	mutex_unlock(&inode->i_mutex);
> +	return new;
>  }
>  
>  static ssize_t
> -- 
> 1.7.0.4
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

