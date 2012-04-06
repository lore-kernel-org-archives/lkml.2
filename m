Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2DFV2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:28:32 -0400
Received: from mga06.intel.com ([134.134.136.21]:35726 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755146Ab2DFV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F59B2.4090400@wwwdotorg.org>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
	<20120406184956.22088.85217.stgit@dwillia2-linux.jf.intel.com>
	<4F7F59B2.4090400@wwwdotorg.org>
Date: Fri, 6 Apr 2012 14:28:28 -0700
Message-ID: <CABE8wws23LSLBxz34LYuyYtXMCG+-YTShhojXdeVkfiOvHWseQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] tegra, serial8250: add ->handle_break() uart_port op
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 2:01 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/06/2012 12:49 PM, Dan Williams wrote:
>> The "KT" serial port has another use case for a "received break" quirk,
>> so before adding another special case to the 8250 core take this
>> opportunity to push such quirks out of the core and into a uart_port op.
>
> This doesn't seem quite right. Why do the board files have to set up
> this .handle_break function; they're already setting .type=PORT_TEGRA,
> which should be enough to drive the setup of any required quirks.

Because struct serial8250_config does not convey any uart_port ops.

> If plat_serial8250_port must contain this field, then
> drivers/tty/serial/of_serial.c needs a similar change so that this all
> works when booting using device tree.
>
> I'm not sure what the implication is of moving the call to clr_fifo()
> into uart_handle_break(). What's the benefit of one location over the other?

This was the location where the core was already doing it's break
handling, so it made sense to check here if the device had any quirks
to run.  There shouldn't be any implications because the core was
already doing clear_rx_fifo() immediately before calling
uart_handle_break.  Here is the relevant hunk with a bit more context:

@@ -1399,34 +1378,24 @@ serial8250_rx_chars(struct uart_8250_port *up,
unsigned char lsr)
                         */
                        ch = 0;

                flag = TTY_NORMAL;
                up->port.icount.rx++;

                lsr |= up->lsr_saved_flags;
                up->lsr_saved_flags = 0;

                if (unlikely(lsr & UART_LSR_BRK_ERROR_BITS)) {
-                       /*
-                        * For statistics only
-                        */
                        if (lsr & UART_LSR_BI) {
                                lsr &= ~(UART_LSR_FE | UART_LSR_PE);
                                up->port.icount.brk++;
                                /*
-                                * If tegra port then clear the rx fifo to
-                                * accept another break/character.
-                                */
-                               if (up->port.type == PORT_TEGRA)
-                                       clear_rx_fifo(up);
-
-                               /*
                                 * We do the SysRQ and SAK checking
                                 * here because otherwise the break
                                 * may get masked by ignore_status_mask
                                 * or read_status_mask.
                                 */
                                if (uart_handle_break(&up->port))
                                        goto ignore_char;
                        } else if (lsr & UART_LSR_PE)
                                up->port.icount.parity++;
                        else if (lsr & UART_LSR_FE)

> If the callback function is to no longer live in 8250.c itself,
> arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
> and that file will be going away once we get rid of all the board files
> and move solely to device tree.

Can you help me with an incremental patch to fix this up?  I can
muddle my way through Tegra internals, but I already missed the
of_serial.c hook.

--
Dan
