Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab2KBKVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:21:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559Ab2KBKVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:21:05 -0400
Date: Fri, 2 Nov 2012 15:50:47 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: sjur.brandeland@stericsson.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com
Subject: Re: [PATCHv7 4/4] virtio_console: Add support for remoteproc serial
Message-ID: <20121102102047.GE10483@amit.redhat.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
 <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com>
 <878vayhsca.fsf@rustcorp.com.au>
 <20121101073951.GA17012@amit.redhat.com>
 <87r4oc52ov.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r4oc52ov.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 02 Nov 2012 [09:52:08], Rusty Russell wrote:
> Amit Shah <amit.shah@redhat.com> writes:
> > On (Tue) 23 Oct 2012 [12:17:49], Rusty Russell wrote:
> >> sjur.brandeland@stericsson.com writes:
> >> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> >
> >> > @@ -1415,7 +1524,16 @@ static void remove_port_data(struct port *port)
> >> >  
> >> >  	/* Remove buffers we queued up for the Host to send us data in. */
> >> >  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> >> > -		free_buf(buf);
> >> > +		free_buf(buf, true);
> >> > +
> >> > +	/*
> >> > +	 * Remove buffers from out queue for rproc-serial. We cannot afford
> >> > +	 * to leak any DMA mem, so reclaim this memory even if this might be
> >> > +	 * racy for the remote processor.
> >> > +	 */
> >> > +	if (is_rproc_serial(port->portdev->vdev))
> >> > +		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
> >> > +			free_buf(buf, true);
> >> >  }
> >> 
> >> This seems wrong; either this is needed even if !is_rproc_serial(), or
> >> it's not necessary as the out_vq is empty.
> >> 
> >> Every path I can see has the device reset (in which case the queues
> >> should not be active), or we got a VIRTIO_CONSOLE_PORT_REMOVE event (in
> >> which case, the same).
> >> 
> >> I think we can have non-blocking writes which could leave buffers in
> >> out_vq: Amit?
> >
> > Those get 'reclaimed' just above this hunk:
> >
> >
> > static void remove_port_data(struct port *port)
> > {
> > 	struct port_buffer *buf;
> >
> > 	/* Remove unused data this port might have received. */
> > 	discard_port_data(port);
> >
> > 	reclaim_consumed_buffers(port);
> >
> > 	/* Remove buffers we queued up for the Host to send us data in. */
> > 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> > 	      free_buf(buf, true);
> 
> No, that's pending input buffers, not output buffers.

You're right.  Nice catch.

Sjur, can you remove the WARN_ON in your latest series, even generic
ports may have buffers in the outq.

It'll also need to be done in the port_fops_release() function.  Let
me know if you prefer I send a patch instead.

Thanks,
		Amit
