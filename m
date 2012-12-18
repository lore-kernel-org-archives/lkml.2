Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2LREYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:24:36 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:36731 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LREYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:24:35 -0500
Date: Mon, 17 Dec 2012 20:24:36 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] mm/swap: abort swapoff after disk error
In-Reply-To: <20121214110110.8181.70783.stgit@zurg>
Message-ID: <alpine.LNX.2.00.1212171953070.5927@eggly.anvils>
References: <20121214110110.8181.70783.stgit@zurg>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012, Konstantin Khlebnikov wrote:

> Content of non-uptodate pages completely random, we cannot expose them into
> userspace. This leads to information leak and will crash userspace for sure.

Good find, yes, it's very wrong as is.  But, sorry, I don't like your fix
- better than ignoring the issue as at present, but not the right answer.

> Probably we can reuse hwpoison entries here, but tmpfs already too complex.

HWpoison entries?  They're for when that page of RAM is bad, but this is
quite a different case: the page is fine and can perfectly well be freed
and reused - what's bad is the data currently in it.

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Original-patch-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> ---
>  mm/swapfile.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index e97a0e5..98fc2fd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1127,6 +1127,22 @@ int try_to_unuse(unsigned int type, bool frontswap,
>  		wait_on_page_writeback(page);
>  
>  		/*
> +		 * If read failed we cannot map not-uptodate page to
> +		 * user space. Actually, we are in serious troubles,
> +		 * we do not even know what process to kill. So, the only

try_to_unuse() is all about locating exactly where this page belongs;
and if the user is lucky, the page in question won't even be needed again
before the process exits, so nothing should be killed at this point.


> +		 * variant remains: to stop swapoff() and allow someone
> +		 * to kill processes to zap invalid pages.

No, we should not abort swapoff: there's every reason to continue,
to make sure that this unreliable area can be taken out of service.

> +		 *
> +		 * TODO replace page with hwpoison entry in pte and shmem.

Instead of blindly going ahead and inserting ptes pointing to the
!PageUptodate page, unuse_pte() and shmem_unuse_inode() should insert
a substitute bad swapentry, to generate SIGBUS if it's accessed.

swp_entry(1, 0) might serve, but there's probably a few mods needed
here and there; and getting the details right (e.g. memcg charges)
will need care.

Not as straightforward as your block below, I admit.  I wonder if you
posted that just to stir me to do better: or can you take it further?

Thanks,
Hugh

> +		 */
> +		if (unlikely(!PageUptodate(page))) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			retval = -EIO;
> +			break;
> +		}
> +
> +		/*
>  		 * Remove all references to entry.
>  		 */
>  		swcount = *swap_map;
