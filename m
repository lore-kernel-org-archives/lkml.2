Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1JRVXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:23:12 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34760 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab1JRVXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:23:10 -0400
X-Sasl-enc: LYHI1x1vf5po+Xplz5pp7R7SLy1czGZg8q0QJqjvH64j 1318972989
Date: Tue, 18 Oct 2011 14:21:05 -0700
From: Greg KH <greg@kroah.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Allen Martin <AMartin@nvidia.com>,
        Tom Warren <twarren@nvidia.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] TTY: serial_core: Fix crash if DCD drop during suspend
Message-ID: <20111018212105.GA10426@kroah.com>
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
 <1318379144-27187-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318379144-27187-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 05:25:44PM -0700, Doug Anderson wrote:
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
> Acked-by: Alan Cox <alan@linux.intel.com>
> ---
> v2: Updated change description and comments based on deeper digging.

This patch doesn't apply at all to the linux-next tree, can you redo it
so that I know it is correct, and resend it?  (remember to keep Alan's
Ack on it.)

thanks,

greg k-h
