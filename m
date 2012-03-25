Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2CYTRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:17:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58730 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2CYTRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:17:02 -0400
Date: Sun, 25 Mar 2012 12:16:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Rik van Riel <riel@redhat.com>
cc: Anton Blanchard <anton@samba.org>, aarcange@redhat.com, mel@csn.ul.ie,
        akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Re: kswapd stuck using 100% CPU
In-Reply-To: <20120324102621.353114da@annuminas.surriel.com>
Message-ID: <alpine.LSU.2.00.1203251212050.1984@eggly.anvils>
References: <20120324130353.48f2e4c8@kryten> <20120324102621.353114da@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012, Rik van Riel wrote:
> 
> Only test compaction_suitable if the kernel is built with CONFIG_COMPACTION,
> otherwise the stub compaction_suitable function will always return
> COMPACT_SKIPPED and send kswapd into an infinite loop.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Anton Blanchard <anton@samba.org>

Thank you, Anton and Rik.  I never quite got around to investigating
why swapping had been nearly twice as slow with linux-next on my Aspire
One (with a relatively minimal config, omitting COMPACTION).  That was
the reason (one half of the HT cpu busy in kswapd), and this fixes it.

Tested-by: Hugh Dickins <hughd@google.com>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7658fd6..33c332b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2946,7 +2946,8 @@ out:
>  				continue;
>  
>  			/* Would compaction fail due to lack of free memory? */
> -			if (compaction_suitable(zone, order) == COMPACT_SKIPPED)
> +			if (COMPACTION_BUILD &&
> +			    compaction_suitable(zone, order) == COMPACT_SKIPPED)
>  				goto loop_again;
>  
>  			/* Confirm the zone is balanced for order-0 */
