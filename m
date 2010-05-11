Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0EKSjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:39:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab0EKSju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:39:50 -0400
Date: Tue, 11 May 2010 11:37:22 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
Message-Id: <20100511113722.65ab2f4a.akpm@linux-foundation.org>
In-Reply-To: <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	<1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 19:22:14 +0100 Chris Wilson <chris@chris-wilson.co.uk> wrote:

> +	reloc_offset = src_priv->gtt_offset;
>  	for (page = 0; page < page_count; page++) {
> -		void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +		void __iomem *s;
> +		void *d;
> +
> +		d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>  		if (d == NULL)
>  			goto unwind;
> -		s = kmap_atomic(src_priv->pages[page], KM_USER0);
> -		memcpy(d, s, PAGE_SIZE);
> -		kunmap_atomic(s, KM_USER0);
> +
> +		s = io_mapping_map_atomic_wc(dev_priv->mm.gtt_mapping,
> +					     reloc_offset);
> +		memcpy_fromio(d, s, PAGE_SIZE);
> +		io_mapping_unmap_atomic(s);

As mentioned in the other email, this will still corrupt the KM_USER0
slot, and will generate a debug_kmap_atomic() warning.

