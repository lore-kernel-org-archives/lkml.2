Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2JJJ5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:57:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2JJJ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:57:30 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Constantine Shulyupin <const@makelinux.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: usb-skeleton.c: fix compilation error and restore kref_put on fail in skel_open
Date: Wed, 10 Oct 2012 11:55:45 +0200
Message-ID: <1397300.1BYdlnI91r@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1349603832-26424-1-git-send-email-const@MakeLinux.com>
References: <1349603832-26424-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2012 11:57:12 Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Function skel_open increments usage count for the device with kref_get and the usage count should be decremented on the function failure.
> 
> Some last changes in function skel_open and finally commit
> 52a7499 Revert "USB: usb-skeleton.c: fix open/disconnect race"
> introduced a bug in function skel_open, which this patch fixes.
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
>  drivers/usb/usb-skeleton.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> index 0616f23..027005b 100644
> --- a/drivers/usb/usb-skeleton.c
> +++ b/drivers/usb/usb-skeleton.c
> @@ -113,8 +113,10 @@ static int skel_open(struct inode *inode, struct file *file)
>  	mutex_lock(&dev->io_mutex);
>  
>  	retval = usb_autopm_get_interface(interface);
> -	if (retval)
> -		goto out_err;
> +	if (retval) {
> +		kref_put(&dev->kref, skel_delete);
> +		goto exit;
> +	}
>  
>  	/* save our object in the file's private structure */
>  	file->private_data = dev;

Hi,

good catch, but the fix is wrong. You also need to drop the lock.

	Regards
		Oliver


