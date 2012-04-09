Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2DIXO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:14:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2DIXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:14:28 -0400
Date: Mon, 9 Apr 2012 16:14:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars Ellenberg <drbd-dev@lists.linbit.com>,
        drbd-user@lists.linbit.com
Subject: Re: [Patch] drbd: check MODULE for THIS_MODULE
Message-Id: <20120409161427.1decc2c1.akpm@linux-foundation.org>
In-Reply-To: <1333433616-8315-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1333433616-8315-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Apr 2012 14:13:36 +0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> THIS_MODULE is NULL only when drbd is compiled as built-in,
> so the #ifdef CONFIG_MODULES should be #ifdef MODULE instead.
> 
> This fixes the warning:
> 
> drivers/block/drbd/drbd_main.c: In function ___drbd_buildtag___:
> drivers/block/drbd/drbd_main.c:4187:24: warning: the comparison will always evaluate as ___true___ for the address of _____this_module___ will never be NULL [-Waddress]
> 
> Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index 211fc44..96c432f 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -4183,12 +4183,11 @@ const char *drbd_buildtag(void)
>  	static char buildtag[38] = "\0uilt-in";
>  
>  	if (buildtag[0] == 0) {
> -#ifdef CONFIG_MODULES
> -		if (THIS_MODULE != NULL)
> -			sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
> -		else
> +#ifdef MODULE
> +		sprintf(buildtag, "srcversion: %-24s", THIS_MODULE->srcversion);
> +#else
> +		buildtag[0] = 'b';
>  #endif
> -			buildtag[0] = 'b';
>  	}
>  
>  	return buildtag;

If the MODULE_SRCVERSION_ALL help in init/Kconfig is to be believed,
this should depend on CONFIG_MODULE_SRCVERSION_ALL?

But drbd is the only driver in all of Linux which plays with
srcversion.  Can we just delete this code?

