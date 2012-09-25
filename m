Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2IYECS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab2IYECR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:02:17 -0400
Date: Tue, 25 Sep 2012 09:31:58 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv4] virtio_console: Add support for remoteproc serial
Message-ID: <20120925040158.GC32657@amit.redhat.com>
References: <1348489987-6768-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120924174523.GA14390@amit.redhat.com>
 <81C3A93C17462B4BBD7E272753C1057923BD79D728@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923BD79D728@EXDCVYMBSTM005.EQ1STM.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 24 Sep 2012 [23:50:01], Sjur BRENDELAND wrote:
> Hi Amit,
> 
> > I'm sorry for not being able to look at this earlier.
> 
> No worries. I'll try to respin and retest this patch by tomorrow.
> If you by any chance could find time to review so could make it in time
> for 3.7 it would be great :-)

I think it might be late for 3.7 already, I'd prefer to let this bake
for a while, ensure it passes my test suites, at the least.  But I'll
let Rusty take the final call.

> > A general comment is to base this patchset on linux-next; we've been
> > seeing more than usual activity for virtio_console this time around.
> > I don't expect the conflicts to be big, though.
> 
> Sure, I'll based the next patch on linux-next.
> 
> ...
> > > This implementation reuses the existing virtio_console
> > > implementation, and adds support for DMA allocation
> > > of data buffers and disables use of tty console and
> > > the virtio control queue.
> > 
> > Any specific reason to not use the control queue?  It's just another
> > virtio-serial port; the only special thing about it being it's an
> > internal channel between the device and driver.
> 
> Yes, as mention to Michael earlier. I use rproc_serial for talking
> to a modem running in early boot phases, before the OS has started,
> or when the modem is executing it's crash handler. In both these 
> cases the modem run in a very limited execution environment, so
> I want to keep the protocol and handling of the vqs as simple as
> possible. Due to this I really don't want more than single pair
> of vqs.

OK.

> We also have very simple use-cases. The port is opened once
> in the life-time of the modem, and only reopened after a
> cold-start of the modem. So I should not get into any issues
> with race conditions.
>
> > If you're not going to implement any control commands, I guess you
> > could conveniently not use the actual port, but keep it around, in
> > case you find use for it later.  The advantage will be that older
> > kernels will work without any updates on newer devices.
> 
> With the current usage pattern I have in mind, I'd rather add this
> feature later when/if needed. We can always add a new feature bit
> for this if we introduce the control channel later on.

OK.

