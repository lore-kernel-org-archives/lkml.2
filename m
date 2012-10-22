Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2JVWFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:05:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2JVWFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:05:31 -0400
Date: Mon, 22 Oct 2012 15:05:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        levinsasha928@gmail.com, Marc.Zyngier@arm.com,
        virtualization@lists.linux-foundation.org, ericvh@gmail.com
Subject: Re: [PATCH v2 2/3] virtio: 9p: correctly pass physical address to
 userspace for high pages
Message-Id: <20121022150530.99caaecf.akpm@linux-foundation.org>
In-Reply-To: <1350651813-8694-2-git-send-email-will.deacon@arm.com>
References: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
	<1350651813-8694-2-git-send-email-will.deacon@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 14:03:32 +0100
Will Deacon <will.deacon@arm.com> wrote:

> When using a virtio transport, the 9p net device may pass the physical
> address of a kernel buffer to userspace via a scatterlist inside a
> virtqueue. If the kernel buffer is mapped outside of the linear mapping
> (e.g. highmem), then virt_to_page will return a bogus value and we will
> populate the scatterlist with junk.
> 
> This patch uses kmap_to_page when populating the page array for a kernel
> buffer.
> 
> ...
>
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -39,6 +39,7 @@
>  #include <linux/inet.h>
>  #include <linux/idr.h>
>  #include <linux/file.h>
> +#include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <net/9p/9p.h>
>  #include <linux/parser.h>
> @@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
>  		int count = nr_pages;
>  		while (nr_pages) {
>  			s = rest_of_page(data);
> -			pages[index++] = virt_to_page(data);
> +			pages[index++] = kmap_to_page(data);
>  			data += s;
>  			nr_pages--;

I am suspecting that this code has been busted for a while on x86
highmem, but nobody noticed.  True or false?  If "true" then I expect
that a -stable backport is appropriate?

