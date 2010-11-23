Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0KWUrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:47:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab0KWUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:47:10 -0500
Date: Tue, 23 Nov 2010 12:46:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Tiago Vignatti <tiago.vignatti@nokia.com>,
        Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpu: vga: limit kmalloc'ed memory size
Message-Id: <20101123124600.4401ea43.akpm@linux-foundation.org>
In-Reply-To: <20101123190828.GA27159@albatros>
References: <1290445864-13657-1-git-send-email-segoon@openwall.com>
	<20101122100915.5bf966fe.akpm@linux-foundation.org>
	<20101123190828.GA27159@albatros>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 22:08:28 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> > And perhaps
> > strndup_user() needs __GFP_NOWARN treatment.
> 
> strndup_user() silently return ERR_PTR(-EINVAL) if string is too long.
> 
> > The code should be using strndup_user() anyway.
> 
> Smth like this?
> 
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index 09e3090..3afd249 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -836,19 +836,10 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
>         int ret_val;
>         int i;
>  
> -       if (count > PAGE_SIZE)
> -               count = PAGE_SIZE;
> -
> -       kbuf = kmalloc(count + 1, GFP_KERNEL);
> -       if (!kbuf)
> -               return -ENOMEM;
> -
> -       if (copy_from_user(kbuf, buf, count)) {
> -               kfree(kbuf);
> -               return -EFAULT;
> -       }
> +       kbuf = strndup_user(buf, PAGE_SIZE);
> +       if (IS_ERR(kbuf))
> +               return PTR_ERR(kbuf);
>         curr_pos = kbuf;
> -       kbuf[count] = '\0';     /* Just to make sure... */
>  
>         if (strncmp(curr_pos, "lock ", 5) == 0) {
>                 curr_pos += 5;

What I'm suggesting is that we simply do

	kbuf = strndup_user(buf, count);

and make strndup_user() do the right thing if `count' turned out to be
crazy large.  THis way we don't have to sprinkle decisions about "crazy
largeness" all over the kernel.

And the way in which I suggest that strndup_user() decides whether the
length is too great is to try to kmalloc that amount of memory. 
If it succeeds then fine, proceed.  If it fails then return an error,
probably ENOMEM.  And that attempt to invoke kmalloc() shouldn't spew a
warning.


