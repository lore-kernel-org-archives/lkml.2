Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0G1UAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:00:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49783 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0G1UA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:00:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NTXQVrlaMAcsc+VAt0cyqBJvCy4LFcZKPhdGmQ426L14YmCj2xvcyZ4+A2PMbD+MTM
         dJ39lfnEyW6rs+1v2IaqE7P59QsUuRkytDMZe4eWzBoZtznKYQWZ//6eGQ/fCUjxBCpU
         3UMmrTzUh3C+fLvaqhuXXtttZ9USfRL0dcBXo=
Date: Wed, 28 Jul 2010 22:00:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Andrew Veliath <andrewtv@usa.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] oss: msnd: check request_region() return value
Message-ID: <20100728200002.GP26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, Andrew Veliath <andrewtv@usa.net>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1280335296-23475-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280335296-23475-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 08:41:36PM +0400, Kulikov Vasiliy wrote:
> request_region() may fail, if so return -ENOMEM.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  sound/oss/msnd_pinnacle.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
> index bfaac5f..cd70b9a 100644
> --- a/sound/oss/msnd_pinnacle.c
> +++ b/sound/oss/msnd_pinnacle.c
> @@ -1400,9 +1400,13 @@ static int __init attach_multisound(void)
>  		printk(KERN_ERR LOGNAME ": Couldn't grab IRQ %d\n", dev.irq);
>  		return err;
>  	}
> -	request_region(dev.io, dev.numio, dev.name);

This should be -EBUSY as well.  The same for "[PATCH 06/10] ALSA: msnd: 
check request_region() return value"

Another way to write that would be:

-	request_region(dev.io, dev.numio, dev.name);
+	err = request_region(dev.io, dev.numio, dev.name);
+	if (err) {
+		free_irq(dev.irq, &dev);
+		return err;
+	}

regards,
dan carpenter

> +	if (request_region(dev.io, dev.numio, dev.name) == NULL) {
> +		free_irq(dev.irq, &dev);
> +		return -ENOMEM;
> +	}

