Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0JTOzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:55:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0JTOzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:55:43 -0400
Date: Wed, 20 Oct 2010 16:55:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@signal11.us, linux-input@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: hidraw, fix window in hidraw_release
In-Reply-To: <1287480595-5627-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1010201655191.6879@pobox.suse.cz>
References: <1287480285-5335-1-git-send-email-jslaby@suse.cz> <1287480595-5627-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Jiri Slaby wrote:

> There is a window between hidraw_table check and its dereference.
> In that window, the device may be unplugged and removed form the
> system and we will then dereference NULL.
> 
> Lock that place properly so that either we get NULL and jump out or we
> can work with real pointer.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  drivers/hid/hidraw.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 925992f..8a4b32d 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -218,9 +218,13 @@ static int hidraw_release(struct inode * inode, struct file * file)
>  	unsigned int minor = iminor(inode);
>  	struct hidraw *dev;
>  	struct hidraw_list *list = file->private_data;
> +	int ret;
>  
> -	if (!hidraw_table[minor])
> -		return -ENODEV;
> +	mutex_lock(&minors_lock);
> +	if (!hidraw_table[minor]) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
>  
>  	list_del(&list->node);
>  	dev = hidraw_table[minor];
> @@ -233,10 +237,12 @@ static int hidraw_release(struct inode * inode, struct file * file)
>  			kfree(list->hidraw);
>  		}
>  	}
> -
>  	kfree(list);
> +	ret = 0;
> +unlock:
> +	mutex_unlock(&minors_lock);
>  
> -	return 0;
> +	return ret;
>  }

Good catch, applied. Thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
