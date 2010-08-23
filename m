Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0HWT00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:26:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab0HWT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:26:24 -0400
Date: Mon, 23 Aug 2010 12:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Message-Id: <20100823122606.47524cef.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010 19:57:51 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
> caller.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/md/dm-region-hash.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
> --- a/drivers/md/dm-region-hash.c
> +++ b/drivers/md/dm-region-hash.c
> @@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
>  	struct dm_region *reg, *nreg;
>  
>  	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
> -	if (unlikely(!nreg))
> -		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
> +	if (unlikely(!nreg)) {
> +		/* FIXME: this may potentially loop forever */
> +		do {
> +			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
> +		} while (!nreg);
> +	}
>  
>  	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
>  		      DM_RH_CLEAN : DM_RH_NOSYNC;

erm.

The reason for adding GFP_NOFAIL in the first place was my observation
that the kernel contained lots of open-coded retry-for-ever loops.

All of these are wrong, bad, buggy and mustfix.  So we consolidated the
wrongbadbuggymustfix concept into the core MM so that miscreants could
be easily identified and hopefully fixed.

I think that simply undoing that change is a bad idea - it allows the
wrongbadbuggymustfix code to hide from view.

The correct way to remove __GFP_NOFAIL is to fix the
wrongbadbuggymustfix code properly.
