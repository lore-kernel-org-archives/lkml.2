Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0D3RIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:08:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932652Ab0D3RIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:30 -0400
Date: Thu, 29 Apr 2010 16:06:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] padata: Use a timer to handle the reorder queues
Message-Id: <20100429160644.4dee414d.akpm@linux-foundation.org>
In-Reply-To: <20100429124337.GJ5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
	<20100429124337.GJ5275@secunet.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 14:43:37 +0200
Steffen Klassert <steffen.klassert@secunet.com> wrote:

> padata_get_next had a bogus check that returned always true,
> so the try_again loop in padata_reorder was never taken.

A better changelog would have told us what this "bogus check" _is_.

> This can lead to object leaks in some rare cases.

And a better changelog would describe those leaks!

> This patch
> implements a timer that processes the reorder queues if noone
> else does it in appropriate time.

Under what circumstances would "noone else do it in appropriate time"? 
Would that be a bug, or what?

> @@ -273,13 +274,22 @@ try_again:
>  
>  	spin_unlock_bh(&pd->lock);
>  
> -	if (atomic_read(&pd->reorder_objects))
> -		goto try_again;
> +	if (atomic_read(&pd->reorder_objects)
> +			&& !(pinst->flags & PADATA_RESET))
> +		mod_timer(&pd->timer, jiffies + HZ);
> +	else
> +		del_timer(&pd->timer);
>  
> -out:
>  	return;
>  }

I'd feel more comfortable if the above was in the locked region.  Is
there a race whereby another CPU can set pd->reorder_objects, but we
forgot to arm the timer?


