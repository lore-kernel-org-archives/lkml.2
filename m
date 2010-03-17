Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0CQOZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:25:55 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:5359 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0CQOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:25:54 -0400
Subject: Re: [PATCH 4/5] tmpfs: cleanup mpol_parse_str()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kiran@scalex86.org,
       cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, mel@csn.ul.ie,
       stable@kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <20100316145121.4C51.A69D9226@jp.fujitsu.com>
References: <201003122353.o2CNrC56015250@imap1.linux-foundation.org>
	 <20100316143406.4C45.A69D9226@jp.fujitsu.com>
	 <20100316145121.4C51.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Mar 2010 10:25:50 -0400
Message-Id: <1268835950.4773.48.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 14:52 +0900, KOSAKI Motohiro wrote:
> mpol_parse_str() made lots 'err' variable related bug. because
> it is ugly and reviewing unfriendly.
> 
> This patch makes simplify it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Ravikiran Thirumalai <kiran@scalex86.org>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: <stable@kernel.org>

Nice cleanup.

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

> ---
>  mm/mempolicy.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 5c197d5..816419d 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2193,8 +2193,8 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  			char *rest = nodelist;
>  			while (isdigit(*rest))
>  				rest++;
> -			if (!*rest)
> -				err = 0;
> +			if (*rest)
> +				goto out;
>  		}
>  		break;
>  	case MPOL_INTERLEAVE:
> @@ -2203,7 +2203,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		 */
>  		if (!nodelist)
>  			nodes = node_states[N_HIGH_MEMORY];
> -		err = 0;
>  		break;
>  	case MPOL_LOCAL:
>  		/*
> @@ -2212,7 +2211,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		if (nodelist)
>  			goto out;
>  		mode = MPOL_PREFERRED;
> -		err = 0;
>  		break;
>  	case MPOL_DEFAULT:
>  		/*
> @@ -2227,7 +2225,6 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		 */
>  		if (!nodelist)
>  			goto out;
> -		err = 0;
>  	}
>  
>  	mode_flags = 0;
> @@ -2241,13 +2238,14 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  		else if (!strcmp(flags, "relative"))
>  			mode_flags |= MPOL_F_RELATIVE_NODES;
>  		else
> -			err = 1;
> +			goto out;
>  	}
>  
>  	new = mpol_new(mode, mode_flags, &nodes);
>  	if (IS_ERR(new))
> -		err = 1;
> -	else {
> +		goto out;
> +
> +	{
>  		int ret;
>  		NODEMASK_SCRATCH(scratch);
>  		if (scratch) {
> @@ -2258,13 +2256,15 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
>  			ret = -ENOMEM;
>  		NODEMASK_SCRATCH_FREE(scratch);
>  		if (ret) {
> -			err = 1;
>  			mpol_put(new);
> -		} else if (no_context) {
> -			/* save for contextualization */
> -			new->w.user_nodemask = nodes;
> +			goto out;
>  		}
>  	}
> +	err = 0;
> +	if (no_context) {
> +		/* save for contextualization */
> +		new->w.user_nodemask = nodes;
> +	}
>  
>  out:
>  	/* Restore string for error message */

