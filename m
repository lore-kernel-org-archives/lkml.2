Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2I0CFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:05:41 -0400
Received: from ozlabs.org ([203.10.76.45]:53093 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab2I0CFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:05:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv5 2/3] virtio_console: Add support for remoteproc serial
In-Reply-To: <1348580837-10919-3-git-send-email-sjur.brandeland@stericsson.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com> <1348580837-10919-3-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 27 Sep 2012 09:22:24 +0930
Message-ID: <87haqk4a13.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add a simple serial connection driver called
> VIRTIO_ID_RPROC_SERIAL (11) for communicating with a
> remote processor in an asymmetric multi-processing
> configuration.
>
...
>  static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
>  				     int nrbufs)
>  {
>  	struct port_buffer *buf;
>  	size_t alloc_size;
>  
> +	if (is_rproc_serial(vq->vdev) && !irqs_disabled())
> +		reclaim_dma_bufs();

Hmm, you need a gfp_t arg into alloc_buf; your last patch simply changed
them all to GFP_ATOMIC, which makes the console far less memory
friendly.

You check !irqs_disabled() in a couple of places; I think the caller
needs to indicate (possibly by checking for gfp == GFP_KERNEL) whether
it's safe to call reclaim_dma_bufs().

> @@ -838,6 +927,10 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  		.u.data = &sgl,
>  	};
>  
> +	/* rproc_serial does not support splice */
> +	if (is_rproc_serial(port->out_vq->vdev))
> +		return -EINVAL;

Why not? ;)

Thanks,
Rusty.
