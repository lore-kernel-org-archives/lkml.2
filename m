Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2JAJfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:35:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab2JAJfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:35:32 -0400
Date: Mon, 1 Oct 2012 15:05:14 +0530
From: Amit Shah <amit.shah@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjurbren@stericsson.com, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 1/3] virtio_console:Merge struct buffer_token into struct
 port_buffer
Message-ID: <20121001093514.GD9810@amit.redhat.com>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com>
 <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 25 Sep 2012 [15:47:15], sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> This merge reduces code size by unifying the approach for
> sending scatter-lists and regular buffers. Any type of
> write operation (splice, write, put_chars) will now allocate
> a port_buffer and send_buf() and free_buf() can always be used.

Thanks for this cleanup; I should've caught it at the review of the
virtio-trace patchset itself -- sorry for that.

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

unsigned int

> +
>  	kfree(buf->buf);

buf->buf isn't set to NULL in case sgpages is > 0.  Please set
buf->buf to NULL (and initialise other fields to default values) in
alloc_buf() (and leave this as is).

> +
> +	if (buf->sgpages)

This 'if' is not necessary; just having the for loop will do the right
thing.

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

Indentation is off.

>  {
>  	struct port_buffer *buf;
> +	size_t alloc_size;
>  
> -	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
> +	/* Allocate buffer and the scatter list */
> +	alloc_size = sizeof(*buf) + sizeof(struct scatterlist) * nrbufs;
> +	buf = kmalloc(alloc_size, GFP_ATOMIC);

This looks hacky, along with the 'struct scatterlist sg[1]' in
port_buffer above.  Use a pointer instead?  At the least, please
include a comment in struct port_buffer mentioning sg has to be the
last element in the struct.

>  	if (!buf)
>  		goto fail;
> -	buf->buf = kzalloc(buf_size, GFP_KERNEL);
> +
> +	buf->sgpages = nrbufs;
> +	if (nrbufs > 0)
> +		return buf;
> +
> +	buf->buf = kmalloc(buf_size, GFP_ATOMIC);

That's a lot of GFP_ATOMICS; even for the cases that don't need them.
Maybe add a gfp param that only allocates GFP_ATOMIC memory from
callers in interrupt context.  All existing code got switched to using
GFP_ATOMIC buffers as well, that's definitely not good.

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
> @@ -476,52 +504,25 @@ static ssize_t send_control_msg(struct port *port, unsigned int event,
>  	return 0;
>  }
>  
> -struct buffer_token {
> -	union {
> -		void *buf;
> -		struct scatterlist *sg;
> -	} u;
> -	/* If sgpages == 0 then buf is used, else sg is used */
> -	unsigned int sgpages;
> -};
> -
> -static void reclaim_sg_pages(struct scatterlist *sg, unsigned int nrpages)
> -{
> -	int i;
> -	struct page *page;
> -
> -	for (i = 0; i < nrpages; i++) {
> -		page = sg_page(&sg[i]);
> -		if (!page)
> -			break;
> -		put_page(page);
> -	}
> -	kfree(sg);
> -}
>  
>  /* Callers must take the port->outvq_lock */
>  static void reclaim_consumed_buffers(struct port *port)
>  {
> -	struct buffer_token *tok;
> +	struct port_buffer *buf;
>  	unsigned int len;
>  
>  	if (!port->portdev) {
>  		/* Device has been unplugged.  vqs are already gone. */
>  		return;
>  	}
> -	while ((tok = virtqueue_get_buf(port->out_vq, &len))) {
> -		if (tok->sgpages)
> -			reclaim_sg_pages(tok->u.sg, tok->sgpages);
> -		else
> -			kfree(tok->u.buf);
> -		kfree(tok);
> +	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
> +		free_buf(buf);
>  		port->outvq_full = false;
>  	}
>  }
>  
> -static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
> -			      int nents, size_t in_count,
> -			      struct buffer_token *tok, bool nonblock)
> +static ssize_t send_buf(struct port *port, struct port_buffer *buf, int nents,
> +			      size_t in_count, bool nonblock)

Indentation is off.

