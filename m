Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2A3Uyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:54:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2A3Uya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:54:30 -0500
Date: Mon, 30 Jan 2012 12:54:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock
 held
Message-Id: <20120130125429.56f6f7d0.akpm@linux-foundation.org>
In-Reply-To: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jan 2012 20:52:47 +0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> lkdtm_do_action() may call sleeping functions like kmalloc(),
> so do not call it with spin lock held.
> 
> Cc: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
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

lkdtm_handler() can be called from module IRQ handlers, so perhaps the
same problems can still happen.  The patch does improve things though ;)

