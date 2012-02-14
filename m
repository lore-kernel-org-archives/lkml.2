Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969Ab2BNUqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:46:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760596Ab2BNUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:46:48 -0500
Date: Tue, 14 Feb 2012 12:46:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
Message-Id: <20120214124647.73ca5bc1.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1202141336060.24883@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
	<20120209150652.5b1d19dc.akpm@linux-foundation.org>
	<FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
	<alpine.DEB.2.00.1202130958470.23562@router.home>
	<20120213194446.GD26353@mwanda>
	<alpine.DEB.2.00.1202131424020.25908@router.home>
	<20120214072017.GF26353@mwanda>
	<alpine.DEB.2.00.1202140858080.20013@router.home>
	<8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
	<alpine.DEB.2.00.1202141032410.22250@router.home>
	<ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
	<alpine.DEB.2.00.1202141329360.24883@router.home>
	<alpine.DEB.2.00.1202141336060.24883@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 13:37:44 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> This patch still preserves kcalloc. But note that if kcalloc returns NULL
> then multiple conditions may have caused it. One is that the array is
> simply too large. The other may be that such an allocation is not possible
> due to fragmentation.
> 
> 
> Subject: Introduce calculate_array_size
> 
> calculate_array_size calculates the size of an array while
> checking for errors. Returns 0 if the size is too large.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> 
> ---
>  include/linux/slab.h |   15 +++++++++++++++
>  mm/util.c            |    9 ++++++---
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/slab.h
> ===================================================================
> --- linux-2.6.orig/include/linux/slab.h	2012-02-14 13:32:43.000000000 -0600
> +++ linux-2.6/include/linux/slab.h	2012-02-14 13:34:41.000000000 -0600
> @@ -242,6 +242,21 @@ size_t ksize(const void *);
>   */
>  void *kcalloc(size_t n, size_t size, gfp_t flags);
> 
> +/*
> + * calculate_array_size - Calculate an array size given the size of a
> + * particular element with checking for overflow.
> + *
> + * Return 0 if there is an overflow.
> + */
> +static inline long calculate_array_size(size_t n, size_t size)
> +{
> +	if (size != 0 && n > ULONG_MAX / size)
> +
> +		return 0;
> +
> +	return n * size;
> +}
> +
>  #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
>  /**
>   * kmalloc_node - allocate memory from a specific node
> Index: linux-2.6/mm/util.c
> ===================================================================
> --- linux-2.6.orig/mm/util.c	2012-02-14 13:32:54.000000000 -0600
> +++ linux-2.6/mm/util.c	2012-02-14 13:34:10.000000000 -0600
> @@ -83,9 +83,12 @@ EXPORT_SYMBOL(kmemdup);
>   */
>  void *kcalloc(size_t n, size_t size, gfp_t flags)
>  {
> -	if (size != 0 && n > ULONG_MAX / size)
> -		return NULL;
> -	return __kmalloc(n * size, flags | __GFP_ZERO);
> +	size_t s = calculate_array_size(n, size);
> +
> +	if (s)
> +		return kzalloc(s, flags);
> +
> +	return NULL;
>  }
>  EXPORT_SYMBOL(kcalloc);

The patch appears to be a no-op.  Confused.

