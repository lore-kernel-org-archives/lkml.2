Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2ICGXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:23:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38228 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab2ICGXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:23:22 -0400
Date: Mon, 3 Sep 2012 14:23:12 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: T Makphaibulchoke <tmac@hp.com>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
        paul.gortmaker@windriver.com, weiyang@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel/resource.c: fix stack overflow in
 __reserve_region_with_split
Message-ID: <20120903062311.GA2370@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1346447065-15399-1-git-send-email-tmac@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346447065-15399-1-git-send-email-tmac@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090306-6078-0000-0000-00000EF7A112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 03:04:25PM -0600, T Makphaibulchoke wrote:
> Using recurvise call to try adding a non-conflicting region in the function
> __reserve_region_with_split() could result in a stack overflow in the case
> that the recursive calls are too deep.  Convert the recursive calls to
> an iterative loop to avoid the problem.
> 
> Signed-off-by: T Makphaibulchoke <tmac@hp.com>
> 
> --
> Change since v1:
> * Fixing __resrve_region_with_split() to ensure a reqioon reserve request is
>   satisfied to the fullest extent, minus any overlapping conflicting regions.
> ---
>  kernel/resource.c |   47 +++++++++++++++++++++++++++++++++++------------
>  1 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 34d4588..f0cdeb6 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -763,6 +763,7 @@ static void __init __reserve_region_with_split(struct resource *root,
>  	struct resource *parent = root;
>  	struct resource *conflict;
>  	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
> +	struct resource *next_res = NULL;
> 
>  	if (!res)
>  		return;
> @@ -772,21 +773,43 @@ static void __init __reserve_region_with_split(struct resource *root,
>  	res->end = end;
>  	res->flags = IORESOURCE_BUSY;
> 
> -	conflict = __request_resource(parent, res);
> -	if (!conflict)
> -		return;
> +	while (1) {
> 
> -	/* failed, split and try again */
> -	kfree(res);
> +		conflict = __request_resource(parent, res);
> +		if (!conflict) {
> +			if (!next_res)
> +				break;
> +			res = next_res;
> +			next_res = NULL;
> +			continue;
> +		}
> 
> -	/* conflict covered whole area */
> -	if (conflict->start <= start && conflict->end >= end)
> -		return;
> +		/* conflict covered whole area */
> +		if (conflict->start <= res->start &&
> +				conflict->end >= res->end) {
> +			kfree(res);
> +			WARN_ON(next_res);
> +			break;
> +		}
> +
> +		/* failed, split and try again */
> +		if (conflict->start > res->start) {
> +			end = res->end;
> +			res->end = conflict->start - 1;
> +			if (conflict->end < end) {
> +				next_res = kzalloc(sizeof(*res), GFP_ATOMIC);
> +				if (!next_res) {
> +					kfree(res);
> +					break;
> +				}
> +				next_res->start = conflict->end + 1;
> +				next_res->end = end;

The new resources name and flags have to be set here.

Otherwise looks correct to me. Certainly some testing will be needed.
RP

