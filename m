Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab1ESPtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:49:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54741 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505Ab1ESPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:49:38 -0400
Date: Thu, 19 May 2011 16:50:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110519165039.7fd8ec34@lxorguk.ukuu.org.uk>
In-Reply-To: <4DD533DE.1020705@freescale.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
	<1305813272-31826-7-git-send-email-timur@freescale.com>
	<20110519153358.5876f310@lxorguk.ukuu.org.uk>
	<4DD533DE.1020705@freescale.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Under what circumstances can ttys be NULL?  I currently only use this code in
> the RX and TX interrupt handlers, which are both enabled in the
> tty_port_operations.activate() function.

When you add hangup support.

> 
> Is this right for the TX handler:
> 
> static irqreturn_t ehv_bc_tty_tx_isr(int irq, void *data)
> {
> 	struct ehv_bc_data *bc = data;
> 	struct tty_struct *ttys = tty_port_tty_get(&bc->port);
> 
> 	ehv_bc_tx_dequeue(bc);
> 	if (ttys) {
> 		tty_wakeup(ttys);
> 		tty_kref_put(ttys);
> 	}
> 
> 	return IRQ_HANDLED;

Yes.
		    EV_BYTE_CHANNEL_MAX_BYTES);
> > The kfifo API is probably faster and cleaner. Much of tty still uses
> > CIRC_* because they predate the new APIs.
> 
> Ok, I'll change it.

I flag that one up as a general comment - don't feel you need to change
it if CIRC_* works in your case.

> > I guess the only other thing to consider is whether you want to implement
> > a SYSRQ interface on your console ?
> 
> I don't think byte channels can support SYSRQ, but I'll look into it.

What some drivers do in this case is nominate some obscure ctrl sequence
to mean 'sysrq' unless doubled (eg ctrl-^ etc)

Depends if the functionality is useful in your environment or not