>  {
>  	struct virtqueue *out_vq;
>  	ssize_t ret;
> @@ -534,7 +535,7 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
>  
>  	reclaim_consumed_buffers(port);
>  
> -	ret = virtqueue_add_buf(out_vq, sg, nents, 0, tok, GFP_ATOMIC);
> +	ret = virtqueue_add_buf(out_vq, buf->sg, nents, 0, buf, GFP_ATOMIC);
>  
>  	/* Tell Host to go! */
>  	virtqueue_kick(out_vq);
> @@ -559,8 +560,11 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
>  	 * we need to kmalloc a GFP_ATOMIC buffer each time the
>  	 * console driver writes something out.
>  	 */
> -	while (!virtqueue_get_buf(out_vq, &len))
> +	for (buf = virtqueue_get_buf(out_vq, &len); !buf;
> +	     buf = virtqueue_get_buf(out_vq, &len))
>  		cpu_relax();

Looks awkward, how about

	while (!(buf = virtqueue_get_buf(out_vq, &len))
		cpu_relax();

> +
> +	free_buf(buf);
>  done:
>  	spin_unlock_irqrestore(&port->outvq_lock, flags);
>  
> @@ -572,36 +576,6 @@ done:
>  	return in_count;
>  }
>  
> -static ssize_t send_buf(struct port *port, void *in_buf, size_t in_count,
> -			bool nonblock)
> -{
> -	struct scatterlist sg[1];
> -	struct buffer_token *tok;
> -
> -	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
> -	if (!tok)
> -		return -ENOMEM;
> -	tok->sgpages = 0;
> -	tok->u.buf = in_buf;
> -
> -	sg_init_one(sg, in_buf, in_count);
> -
> -	return __send_to_port(port, sg, 1, in_count, tok, nonblock);
> -}
> -
> -static ssize_t send_pages(struct port *port, struct scatterlist *sg, int nents,
> -			  size_t in_count, bool nonblock)
> -{
> -	struct buffer_token *tok;
> -
> -	tok = kmalloc(sizeof(*tok), GFP_ATOMIC);
> -	if (!tok)
> -		return -ENOMEM;
> -	tok->sgpages = nents;
> -	tok->u.sg = sg;
> -
> -	return __send_to_port(port, sg, nents, in_count, tok, nonblock);
> -}
>  
>  /*
>   * Give out the data that's requested from the buffer that we have
> @@ -748,7 +722,7 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  			       size_t count, loff_t *offp)
>  {
>  	struct port *port;
> -	char *buf;
> +	struct port_buffer *buf;
>  	ssize_t ret;
>  	bool nonblock;
>  
> @@ -766,11 +740,11 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  
>  	count = min((size_t)(32 * 1024), count);
>  
> -	buf = kmalloc(count, GFP_KERNEL);
> +	buf = alloc_buf(port->out_vq, count, 0);
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	ret = copy_from_user(buf, ubuf, count);
> +	ret = copy_from_user(buf->buf, ubuf, count);
>  	if (ret) {
>  		ret = -EFAULT;
>  		goto free_buf;
> @@ -784,13 +758,13 @@ static ssize_t port_fops_write(struct file *filp, const char __user *ubuf,
>  	 * through to the host.
>  	 */
>  	nonblock = true;
> -	ret = send_buf(port, buf, count, nonblock);
> +	ret = send_buf(port, buf, 1, count, nonblock);
>  
>  	if (nonblock && ret > 0)
>  		goto out;
>  
>  free_buf:
> -	kfree(buf);
> +	free_buf(buf);
>  out:
>  	return ret;
>  }
> @@ -856,6 +830,7 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  	struct port *port = filp->private_data;
>  	struct sg_list sgl;
>  	ssize_t ret;
> +	struct port_buffer *buf;
>  	struct splice_desc sd = {
>  		.total_len = len,
>  		.flags = flags,
> @@ -867,17 +842,17 @@ static ssize_t port_fops_splice_write(struct pipe_inode_info *pipe,
>  	if (ret < 0)
>  		return ret;
>  
> +	buf = alloc_buf(port->out_vq, 0, pipe->nrbufs);
>  	sgl.n = 0;
>  	sgl.len = 0;
>  	sgl.size = pipe->nrbufs;
> -	sgl.sg = kmalloc(sizeof(struct scatterlist) * sgl.size, GFP_KERNEL);
> -	if (unlikely(!sgl.sg))
> -		return -ENOMEM;
> -
> +	sgl.sg = buf->sg;
>  	sg_init_table(sgl.sg, sgl.size);
>  	ret = __splice_from_pipe(pipe, &sd, pipe_to_sg);
>  	if (likely(ret > 0))
> -		ret = send_pages(port, sgl.sg, sgl.n, sgl.len, true);
> +		ret = send_buf(port, buf, sgl.n, sgl.len, true);
> +	else
> +		free_buf(buf);
>  
>  	return ret;
>  }
> @@ -1031,6 +1006,7 @@ static const struct file_operations port_fops = {
>  static int put_chars(u32 vtermno, const char *buf, int count)
>  {
>  	struct port *port;
> +	struct port_buffer *port_buf;
>  
>  	if (unlikely(early_put_chars))
>  		return early_put_chars(vtermno, buf, count);
> @@ -1039,7 +1015,13 @@ static int put_chars(u32 vtermno, const char *buf, int count)
>  	if (!port)
>  		return -EPIPE;
>  
> -	return send_buf(port, (void *)buf, count, false);
> +	port_buf = alloc_buf(port->out_vq, count, 0);
> +	if (port_buf == NULL)
> +		return -ENOMEM;
> +
> +	memcpy(port_buf->buf, buf, count);

Hm, this introduces an unnecessary copy for console ports, and is
going to make console IO slower.  Can you think of a way to avoid
this?  (Remember, this is done in interrupt context.)

		Amit
