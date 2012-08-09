Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2HIJDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982Ab2HIJDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:03:39 -0400
Date: Thu, 9 Aug 2012 14:33:12 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH 2/6] virtio/console: Add a failback for unstealable
 pipe buffer
Message-ID: <20120809090312.GH3280@amit.redhat.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
 <20120724023718.6600.68836.stgit@ltc189.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724023718.6600.68836.stgit@ltc189.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 24 Jul 2012 [11:37:18], Yoshihiro YUNOMAE wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Add a failback memcpy path for unstealable pipe buffer.
> If buf->ops->steal() fails, virtio-serial tries to
> copy the page contents to an allocated page, instead
> of just failing splice().
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
>  drivers/char/virtio_console.c |   28 +++++++++++++++++++++++++---
>  1 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index fe31b2f..911cb3e 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -794,7 +794,7 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
>  			struct splice_desc *sd)
>  {
>  	struct sg_list *sgl = sd->u.data;
> -	unsigned int len = 0;
> +	unsigned int offset, len;
>  
>  	if (sgl->n == MAX_SPLICE_PAGES)
>  		return 0;
> @@ -807,9 +807,31 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
>  
>  		len = min(buf->len, sd->len);
>  		sg_set_page(&(sgl->sg[sgl->n]), buf->page, len, buf->offset);
> -		sgl->n++;
> -		sgl->len += len;
> +	} else {
> +		/* Failback to copying a page */
> +		struct page *page = alloc_page(GFP_KERNEL);

I prefer zeroing out the page.  If there's not enough data to be
filled in the page, the remaining data can be leaked to the host.

		Amit
