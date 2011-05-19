Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1ESOfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:35:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34835 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598Ab1ESOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:35:14 -0400
Date: Thu, 19 May 2011 15:33:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110519153358.5876f310@lxorguk.ukuu.org.uk>
In-Reply-To: <1305813272-31826-7-git-send-email-timur@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
	<1305813272-31826-7-git-send-email-timur@freescale.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	struct tty_struct *ttys;

ttys are refcounted and you have a refcounted pointer for free in your
tty_port that is maintained by the tty_port logic, as well as it
providing ref counted, properly locked handling for the reference.



> +/******************************** TTY DRIVER ********************************/
> +
> +/*
> + * byte channel receive interupt handler
> + *
> + * This ISR is called whenever data is available on a byte channel.
> + */
> +static irqreturn_t ehv_bc_tty_rx_isr(int irq, void *data)
> +{
> +	struct ehv_bc_data *bc = data;
> +	struct tty_struct *ttys = bc->ttys;

ttys = tty_port_tty_get(&bc->port);
stuff
if (ttys != NULL)
	tty stuff
	tty_kref_put(ttys);

> +	ev_byte_channel_poll(bc->handle, &rx_count, &tx_count);
> +	count = tty_buffer_request_room(ttys, rx_count);
> +
> +	/* 'count' is the maximum amount of data the TTY layer can accept at
> +	 * this time.  However, during testing, I was never able to get 'count'
> +	 * to be less than 'rx_count'.  I'm not sure whether I'm calling it
> +	 * correctly.

It will try hard to fulfill your request until 64K is queued. Before that
point your only expected failure is when the system kmalloc for
GFP_ATOMIC fails, which is an extreme situation.

> +		/* Pass the received data to the tty layer.  Note that this
> +		 * function calls tty_buffer_request_room(), so I'm not sure if
> +		 * we should have also called tty_buffer_request_room().
> +		 */
> +		ret = tty_insert_flip_string(ttys, buffer, len);

You only need to request_room in advance if you can't handle the case
where the insert_flip_string returns less than you stuffed down it.

> +		len = min_t(unsigned int,
> +			    CIRC_CNT_TO_END(bc->head, bc->tail, BUF_SIZE),
> +			    EV_BYTE_CHANNEL_MAX_BYTES);

The kfifo API is probably faster and cleaner. Much of tty still uses
CIRC_* because they predate the new APIs.


> + * This ISR is called whenever space becomes available for transmitting
> + * characters on a byte channel.
> + */
> +static irqreturn_t ehv_bc_tty_tx_isr(int irq, void *data)
> +{
> +	struct ehv_bc_data *bc = data;
> +
> +	ehv_bc_tx_dequeue(bc);
> +	tty_wakeup(bc->ttys);

Again tty krefs/locking

> +/* This function can be called multiple times for a given tty_struct, which is
> + * why we initialize bc->ttys in ehv_bc_tty_port_activate() instead.
> + *
> + * For some reason, the tty layer will still call this function even if the
> + * device was not registered (i.e. tty_register_device() was not called).  So
> + * we need to check for that.

[Because register_device is optional and some legacy drivers still don't
use it]

You really also need a hangup method so vhangup() does the right thing
and you can securely do logins etc and sessions on your console. As
you've got no hardware entangled in this and you already use tty_port
helpers the hangup helper will do the work for you.

I guess the only other thing to consider is whether you want to implement
a SYSRQ interface on your console ?


