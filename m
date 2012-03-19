Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2CSXso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:48:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59265 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2CSXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:48:43 -0400
Date: Mon, 19 Mar 2012 16:48:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Gehring <mg@ebfe.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/vt: set_get_cmap() check user buffer
Message-ID: <20120319234839.GA26931@kroah.com>
References: <1332200041-31052-1-git-send-email-mg@ebfe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332200041-31052-1-git-send-email-mg@ebfe.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:34:01AM +0100, Michael Gehring wrote:
> set_get_cmap() ignores the result of {get,put}_user(), causing ioctl(vt,
> {G,P}IO_CMAP, 0xdeadbeef) to silently fail.

Why not just check each return value, failing only if/when a specific
write fails?

> 
> Another side effect of this: calling the PIO_CMAP ioctl with an invalid
> buffer will zero the default colormap and the palette for all vts (all
> colors set to black).
> 
> Use access_ok() and return -EFAULT when appropriate.
> 
> Signed-off-by: Michael Gehring <mg@ebfe.org>
> ---
>  drivers/tty/vt/vt.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index e716839..176b2a1 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3897,15 +3897,18 @@ static int set_get_cmap(unsigned char __user *arg, int set)
>  
>      WARN_CONSOLE_UNLOCKED();
>  
> +    if (!access_ok(set ? VERIFY_READ : VERIFY_WRITE, arg, 3 * 16))
> +	return -EFAULT;
> +
>      for (i = 0; i < 16; i++)
>  	if (set) {
> -	    get_user(default_red[i], arg++);
> -	    get_user(default_grn[i], arg++);
> -	    get_user(default_blu[i], arg++);
> +	    __get_user(default_red[i], arg++);
> +	    __get_user(default_grn[i], arg++);
> +	    __get_user(default_blu[i], arg++);
>  	} else {
> -	    put_user(default_red[i], arg++);
> -	    put_user(default_grn[i], arg++);
> -	    put_user(default_blu[i], arg++);
> +	    __put_user(default_red[i], arg++);
> +	    __put_user(default_grn[i], arg++);
> +	    __put_user(default_blu[i], arg++);

What's to keep this userspace buffer from becoming invalid after the
check?  For some reason I thought we couldn't check beforehand like
this, but I can't recall why at this specific moment.

And ugh, why do we have a function that does two things, like this?  The
only thing we are "saving" is a single for loop by doing things this
way, splitting it out into a set/get function, would make more sense in
the end.

thanks,

greg k-h
