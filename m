Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab0LMSgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:36:36 -0500
Received: from kroah.org ([198.145.64.141]:43061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab0LMSgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:36:16 -0500
Date: Mon, 13 Dec 2010 10:34:48 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on
 initialize
Message-ID: <20101213183448.GA11745@kroah.com>
References: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:45:50AM -0800, Hank Janssen wrote:
> Correct issue with not checking kmalloc return value.
> This fix now only uses one receive buffer for all hv_utils 
> channels, and will do only one kmalloc on init and will return
> with a -ENOMEM if kmalloc fails on initialize.
> 
> Thanks to Evgeniy Polyakov <zbr@ioremap.net> for pointing this out.
> And thanks to Jesper Juhl <jj@chaosbits.net> and Ky Srinivasan 
> <ksrinivasan@novell.com> for suggesting a better implementation of
> my original patch.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Cc:Evgeniy Polyakov <zbr@ioremap.net>
> Cc:Jesper Juhl <jj@chaosbits.net>
> Cc:Ky Srinivasan <ksrinivasan@novell.com>
> 
> ---
>  drivers/staging/hv/hv_utils.c |   68 +++++++++++++++++++---------------------
>  1 files changed, 32 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
> index 53e1e29..4ed4ab8 100644
> --- a/drivers/staging/hv/hv_utils.c
> +++ b/drivers/staging/hv/hv_utils.c
> @@ -38,12 +38,15 @@
>  #include "vmbus_api.h"
>  #include "utils.h"
>  
> +/*
> + * Buffer used to receive packets from Hyper-V
> + */
> +static u8 *chan_buf;

One buffer is nicer, yes, but what's controlling access to this buffer?
You use it in multiple functions, and what's to say those functions
can't be called at the same time on different cpus?  So, shouldn't you
either have some locking for access to the buffer, or have a
per-function buffer instead?

And if you have a per-function buffer, again, you might need to control
access to it as the functions could be called multiple times at the same
time, right?

thanks,

greg k-h
