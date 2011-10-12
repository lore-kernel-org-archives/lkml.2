Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1JLMFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:05:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38660 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752814Ab1JLMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:05:02 -0400
Date: Wed, 12 Oct 2011 12:57:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Allen Martin <AMartin@nvidia.com>,
        Tom Warren <twarren@nvidia.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] TTY: serial_core: Fix crash if DCD drop during
 suspend
Message-ID: <20111012125717.75c9d9a8@lxorguk.ukuu.org.uk>
In-Reply-To: <1318379144-27187-1-git-send-email-dianders@chromium.org>
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
	<1318379144-27187-1-git-send-email-dianders@chromium.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011 17:25:44 -0700
Doug Anderson <dianders@chromium.org> wrote:

> This crash was showing up 100% of the time on Tegra CPUs when an
> agetty was running on the serial port and the console was not running
> on the serial port.  The reason the Tegra saw it so reliably is that
> the Tegra CPU internally ties DTR to DCD/DSR.  That means when we
> dropped DTR during suspend we would get always get an immediate DCD
> drop.
> 
> The specific order of operations that were running:
> * uart_suspend_port() would be called to put the uart in suspend mode
> * we'd drop DTR (ops->set_mctrl(uport, 0)).
> * the DTR drop would be looped back in the CPU to be a DCD drop.
> * the DCD drop would look to the serial driver as a hangup
> * the hangup would call uart_shutdown()
> * ... suspend / resume happens ...
> * uart_resume_port() would be called and run the code in the
>   (port->flags & ASYNC_SUSPENDED) block, which would startup the port
>   (and enable tx again).
> * Since the UART would be available for tx, we'd immediately get
>   an interrupt, eventually calling transmit_chars()
> * The transmit_chars() function would crash.  The first crash would
>   be a dereference of a NULL tty member, but since the port has been
>   shutdown that was just a symptom.
> 
> I have proposed a patch that would fix the Tegra CPUs here (see
> https://lkml.org/lkml/2011/10/11/444 - tty/serial: Prevent drop of DCD
> on suspend for Tegra UARTs).  However, even with that fix it is still
> possible for systems that have an externally visible DCD line to see a
> crash if the DCD drops at just the right time during suspend: thus
> this patch is still useful.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Alan Cox <alan@linux.intel.com>
