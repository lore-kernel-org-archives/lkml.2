Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0IHTvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:51:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61859 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0IHTve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:51:34 -0400
Date: Wed, 8 Sep 2010 13:51:30 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 6/7] arch/powerpc/platforms/maple/setup.c: Add
 of_node_put to avoid memory leak
Message-ID: <20100908195130.GB7065@angua.secretlab.ca>
References: <1283075566-27441-1-git-send-email-julia@diku.dk>
 <1283075566-27441-7-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283075566-27441-7-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 11:52:45AM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_node_by_path.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1;
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
> of_node_put(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  arch/powerpc/platforms/maple/setup.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
> index 3fff8d9..fe34c3d 100644
> --- a/arch/powerpc/platforms/maple/setup.c
> +++ b/arch/powerpc/platforms/maple/setup.c
> @@ -358,6 +358,7 @@ static int __init maple_cpc925_edac_setup(void)
>  	model = (const unsigned char *)of_get_property(np, "model", NULL);
>  	if (!model) {
>  		printk(KERN_ERR "%s: Unabel to get model info\n", __func__);
> +		of_node_put(np);

Acked-by: Grant Likely <grant.likely@secretlab.ca>

This patch should also fix the exact same problem after a call to
of_find_node_by_type() in the same function (line 370).

>  		return -ENODEV;
>  	}
>  
> 
