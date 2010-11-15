Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0KOEs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:48:56 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34724 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab0KOEsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:48:55 -0500
Date: Mon, 15 Nov 2010 13:48:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] fbcmap: integer overflow bug
Message-ID: <20101115044820.GA8489@linux-sh.org>
References: <20101027093716.GD6062@bicker> <20101105134018.2c11f283.akpm@linux-foundation.org> <20101113100718.GB1795@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113100718.GB1795@bicker>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 01:07:18PM +0300, Dan Carpenter wrote:
> @@ -256,8 +264,12 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>  	int rc, size = cmap->len * sizeof(u16);
>  	struct fb_cmap umap;
>  
> +	if (cmap->len * 2 > INT_MAX)
> +		return -EINVAL;
> +
>  	memset(&umap, 0, sizeof(struct fb_cmap));
> -	rc = fb_alloc_cmap(&umap, cmap->len, cmap->transp != NULL);
> +	rc = fb_alloc_cmap_gfp(&umap, cmap->len, cmap->transp != NULL,
> +				GFP_KERNEL);
>  	if (rc)
>  		return rc;
>  	if (copy_from_user(umap.red, cmap->red, size) ||

This looks reasonable, but it probably makes more sense to use -E2BIG
for the overflow case (as other cases are doing already), and also just
to check size directly rather than open-coding the * 2.
