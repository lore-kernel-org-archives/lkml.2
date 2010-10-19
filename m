Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858Ab0JSJ2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:28:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38131 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826Ab0JSJ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oJyI+RHy1w9zld4opnDs4biA28BKnDeB4iOsa9v/OjzNDALHxiBbC4K84uD7v8u5vD
         mLUlSlMfRbpJhpZovH24yOCS2OvN4aAKZUjp2iXLPCsC6TsgspM/QQb2zBDjMzbJiTxa
         vcChibPNQ5xAHo39G8wjMtXCBFBQ5F9I2s3a0=
Message-ID: <4CBD64AC.7030207@suse.cz>
Date: Tue, 19 Oct 2010 11:28:12 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
CC: jkosina@suse.cz, alan@signal11.us, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: hidraw, fix window in hidraw_release
References: <20101009144026.c37f8d25.ospite@studenti.unina.it> <1287480285-5335-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1287480285-5335-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 11:24 AM, Jiri Slaby wrote:
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
> index 925992f..6d81be3 100644
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
> +	ret = 0;
> +unlock:
> +	mutex_unlock(&minors_lock);
>  	kfree(list);

Actually the kfree cannot be here. The first process to exit would free
it and the others will try to free it again.

Was it supposed to leak memory in the !hidraw_table[minor] case?

regards,
-- 
js
suse labs
