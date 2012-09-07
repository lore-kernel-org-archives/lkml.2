Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab2IGT2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:28:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2IGT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:28:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Date: Fri, 7 Sep 2012 19:28:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071928.09999.arnd@arndb.de>
X-Provags-ID: V02:K0:/WKsmw0x5/WgBmsulpOeDDeXe7Y3w7iyfZQ4iEBIU6h
 216cW4jMeMoqgOyJ4tneWO6fmUBe2eTarxpx0d6ND6sPbZuYBP
 oQrxFUVfl+uvcO8ez9THvulMR5r4aEMUD26ETjKPPLq6lu3YeM
 wLjl04B/0h3KIL/EXtTlzFJBcx7XibvgQUHly5tiobu+QEHXxq
 jshEAfwA5CHOEApy8v6/jD230S6o/pwOtr6sByBfhLzPNkKZM6
 6QsPs3gQ06TVBUE90xv+j63lyQRq1+46Ve8U9QkY9rX0fpT9HZ
 jaWwSg/MP7Vnvp4Pbe4QjOdvrBpKBtWWFyxuskrEf4eMCd+H7Y
 YjWWQyAKBRpTDVnabZ/Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Catalin Marinas wrote:
> +
> +/*
> + *	dmac_inv_range(start,end)

all of these appear to be unused now. Can you remove them?

> + *	Invalidate the data cache within the specified region; we will be
> + *	performing a DMA operation in this region and we want to purge old
> + *	data in the cache.
> + *
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +ENTRY(dmac_inv_range)
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +	bic	x1, x1, x3
> +1:	dc	ivac, x0			// invalidate D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(dmac_inv_range)
> +
> +/*
> + *	dmac_clean_range(start,end)
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +ENTRY(dmac_clean_range)
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +1:	dc	cvac, x0			// clean D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(dmac_clean_range)
> +
> +/*
> + *	dmac_flush_range(start,end)
> + *	- start   - virtual start address of region
> + *	- end     - virtual end address of region
> + */
> +ENTRY(dmac_flush_range)
> +	dcache_line_size x2, x3
> +	sub	x3, x2, #1
> +	bic	x0, x0, x3
> +1:	dc	civac, x0			// clean & invalidate D / U line
> +	add	x0, x0, x2
> +	cmp	x0, x1
> +	b.lo	1b
> +	dsb	sy
> +	ret
> +ENDPROC(dmac_flush_range)
> +
> +/*
> + *	dmac_map_area(start, size, dir)
> + *	- start	- kernel virtual start address
> + *	- size	- size of region
> + *	- dir	- DMA direction
> + */
> +ENTRY(dmac_map_area)
> +	add	x1, x1, x0
> +	cmp	x2, #DMA_FROM_DEVICE
> +	b.eq	dmac_inv_range
> +	b	dmac_clean_range
> +ENDPROC(dmac_map_area)
> +
> +/*
> + *	dmac_unmap_area(start, size, dir)
> + *	- start	- kernel virtual start address
> + *	- size	- size of region
> + *	- dir	- DMA direction
> + */
> +ENTRY(dmac_unmap_area)
> +	add	x1, x1, x0
> +	cmp	x2, #DMA_TO_DEVICE
> +	b.ne	dmac_inv_range
> +	ret
> +ENDPROC(dmac_unmap_area)


Aside from this:

Acked-by: Arnd Bergmann <arnd@arndb.de>
