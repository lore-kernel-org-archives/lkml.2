Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0L0RIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 12:08:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab0L0RIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 12:08:02 -0500
Date: Mon, 27 Dec 2010 10:08:17 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tsozik <tsozik@yahoo.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl and _get_icount functions
Message-ID: <20101227100817.10a53243@lembas.zaitcev.lan>
In-Reply-To: <466840.5514.qm@web65716.mail.ac4.yahoo.com>
References: <466840.5514.qm@web65716.mail.ac4.yahoo.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010 22:34:23 -0800 (PST)
Tsozik <tsozik@yahoo.com> wrote:

> Usually MSR contains information about both states which are raised and
> states which are changed. It looks like we use upper MSR nibble which
> contains information about 4 states which were raised, not lower MSR
> nibble which contains information about 4 states which were changed.

Sure, I know how typical UART works. Does the MCT device deliver the
change states? If it does and you want to use those, go ahead.

> I also researched implementations under usb/serial and saw that all of
> them are rely on the current states (not change states) to increment
> the respective counter variables.

Here's drivers/usb/serial/io_edgeport.c:

static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr)
{
	struct  async_icount *icount;

	dbg("%s %02x", __func__, newMsr);

	if (newMsr & (EDGEPORT_MSR_DELTA_CTS | EDGEPORT_MSR_DELTA_DSR |
			EDGEPORT_MSR_DELTA_RI | EDGEPORT_MSR_DELTA_CD)) {
		icount = &edge_port->icount;

		/* update input line counters */
		if (newMsr & EDGEPORT_MSR_DELTA_CTS)
			icount->cts++;
		if (newMsr & EDGEPORT_MSR_DELTA_DSR)
			icount->dsr++;
		if (newMsr & EDGEPORT_MSR_DELTA_CD)
			icount->dcd++;
		if (newMsr & EDGEPORT_MSR_DELTA_RI)
			icount->rng++;
		wake_up_interruptible(&edge_port->delta_msr_wait);
	}

Looks like it counts changes to me. And in any case, the gold standard
is in drivers/serial/8250.c:

static unsigned int check_modem_status(struct uart_8250_port *up)
{
	unsigned int status = serial_in(up, UART_MSR);

	status |= up->msr_saved_flags;
	up->msr_saved_flags = 0;
	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
	    up->port.state != NULL) {
		if (status & UART_MSR_TERI)
			up->port.icount.rng++;
		if (status & UART_MSR_DDSR)
			up->port.icount.dsr++;
		if (status & UART_MSR_DDCD)
			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
		if (status & UART_MSR_DCTS)
			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);

		wake_up_interruptible(&up->port.state->port.delta_msr_wait);
	}

I only proposed accomplishing the same result by comparing states
in place of relying on hardware change reports like both of the
above do.

-- Pete
