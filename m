Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0IHUAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:00:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34976 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0IHUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:00:19 -0400
Date: Wed, 8 Sep 2010 14:00:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 4/4] arch/powerpc/platforms/chrp/nvram.c: Add
 of_node_put to avoid memory leak
Message-ID: <20100908200016.GE7065@angua.secretlab.ca>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
 <1283269738-14612-5-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283269738-14612-5-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:48:58PM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_node_by_type.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1,E2;
> statement S;
> @@
> 
> *x = 
> (of_find_node_by_path
> |of_find_node_by_name
> |of_find_node_by_phandle
> |of_get_parent
> |of_get_next_parent
> |of_get_next_child
> |of_find_compatible_node
> |of_match_node
> |of_find_node_by_type
> |of_find_node_with_property
> |of_find_matching_node
> |of_parse_phandle
> )(...);
> ...
> if (x == NULL) S
> <... when != x = E
> *if (...) {
>   ... when != of_node_put(x)
>       when != if (...) { ... of_node_put(x); ... }
> (
>   return <+...x...+>;
> |
> *  return ...;
> )
> }
> ...>
> (
> E2 = x;
> |
> of_node_put(x);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> 
> ---
>  arch/powerpc/platforms/chrp/nvram.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/chrp/nvram.c b/arch/powerpc/platforms/chrp/nvram.c
> index ba3588f..d3ceff0 100644
> --- a/arch/powerpc/platforms/chrp/nvram.c
> +++ b/arch/powerpc/platforms/chrp/nvram.c
> @@ -74,8 +74,10 @@ void __init chrp_nvram_init(void)
>  		return;
>  
>  	nbytes_p = of_get_property(nvram, "#bytes", &proplen);
> -	if (nbytes_p == NULL || proplen != sizeof(unsigned int))
> +	if (nbytes_p == NULL || proplen != sizeof(unsigned int)) {
> +		of_node_put(nvram);
>  		return;
> +	}
>  
>  	nvram_size = *nbytes_p;
>  
> 
