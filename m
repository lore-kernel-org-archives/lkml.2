Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0KVSOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:14:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443Ab0KVSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:14:30 -0500
Date: Mon, 22 Nov 2010 10:09:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpu: vga: limit kmalloc'ed memory size
Message-Id: <20101122100915.5bf966fe.akpm@linux-foundation.org>
In-Reply-To: <1290445864-13657-1-git-send-email-segoon@openwall.com>
References: <1290445864-13657-1-git-send-email-segoon@openwall.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 20:11:03 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:

> count is not checked before kmalloc() call.  Too big value would
> generate stack dump.  To prevent this limit 'count' maximum value.
> 1024 looks OK - the data should be the string of tens of bytes.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Compile tested only.
> 
>  v1 had incorrect comment text, as Dan Rosenberg noticed.
> 
>  drivers/gpu/vga/vgaarb.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index c380c65..09e3090 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -836,6 +836,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>  	int ret_val;
>  	int i;
>  
> +	if (count > 1024)
> +		count = 1024;
>  
>  	kbuf = kmalloc(count + 1, GFP_KERNEL);
>  	if (!kbuf)

Bit ugly, that.

Arguably we should just let the allocation attempt pass through to
kmalloc() and let kmalloc() return an error if it was too large.  Possibly
we need a __GFP_NOWARN in there somewhere.  Please send us that stack
dump?

The code should be using strndup_user() anyway.  And perhaps
strndup_user() needs __GFP_NOWARN treatment.

