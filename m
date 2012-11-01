Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab2KAXXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:23:13 -0400
Received: from ozlabs.org ([203.10.76.45]:33941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2KAXXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:23:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>
Cc: sjur.brandeland@stericsson.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com
Subject: Re: [PATCHv7 4/4] virtio_console: Add support for remoteproc serial
In-Reply-To: <20121101073951.GA17012@amit.redhat.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com> <878vayhsca.fsf@rustcorp.com.au> <20121101073951.GA17012@amit.redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 02 Nov 2012 09:52:08 +1030
Message-ID: <87r4oc52ov.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Tue) 23 Oct 2012 [12:17:49], Rusty Russell wrote:
>> sjur.brandeland@stericsson.com writes:
>> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
>> > @@ -1415,7 +1524,16 @@ static void remove_port_data(struct port *port)
>> >  
>> >  	/* Remove buffers we queued up for the Host to send us data in. */
>> >  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
>> > -		free_buf(buf);
>> > +		free_buf(buf, true);
>> > +
>> > +	/*
>> > +	 * Remove buffers from out queue for rproc-serial. We cannot afford
>> > +	 * to leak any DMA mem, so reclaim this memory even if this might be
>> > +	 * racy for the remote processor.
>> > +	 */
>> > +	if (is_rproc_serial(port->portdev->vdev))
>> > +		while ((buf = virtqueue_detach_unused_buf(port->out_vq)))
>> > +			free_buf(buf, true);
>> >  }
>> 
>> This seems wrong; either this is needed even if !is_rproc_serial(), or
>> it's not necessary as the out_vq is empty.
>> 
>> Every path I can see has the device reset (in which case the queues
>> should not be active), or we got a VIRTIO_CONSOLE_PORT_REMOVE event (in
>> which case, the same).
>> 
>> I think we can have non-blocking writes which could leave buffers in
>> out_vq: Amit?
>
> Those get 'reclaimed' just above this hunk:
>
>
> static void remove_port_data(struct port *port)
> {
> 	struct port_buffer *buf;
>
> 	/* Remove unused data this port might have received. */
> 	discard_port_data(port);
>
> 	reclaim_consumed_buffers(port);
>
> 	/* Remove buffers we queued up for the Host to send us data in. */
> 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> 	      free_buf(buf, true);

No, that's pending input buffers, not output buffers.

Cheers,
Rusty.
