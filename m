Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2AWNWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:22:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61291 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356Ab2AWNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:22:42 -0500
Date: Mon, 23 Jan 2012 15:22:33 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Zhao Jin <cronozhj@gmail.com>
cc: cl@linux-foundation.org, mpm@selenic.com, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2][RESEND] slab: avoid unnecessary touching of a partial
 slab
In-Reply-To: <1314376095-14991-1-git-send-email-cronozhj@gmail.com>
Message-ID: <alpine.LFD.2.02.1201231521340.11844@tux.localdomain>
References: <1314376095-14991-1-git-send-email-cronozhj@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2000391229-1327324958=:11844"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2000391229-1327324958=:11844
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

[ Replying to an old patch that I seem to have missed. ]

On Sat, 27 Aug 2011, Zhao Jin wrote:
> In cache_alloc_refill(), after refilling from a partial slab, if the
> slab remains partial, it would be deleted from and then added again to
> the partial list. As the slab is the first element in the list before
> deletion, such behavior has no effect. This patch avoids touching the
> slab in this case.
>
> Signed-off-by: Zhao Jin <cronozhj@gmail.com>

Looks good to me, Christoph, David?

> ---
> mm/slab.c |    7 +++----
> 1 files changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/slab.c b/mm/slab.c
> index 82e0a0e..2d7a0f4 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3121,11 +3121,10 @@ retry:
> 		check_slabp(cachep, slabp);
>
> 		/* move slabp to correct slabp list: */
> -		list_del(&slabp->list);
> 		if (slabp->free == BUFCTL_END)
> -			list_add(&slabp->list, &l3->slabs_full);
> -		else
> -			list_add(&slabp->list, &l3->slabs_partial);
> +			list_move(entry, &l3->slabs_full);
> +		else if (entry != l3->slabs_partial.next)
> +			list_move(entry, &l3->slabs_partial);
> 	}
>
> must_grow:
> -- 
> 1.7.4.1
>
>
--8323328-2000391229-1327324958=:11844--
