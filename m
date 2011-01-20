Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1ATJEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 04:04:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53893 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab1ATJEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 04:04:34 -0500
Date: Thu, 20 Jan 2011 09:04:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
Message-ID: <20110120090408.GA22101@n2100.arm.linux.org.uk>
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org> <20110119082534.GA9569@gallagher> <4D3760DD.1010609@codeaurora.org> <20110119222407.GD6335@n2100.arm.linux.org.uk> <4D37A016.8060902@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D37A016.8060902@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 06:38:14PM -0800, Stepan Moskovchenko wrote:
> On 1/19/2011 2:24 PM, Russell King - ARM Linux wrote:
>> On Wed, Jan 19, 2011 at 02:08:29PM -0800, Stepan Moskovchenko wrote:
>>>>> +		/* Mask conditions we're ignorning. */
>>>>> +		sr&= port->read_status_mask;
>>>>> +		if (sr&   UART_SR_RX_BREAK)
>>>>> +			flag = TTY_BREAK;
>>>>> +		else if (sr&   UART_SR_PAR_FRAME_ERR)
>>>>> +			flag = TTY_FRAME;
>>>> It doesn't look like the flag is used anywhere after it has been
>>>> assigned.
>>> An artifact of an old driver. Removed.
>> But still required to support proper error signalling.
>>
>
> On second thought, from poking around the kernel some more, I believe  
> the following should be a better approach:
>         if (sr & UART_SR_RX_BREAK) {
>             tty_insert_flip_char(tty, 0, TTY_BREAK);
>         } else if (sr & UART_SR_PAR_FRAME_ERR) {
>             tty_insert_flip_char(tty, 0, TTY_FRAME);
>         }
>
> Russell, what do you think? Shall I make the change in v2?

Why not take a look at what a known good serial driver such as 8250.c
does?  The expected flow is something like:

        lsr = serial_inp(up, UART_LSR);
        do {
		if (!(lsr & UART_LSR_DR))
			break;
                ch = serial_inp(up, UART_RX);
                flag = TTY_NORMAL;
                up->port.icount.rx++;
                if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {

This is where we handle errors.

                        /*
                         * For statistics only
                         */
                        if (lsr & UART_LSR_BI) {

A break error shouldn't flag framing or parity errors

                                lsr &= ~(UART_LSR_FE | UART_LSR_PE);
                                up->port.icount.brk++;
                                /*
                                 * We do the SysRQ and SAK checking
                                 * here because otherwise the break
                                 * may get masked by ignore_status_mask
                                 * or read_status_mask.
                                 */
                                if (uart_handle_break(&up->port))
                                        continue;

You only need that if you want SAK handling (secure attention key) or
magic sysrq - which is useful for debugging.

                        } else if (lsr & UART_LSR_PE)
                                up->port.icount.parity++;
                        else if (lsr & UART_LSR_FE)
                                up->port.icount.frame++;
                        if (lsr & UART_LSR_OE)
                                up->port.icount.overrun++;

These update the per-port statistics.

                        /*
                         * Mask off conditions which should be ignored.
                         */
                        lsr &= up->port.read_status_mask;

This gets rid of conditions that the user has told TTY that they're not
interested in (based on termios flags).  Setting up this mask is specific
to the hardware.

                        if (lsr & UART_LSR_BI) {
                                DEBUG_INTR("handling break....");
                                flag = TTY_BREAK;
                        } else if (lsr & UART_LSR_PE)
                                flag = TTY_PARITY;
                        else if (lsr & UART_LSR_FE)
                                flag = TTY_FRAME;

This sets the error marker for the tty layer.

                }
                if (uart_handle_sysrq_char(&up->port, ch))
                        continue;

Again, if you're handling sysrq, then this passes the character to the
sysrq handlers.

                uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);

This finally does the handling of which characters to ignore, again
based on the users termios settings.

        } while (max_count-- > 0);

Without the handling with these errors, the termios settings for ignoring
parity, parity checking, break handling, marking parity errors, etc.  The
handling of these termios flags depend on this code:

  INPCK, BRKINT, PARMRK, IGNPAR, IGNBRK and CREAD.
