Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2H1EaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 00:30:18 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39232 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2H1EaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 00:30:17 -0400
Date: Tue, 28 Aug 2012 12:30:08 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: T Makphaibulchoke <tmac@hp.com>
Cc: akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        weiyang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/resource.c: fix stack overflow in
 __reserve_region_with_split
Message-ID: <20120828043008.GJ20843@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1346114874-6862-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346114874-6862-1-git-send-email-tmac@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082804-1976-0000-0000-000010A424AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 06:47:54PM -0600, T Makphaibulchoke wrote:
> Using recurvise call to try adding a non-conflicting region in the function
> __reserve_region_with_split() could result in a stack overflow in the case
> that the recursive calls are too deep.  Convert the recursive calls to
> an iterative loop to avoid the problem.
> 
> Signed-off-by: T Makphaibulchoke <tmac@hp.com>
> ---
>  kernel/resource.c |   32 ++++++++++++++++++--------------
>  1 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 34d4588..d6e9f9c 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -768,25 +768,29 @@ static void __init __reserve_region_with_split(struct resource *root,
>  		return;
> 
>  	res->name = name;
> -	res->start = start;
> -	res->end = end;
>  	res->flags = IORESOURCE_BUSY;
> 
> -	conflict = __request_resource(parent, res);
> -	if (!conflict)
> -		return;
> +	while (1) {
> +		res->start = start;
> +		res->end = end;
> 
> -	/* failed, split and try again */
> -	kfree(res);
> +		conflict = __request_resource(parent, res);
> +		if (!conflict)
> +			break;
> 
> -	/* conflict covered whole area */
> -	if (conflict->start <= start && conflict->end >= end)
> -		return;
> +		/* conflict covered whole area */
> +		if (conflict->start <= start && conflict->end >= end) {
> +			kfree(res);
> +			break;
> +		}
> +
> +		/* failed, split and try again */
> +		if (conflict->start > start)
> +			end = conflict->start - 1;
> +		if (conflict->end < end)
> +			start = conflict->end + 1;
> +	}

Earlier the patch reserved all areas from 'start' to 'end' skipping any
conflicting intermediate regions.  Your patch will reserve just the
first available fragment before the conflicting range, but will not 
reserve any fragments after the conflicting range. 

For example:
if the region requested is 1 to 100, but 20-30 is already reserved, than
the earlier behavior would reserve 1-20 and 30-100. With your
patch, it will just reserve 1-20.

RP

