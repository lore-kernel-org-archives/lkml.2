Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab2CAUQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:16:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2CAUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:15:58 -0500
Date: Thu, 1 Mar 2012 12:15:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than
 PAGE_SIZE
Message-Id: <20120301121557.0e0fd728.akpm@linux-foundation.org>
In-Reply-To: <1330629779-1449-1-git-send-email-daniel.vetter@ffwll.ch>
References: <20120229153216.8c3ae31d.akpm@linux-foundation.org>
	<1330629779-1449-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Mar 2012 20:22:59 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> drm/i915 wants to read/write more than one page in its fastpath
> and hence needs to prefault more than PAGE_SIZE bytes.
> 
> Add new functions in filemap.h to make that possible.
> 
> Also kill a copy&pasted spurious space in both functions while at it.
> 
>
> ...
>
> +/* Multipage variants of the above prefault helpers, useful if more than
> + * PAGE_SIZE of date needs to be prefaulted. These are separate from the above
> + * functions (which only handle up to PAGE_SIZE) to avoid clobbering the
> + * filemap.c hotpaths. */

Like this please:

/*
 * Multipage variants of the above prefault helpers, useful if more than
 * PAGE_SIZE of date needs to be prefaulted. These are separate from the above
 * functions (which only handle up to PAGE_SIZE) to avoid clobbering the
 * filemap.c hotpaths.
 */

and s/date/data/

> +static inline int fault_in_multipages_writeable(char __user *uaddr, int size)
> +{
> +	int ret;
> +	const char __user *end = uaddr + size - 1;
> +
> +	if (unlikely(size == 0))
> +		return 0;
> +
> +	/*
> +	 * Writing zeroes into userspace here is OK, because we know that if
> +	 * the zero gets there, we'll be overwriting it.
> +	 */

Yeah, like that.

> +	while (uaddr <= end) {
> +		ret = __put_user(0, uaddr);
> +		if (ret != 0)
> +			return ret;
> +		uaddr += PAGE_SIZE;
> +	}
> +
> +	/* Check whether the range spilled into the next page. */
> +	if (((unsigned long)uaddr & PAGE_MASK) ==
> +			((unsigned long)end & PAGE_MASK))
> +		ret = __put_user(0, end);
> +
> +	return ret;
> +}
> +
> +static inline int fault_in_multipages_readable(const char __user *uaddr,
> +					       int size)
> +{
> +	volatile char c;
> +	int ret;
> +	const char __user *end = uaddr + size - 1;
> +
> +	if (unlikely(size == 0))
> +		return 0;
> +
> +	while (uaddr <= end) {
> +		ret = __get_user(c, uaddr);
> +		if (ret != 0)
> +			return ret;
> +		uaddr += PAGE_SIZE;
> +	}
> +
> +	/* Check whether the range spilled into the next page. */
> +	if (((unsigned long)uaddr & PAGE_MASK) ==
> +			((unsigned long)end & PAGE_MASK)) {
> +		ret = __get_user(c, end);
> +		(void)c;
> +	}
> +
> +	return ret;
> +}

Please merge it via the DRI tree.
