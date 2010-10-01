Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0JALHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:07:14 -0400
Received: from smtp.nokia.com ([192.100.122.233]:53021 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0JALHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:07:12 -0400
Date: Fri, 1 Oct 2010 13:57:11 +0300
From: David Cohen <david.cohen@nokia.com>
To: ext Fernando Guzman Lugo <x0095840@ti.com>
Cc: "Doyu Hiroshi (Nokia-MS/Espoo)" <hiroshi.doyu@nokia.com>,
        "Contreras Felipe (Nokia-MS/Helsinki)" <felipe.contreras@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] iovmm: fix roundup for next area and end check for
 the last area
Message-ID: <20101001105711.GA11617@esdhcp036161.research.nokia.com>
References: <1285902536-7043-1-git-send-email-x0095840@ti.com>
 <1285902536-7043-2-git-send-email-x0095840@ti.com>
 <1285902536-7043-3-git-send-email-x0095840@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285902536-7043-3-git-send-email-x0095840@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Oct 2010 11:06:59.0161 (UTC) FILETIME=[C47B1C90:01CB6158]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 01, 2010 at 05:08:53AM +0200, ext Fernando Guzman Lugo wrote:
> As da_end does not belongs to the area the roundup should
> be done to da_end and not to da_end + 1.
> Also the end check for the last area should be
> ULONG_MAX - start + 1 >= bytes.
> 
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> ---
>  arch/arm/plat-omap/iovmm.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 24ca9c4..fc6b109 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -289,19 +289,19 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>  	prev_end = 0;
>  	list_for_each_entry(tmp, &obj->mmap, list) {
>  
> -		if (prev_end >= start)
> +		if (prev_end > start)
>  			break;
>  
>  		if (start + bytes <= tmp->da_start)
>  			goto found;
>  
>  		if (flags & IOVMF_DA_ANON)
> -			start = roundup(tmp->da_end + 1, alignement);
> +			start = roundup(tmp->da_end, alignement);

There's a lack of comment here, but the purpose of tmp->da_end + 1 is to
create a gap between iovm areas to force to trigger iommu faults when
some access exceeds a valid area. Without this gap, such situation
may produce data corruption which is much more difficult to track.

Br,

David

>  
>  		prev_end = tmp->da_end;
>  	}
>  
> -	if ((start > prev_end) && (ULONG_MAX - start >= bytes))
> +	if ((start >= prev_end) && (ULONG_MAX - start + 1 >= bytes))
>  		goto found;
>  
>  	dev_dbg(obj->dev, "%s: no space to fit %08x(%x) flags: %08x\n",
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
