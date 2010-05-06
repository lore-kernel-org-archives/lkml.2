Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab0EFEDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 00:03:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0EFEDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 00:03:35 -0400
Date: Thu, 6 May 2010 00:03:31 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org
Subject: Re: [PATCH] Parisc: Check kmalloc return value before use the
	buffer in ccio-dma.c
Message-ID: <20100506040331.GC4902@bombadil.infradead.org>
References: <20100506024208.GB15956@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506024208.GB15956@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 10:42:08AM +0800, wzt.wzt@gmail.com wrote:
> +	if (!name) {
> +		printk(KERN_ERR "%s() failed to get enough memory\n", __func__);
> +		return ;
> +	}
> +
>  	snprintf(name, 14, "GSC Bus [%d/]", ioc->hw_path);

This code can't fail, since the failure case won't be handled by the
probe function, and will continue along without properly initializing
the resources and will fail later. While we could add proper error
handling, if these functions are called, the ccio IOMMU exists on the
machine, and without it, we can't do any DMA (amongst other things.)
So in that case, if this kmalloc fails (which it really shouldn't...)
we're pretty much screwed.

We can change it to GFP_ATOMIC|__GFP_NOFAIL so it will retry infinitely,
or we can panic in the error path with a nice error message so the users
knows why his machine isn't going to work.

I suggest the latter since you'll have the test to squelch gcc warnings
and such.

regards, Kyle

