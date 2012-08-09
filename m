Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2HIJA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:00:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab2HIJAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:00:55 -0400
Date: Thu, 9 Aug 2012 14:30:15 +0530
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
Subject: Re: [RFC PATCH 1/6] virtio/console: Add splice_write support
Message-ID: <20120809090015.GG3280@amit.redhat.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
 <20120724023707.6600.69536.stgit@ltc189.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724023707.6600.69536.stgit@ltc189.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 24 Jul 2012 [11:37:07], Yoshihiro YUNOMAE wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Enable to use splice_write from pipe to virtio-console port.
> This steals pages from pipe and directly send it to host.
> 
> Note that this may accelerate only the guest to host path.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Amit Shah <amit.shah@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

> +/* Faster zero-copy write by splicing */
> +static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
> +				      struct file *filp, loff_t *ppos,
> +				      size_t len, unsigned int flags)
> +{
> +	struct port *port = filp->private_data;
> +	struct sg_list sgl;
> +	ssize_t ret;
> +	struct splice_desc sd = {
> +		.total_len = len,
> +		.flags = flags,
> +		.pos = *ppos,
> +		.u.data = &sgl,
> +	};
> +
> +	sgl.n = 0;
> +	sgl.len = 0;
> +	sgl.sg = kmalloc(sizeof(struct scatterlist) * MAX_SPLICE_PAGES,
> +			 GFP_ATOMIC);

Do you expect this function to be called from interrupt context?

> +	if (unlikely(!sgl.sg))
> +		return -ENOMEM;
> +
> +	sg_init_table(sgl.sg, MAX_SPLICE_PAGES);
> +	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
> +	if (likely(ret > 0))
> +		ret = send_pages(port, sgl.sg, sgl.n, sgl.len, true);
> +
> +	return ret;
> +}

		Amit
