Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1FOF6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 01:58:06 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:37005 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1FOF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 01:58:05 -0400
Date: Wed, 15 Jun 2011 07:58:03 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible deadlock when suspending framebuffer
Message-ID: <20110615075803.3348b4ec@pluto.restena.lu>
In-Reply-To: <1308100165.2113.4.camel@Tux>
References: <1308100165.2113.4.camel@Tux>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 15 Jun 2011 09:09:24 Wanlong Gao <wanlong.gao@gmail.com> wrote:
> <snip>
> Hi Francis:
> can you test this patch?

Do you have a deadlock trace which you are trying to fix?

It's either the caller of unregister_framebuffer() which must be
changed to not call unregister_framebuffer with info's lock held or
the code reacting on the notification that must not try to acquire the
lock again.

The interesting par is if console semaphore has some relation to this
deadlock as the order for taking both varies... It could be
lock_fb_info(); console_lock()  versus console_lock(); lock_fb_info()

Bruno


> Thanks
> 
> From fe026c42af4cbdce053460a428a445e99071586a Mon Sep 17 00:00:00 2001
> From: Wanlong Gao <wanlong.gao@gmail.com>
> Date: Wed, 15 Jun 2011 09:03:41 +0800
> Subject: [PATCH] test
> 
> 
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  drivers/video/fbmem.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 5aac00e..6e6cef3 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1642,11 +1642,8 @@ static int do_unregister_framebuffer(struct
> fb_info *fb_info)
>  	if (i < 0 || i >= FB_MAX || registered_fb[i] != fb_info)
>  		return -EINVAL;
>  
> -	if (!lock_fb_info(fb_info))
> -		return -ENODEV;
>  	event.info = fb_info;
>  	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
> -	unlock_fb_info(fb_info);

Not a good idea to stop taking fb_lock here.
Pretty all calls of fb_notifier_call_chain are protected by info's
lock, except the one for FB_EVENT_FB_UNREGISTERED a few lines further.

IMHO it wou make sense to add the lock around that last one so all
notifier chain calls are handled the same.

>  	if (ret)
>  		return -EINVAL;

