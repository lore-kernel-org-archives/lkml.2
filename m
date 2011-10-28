Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab1J1XBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:01:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab1J1XBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:01:16 -0400
Date: Fri, 28 Oct 2011 16:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] ida: make ida_simple_get/put() IRQ safe
Message-Id: <20111028160115.bba2b8cf.akpm@linux-foundation.org>
In-Reply-To: <20111026203311.GF24261@google.com>
References: <20111026203311.GF24261@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 13:33:11 -0700
Tejun Heo <tj@kernel.org> wrote:

> It's often convenient to be able to release resource from IRQ context.
> Make ida_simple_*() use irqsave/restore spin ops so that they are IRQ
> safe.

The patch also accidentally makes ida_simple_get() callable from
interrupt context.  That's a somewhat unreliable operation due to
-ENOMEM possibilities even with GFP_ATOMIC.

> --- work.orig/lib/idr.c
> +++ work/lib/idr.c
> @@ -944,6 +944,7 @@ int ida_simple_get(struct ida *ida, unsi
>  {
>  	int ret, id;
>  	unsigned int max;
> +	unsigned long flags;
>  
>  	BUG_ON((int)start < 0);
>  	BUG_ON((int)end < 0);
> @@ -959,7 +960,7 @@ again:
>  	if (!ida_pre_get(ida, gfp_mask))
>  		return -ENOMEM;
>  
> -	spin_lock(&simple_ida_lock);
> +	spin_lock_irqsave(&simple_ida_lock, flags);
>  	ret = ida_get_new_above(ida, start, &id);
>  	if (!ret) {
>  		if (id > max) {
> @@ -969,7 +970,7 @@ again:
>  			ret = id;
>  		}
>  	}
> -	spin_unlock(&simple_ida_lock);
> +	spin_unlock_irqrestore(&simple_ida_lock, flags);
>  
>  	if (unlikely(ret == -EAGAIN))
>  		goto again;
> @@ -985,10 +986,12 @@ EXPORT_SYMBOL(ida_simple_get);
>   */
>  void ida_simple_remove(struct ida *ida, unsigned int id)
>  {
> +	unsigned long flags;
> +
>  	BUG_ON((int)id < 0);
> -	spin_lock(&simple_ida_lock);
> +	spin_lock_irqsave(&simple_ida_lock, flags);
>  	ida_remove(ida, id);
> -	spin_unlock(&simple_ida_lock);
> +	spin_unlock_irqrestore(&simple_ida_lock, flags);
>  }
>  EXPORT_SYMBOL(ida_simple_remove);

It didn't update the kerneldoc.  I wouldn't have bothered either ;)
We're generally bad about documenting permissible calling environments
and preconditions.