> > >  static void free_buf(struct port_buffer *buf)
> > >  {
> > > -	kfree(buf->buf);
> > > +	unsigned long flags;
> > > +
> > > +	if (!buf->dev) {
> > > +		kfree(buf->buf);
> > > +		goto freebuf;
> > > +	}
> > > +
> > > +	BUG_ON(!rproc_enabled);
> > > +
> > > +	/* dma_free_coherent requires interrupts to be enabled */
> > > +	if (rproc_enabled && !irqs_disabled()) {
> > 
> > You don't need to check for rproc_enabled here.
> 
> Actually I do need this check. The reason is that I am
> exploiting gcc's ability to discard dead code. When I compile
> for arch's that does not have DMA, this block is dead and will be
> discarded. This way I avoid the link error for the missing
> symbol dma_free_coherent(). But I can add a comment on this.

OK, I see.  The BUG_ON would guarantee at run-time, but the
compile-time advantage wasn't obvious.

> > Then, you can just invert the if condition (if (irqs_disabled()) and
> > include the relevant block here.  This way, you can make do without
> > the goto and return mess below.
> 
> Yeah, I did an earlier version without goto, but I wanted to separate
> the rproc / non-rproc clearly to make it easier to see what happened
> if rproc was disabled. But I'll have a stab at refactoring this code
> again.

> > > @@ -485,7 +582,10 @@ static void reclaim_consumed_buffers(struct port
> > *port)
> > >  		return;
> > >  	}
> > >  	while ((buf = virtqueue_get_buf(port->out_vq, &len))) {
> > > -		kfree(buf);
> > > +		if (is_console_port(port))
> > > +			kfree(buf);
> > > +		else
> > > +			free_buf(buf);
> > 
> > Hm?
> 
> See below.
> 
> > 
> > >  		port->outvq_full = false;
> > >  	}
> > >  }
> > > @@ -498,6 +598,7 @@ static ssize_t send_buf(struct port *port, void
> > *in_buf, size_t in_count,
> > >  	ssize_t ret;
> > >  	unsigned long flags;
> > >  	unsigned int len;
> > > +	struct port_buffer *buf = in_buf;
> > 
> > This looks wrong: the buffer we receive here is the actual data
> > (buf->buf).  It can never be a port_buffer (buf).
> 
> See below.
> 
> > 
> > >
> > >  	out_vq = port->out_vq;
> > >
> > > @@ -505,8 +606,11 @@ static ssize_t send_buf(struct port *port, void
> > *in_buf, size_t in_count,
> > >
> > >  	reclaim_consumed_buffers(port);
> > >
> > > -	sg_init_one(sg, in_buf, in_count);
> > > -	ret = virtqueue_add_buf(out_vq, sg, 1, 0, in_buf, GFP_ATOMIC);
> > > +	if (is_console_port(port))
> > 
> > I think you're misinterpreting what is_console_port() is.  It means if
> > a port is associated with an hvc/tty device.
> 
> See below.
> 
> > 
> > > +		sg_init_one(sg, in_buf, in_count);
> > > +	else
> > > +		sg_init_one(sg, buf->buf, in_count);
> > > +	ret = virtqueue_add_buf(out_vq, sg, 1, 0, buf, GFP_ATOMIC);
> > >
> > >  	/* Tell Host to go! */
> > >  	virtqueue_kick(out_vq);
> > > @@ -669,7 +773,7 @@ static ssize_t port_fops_write(struct file *filp,
> > const char __user *ubuf,
> > >  			       size_t count, loff_t *offp)
> > >  {
> > >  	struct port *port;
> > > -	char *buf;
> > > +	struct port_buffer *buf;
> > >  	ssize_t ret;
> > >  	bool nonblock;
> > >
> > > @@ -696,11 +800,11 @@ static ssize_t port_fops_write(struct file
> > *filp, const char __user *ubuf,
> > >
> > >  	count = min((size_t)(32 * 1024), count);
> > >
> > > -	buf = kmalloc(count, GFP_KERNEL);
> > > +	buf = alloc_buf(port->out_vq, count);
> > >  	if (!buf)
> > >  		return -ENOMEM;
> > >
> > > -	ret = copy_from_user(buf, ubuf, count);
> > > +	ret = copy_from_user(buf->buf, ubuf, count);
> > >  	if (ret) {
> > >  		ret = -EFAULT;
> > >  		goto free_buf;
> > > @@ -720,7 +824,7 @@ static ssize_t port_fops_write(struct file *filp,
> > const char __user *ubuf,
> > >  		goto out;
> > >
> > >  free_buf:
> > > -	kfree(buf);
> > > +	free_buf(buf);
> > >  out:
> > >  	return ret;
> > >  }
> > 
> > OK, I now get what you did with send_buf() above.  However, send_buf()
> > now should be completely broken for non-rproc devices: you're
> > allocating a buf instead of a buf->buf and passing that on to
> > send_buf() as a void*.  You should instead modify send_buf() to accept
> > a struct port_buffer instead.
> > 
> > Second, send_buf() receives a struct port_buffer(), but in the
> > 'is_console_port()' case, you ignore that fact, and just pass on the
> > void* pointer to sg_init_one().  You should instead pass buf->buf.
> 
> OK, so the issue here it that currently put_chars() passes a
> char-buffer to send_buf() instead of a port_buffer. The tests above
> tries to handle this case, distingusing between a tty and char device.
> I agree that this is not the best solution.
> 
> But if I change put_chars to create a port_buffer and copy
> data into it I can avoid the crap you pointed at above.

Yes, it's much easier if we don't have special cases in these generic
routines.

> ...
> > > -	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
> > > +	if (!is_rproc_serial(vdev) &&
> > > +	    virtio_has_feature(vdev, VIRTIO_CONSOLE_F_SIZE))
> > >  		hvc_resize(port->cons.hvc, port->cons.ws);
> > 
> > Why do you want to ensure !is_rproc_serial() here?  As long as the
> > device doesn't expose the VIRTIO_CONSOLE_F_SIZE feature, you should be
> > fine, so this hunk can be dropped.
> 
> I need this test because virtio_check_driver_offered_feature() called
> from virtio_has_feature will throw a BUG() if you test on a feature
> not declared in the driver's feature-set.

Ah, OK.

> > > @@ -1102,10 +1209,10 @@ static unsigned int fill_queue(struct
> > virtqueue *vq, spinlock_t *lock)
> > >
> > >  	nr_added_bufs = 0;
> > >  	do {
> > > -		buf = alloc_buf(PAGE_SIZE);
> > > +		buf = alloc_buf(vq, PAGE_SIZE);
> > >  		if (!buf)
> > >  			break;
> > > -
> > > +		memset(buf->buf, 0, PAGE_SIZE);
> > 
> > Why this memset here?
> > 
> > 1. alloc_buf() already does kzalloc()
> 
> It used to do that, but not anymore. This patch
> changes kzalloc() to kmalloc() in alloc_buf()

Obviously I missed it :)

> > 2. Is there any specific reason you want the buffer to be zeroed?
> > 
> > I've recently realised zeroing out the buffer before giving it to the
> > device serves no real purpose, and we're just slowing down the
> > allocation here, so I'm tempted to convert the kzalloc() to
> > kmalloc(), unless you have a specific need for zeroed pages.
> 
> Agree, the only reason is that I did memset was not to change legacy
> behavior. I'd prefer to skip the memset too, so let's do that.

Can you please split that into a separate patch?

> > This hunk is already present in linux-next; rebasing over that should
> > get rid of it.
> 
> Sure, I'll rebase next patch to linux-next and send a new patch tomorrow.

Thanks!

		Amit
