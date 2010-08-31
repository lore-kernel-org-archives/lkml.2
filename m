Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0HaP7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:59:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56371 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103Ab0HaP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:59:50 -0400
Date: Tue, 31 Aug 2010 16:59:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 2/4] sound/soc/fsl/p1022_ds.c: Add of_node_put to avoid
 memory leak
Message-ID: <20100831155948.GB30599@rakim.wolfsonmicro.main>
References: <1283269738-14612-1-git-send-email-julia@diku.dk>
 <1283269738-14612-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283269738-14612-3-git-send-email-julia@diku.dk>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 05:48:56PM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_parse_phandle.
> 
> This patch also moves the existing call to of_node_put tothe end of the
> error handling code, to make it possible to jump to of_node_put without
> doing the other cleanup operations.  These appear to be disjoint
> operations, so the ordering doesn't matter.

CCing in Timur who wrote and maintains that driver - looks OK to me.

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
> 
> ---
>  sound/soc/fsl/p1022_ds.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/soc/fsl/p1022_ds.c b/sound/soc/fsl/p1022_ds.c
> index f8176e8..63b9eaa 100644
> --- a/sound/soc/fsl/p1022_ds.c
> +++ b/sound/soc/fsl/p1022_ds.c
> @@ -346,8 +346,10 @@ static int p1022_ds_probe(struct platform_device *pdev)
>  	}
>  
>  	mdata = kzalloc(sizeof(struct machine_data), GFP_KERNEL);
> -	if (!mdata)
> -		return -ENOMEM;
> +	if (!mdata) {
> +		ret = -ENOMEM;
> +		goto error_put;
> +	}
>  
>  	mdata->dai[0].cpu_dai_name = dev_name(&ssi_pdev->dev);
>  	mdata->dai[0].ops = &p1022_ds_ops;
> @@ -502,13 +504,12 @@ static int p1022_ds_probe(struct platform_device *pdev)
>  	return 0;
>  
>  error:
> -	of_node_put(codec_np);
> -
>  	if (sound_device)
>  		platform_device_unregister(sound_device);
>  
>  	kfree(mdata);
> -
> +error_put:
> +	of_node_put(codec_np);
>  	return ret;
>  }
>  
> 
