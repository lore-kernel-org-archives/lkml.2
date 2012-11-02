Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2KBKpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:45:23 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:43964 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab2KBKpV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:45:21 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Amit Shah <amit.shah@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>
Date: Fri, 2 Nov 2012 11:44:55 +0100
Subject: RE: [PATCHv7 4/4] virtio_console: Add support for remoteproc serial
Thread-Topic: [PATCHv7 4/4] virtio_console: Add support for remoteproc serial
Thread-Index: Ac2448sTjqhiEbRFSgyjJRqYhJRBlAAAS19w
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BE98E5C6@EXDCVYMBSTM005.EQ1STM.local>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com>
 <1350287856-5284-5-git-send-email-sjur.brandeland@stericsson.com>
 <878vayhsca.fsf@rustcorp.com.au> <20121101073951.GA17012@amit.redhat.com>
 <87r4oc52ov.fsf@rustcorp.com.au> <20121102102047.GE10483@amit.redhat.com>
In-Reply-To: <20121102102047.GE10483@amit.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On (Fri) 02 Nov 2012 [09:52:08], Rusty Russell wrote:
> > Amit Shah <amit.shah@redhat.com> writes:
> > > On (Tue) 23 Oct 2012 [12:17:49], Rusty Russell wrote:
> > >> sjur.brandeland@stericsson.com writes:
> > >> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> > >
> > >> > @@ -1415,7 +1524,16 @@ static void remove_port_data(struct port
> *port)
> > >> >
> > >> >  	/* Remove buffers we queued up for the Host to send us data in. */
> > >> >  	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> > >> > -		free_buf(buf);
> > >> > +		free_buf(buf, true);
> > >> > +
> > >> > +	/*
> > >> > +	 * Remove buffers from out queue for rproc-serial. We
> cannot afford
> > >> > +	 * to leak any DMA mem, so reclaim this memory even if this
> might be
> > >> > +	 * racy for the remote processor.
> > >> > +	 */
> > >> > +	if (is_rproc_serial(port->portdev->vdev))
> > >> > +		while ((buf = virtqueue_detach_unused_buf(port-
> >out_vq)))
> > >> > +			free_buf(buf, true);
> > >> >  }
> > >>
> > >> This seems wrong; either this is needed even if !is_rproc_serial(), or
> > >> it's not necessary as the out_vq is empty.
> > >>
> > >> Every path I can see has the device reset (in which case the queues
> > >> should not be active), or we got a VIRTIO_CONSOLE_PORT_REMOVE
> event (in
> > >> which case, the same).
> > >>
> > >> I think we can have non-blocking writes which could leave buffers in
> > >> out_vq: Amit?
> > >
> > > Those get 'reclaimed' just above this hunk:
> > >
> > >
> > > static void remove_port_data(struct port *port)
> > > {
> > > 	struct port_buffer *buf;
> > >
> > > 	/* Remove unused data this port might have received. */
> > > 	discard_port_data(port);
> > >
> > > 	reclaim_consumed_buffers(port);
> > >
> > > 	/* Remove buffers we queued up for the Host to send us data in. */
> > > 	while ((buf = virtqueue_detach_unused_buf(port->in_vq)))
> > > 	      free_buf(buf, true);
> >
> > No, that's pending input buffers, not output buffers.
> 
> You're right.  Nice catch.
> 
> Sjur, can you remove the WARN_ON in your latest series, even generic
> ports may have buffers in the outq.

Sure, I can respin the patch and remove the WARN_ON().

> It'll also need to be done in the port_fops_release() function.  Let
> me know if you prefer I send a patch instead.

I can have a go at this, as I have to respin the patch anyway.

Thanks,
Sjur

