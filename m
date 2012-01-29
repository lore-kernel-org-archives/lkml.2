Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2A2BNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 20:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2A2BNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 20:13:17 -0500
Message-ID: <4F249DBE.8070203@redhat.com>
Date: Sun, 29 Jan 2012 09:15:42 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock
 held
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com>
In-Reply-To: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2012 08:52 PM, Cong Wang wrote:

> lkdtm_do_action() may call sleeping functions like kmalloc(),
> so do not call it with spin lock held.
> 
> Cc: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


Reviewed-by: Dave Young <dyoung@redhat.com>

> 
> ---
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index 150cd70..28adefe 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -354,6 +354,7 @@ static void lkdtm_do_action(enum ctype which)
>  static void lkdtm_handler(void)
>  {
>  	unsigned long flags;
> +	bool do_it = false;
>  
>  	spin_lock_irqsave(&count_lock, flags);
>  	count--;
> @@ -361,10 +362,13 @@ static void lkdtm_handler(void)
>  			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
>  
>  	if (count == 0) {
> -		lkdtm_do_action(cptype);
> +		do_it = true;
>  		count = cpoint_count;
>  	}
>  	spin_unlock_irqrestore(&count_lock, flags);
> +
> +	if (do_it)
> +		lkdtm_do_action(cptype);
>  }
>  
>  static int lkdtm_register_cpoint(enum cname which)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks
Dave
