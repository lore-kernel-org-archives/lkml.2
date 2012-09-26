Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2IZCon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 22:44:43 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57237 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2IZCom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 22:44:42 -0400
X-AuditID: b753bd60-96850ba000002f78-04-50626c17ae58
X-AuditID: b753bd60-96850ba000002f78-04-50626c17ae58
Message-ID: <50626C11.9040708@hitachi.com>
Date: Wed, 26 Sep 2012 11:44:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: sjur.brandeland@stericsson.com
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@stericsson.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] virtio_console:Merge struct buffer_token into struct
 port_buffer
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com> <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/25 22:47), sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> This merge reduces code size by unifying the approach for
> sending scatter-lists and regular buffers. Any type of
> write operation (splice, write, put_chars) will now allocate
> a port_buffer and send_buf() and free_buf() can always be used.

Thanks!
This looks much nicer and simpler. I just have some comments below.

> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: Rusty Russell <rusty@rustcorp.com.au>
> cc: Michael S. Tsirkin <mst@redhat.com>
> cc: Amit Shah <amit.shah@redhat.com>
> cc: Linus Walleij <linus.walleij@linaro.org>
> cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  drivers/char/virtio_console.c |  141 ++++++++++++++++++-----------------------
>  1 files changed, 62 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 8ab9c3d..f4f7b04 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -111,6 +111,11 @@ struct port_buffer {
>  	size_t len;
>  	/* offset in the buf from which to consume data */
>  	size_t offset;
> +
> +	/* If sgpages == 0 then buf is used, else sg is used */
> +	unsigned int sgpages;
> +
> +	struct scatterlist sg[1];
>  };
>  
>  /*
> @@ -338,23 +343,46 @@ static inline bool use_multiport(struct ports_device *portdev)
>  
>  static void free_buf(struct port_buffer *buf)
>  {
> +	int i;
> +
>  	kfree(buf->buf);

this should be done only when !buf->sgpages, or (see below)

> +
> +	if (buf->sgpages)
> +		for (i = 0; i < buf->sgpages; i++) {
> +			struct page *page = sg_page(&buf->sg[i]);
> +			if (!page)
> +				break;
> +			put_page(page);
> +		}
> +
>  	kfree(buf);
>  }
>  
> -static struct port_buffer *alloc_buf(size_t buf_size)
> +static struct port_buffer *alloc_buf(struct virtqueue *vq, size_t buf_size,
> +				     int nrbufs)
>  {
>  	struct port_buffer *buf;
> +	size_t alloc_size;
>  
> -	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> +	/* Allocate buffer and the scatter list */
> +	alloc_size = sizeof(*buf) + sizeof(struct scatterlist) * nrbufs;

This allocates one redundant sg entry when nrbuf > 0,
but I think it is OK. (just a comment)

> +	buf = kmalloc(alloc_size, GFP_ATOMIC);

This should be kzalloc(), or buf->buf and others are not initialized,
which will cause unexpected kfree bug at kfree(buf->buf) in free_buf.

>  	if (!buf)
>  		goto fail;
> -	buf->buf = kzalloc(buf_size, GFP_KERNEL);
> +
> +	buf->sgpages = nrbufs;
> +	if (nrbufs > 0)
> +		return buf;
> +
> +	buf->buf = kmalloc(buf_size, GFP_ATOMIC);

You can also use kzalloc here as previous code does.
But if the reason why using kzalloc comes from the security,
I think kmalloc is enough here, since the host can access
all the guest pages anyway.

>  	if (!buf->buf)
>  		goto free_buf;
>  	buf->len = 0;
>  	buf->offset = 0;
>  	buf->size = buf_size;
> +
> +	/* Prepare scatter buffer for sending */
> +	sg_init_one(buf->sg, buf->buf, buf_size);
>  	return buf;
>  
>  free_buf:

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


